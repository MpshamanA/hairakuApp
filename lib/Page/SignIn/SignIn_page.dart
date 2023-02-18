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
  SignInModel model = SignInModel();
  // 認証用
  String emailAddress = '';
  String password = '';

  bool watchEmailAddress = false;
  bool watchPassword = false;

  void callSignInToFirebase() {
    model.signInToFirebase(emailAddress, password, context, ref);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text('ログイン'),
        backgroundColor: ConstColors.appbarColor,
        foregroundColor: ConstColors.mainColor,
        //影
        elevation: (0.0),
      ),
      body: Column(
        children: [
          TextFormField(
              decoration: const InputDecoration(label: Text('メールアドレス')),
              //バリデーション
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value == '' || !EmailValidator.validate(value!)) {
                  return 'メールアドレスが不正です';
                }
                return null;
              },
              onChanged: (value) => setState(() {
                    emailAddress = value;
                  })),
          TextFormField(
            decoration: const InputDecoration(label: Text('パスワード')),
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
              password = value;
            }),
          ),
          ElevatedButton(
              onPressed:
                  !EmailValidator.validate(emailAddress) || password.length < 6
                      ? null
                      : callSignInToFirebase,
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
          )
        ],
      ),
    );
  }
}
