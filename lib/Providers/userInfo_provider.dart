import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Model/Customer.dart';

//ここのユーザーはfirestoreから取得する
//refは使わないので_に変更
final userProvider = StateProvider((_) {
  return Customer(uid: '', name: '', emailAddress: '');
});
