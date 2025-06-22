import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseService {
  static FirebaseAuth get auth => FirebaseAuth.instance;
  static FirebaseFirestore get firestore => FirebaseFirestore.instance;
  static FirebaseStorage get storage => FirebaseStorage.instance;

  static Future<void> initialize() async {
    // Additional Firebase initialization if needed
    // Configure Firestore settings
    firestore.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
  }

  // Authentication Methods
  static Future<UserCredential?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      return await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print('Sign in error: $e');
      return null;
    }
  }

  static Future<UserCredential?> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      return await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print('Sign up error: $e');
      return null;
    }
  }

  static Future<void> signOut() async {
    try {
      await auth.signOut();
    } catch (e) {
      print('Sign out error: $e');
    }
  }

  // Firestore Methods
  static Future<void> createDocument(
    String collection,
    String documentId,
    Map<String, dynamic> data,
  ) async {
    try {
      await firestore.collection(collection).doc(documentId).set(data);
    } catch (e) {
      print('Create document error: $e');
    }
  }

  static Future<DocumentSnapshot?> getDocument(
    String collection,
    String documentId,
  ) async {
    try {
      return await firestore.collection(collection).doc(documentId).get();
    } catch (e) {
      print('Get document error: $e');
      return null;
    }
  }

  static Future<QuerySnapshot?> getCollection(String collection) async {
    try {
      return await firestore.collection(collection).get();
    } catch (e) {
      print('Get collection error: $e');
      return null;
    }
  }

  static Stream<QuerySnapshot> getCollectionStream(String collection) {
    return firestore.collection(collection).snapshots();
  }

  static Future<void> updateDocument(
    String collection,
    String documentId,
    Map<String, dynamic> data,
  ) async {
    try {
      await firestore.collection(collection).doc(documentId).update(data);
    } catch (e) {
      print('Update document error: $e');
    }
  }

  static Future<void> deleteDocument(
    String collection,
    String documentId,
  ) async {
    try {
      await firestore.collection(collection).doc(documentId).delete();
    } catch (e) {
      print('Delete document error: $e');
    }
  }

  // Storage Methods
  static Future<String?> uploadFile(
    String path,
    String fileName,
    List<int> fileBytes,
  ) async {
    try {
      final ref = storage.ref().child(path).child(fileName);
      final uploadTask = ref.putData(Uint8List.fromList(fileBytes));
      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('Upload file error: $e');
      return null;
    }
  }

  static Future<void> deleteFile(String path) async {
    try {
      await storage.ref().child(path).delete();
    } catch (e) {
      print('Delete file error: $e');
    }
  }
}
