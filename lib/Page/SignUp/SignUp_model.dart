import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:user_manage_qrcode/Page/SignUp/SignUp_page.dart';
import 'package:user_manage_qrcode/app.dart';

import '../../Component/AlertBuilderForCupertino.dart';
import '../../Custom/CustomMaterialPageRoute.dart';
import '../../Model/Customer.dart';
import '../../Providers/userInfo_provider.dart';

class SignUpModel {
  Future<void> _showSignUpErorrDialog(
      String subMsg, BuildContext context) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) => AlertBuilderForCupertino(
              titleMsg: '新規登録に失敗しました。',
              subMsg: subMsg,
            )).then((_) {
      //OKを押されたら
      Navigator.push(context,
          CustomMaterialPageRoute(builder: (context) => const SignUp()));
    });
  }

  //usersコレクションに新規登録したユーザーのuidでデータを登録する

  Future<void> addUserWithCollection(FirebaseAuth auth, String name,
      String emailAdress, String password, ref, BuildContext context) async {
    final String uid = auth.currentUser!.uid.toString();

    //同じ会議（重複）は受け付けない
    DocumentReference<Map<String, dynamic>> users =
        FirebaseFirestore.instance.collection('users').doc(uid);
    users.set({
      'emailAdress': emailAdress,
      'name': name,
    }).then((_) {
      print('データの登録に成功');
      //新規登録したユーザー情報をグローバルで管理する
      final userState = ref.watch(userProvider.notifier);
      userState.state =
          Customer(uid: uid, name: name, emailAddress: emailAdress);
      //ログイン状態を更新する
      userState.state.isSignin = true;

      //ユーザーの登録に成功したら
      // auth的にログイン処理が必要か？
      //画面遷移
      Navigator.push(
          context, CustomMaterialPageRoute(builder: (context) => const App()));
      EasyLoading.dismiss();
    }).catchError((e) {
      EasyLoading.dismiss();
      print('fireStoreへのデータの登録で失敗しました。: $e');
      return;
    });
  }

  Future<void> signUpToFirebase(String name, String emailAdress,
      String password, WidgetRef ref, BuildContext context) async {
    await Firebase.initializeApp();
    FirebaseAuth auth = FirebaseAuth.instance;
    //ローディング開始
    EasyLoading.show();
    try {
      await auth
          .createUserWithEmailAndPassword(
        email: emailAdress,
        password: password,
      )
          .then((_) async {
        await addUserWithCollection(
            auth, name, emailAdress, password, ref, context);
      });
    } on FirebaseAuthException catch (e) {
      EasyLoading.dismiss();
      //既に存在するメールアドレスの場合
      if (e.code == 'email-already-in-use') {
        _showSignUpErorrDialog('既に登録されたメールアドレスです。', context);
      } else {
        _showSignUpErorrDialog('時間をおいて再度登録してください。', context);
      }
      //デバッグ用
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        return;
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        return;
      }
    } catch (e) {
      print('ユーザーの作成に失敗しました。: $e');
      return;
    }
  }
}
