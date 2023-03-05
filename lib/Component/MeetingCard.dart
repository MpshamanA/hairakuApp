import 'package:flutter/material.dart';

class MeetingCard extends StatelessWidget {
  const MeetingCard(
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
    return StreamBuilder<Object>(
        stream: null,
        builder: (context, snapshot) {
          return Container(
            height: 50,
            width: deviceWidth * 0.65,
            // color: Colors.blueAccent,
            decoration: BoxDecoration(
                // 枠線
                border: Border.all(
                    color: Color.fromARGB(130, 116, 192, 255), width: 2),
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
                            style:
                                TextStyle(fontSize: 12, color: Colors.blueGrey),
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
        });
  }
}
