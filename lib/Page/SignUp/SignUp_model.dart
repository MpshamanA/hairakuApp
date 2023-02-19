import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:user_manage_qrcode/app.dart';

import '../../Custom/CustomMaterialPageRoute.dart';
import '../../Model/Customer.dart';
import '../../Providers/userInfo_provider.dart';

class SignUpModel {
  Future<void> signUpToFirebase(String name, String emailAdress,
      String password, WidgetRef ref, BuildContext context) async {
    await Firebase.initializeApp();

    //firebase: email password認証
    try {
      final UserCredential credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAdress,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
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

    //uid取得
    final FirebaseAuth auth = FirebaseAuth.instance;
    final String uid = auth.currentUser!.uid.toString();
    //usersコレクションに新規登録したユーザーのuidでデータを登録する
    DocumentReference<Map<String, dynamic>> users =
        FirebaseFirestore.instance.collection('users').doc(uid);
    users.set({
      'emailAdress': emailAdress,
      'name': name,
      // 'companyName': _companyName
    }).then((_) {
      print('データの登録に成功');
      //新規登録したユーザー情報をグローバルで管理する
      final userState = ref.watch(userProvider.notifier);
      userState.state = Customer(
          uid: uid,
          name: name,
          // companyName: _companyName,
          emailAddress: emailAdress);
      //ログイン状態を更新する
      userState.state.isSignin = true;
      //ユーザーの登録に成功したら画面遷移
      Navigator.push(
          context, CustomMaterialPageRoute(builder: (context) => const App()));
    }).catchError((e) {
      print('fireStoreへのデータの登録で失敗しました。: $e');
      return;
    });
  }
}
