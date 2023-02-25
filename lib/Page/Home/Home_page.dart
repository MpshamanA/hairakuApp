import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:user_manage_qrcode/Page/AccountSetting/AccountSetting_page.dart';

// import '../../Component/AlertBuilderForCupertino.dart';
import '../../Const//ConstColors.dart';
import '../../Custom/CustomMaterialPageRoute.dart';
import '../../Model/Customer.dart';
import '../../Providers/userInfo_provider.dart';
// import '../../Providers/userManage_provider.dart';

class _UserCard extends StatelessWidget {
  _UserCard(
      {Key? key,
      required this.mainColor,
      required this.customer,
      required this.deviceSize})
      : super(key: key);

  final Customer customer;
  final Color mainColor;
  final Size deviceSize;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: deviceSize.height * 0.28,
        width: deviceSize.width * 0.9,
        child: Card(
          color: mainColor, // Card自体の色
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
                    color: Colors.white,
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
  //FireBaseからmeetings情報をとってくる
  List<Map<String, dynamic>> meetings = [
    {'id': 1, '会議名': '会議１', '開催者': '開催者１', '開催日': '23-5-24'},
    {'id': 2, '会議名': '会議２', '開催者': '開催者２', '開催日': '23-5-24'},
    {'id': 3, '会議名': '会議３', '開催者': '開催者３', '開催日': '23-5-24'},
    {'id': 4, '会議名': '会議４', '開催者': '開催者４', '開催日': '23-5-24'},
    {'id': 5, '会議名': '会議５', '開催者': '開催者５', '開催日': '23-5-24'},
    {'id': 6, '会議名': '会議６', '開催者': '開催者６', '開催日': '23-5-24'},
  ];

  @override
  Widget build(BuildContext context) {
    final Size deviceSize = MediaQuery.of(context).size;
    //画面の横幅を取得
    final double deviceWidth = deviceSize.width;
    //画面の縦幅を取得
    final double deviceHeight = deviceSize.height;
    return Scaffold(
      backgroundColor: ConstColors.bodyColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.account_circle),
          iconSize: 30,
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _UserCard(
            mainColor: ConstColors.mainColor,
            customer: ref.watch(userProvider),
            deviceSize: deviceSize,
          ),
          Text(
            '参加した最新の集まり',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          //参加してる
          ref.watch(userProvider).isAdmission
              ?
              //データをとる時に最初の会議は削除する
              MeetingCardWidget(
                  deviceWidth: deviceWidth,
                  meetingName: meetings[0]['会議名'],
                  startDate: meetings[0]['開催日'],
                  organizer: meetings[0]['開催者'])

              // : Text('入場ミーティングは無し')
              // : Text('現在参加していません'),
              : MeetingCardWidget(
                  deviceWidth: deviceWidth,
                  meetingName: meetings[0]['会議名'],
                  startDate: meetings[0]['開催日'],
                  organizer: meetings[0]['開催者']),
          //入場中の会議
          Text(
            "参加した過去の集まり",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          //ここで過去の会議を5つ表示する
          SizedBox(
            height: deviceHeight * 0.15,
            width: deviceWidth * 0.7,
            child: Scrollbar(
              child: ListView.builder(
                  // shrinkWrap: true,
                  // itemCount: meetings.length,
                  itemCount: 5,
                  itemBuilder: (c, i) {
                    //データをとる時に最初の会議は削除する
                    return SizedBox(
                      height: deviceHeight * 0.09,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MeetingCardWidget(
                              deviceWidth: deviceWidth,
                              meetingName: meetings[i]['会議名'],
                              startDate: meetings[i]['開催日'],
                              organizer: meetings[i]['開催者']),
                        ],
                      ),
                    );
                  }),
            ),
          ),
          TextButton(
              onPressed: () {
                // Navigator.push(
                //     context,
                //     CustomMaterialPageRoute(
                //         builder: (context) => const SignUp()));
              },
              child: const Text('もっと見る'))
        ],
      ),
    );
  }
}

class MeetingCardWidget extends StatelessWidget {
  const MeetingCardWidget(
      {Key? key,
      required this.deviceWidth,
      required this.meetingName,
      required this.startDate,
      required this.organizer})
      : super(key: key);

  final double deviceWidth;
  final String meetingName;
  final String startDate;
  final String organizer;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: deviceWidth * 0.65,
      // color: Colors.blueAccent,
      decoration: BoxDecoration(
          // 枠線
          border:
              Border.all(color: Color.fromARGB(130, 116, 192, 255), width: 2),
          // 角丸
          borderRadius: BorderRadius.circular(8),
          color: Color.fromARGB(52, 116, 192, 255)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,

        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: deviceWidth * 0.4,
                    child: Text(
                      meetingName,
                      // style: TextStyle(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text(
                      startDate,
                      style: TextStyle(fontSize: 12, color: Colors.blueGrey),
                    ),
                  ),
                ],
              ),
              Text(
                organizer,
                style: TextStyle(fontSize: 12),
              ),
              // Text('23-5-24'),
            ],
          ),
        ],
      ),
    );
  }
}
