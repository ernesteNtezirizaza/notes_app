import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../screens/login_screen.dart';
import '../screens/notes_screen.dart';

/// A stateless widget that acts as a gatekeeper for the application's screens
/// based on the user's authentication status.
///
/// This widget uses the [AuthProvider] to determine if the user is authenticated.
/// If authenticated, it shows the [NotesScreen], otherwise it shows the [LoginScreen].
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Using the Consumer widget to listen to changes in the AuthProvider
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        // Checking the authentication status from the AuthProvider
        if (authProvider.isAuthenticated) {
          // If user is authenticated, navigate to the NotesScreen
          return const NotesScreen();
        } else {
          // If user is not authenticated, show the LoginScreen
          return const LoginScreen();
        }
      },
    );
  }
}