import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../../core/services/firebase_service.dart';
import '../../app.dart';
import 'mock_auth_provider.dart';

// Auth state provider
final authStateProvider = StreamProvider<User?>((ref) {
  if (kDemoMode) {
    return Stream.value(MockUser());
  }
  return FirebaseAuth.instance.authStateChanges();
});

// Current user provider
final currentUserProvider = StreamProvider<UserModel?>((ref) {
  if (kDemoMode) {
    if (kDebugMode) {
      print('=== Auth Provider Debug ===');
      print('Demo mode is ENABLED');
      print('Using hardcoded demo user data');
      print('Demo user name: "Demo User"');
      print('To fix: Change kDemoMode to false or update demo user name');
    }
    return Stream.value(UserModel(
      id: 'priyankesh_user',
      name: 'Priyankesh', // FIXED: Changed from 'Demo User' to 'Priyankesh'
      email: 'priyankesh@ecocura.com',
      tier: UserTier.silver,
      points: 750,
      pointsToNextTier: 250,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      updatedAt: DateTime.now(),
    ));
  }

  final authState = ref.watch(authStateProvider);

  return authState.when(
    data: (user) {
      if (user == null) return Stream.value(null);
      return FirebaseService.firestore
          .collection('users')
          .doc(user.uid)
          .snapshots()
          .map((doc) => doc.exists ? UserModel.fromFirestore(doc) : null);
    },
    loading: () => Stream.value(null),
    error: (_, __) => Stream.value(null),
  );
});

// Auth service provider
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign in with email and password
  Future<UserCredential?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    if (kDemoMode) {
      return await MockAuthService.signInWithEmailAndPassword(email, password);
    }

    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Create user with email and password
  Future<UserCredential?> createUserWithEmailAndPassword(
    String email,
    String password,
    String name,
  ) async {
    if (kDemoMode) {
      return await MockAuthService.createUserWithEmailAndPassword(email, password);
    }

    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        // Create user document in Firestore
        final user = UserModel(
          id: credential.user!.uid,
          name: name,
          email: email,
          tier: UserTier.bronze,
          points: 0,
          pointsToNextTier: 500,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await FirebaseService.firestore
            .collection('users')
            .doc(credential.user!.uid)
            .set(user.toFirestore());
      }

      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Sign out
  Future<void> signOut() async {
    if (kDemoMode) {
      await MockAuthService.signOut();
      return;
    }
    await _auth.signOut();
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Update user profile
  Future<void> updateUserProfile(UserModel user) async {
    try {
      await FirebaseService.firestore
          .collection('users')
          .doc(user.id)
          .update(user.toFirestore());
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  // Handle Firebase Auth exceptions
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'email-already-in-use':
        return 'The account already exists for that email.';
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'too-many-requests':
        return 'Too many requests. Try again later.';
      case 'operation-not-allowed':
        return 'Signing in with Email and Password is not enabled.';
      default:
        return 'An error occurred: ${e.message}';
    }
  }
}

// Auth state notifier for complex auth operations
class AuthNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  AuthNotifier(this._authService) : super(const AsyncValue.loading());

  final AuthService _authService;

  Future<void> signIn(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      await _authService.signInWithEmailAndPassword(email, password);
      // User state will be updated automatically through currentUserProvider
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> signUp(String email, String password, String name) async {
    state = const AsyncValue.loading();
    try {
      await _authService.createUserWithEmailAndPassword(email, password, name);
      // User state will be updated automatically through currentUserProvider
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    try {
      await _authService.signOut();
      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _authService.resetPassword(email);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AsyncValue<UserModel?>>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthNotifier(authService);
});
