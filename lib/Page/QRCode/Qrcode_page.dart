import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:user_manage_qrcode/Providers/userInfo_provider.dart';

import '../../Const/ConstColors.dart';
import '../../Model/Customer.dart';

class _Qrcode extends StatelessWidget {
  const _Qrcode({
    Key? key,
    required this.customer,
  }) : super(key: key);

  final Customer customer;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(30),
        alignment: Alignment.topCenter,
        child: QrImage(
          data: '${customer.name}',
          version: QrVersions.auto,
          size: 150.0, //QRコードのサイズ
        ),
      ),
    );
  }
}

class QrcodePage extends ConsumerStatefulWidget {
  const QrcodePage({super.key});

  @override
  _QrcodePageState createState() => _QrcodePageState();
}

class _QrcodePageState extends ConsumerState<QrcodePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstColors.bodyColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.account_circle),
          color: ConstColors.mainColor,
          onPressed: () {
            print('object');
          },
        ),
        centerTitle: true,
        title: const Text('QRCode'),
        backgroundColor: ConstColors.appbarColor,
        foregroundColor: ConstColors.mainColor,
        elevation: (0.0),
      ),
      body: _Qrcode(customer: ref.watch(userProvider)),
    );
  }
}
