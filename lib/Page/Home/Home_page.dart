import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:user_manage_qrcode/Page/AccountSetting/AccountSetting_page.dart';

import '../../Component/AlertBuilderForCupertino.dart';
import '../../Const//ConstColors.dart';
import '../../Custom/CustomMaterialPageRoute.dart';
import '../../Model/Customer.dart';
import '../../Providers/userInfo_provider.dart';
import '../../Providers/userManage_provider.dart';

class _UserCard extends StatelessWidget {
  const _UserCard({
    Key? key,
    required this.mainColor,
    required this.customer,
  }) : super(key: key);

  final Customer customer;
  final Color mainColor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 230,
        child: Card(
          color: mainColor.withOpacity(0.8), // Card自体の色
          margin: const EdgeInsets.all(20),
          elevation: 8, // 影の離れ具合
          shadowColor: Colors.black, // 影の色
          shape: RoundedRectangleBorder(
            // 枠線を変更できる
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: SizedBox(
              child: ListTile(
                title: Text(
                  customer.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // subtitle: Text(
                //   customer.companyName,
                //   textAlign: TextAlign.center,
                //   style: const TextStyle(color: Colors.white70),
                // ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Home extends ConsumerStatefulWidget {
  Home({Key? key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstColors.bodyColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.account_circle),
          color: ConstColors.mainColor,
          onPressed: () {
            //appbarのaccount_circleアイコンをタップしたときの処理
            Navigator.push(
                context,
                CustomMaterialPageRoute(
                    builder: (context) => AccountSetting()));
          },
        ),
        centerTitle: true,
        title: const Text('ホーム'),
        backgroundColor: ConstColors.appbarColor,
        foregroundColor: ConstColors.mainColor,
        //影
        elevation: (0.0),
      ),
      body: Column(
        children: [
          _UserCard(
            mainColor: ConstColors.mainColor,
            customer: ref.watch(userProvider),
          ),
          Text(
            '入場したミーテイング',
            textAlign: TextAlign.left,
          ),
          ref.watch(userProvider).isAdmission
              ? Text('入場中だよ')
              : Text('入場したミーティングは無し')
        ],
      ),
    );
  }
}
