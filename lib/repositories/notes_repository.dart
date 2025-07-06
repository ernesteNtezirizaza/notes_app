import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/note.dart';

// A repository class that handles all CRUD operations for notes
// using Firebase Firestore as the backend database.
class NotesRepository {
  // Firestore instance for database operations
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Collection name in Firestore where notes will be stored
  final String _collection = 'notes';

  // Fetches all notes for a specific user from Firestore.
  // 
  // Parameters:
  // - `userId`: The ID of the user whose notes to fetch
  // 
  // Returns:
  // - A Future<List<Note>> containing all notes for the user,
  //   ordered by updatedAt in descending order (newest first)
  // 
  // Throws:
  // - Exception if the fetch operation fails
  Future<List<Note>> fetchNotes(String userId) async {
    try {
      // Query Firestore for notes belonging to the user, ordered by update time
      final QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .orderBy('updatedAt', descending: true)
          .get();

      // Convert Firestore documents to Note objects
      return snapshot.docs
          .map(
            (doc) => Note.fromMap(doc.data() as Map<String, dynamic>, doc.id),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch notes: $e');
    }
  }

  // Adds a new note to Firestore.
  // 
  // Parameters:
  // - `text`: The content of the note
  // - `userId`: The ID of the user who owns the note
  // 
  // Throws:
  // - Exception if the add operation fails
  Future<void> addNote(String text, String userId) async {
    try {
      final now = DateTime.now();
      // Create a new Note object (Firestore will generate the ID)
      final note = Note(
        id: '', // Firestore will generate this
        text: text,
        createdAt: now,
        updatedAt: now,
        userId: userId,
      );

      // Add the note to Firestore collection
      await _firestore.collection(_collection).add(note.toMap());
    } catch (e) {
      throw Exception('Failed to add note: $e');
    }
  }

  // Updates an existing note in Firestore.
  // 
  // Parameters:
  // - `noteId`: The ID of the note to update
  // - `text`: The new content for the note
  // 
  // Throws:
  // - Exception if the update operation fails
  Future<void> updateNote(String noteId, String text) async {
    try {
      // Update the note's text and set updatedAt to current time
      await _firestore.collection(_collection).doc(noteId).update({
        'text': text,
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
      });
    } catch (e) {
      throw Exception('Failed to update note: $e');
    }
  }

  // Deletes a note from Firestore.
  // 
  // Parameters:
  // - `noteId`: The ID of the note to delete
  // 
  // Throws:
  // - Exception if the delete operation fails
  Future<void> deleteNote(String noteId) async {
    try {
      // Delete the note document from Firestore
      await _firestore.collection(_collection).doc(noteId).delete();
    } catch (e) {
      throw Exception('Failed to delete note: $e');
    }
  }

  // Gets a real-time stream of notes for a specific user.
  // 
  // Parameters:
  // - `userId`: The ID of the user whose notes to stream
  // 
  // Returns:
  // - A Stream<List<Note>> that emits whenever the notes collection changes,
  //   maintaining order by updatedAt in descending order (newest first)
  Stream<List<Note>> getNotesStream(String userId) {
    return _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Note.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }
}