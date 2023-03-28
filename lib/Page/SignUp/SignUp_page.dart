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
    //メイン要素の縦幅を指定
    final double mainHeight = deviceHeight * 0.67;
    //テキストフィールドboxの縦幅指定
    final double textFieldboxHeight = mainHeight * 0.5;
    //テキストフィールドの縦幅指定
    final double textFieldHeight = textFieldboxHeight * 0.02;

    return Scaffold(
      // resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          height: mainHeight,
          child: Column(
            //Columnはデフォルトでは画面全体に広がるのでそのままではセンターに表示されない
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Image.asset(
                  'assets/images/flutter-logo.png',
                  width: deviceWidth * 0.15,
                  fit: BoxFit.fill,
                ),
              ),
              SizedBox(
                height: textFieldboxHeight,
                width: deviceWidth * 0.8,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextFormField(
                      enabled: _nameEnabled,
                      style: TextStyle(fontSize: textFieldHeight * 2.5),
                      decoration: InputDecoration(
                        label: Text('名前'),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: textFieldHeight, horizontal: 10),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _name = value;
                        });
                      },
                    ),
                    TextFormField(
                      enabled: _emailAdressEnabled,
                      style: TextStyle(fontSize: textFieldHeight * 2.5),
                      decoration: InputDecoration(
                        label: Text('メールアドレス'),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: textFieldHeight, horizontal: 10),
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
                      style: TextStyle(fontSize: textFieldHeight * 2.5),
                      decoration: InputDecoration(
                        label: Text('パスワード'),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: textFieldHeight, horizontal: 10),
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
      ),
    );
  }
}
