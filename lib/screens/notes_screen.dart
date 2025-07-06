import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/note_provider.dart';
import '../models/note.dart';
import '../widgets/add_note_dialog.dart';
import '../widgets/edit_note_dialog.dart';
import '../widgets/delete_confirmation_dialog.dart';

/// Screen that displays a list of notes and provides CRUD operations
class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize notes data after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final notesProvider = Provider.of<NotesProvider>(context, listen: false);

      print('Initializing NotesScreen with user: ${authProvider.user?.uid}');

      // Start listening to notes if user is authenticated
      if (authProvider.user != null) {
        notesProvider.startListeningToNotes(authProvider.user!.uid);
      }
    });
  }

  /// Displays a snackbar with a message
  /// [message] - The text to display
  /// [isError] - If true, shows the snackbar in error color (red)
  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent : Colors.teal,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Shows the dialog for adding a new note
  Future<void> _showAddNoteDialog() async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => const AddNoteDialog(),
    );

    // If dialog returned text and widget is still mounted
    if (result != null && result.isNotEmpty && mounted) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final notesProvider = Provider.of<NotesProvider>(context, listen: false);

      // Add the new note
      final success = await notesProvider.addNote(
        result,
        authProvider.user!.uid,
      );
      
      if (mounted) {
        if (success) {
          _showSnackBar('Note added successfully!');
        } else {
          _showSnackBar(notesProvider.errorMessage, isError: true);
        }
      }
    }
  }

  /// Shows the dialog for editing an existing note
  /// [note] - The note to be edited
  Future<void> _showEditNoteDialog(Note note) async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => EditNoteDialog(initialText: note.text),
    );

    // If dialog returned new text and it's different from original
    if (result != null && result != note.text && mounted) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final notesProvider = Provider.of<NotesProvider>(context, listen: false);

      // Update the note
      final success = await notesProvider.updateNote(
        note.id,
        result,
        authProvider.user!.uid,
      );
      
      if (mounted) {
        if (success) {
          _showSnackBar('Note updated successfully!');
        } else {
          _showSnackBar(notesProvider.errorMessage, isError: true);
        }
      }
    }
  }

  /// Shows the confirmation dialog before deleting a note
  /// [note] - The note to be deleted
  Future<void> _showDeleteConfirmationDialog(Note note) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => DeleteConfirmationDialog(noteText: note.text),
    );

    // If user confirmed deletion
    if (confirmed == true && mounted) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final notesProvider = Provider.of<NotesProvider>(context, listen: false);

      // Delete the note
      final success = await notesProvider.deleteNote(
        note.id,
        authProvider.user!.uid,
      );
      
      if (mounted) {
        if (success) {
          _showSnackBar('Note deleted successfully!');
        } else {
          _showSnackBar(notesProvider.errorMessage, isError: true);
        }
      }
    }
  }

  /// Signs out the current user
  Future<void> _signOut() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final notesProvider = Provider.of<NotesProvider>(context, listen: false);

    await authProvider.signOut();
    notesProvider.clearNotes();
    _showSnackBar('Signed out successfully!');
  }

  /// Builds the empty state widget when no notes are available
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.note_add, size: 64, color: Colors.blueGrey[300]),
          const SizedBox(height: 16),
          Text(
            'Nothing here yet—tap + to add a note.',
            style: TextStyle(fontSize: 16, color: Colors.blueGrey[300]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Builds a card widget for a single note
  /// [note] - The note to display in the card
  Widget _buildNoteCard(Note note) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      color: Colors.blueGrey[50], // Light background color for cards
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          note.text,
          style: const TextStyle(fontSize: 16, color: Colors.blueGrey),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            'Updated: ${_formatDate(note.updatedAt)}',
            style: TextStyle(fontSize: 12, color: Colors.blueGrey[400]),
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: Colors.blue[700]),
              onPressed: () => _showEditNoteDialog(note),
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red[700]),
              onPressed: () => _showDeleteConfirmationDialog(note),
            ),
          ],
        ),
      ),
    );
  }

  /// Formats a DateTime into a relative time string
  /// [date] - The DateTime to format
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Notes', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue[800], // Dark blue app bar
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: _signOut,
            tooltip: 'Sign Out',
          ),
        ],
      ),
      body: Consumer<NotesProvider>(
        builder: (context, notesProvider, child) {
          // Show loading indicator while data is loading
          if (notesProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            );
          }

          // Show empty state if no notes available
          if (!notesProvider.hasNotes) {
            return _buildEmptyState();
          }

          // Build list of notes
          return ListView.builder(
            itemCount: notesProvider.notes.length,
            itemBuilder: (context, index) {
              final note = notesProvider.notes[index];
              return _buildNoteCard(note);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddNoteDialog,
        backgroundColor: Colors.blue[700], // Matching dark blue FAB
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}