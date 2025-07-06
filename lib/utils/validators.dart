/// A collection of static methods for validating various types of input fields.
/// Each validator returns a String error message if validation fails, or null if validation passes.
class Validators {
  /// Validates an email address.
  /// 
  /// Returns:
  /// - 'Email is required' if the value is null or empty
  /// - 'Please enter a valid email address' if the value doesn't match email format
  /// - null if the email is valid
  static String? validateEmail(String? value) {
    // Check for empty or null value
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    // Regular expression for basic email validation
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    
    // Check if the email matches the regex pattern
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    // Return null if validation passes
    return null;
  }

  /// Validates a password.
  /// 
  /// Returns:
  /// - 'Password is required' if the value is null or empty
  /// - 'Password must be at least 6 characters long' if the password is too short
  /// - null if the password is valid
  static String? validatePassword(String? value) {
    // Check for empty or null value
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    // Check minimum length requirement
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }

    // Return null if validation passes
    return null;
  }

  /// Validates note text.
  /// 
  /// Returns:
  /// - 'Note text is required' if the value is null or empty
  /// - 'Note cannot be empty' if the value contains only whitespace
  /// - null if the note text is valid
  static String? validateNoteText(String? value) {
    // Check for empty or null value
    if (value == null || value.isEmpty) {
      return 'Note text is required';
    }

    // Check if the value is just whitespace
    if (value.trim().isEmpty) {
      return 'Note cannot be empty';
    }

    // Return null if validation passes
    return null;
  }
}