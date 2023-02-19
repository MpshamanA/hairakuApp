class Customer {
  String uid;
  String name;
  // String companyName;
  String emailAddress;
  //ログイン状態を管理
  bool isSignin = false;
  //会議への入場状況を管理
  bool isAdmission = false;

  Customer(
      {required this.uid,
      required this.name,
      // required this.companyName,
      required this.emailAddress});
}
