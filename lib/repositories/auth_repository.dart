import 'package:firebase_auth/firebase_auth.dart';
import '../models/user.dart';

/// Repository class that handles all authentication-related operations
/// using Firebase Authentication service.
class AuthRepository {
  // FirebaseAuth instance to interact with Firebase Authentication
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Returns the currently logged-in user as an [AppUser] object.
  /// Returns null if no user is logged in.
  UserModel? get currentUser {
    final user = _auth.currentUser;
    return user != null ? UserModel.fromFirebaseUser(user) : null;
  }

  /// A stream of authentication state changes.
  /// This stream emits events when the user signs in or signs out.
  /// Returns an [AppUser] when signed in, or null when signed out.
  Stream<UserModel?> get authStateChanges {
    return _auth.authStateChanges().map((User? user) {
      return user != null ? UserModel.fromFirebaseUser(user) : null;
    });
  }

  /// Creates a new user account with the given email and password.
  ///
  /// Parameters:
  /// - [email]: The email address for the new user
  /// - [password]: The password for the new user
  ///
  /// Returns:
  /// - [AppUser] if registration is successful
  /// - null if registration fails
  ///
  /// Throws:
  /// - A String error message if an error occurs during registration
  Future<UserModel?> signUpWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return result.user != null
          ? UserModel.fromFirebaseUser(result.user!)
          : null;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Signs in an existing user with the given email and password.
  ///
  /// Parameters:
  /// - [email]: The user's email address
  /// - [password]: The user's password
  ///
  /// Returns:
  /// - [AppUser] if login is successful
  /// - null if login fails
  ///
  /// Throws:
  /// - A String error message if an error occurs during login
  Future<UserModel?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return result.user != null
          ? UserModel.fromFirebaseUser(result.user!)
          : null;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Signs out the current user.
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Handles Firebase authentication exceptions and converts them
  /// to user-friendly error messages.
  ///
  /// Parameter:
  /// - [e]: The FirebaseAuthException to handle
  ///
  /// Returns:
  /// - A String containing a user-friendly error message
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'email-already-in-use':
        return 'The account already exists for that email.';
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided for that user.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This user has been disabled.';
      case 'too-many-requests':
        return 'Too many requests. Try again later.';
      case 'operation-not-allowed':
        return 'Signing in with Email and Password is not enabled.';
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }
}