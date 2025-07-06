import 'package:flutter/material.dart';

/// A dialog widget that prompts the user to confirm deletion of a note.
/// 
/// This widget displays the note content (truncated if too long) and provides
/// two action buttons: Cancel and Delete.
class DeleteConfirmationDialog extends StatelessWidget {
  final String noteText;

  /// Creates a DeleteConfirmationDialog.
  ///
  /// [noteText] is the content of the note to be displayed in the dialog.
  const DeleteConfirmationDialog({super.key, required this.noteText});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // Dialog styling with updated colors
      backgroundColor: Colors.blueGrey[50],
      title: const Text(
        'Delete Note',
        style: TextStyle(color: Colors.deepPurple),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Are you sure you want to delete this note?',
            style: TextStyle(color: Colors.black87),
          ),
          const SizedBox(height: 16),
          // Container showing a preview of the note to be deleted
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.teal[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.teal[100] ?? Colors.teal),
            ),
            child: Text(
              // Display truncated text if note is too long
              noteText.length > 100
                  ? '${noteText.substring(0, 100)}...'
                  : noteText,
              style: const TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
      actions: [
        // Cancel button - returns false when pressed
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.deepPurple),
          ),
        ),
        // Delete button - returns true when pressed
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepOrange, 
            foregroundColor: Colors.white,
          ),
          child: const Text('Delete'),
        ),
      ],
    );
  }
}