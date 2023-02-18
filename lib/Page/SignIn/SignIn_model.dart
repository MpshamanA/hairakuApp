import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:user_manage_qrcode/Providers/userInfo_provider.dart';

import '../../Custom/CustomMaterialPageRoute.dart';
import '../../Model/Customer.dart';
import '../../app.dart';

class SignInModel {
  Future<int> _fetchUserInfo(String uid, WidgetRef ref) async {
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
          companyName: docSnapshot['companyName'],
          emailAddress: docSnapshot['emailAdress']);
      //ログイン情報を更新
      userState.state.isSignin = true;
      return 0;
    } catch (e) {
      print('ログインユーザーの情報取得に失敗しました');
      return -1;
    }
  }

  Future<void> signInToFirebase(String emailAddress, String password,
      BuildContext context, WidgetRef ref) async {
    await Firebase.initializeApp();
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final credential = await auth
          .signInWithEmailAndPassword(email: emailAddress, password: password)
          .then((value) {
        //uid取得
        // uid = auth.currentUser!.uid.toString();
        final returnCode = _fetchUserInfo(value.user!.uid, ref);
        if (returnCode == -1) return;

        //ユーザーの登録に成功したら画面遷移
        Navigator.push(context,
            CustomMaterialPageRoute(builder: (context) => const App()));
      });
    } on FirebaseAuthException catch (e) {
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
