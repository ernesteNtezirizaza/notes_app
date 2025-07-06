import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../utils/validators.dart';
import 'register_screen.dart';

/// A screen that allows users to login to their account.
/// 
/// This screen contains a form with email and password fields,
/// validation, and authentication functionality.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Form key for validation
  final _formKey = GlobalKey<FormState>();
  
  // Controllers for text fields
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  // Toggle for password visibility
  bool _obscurePassword = true;

  @override
  void dispose() {
    // Clean up controllers when widget is disposed
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Displays a snackbar with the given message.
  /// 
  /// [message]: The text to display in the snackbar
  /// [isError]: If true, displays the snackbar with error styling
  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.deepOrange : Colors.teal,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Attempts to login the user with provided credentials.
  /// 
  /// Validates the form first, then communicates with AuthProvider
  /// to authenticate the user.
  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    final success = await authProvider.signIn(email, password);

    if (mounted) {
      if (success) {
        _showSnackBar('Logged in successfully!');
      } else if (authProvider.errorMessage.isNotEmpty) {
        _showSnackBar(authProvider.errorMessage, isError: true);
      }
    }
  }

  /// Navigates to the RegisterScreen.
  void _navigateToSignUp() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const RegisterScreen())
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              return Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // App Title
                    Text(
                      'Notes App',
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 48),

                    // Welcome Back message
                    Text(
                      'Welcome Back',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.grey[800],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Login to your account',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey[700],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),

                    // Email input field
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: Validators.validateEmail,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(color: Colors.grey[700]),
                        prefixIcon: Icon(Icons.email, color: Colors.grey[700]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[600]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.indigo),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Password input field
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      validator: Validators.validatePassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(color: Colors.grey[700]),
                        prefixIcon: Icon(Icons.lock, color: Colors.grey[700]),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey[700],
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[600]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.indigo),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Login button
                    SizedBox(
                      height: 56,
                      child: ElevatedButton(
                        onPressed: authProvider.isLoading ? null : _signIn,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo, 
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: authProvider.isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Sign Up navigation button
                    TextButton(
                      onPressed: authProvider.isLoading ? null : _navigateToSignUp,
                      child: Text(
                        'Don\'t have an account? Register',
                        style: TextStyle(
                          color: Colors.indigo,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}