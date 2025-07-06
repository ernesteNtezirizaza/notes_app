import 'package:flutter/material.dart';
import '../utils/validators.dart';

/// A dialog widget for editing note text with validation.
/// Takes [initialText] as a parameter to pre-populate the text field.
class EditNoteDialog extends StatefulWidget {
  final String initialText;

  const EditNoteDialog({super.key, required this.initialText});

  @override
  State<EditNoteDialog> createState() => _EditNoteDialogState();
}

class _EditNoteDialogState extends State<EditNoteDialog> {
  // Form key for validation
  final _formKey = GlobalKey<FormState>();
  
  // Controller for the text input field
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    // Initialize controller with the initial text value
    _textController = TextEditingController(text: widget.initialText);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed
    _textController.dispose();
    super.dispose();
  }

  /// Handles form submission when the Update button is pressed
  void _submit() {
    if (_formKey.currentState!.validate()) {
      // Return trimmed text if validation passes
      Navigator.of(context).pop(_textController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.blueGrey[50], // Light blue-grey background
      title: const Text(
        'Edit Note',
        style: TextStyle(color: Colors.indigo), // Indigo text color
      ),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _textController,
          maxLines: 5, // Multi-line text input
          autofocus: true, // Auto-focus on the text field
          validator: Validators.validateNoteText, // Text validation
          decoration: InputDecoration(
            hintText: 'Enter your note here...',
            border: const OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white, // White background for text field
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.teal.shade400), // Teal focus border
            ),
          ),
          style: const TextStyle(color: Colors.black87), // Dark text color
        ),
      ),
      actions: [
        // Cancel button
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.redAccent), // Red cancel button
          ),
        ),
        // Update button
        ElevatedButton(
          onPressed: _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal[600], // Teal button color
          ),
          child: const Text(
            'Update',
            style: TextStyle(color: Colors.white), // White text on button
          ),
        ),
      ],
    );
  }
}