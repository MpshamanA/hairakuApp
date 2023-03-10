import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:user_manage_qrcode/Page/SignUp/SignUp_model.dart';

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
  String _emailAdress = '';
  String _password = '';

  bool _nameEnabled = true;
  bool _emailAdressEnabled = true;
  bool _passwordEnabled = true;

  SignUpModel model = SignUpModel();

  void callSignInToFirebase() {
    model.signUpToFirebase(_name, _emailAdress, _password, ref, context);
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
                    enabled: _nameEnabled,
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
                    enabled: _emailAdressEnabled,
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
                    enabled: _passwordEnabled,
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
                    : () {
                        setState(() {
                          _nameEnabled = false;
                          _emailAdressEnabled = false;
                          _passwordEnabled = false;
                        });
                        callSignInToFirebase();
                      }),
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
