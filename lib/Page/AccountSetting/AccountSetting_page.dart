import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Const/ConstColors.dart';
import '../../Custom/CustomMaterialPageRoute.dart';
import '../../Model/Customer.dart';
import '../../Providers/userInfo_provider.dart';
import '../../app.dart';

class AccountSetting extends ConsumerStatefulWidget {
  const AccountSetting({super.key});

  @override
  _AccountSettingState createState() => _AccountSettingState();
}

class _AccountSettingState extends ConsumerState<AccountSetting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstColors.bodyColor,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('アカウント設定'),
        backgroundColor: ConstColors.appbarColor,
        foregroundColor: ConstColors.mainColor,
        //影
        elevation: (0.0),
      ),
      body: Center(
          child: ElevatedButton(
        child: Text('ログアウト'),
        onPressed: () async {
          final userState = ref.watch(userProvider.notifier);
          await FirebaseAuth.instance.signOut().then((_) {
            //ユーザー情報をプロバイダーに登録
            userState.state =
                Customer(uid: '', name: '', companyName: '', emailAddress: '');
            //     //ログイン情報を更新
            userState.state.isSignin = false;

            //ユーザーの登録に成功したら画面遷移
            Navigator.push(context,
                CustomMaterialPageRoute(builder: (context) => const App()));
          });
        },
      )),
    );
  }
}
