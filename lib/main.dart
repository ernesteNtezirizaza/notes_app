import 'package:firebase_core/firebase_core.dart'; 
import 'package:flutter/material.dart'; 
import 'package:provider/provider.dart'; 
import 'firebase_options.dart'; 
import 'providers/auth_provider.dart'; 
import 'providers/note_provider.dart'; 
import 'widgets/auth_wrapper.dart'; 

/// Main function - Entry point of the Flutter application
/// Initializes Firebase and runs the app
void main() async {
  // Ensure Flutter widgets are properly initialized before running the app
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase with platform-specific configuration
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Run the application with MyApp as the root widget
  runApp(const MyApp());
}

/// The root widget of the application
/// Sets up providers and the basic app structure
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Using MultiProvider to make multiple providers available throughout the app
    return MultiProvider(
      providers: [
        // Provider for authentication state management
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        
        // Provider for notes data management
        ChangeNotifierProvider(create: (_) => NotesProvider()),
      ],
      child: MaterialApp(
        title: 'Notes App', // Application title
        
        // Custom theme configuration with updated color scheme
        theme: ThemeData(
          // New color scheme with teal as the primary color
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.teal,
            brightness: Brightness.light,
            // Extended color palette
            primary: Colors.teal.shade700,
            secondary: Colors.amber.shade600,
            surface: Colors.grey.shade50,
          ),
          
          // Enable Material 3 design features
          useMaterial3: true,
          
          // Custom app bar theme
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 2,
            titleTextStyle: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          // Custom floating action button theme
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Colors.teal.shade700,
            foregroundColor: Colors.white,
          ),
        ),
        
        // AuthWrapper handles authentication state and displays appropriate screen
        home: const AuthWrapper(),
        
        // Disable the debug banner in release mode
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}