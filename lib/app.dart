import 'package:flutter/material.dart';
import 'package:user_manage_qrcode/Page/Home/Home_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:user_manage_qrcode/Page/QrcodeScan/QrcodeScan_page.dart';
import 'package:user_manage_qrcode/Page/SignIn/SignIn_page.dart';
import 'package:user_manage_qrcode/Providers/userInfo_provider.dart';

import 'Page/QRCode/Qrcode_page.dart';

class App extends ConsumerStatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  //bottombarでタップされたところを管理するindex
  int _selectIndex = 0;

  /*
  HOMEアイコン : Home()
  QRCodeアイコン : QrcodePage()
  */
  static final List<Widget> _pages = [
    Home(),
    const QrcodeScan(),
    const QrcodePage()
  ];

  void _onTapItem(int index) {
    setState(() {
      _selectIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      //appbarとbodyのUIは別のクラスから取得
      body: ref.watch(userProvider).isSignin
          ? _pages[_selectIndex]
          : const SignIn(),
      bottomNavigationBar: ref.watch(userProvider).isSignin
          ? SizedBox(
              height: 60,
              child: NavigationBar(
                destinations: [
                  const NavigationDestination(
                      icon: Icon(
                        Icons.home,
                        color: Color.fromARGB(255, 14, 102, 255),
                      ),
                      label: "ホーム"),
                  const NavigationDestination(
                      icon: Icon(
                        Icons.qr_code_outlined,
                        color: Color.fromARGB(255, 14, 102, 255),
                      ),
                      label: 'スキャン入場')
                ],
                selectedIndex: _selectIndex,
                onDestinationSelected: _onTapItem,
                backgroundColor: Colors.white,
                animationDuration: const Duration(milliseconds: 500),
              ),
            )
          // ? BottomNavigationBar(
          //     items: const [
          //       BottomNavigationBarItem(icon: Icon(Icons.home), label: 'ホーム'),
          //       BottomNavigationBarItem(
          //         icon: Icon(Icons.qr_code_outlined),
          //         label: 'スキャン入場',
          //       ),
          //       // BottomNavigationBarItem(
          //       //   icon: Icon(Icons.qr_code_outlined),
          //       //   label: 'QRコードテスト',
          //       // ),
          //     ],
          //     currentIndex: _selectIndex,
          //     onTap: _onTapItem,
          //   )
          : null,
    );
  }
}
