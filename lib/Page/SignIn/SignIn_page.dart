import 'dart:ffi';

import 'package:email_validator/email_validator.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:user_manage_qrcode/Page/SignIn/SignIn_model.dart';
import 'package:user_manage_qrcode/Page/SignUp/SignUp_page.dart';

import '../../Const/ConstColors.dart';
import '../../Custom/CustomMaterialPageRoute.dart';

class SignInWidget extends StatelessWidget {
  const SignInWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SignIn(),
    );
  }
}

class SignIn extends ConsumerStatefulWidget {
  const SignIn({super.key});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends ConsumerState<SignIn> {
  SignInModel _model = SignInModel();
  // 認証用
  String _emailAddress = '';
  String _password = '';

  bool _emailAddressEnabled = true;
  bool _passwordEnabled = true;

  void callSignInToFirebase() {
    _model.signInToFirebase(_emailAddress, _password, context, ref);
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
              height: deviceHeight * 0.33,
              width: deviceWidth * 0.8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextFormField(
                      enabled: _emailAddressEnabled,
                      decoration: InputDecoration(
                        label: Text('メールアドレス'),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                      ),
                      //バリデーション
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == '' || !EmailValidator.validate(value!)) {
                          return 'メールアドレスが不正です';
                        }
                        return null;
                      },
                      onChanged: (value) => setState(() {
                            _emailAddress = value;
                          })),
                  TextFormField(
                    enabled: _passwordEnabled,
                    decoration: InputDecoration(
                        label: Text('パスワード'),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15))),
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
                    onChanged: (value) => setState(() {
                      _password = value;
                    }),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 0),
              child: Column(
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                      onPressed: !EmailValidator.validate(_emailAddress) ||
                              _password.length < 6
                          ? null
                          : () {
                              setState(() {
                                _emailAddressEnabled = false;
                                _passwordEnabled = false;
                              });
                              callSignInToFirebase();
                            },
                      child: const Text('ログイン')),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('アカウントをお持ちでない方は'),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                CustomMaterialPageRoute(
                                    builder: (context) => const SignUp()));
                          },
                          child: const Text('こちら'))
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
