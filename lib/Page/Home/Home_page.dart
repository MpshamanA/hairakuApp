import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:user_manage_qrcode/Page/AccountSetting/AccountSetting_page.dart';

// import '../../Component/AlertBuilderForCupertino.dart';
import '../../Const//ConstColors.dart';
import '../../Custom/CustomMaterialPageRoute.dart';
import '../../Component/UserCard.dart';
import '../../Component/MeetingCard.dart';
import '../../Providers/userInfo_provider.dart';
// import '../../Providers/userManage_provider.dart';

import 'package:intl/intl.dart';

import 'dart:convert';

class Home extends ConsumerStatefulWidget {
  Home({Key? key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  List<Map<String, dynamic>> meetingsd = [];
  late String uid = ref.watch(userProvider).uid;

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
          UserCard(
            mainColor: ConstColors.mainColor,
            customer: ref.watch(userProvider),
            deviceSize: deviceSize,
          ),
          // Text(
          //   '参加した最新の集まり',
          //   style: TextStyle(fontWeight: FontWeight.bold),
          // ),
          // //参加してる
          // ref.watch(userProvider).isAdmission
          //     ?
          //     //データをとる時に最初の会議は削除する
          //     MeetingCard(
          //         deviceWidth: deviceWidth,
          //         meetingName: meetings[0]['会議名'],
          //         startDate: meetings[0]['開催日'],
          //         organizer: meetings[0]['開催者'],
          //       )

          //     // : Text('入場ミーティングは無し')
          //     // : Text('現在参加していません'),
          //     : MeetingCard(
          //         deviceWidth: deviceWidth,
          //         meetingName: meetings[0]['会議名'],
          //         startDate: meetings[0]['開催日'],
          //         organizer: meetings[0]['開催者'],
          //       ),
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
              //firestoreからデータを取得して表示する
              child: StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Text('Loading...');
                    }
                    final data = snapshot.data!.data() as Map<String, dynamic>;
                    final meetings = data['meetingsObj'] as List<dynamic>;

                    return ListView.builder(
                        //firestoreから取得したデータは最大５件まで表示する
                        itemCount: meetings.length >= 5 ? 5 : meetings.length,
                        itemBuilder: (_, i) {
                          //データをとる時に最初の会議は削除する
                          return SizedBox(
                            height: deviceHeight * 0.09,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                MeetingCard(
                                    deviceWidth: deviceWidth,
                                    meetingName: meetings[i]['meetingName'],
                                    startDate: meetings[i]['startDate'],
                                    organizer: meetings[i]['organizer']),
                              ],
                            ),
                          );
                        });
                  }),
            ),
          ),
          TextButton(
              onPressed: () async {
                //テストで会議を追加してるがこれはQRコードを読み込んだときに実装する
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(uid)
                    .update({
                  'meetingsObj': FieldValue.arrayUnion([
                    {
                      'id': "iodhjfposdjfpds",
                      'meetingName': 'アロハ会議',
                      'organizer': 'アロハ会社',
                      'startDate': DateFormat('yy-MM-dd').format(DateTime.now())
                    }
                  ])
                });

                // await getMeetingsObj();
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
