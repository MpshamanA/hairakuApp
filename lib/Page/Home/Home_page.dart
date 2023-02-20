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
  _UserCard({
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
  List<Map<String, dynamic>> meetings = [
    {'id': 1, '会議名': '会議１', '開催日時': DateTime.now()},
    {'id': 2, '会議名': '会議２', '開催日時': DateTime.now()},
    {'id': 3, '会議名': '会議３', '開催日時': DateTime.now()},
    {'id': 4, '会議名': '会議４', '開催日時': DateTime.now()},
    {'id': 5, '会議名': '会議５', '開催日時': DateTime.now()},
    {'id': 6, '会議名': '会議６', '開催日時': DateTime.now()},
    {'id': 7, '会議名': '会議７', '開催日時': DateTime.now()},
    {'id': 8, '会議名': '会議８', '開催日時': DateTime.now()},
    {'id': 9, '会議名': '会議９', '開催日時': DateTime.now()},
    {'id': 10, '会議名': '会議１０', '開催日時': DateTime.now()},
    {'id': 11, '会議名': '会議１１', '開催日時': DateTime.now()},
    {'id': 12, '会議名': '会議１２', '開催日時': DateTime.now()},
    {'id': 13, '会議名': '会議１３', '開催日時': DateTime.now()},
    {'id': 14, '会議名': '会議１４', '開催日時': DateTime.now()},
    {'id': 15, '会議名': '会議１５', '開催日時': DateTime.now()},
    {'id': 16, '会議名': '会議１６', '開催日時': DateTime.now()},
  ];

  @override
  Widget build(BuildContext context) {
    //画面の横幅を取得
    final double deviceWidth = MediaQuery.of(context).size.width;
    //画面の縦幅を取得
    final double deviceHeight = MediaQuery.of(context).size.height;
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
                    builder: (context) => const AccountSetting()));
          },
        ),
        centerTitle: true,
        // title: const Text('ホーム'),
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
            '入場中のミーティング',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          ref.watch(userProvider).isAdmission
              ? Text('入場中だよ')
              // : Text('入場ミーティングは無し')
              : Text('hoge'),
          //入場中の会議
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 50,
                width: deviceWidth * 0.8,
                // color: Colors.blueAccent,
                decoration: BoxDecoration(
                  // 枠線
                  // border: Border.all(color: Colors.blue, width: 2),
                  // 角丸
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: deviceWidth * 0.52,
                            child: Text(
                              'みんな仲良くなsssssssssろうよ',
                              // style: TextStyle(fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Text(
                              '23-5-24',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.blueGrey),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '開催者',
                        style: TextStyle(fontSize: 12),
                      ),
                      // Text('23-5-24'),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Text(
            "過去に参加したミーティング",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          //ここで過去の会議を2つ表示する
          Flexible(
            child: ListView.builder(
                itemCount: meetings.length,
                itemBuilder: (c, i) {
                  return Text(
                    meetings[i]['開催日時'].toString(),
                    textAlign: TextAlign.center,
                  );
                }),
          )
        ],
      ),
    );
  }
}
