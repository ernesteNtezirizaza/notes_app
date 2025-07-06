class UserModel {
  final String uid;
  final String email;

  UserModel({required this.uid, required this.email});

  factory UserModel.fromFirebaseUser(user) {
    return UserModel(uid: user.uid, email: user.email ?? '');
  }
}