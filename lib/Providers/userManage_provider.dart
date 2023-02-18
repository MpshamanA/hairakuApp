import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Model/UserManage.dart';

final userManageProvider = StateProvider<UserManage>((_) {
  return UserManage(meetingId: '', userId: '');
});
