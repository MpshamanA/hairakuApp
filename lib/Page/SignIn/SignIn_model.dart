import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:user_manage_qrcode/Page/SignIn/SignIn_page.dart';
import 'package:user_manage_qrcode/Providers/userInfo_provider.dart';

import '../../Component/AlertBuilderForCupertino.dart';
import '../../Custom/CustomMaterialPageRoute.dart';
import '../../Model/Customer.dart';
import '../../app.dart';

class SignInModel {
  Future<void> _fetchUserInfo(String uid, WidgetRef ref) async {
    try {
      final userState = ref.watch(userProvider.notifier);
      //ログインしたユーザーのドキュメントを取得
      final docRef = FirebaseFirestore.instance.collection('users').doc(uid);
      //ドキュメントからデータを取得
      final docSnapshot = await docRef.get();
      //ユーザー情報をプロバイダーに登録
      userState.state = Customer(
          uid: uid,
          name: docSnapshot['name'],
          // companyName: docSnapshot['companyName'],
          emailAddress: docSnapshot['emailAdress']);
      //ログイン情報を更新
      userState.state.isSignin = true;
    } catch (e) {
      print('ログインユーザーの情報取得に失敗しました');
      EasyLoading.dismiss();
    }
  }

  Future<void> signInToFirebase(String emailAddress, String password,
      BuildContext context, WidgetRef ref) async {
    await Firebase.initializeApp();
    try {
      //ローディング開始
      EasyLoading.show(status: 'loading...');
      final FirebaseAuth auth = FirebaseAuth.instance;
      await auth
          .signInWithEmailAndPassword(email: emailAddress, password: password)
          .then((value) async {
        //ログインしたユーザーの情報をプロバイダーに登録
        await _fetchUserInfo(value.user!.uid, ref);
        //ユーザーの登録に成功したら画面遷移
        Navigator.push(context,
            CustomMaterialPageRoute(builder: (context) => const App()));
        EasyLoading.dismiss();
      });
    } on FirebaseAuthException catch (e) {
      EasyLoading.dismiss();
      await showDialog(
          context: context,
          builder: (BuildContext context) => AlertBuilderForCupertino(
                titleMsg: 'ログインに失敗しました。',
                subMsg: 'メールアドレスまたはパスワードが違います。',
              )).then((_) {
        //OKを押されたら
        Navigator.push(context,
            CustomMaterialPageRoute(builder: (context) => const SignIn()));
      });
      //デバック用
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        return;
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        return;
      }
    }
  }
}
