import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Component/MeetingCard.dart';
import '../../Const/ConstColors.dart';
import '../../Providers/userInfo_provider.dart';

class SeeMore extends ConsumerStatefulWidget {
  SeeMore({super.key});

  @override
  _SeeMoreState createState() => _SeeMoreState();
}

class _SeeMoreState extends ConsumerState<SeeMore> {
  @override
  Widget build(BuildContext context) {
    final Size deviceSize = MediaQuery.of(context).size;
    //画面の横幅を取得
    final double deviceWidth = deviceSize.width;
    //画面の縦幅を取得
    final double deviceHeight = deviceSize.height;

    late String uid = ref.watch(userProvider).uid;

    return Scaffold(
      backgroundColor: ConstColors.bodyColor,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('参加したミーティング一覧'),
        backgroundColor: ConstColors.appbarColor,
        foregroundColor: ConstColors.mainColor,
        //影
        elevation: (0.0),
      ),
      body: Center(
        child: SizedBox(
          height: deviceHeight * 0.8,
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
                    //ローディング時の表示コンポーネント
                    return Text('Loading...');
                  }
                  final data = snapshot.data!.data() as Map<String, dynamic>;

                  if (data['meetingsObj'] == null) {
                    return Text(
                      '会議はありません',
                      textAlign: TextAlign.center,
                    );
                  }
                  final meetings = data['meetingsObj'] as List<dynamic>;
                  //最後に追加された会議を最新とする
                  final revMeetings = List.from(meetings.reversed);

                  if (meetings.length <= 0) {
                    return Text(
                      '過去の会議はありません',
                      textAlign: TextAlign.center,
                    );
                  }
                  return ListView.builder(
                      //firestoreから取得したデータは最大５件まで表示する
                      itemCount: meetings.length,
                      itemBuilder: (_, i) {
                        return SizedBox(
                          height: deviceHeight * 0.09,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              MeetingCard(
                                  deviceWidth: deviceWidth,
                                  meetingName: revMeetings[i]['meetingName'],
                                  startDate: revMeetings[i]['startDate'],
                                  organizer: revMeetings[i]['organizer']),
                            ],
                          ),
                        );
                      });
                }),
          ),
        ),
      ),
    );
  }
}
