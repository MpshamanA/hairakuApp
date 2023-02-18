class UserManage {
  DateTime? admissionTime;
  String meetingId;
  String userId;

  UserManage(
      {this.admissionTime = null,
      required this.meetingId,
      required this.userId});

  factory UserManage.init(String meetingId, String userId) {
    return UserManage(
        // admissionTime: DateTime.now(), meetingId: meetingId, userId: userId);
        admissionTime: DateTime.now(),
        meetingId: meetingId,
        userId: userId);
  }
}
