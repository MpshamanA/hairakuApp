import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:user_manage_qrcode/Page/SignIn/SignIn_page.dart';
import 'package:user_manage_qrcode/app.dart';

import '../../Custom/CustomMaterialPageRoute.dart';
import '../../Model/Customer.dart';
import '../../Providers/userInfo_provider.dart';

class SignUpWidget extends StatelessWidget {
  const SignUpWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: SignUp());
  }
}

class SignUp extends ConsumerStatefulWidget {
  const SignUp({super.key});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends ConsumerState<SignUp> {
  String _name = '';
  // String _companyName = '';
  String _emailAdress = '';
  String _password = '';

  Future<void> signUpToFirebase() async {
    await Firebase.initializeApp();

    //firebase: email password認証
    try {
      final UserCredential credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailAdress,
        password: _password,
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
      'emailAdress': _emailAdress,
      'name': _name,
      // 'companyName': _companyName
    }).then((_) {
      print('データの登録に成功');
      //新規登録したユーザー情報をグローバルで管理する
      final userState = ref.watch(userProvider.notifier);
      userState.state = Customer(
          uid: uid,
          name: _name,
          // companyName: _companyName,
          emailAddress: _emailAdress);
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

  @override
  Widget build(BuildContext context) {
    //画面の横幅を取得
    final double deviceWidth = MediaQuery.of(context).size.width;
    //画面の縦幅を取得
    final double deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          //Columnはデフォルトでは画面全体に広がるのでそのままではセンターに表示されない
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 26),
              child: Image.asset(
                'assets/images/flutter-logo.png',
                width: deviceWidth * 0.2,
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(
              height: deviceHeight * 0.4,
              width: deviceWidth * 0.8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      label: Text('名前'),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _name = value;
                      });
                    },
                  ),
                  // TextFormField(
                  //   decoration: InputDecoration(
                  //       label: Text('会社名'), border: OutlineInputBorder()),
                  //   onChanged: (value) {
                  //     setState(() {
                  //       _companyName = value;
                  //     });
                  //   },
                  // ),
                  TextFormField(
                    decoration: InputDecoration(
                      label: Text('メールアドレス'),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                    // keyboardType: TextInputType.emailAddress,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == '' || !EmailValidator.validate(value!)) {
                        return 'メールアドレスが不正です';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        _emailAdress = value;
                      });
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      label: Text('パスワード'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    obscureText: true,
                    maxLength: 20,
                    //バリデーション
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value!.length < 6) {
                        return '6〜20桁でパスワードを作成してください。';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        _password = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            ElevatedButton(
              child: Text('登録'),
              onPressed: _name == '' ||
                      !EmailValidator.validate(_emailAdress) ||
                      _password.length < 6
                  ? null
                  : signUpToFirebase,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('アカウントをお持ちの方は'),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('こちら'))
              ],
            )
          ],
        ),
      ),
    );
  }
}
