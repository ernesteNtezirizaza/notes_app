import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../repositories/auth_repository.dart';

/// A provider class that manages authentication state and operations.
/// Uses ChangeNotifier to notify listeners when the state changes.
class AuthProvider with ChangeNotifier {
  // Repository for handling authentication operations
  final AuthRepository _authRepository = AuthRepository();
  
  // Current authenticated user (null if not authenticated)
  User? _user;
  
  // Loading state flag
  bool _isLoading = false;
  
  // Error message for authentication operations
  String _errorMessage = '';

  // Getter for the current user
  User? get user => _user;
  
  // Getter for loading state
  bool get isLoading => _isLoading;
  
  // Getter for error message
  String get errorMessage => _errorMessage;
  
  // Getter for authentication status
  bool get isAuthenticated => _user != null;

  /// Constructor that sets up auth state listener
  AuthProvider() {
    // Listen to authentication state changes from the repository
    _authRepository.authStateChanges.listen((User? user) {
      _user = user;
      notifyListeners(); // Notify widgets listening to this provider
    });
  }

  /// Helper method to update loading state and notify listeners
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Helper method to set error message and notify listeners
  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  /// Clears any existing error message
  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }

  /// Handles user sign up with email and password
  /// Returns true if successful, false otherwise
  Future<bool> signUp(String email, String password) async {
    try {
      _setLoading(true); // Start loading
      clearError(); // Clear previous errors

      // Attempt to sign up through repository
      final user = await _authRepository.signUpWithEmailAndPassword(
        email,
        password,
      );
      
      if (user != null) {
        _user = user; // Update current user
        _setLoading(false); // Stop loading
        return true; // Success
      }
      
      _setLoading(false);
      return false; // Sign up failed
    } catch (e) {
      _setError(e.toString()); // Set error message
      _setLoading(false); // Stop loading
      return false; // Sign up failed
    }
  }

  /// Handles user sign in with email and password
  /// Returns true if successful, false otherwise
  Future<bool> signIn(String email, String password) async {
    try {
      _setLoading(true); // Start loading
      clearError(); // Clear previous errors

      // Attempt to sign in through repository
      final user = await _authRepository.signInWithEmailAndPassword(
        email,
        password,
      );
      
      if (user != null) {
        _user = user; // Update current user
        _setLoading(false); // Stop loading
        return true; // Success
      }
      
      _setLoading(false);
      return false; // Sign in failed
    } catch (e) {
      _setError(e.toString()); // Set error message
      _setLoading(false); // Stop loading
      return false; // Sign in failed
    }
  }

  /// Handles user sign out
  Future<void> signOut() async {
    try {
      _setLoading(true); // Start loading
      await _authRepository.signOut(); // Sign out through repository
      _user = null; // Clear current user
      _setLoading(false); // Stop loading
    } catch (e) {
      _setError(e.toString()); // Set error message
      _setLoading(false); // Stop loading
    }
  }
}