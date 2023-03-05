import 'package:flutter/material.dart';

import '../../Model/Customer.dart';

class UserCard extends StatelessWidget {
  UserCard(
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
