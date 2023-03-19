import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Custom/CustomMaterialPageRoute.dart';
import '../Model/Customer.dart';
import '../app.dart';

class LogoutBuilderForCupertino extends StatelessWidget {
  const LogoutBuilderForCupertino(
      {Key? key,
      required this.titleMsg,
      required this.subMsg,
      required this.ref,
      required this.userProvider})
      : super(key: key);
  final String titleMsg;
  final String subMsg;
  final WidgetRef ref;
  final StateProvider<Customer> userProvider;

  CupertinoAlertDialog _alertBuilder(BuildContext context, String titleMsg) {
    return CupertinoAlertDialog(
      title: Text(titleMsg),
      content: Text(subMsg),
      actions: [
        CupertinoDialogAction(
            child: Text('ログアウト'),
            onPressed: () async {
              final userState = ref.watch(userProvider.notifier);
              await FirebaseAuth.instance.signOut().then((_) {
                //ユーザー情報をプロバイダーに登録
                userState.state = Customer(uid: '', name: '', emailAddress: '');
                //     //ログイン情報を更新
                userState.state.isSignin = false;

                //ユーザーの登録に成功したら画面遷移
                Navigator.push(context,
                    CustomMaterialPageRoute(builder: (context) => const App()));
              });
            }),
        CupertinoDialogAction(
          child: Text("キャンセル"),
          isDestructiveAction: true,
          onPressed: () => Navigator.of(context).pop(),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _alertBuilder(context, titleMsg);
  }
}
