import 'package:flutter/foundation.dart';
import 'dart:async';
import '../models/note.dart';
import '../repositories/notes_repository.dart';

/// A provider class that manages notes state and handles communication
/// with the notes repository. Uses ChangeNotifier to notify listeners
/// of state changes.
class NotesProvider with ChangeNotifier {
  // Repository instance for notes data operations
  final NotesRepository _notesRepository = NotesRepository();
  
  // Internal state
  List<Note> _notes = [];          // List of notes
  bool _isLoading = false;         // Loading state flag
  String _errorMessage = '';       // Error message storage
  StreamSubscription<List<Note>>? _notesSubscription;  // Stream subscription for real-time updates

  // Getters for external access to state
  List<Note> get notes => _notes;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  bool get hasNotes => _notes.isNotEmpty;

  /// Updates the loading state and notifies listeners
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Sets an error message and notifies listeners
  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  /// Clears any existing error message and notifies listeners
  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }

  /// Starts listening to real-time updates of notes for a specific user
  /// 
  /// Parameters:
  ///   - userId: The ID of the user whose notes to listen to
  void startListeningToNotes(String userId) {
    try {
      _setLoading(true);
      clearError();

      _notesSubscription?.cancel(); // Cancel any existing subscription

      // Subscribe to the notes stream from the repository
      _notesSubscription = _notesRepository
          .getNotesStream(userId)
          .listen(
            (notes) {
              _notes = notes;
              _setLoading(false);
              notifyListeners();
            },
            onError: (error) {
              _setError(error.toString());
              _setLoading(false);
            },
          );
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }

  /// Fetches notes for a user (fallback method if streaming isn't available)
  /// 
  /// Parameters:
  ///   - userId: The ID of the user whose notes to fetch
  Future<void> fetchNotes(String userId) async {
    try {
      _setLoading(true);
      clearError();

      final notes = await _notesRepository.fetchNotes(userId);
      _notes = notes;
      _setLoading(false);
      notifyListeners(); // Notify UI about the changes
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }

  /// Adds a new note for a user
  /// 
  /// Parameters:
  ///   - text: The content of the note
  ///   - userId: The ID of the user creating the note
  /// 
  /// Returns:
  ///   - true if successful, false otherwise
  Future<bool> addNote(String text, String userId) async {
    try {
      clearError();

      await _notesRepository.addNote(text, userId);
      // No need to manually refresh - stream will handle updates
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  /// Updates an existing note
  /// 
  /// Parameters:
  ///   - noteId: The ID of the note to update
  ///   - text: The new content for the note
  ///   - userId: The ID of the user owning the note
  /// 
  /// Returns:
  ///   - true if successful, false otherwise
  Future<bool> updateNote(String noteId, String text, String userId) async {
    try {
      clearError();

      await _notesRepository.updateNote(noteId, text);
      // No need to manually refresh - stream will handle updates
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  /// Deletes a note
  /// 
  /// Parameters:
  ///   - noteId: The ID of the note to delete
  ///   - userId: The ID of the user owning the note
  /// 
  /// Returns:
  ///   - true if successful, false otherwise
  Future<bool> deleteNote(String noteId, String userId) async {
    try {
      clearError();

      await _notesRepository.deleteNote(noteId);
      // No need to manually refresh - stream will handle updates
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  /// Clears all notes and resets state (typically called on logout)
  void clearNotes() {
    _notesSubscription?.cancel();
    _notes = [];
    _isLoading = false;
    _errorMessage = '';
    notifyListeners();
  }

  /// Clean up resources when the provider is disposed
  @override
  void dispose() {
    _notesSubscription?.cancel();
    super.dispose();
  }
}