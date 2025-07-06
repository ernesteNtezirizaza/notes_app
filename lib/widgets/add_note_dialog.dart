import 'package:flutter/material.dart';
import '../utils/validators.dart';

/// A dialog widget for adding new notes.
/// 
/// This dialog provides a form with a text field for entering note content
/// and includes validation, submission, and cancellation functionality.
class AddNoteDialog extends StatefulWidget {
  const AddNoteDialog({super.key});

  @override
  State<AddNoteDialog> createState() => _AddNoteDialogState();
}

class _AddNoteDialogState extends State<AddNoteDialog> {
  // Form key for validating the note input
  final _formKey = GlobalKey<FormState>();
  
  // Controller for managing the text input
  final _textController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed
    _textController.dispose();
    super.dispose();
  }

  /// Handles form submission when the "Add" button is pressed
  void _submit() {
    // Validate the form and if valid, return the trimmed note text
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pop(_textController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.blueGrey[50], // Light blue-grey background
      title: const Text(
        'Add New Note',
        style: TextStyle(color: Colors.indigo), // Indigo text color for title
      ),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _textController,
          maxLines: 5, // Multi-line text input
          autofocus: true, // Auto-focus on the text field when dialog opens
          validator: Validators.validateNoteText, // Input validation
          decoration: InputDecoration(
            hintText: 'Enter your note here...',
            border: const OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white, // White background for text field
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.teal), // Teal focus border
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
        // Add button
        ElevatedButton(
          onPressed: _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green[700], // Dark green button
            foregroundColor: Colors.white, // White text
          ),
          child: const Text('Add'),
        ),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0), // Rounded corners
      ),
    );
  }
}