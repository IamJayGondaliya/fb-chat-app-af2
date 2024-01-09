class UserModel {
  String uid;
  String userName;
  String email;
  String profilepic;

  UserModel({
    required this.uid,
    required this.userName,
    required this.email,
    required this.profilepic,
  });

  factory UserModel.formMap({required Map data}) {
    return UserModel(
      uid: data['uid'],
      userName: data['userName'],
      email: data['email'],
      profilepic: data['profilepic'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'userName': userName,
      'email': email,
      'profilepic': profilepic,
    };
  }
}
