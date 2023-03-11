import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:user_manage_qrcode/Component/AlertBuilderForCupertino.dart';
import 'package:user_manage_qrcode/Model/Meeting.dart';
import 'package:user_manage_qrcode/Model/UserManage.dart';
import 'package:user_manage_qrcode/Providers/userManage_provider.dart';
import 'package:user_manage_qrcode/app.dart';

import '../../Const/ConstColors.dart';
import '../../Custom/CustomMaterialPageRoute.dart';
import '../../Providers/userInfo_provider.dart';

class QrcodeScanWidget extends StatelessWidget {
  const QrcodeScanWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const QrcodeScan(),
    );
  }
}

class QrcodeScan extends ConsumerStatefulWidget {
  const QrcodeScan({super.key});

  @override
  _QrcodeScanState createState() => _QrcodeScanState();
}

class _QrcodeScanState extends ConsumerState<QrcodeScan> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  // Barcode? result;
  QRViewController? controller;
  bool _isQRScanned = false;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
      print("android ok");
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
      print("ios ok");
    }
  }

  //QRCodeから取得したデータを登録用にデコードする
  List<String> _decode(String readQrcodeData) {
    List<String> code = readQrcodeData.split(',');
    return code;
  }

  Meeting _getMeetingInfo(String readQrcodeDate) {
    //code interface : format is csv
    //id,name,organizer,startDate
    List<String> code = _decode(readQrcodeDate);
    Meeting meetingInfo = Meeting(code[0], code[1], code[2], code[3]);
    return meetingInfo;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstColors.bodyColor,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('スキャン入場'),
        backgroundColor: ConstColors.appbarColor,
        foregroundColor: ConstColors.mainColor,
        //影
        elevation: (0.0),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: const Center(
              child: Text('QRCodeを読み込んで入場'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _addUserManage(Meeting meetingInfo) async {
    await Firebase.initializeApp();
    //入場したミーティングをusersコレクションに登録する
    String uid = ref.watch(userProvider).uid;
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'meetingsObj': FieldValue.arrayUnion([
          {
            'id': meetingInfo.id,
            'meetingName': meetingInfo.name,
            'organizer': meetingInfo.organizer,
            'startDate': meetingInfo.startDate
          }
        ])
      });
    } catch (e) {
      print('ユーザー管理情報の登録に失敗しました。');
      return;
    }
  }

  Future<void> _toHome_screen(String format, String code) async {
    //QRCodeの読み取り確認
    if (!_isQRScanned) {
      //カメラ停止
      controller?.pauseCamera();
      _isQRScanned = true;

      //scanDataのコードをdecodeしてデータを取得する
      Meeting meetingInfo = _getMeetingInfo(code);

      await showDialog(
          context: context,
          builder: (BuildContext context) => AlertBuilderForCupertino(
                titleMsg: 'こちらのミーティングに参加します。',
                subMsg: '会議名:${meetingInfo.name} 開催者:${meetingInfo.organizer}',
              )).then((_) {
        //OKを押されたら
        _addUserManage(meetingInfo);
      });

      //ステートを入場ずみに変更する
      ref.watch(userProvider.notifier).state.isAdmission = true;

      //画面遷移
      await Navigator.push(context,
              CustomMaterialPageRoute(builder: (context) => const App()))
          .then((value) {
        // 遷移先画面から戻った場合カメラを再開
        controller?.resumeCamera();
        _isQRScanned = false;
      });
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      //QRcodeのcodeがnullだったらreturnする
      if (scanData.code == null) return;
      // result = scanData;

      _toHome_screen(describeEnum(scanData.format), scanData.code!);
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
