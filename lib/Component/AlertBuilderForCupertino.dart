import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlertBuilderForCupertino extends StatelessWidget {
  const AlertBuilderForCupertino(
      {Key? key, required String this.titleMsg, required String this.subMsg})
      : super(key: key);
  final String titleMsg;
  final String subMsg;

  CupertinoAlertDialog _alertBuilder(BuildContext context, String titleMsg) {
    return CupertinoAlertDialog(
      title: Text(titleMsg),
      content: Text(subMsg),
      actions: [
        CupertinoDialogAction(
          child: Text('OK'),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _alertBuilder(context, titleMsg);
  }
}
