class User {
  final String uid;
  final String email;

  User({required this.uid, required this.email});

  factory User.fromFirebaseUser(user) {
    return User(uid: user.uid, email: user.email ?? '');
  }
}