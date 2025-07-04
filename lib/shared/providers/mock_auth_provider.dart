import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

// Mock auth providers for demo purposes (to avoid Firestore permission issues)
final mockAuthStateProvider = StreamProvider<User?>((ref) {
  // Return a mock user for demo
  return Stream.value(MockUser());
});

final mockCurrentUserProvider = StreamProvider<UserModel?>((ref) {
  // Return a mock user model for demo
  return Stream.value(UserModel(
    id: 'demo_user',
    name: 'Demo User',
    email: 'demo@ecocura.com',
    tier: UserTier.silver,
    points: 750,
    pointsToNextTier: 250,
    createdAt: DateTime.now().subtract(const Duration(days: 30)),
    updatedAt: DateTime.now(),
  ));
});

class MockUser implements User {
  @override
  String get uid => 'demo_user';

  @override
  String? get email => 'demo@ecocura.com';

  @override
  String? get displayName => 'Demo User';

  @override
  String? get photoURL => null;

  @override
  bool get emailVerified => true;

  @override
  bool get isAnonymous => false;

  @override
  UserMetadata get metadata => MockUserMetadata();

  @override
  String? get phoneNumber => null;

  @override
  List<UserInfo> get providerData => [];

  @override
  String? get refreshToken => null;

  @override
  String? get tenantId => null;

  @override
  Future<void> delete() async {}

  @override
  Future<String> getIdToken([bool forceRefresh = false]) async => 'mock_token';

  @override
  Future<IdTokenResult> getIdTokenResult([bool forceRefresh = false]) async {
    return MockIdTokenResult();
  }

  @override
  Future<UserCredential> linkWithCredential(AuthCredential credential) async {
    throw UnimplementedError();
  }

  @override
  Future<ConfirmationResult> linkWithPhoneNumber(String phoneNumber,
      [RecaptchaVerifier? verifier]) async {
    throw UnimplementedError();
  }

  @override
  Future<UserCredential> linkWithPopup(AuthProvider provider) async {
    throw UnimplementedError();
  }

  @override
  Future<void> linkWithRedirect(AuthProvider provider) async {}

  @override
  MultiFactor get multiFactor => throw UnimplementedError();

  @override
  Future<UserCredential> reauthenticateWithCredential(
      AuthCredential credential) async {
    throw UnimplementedError();
  }

  @override
  Future<UserCredential> reauthenticateWithPopup(AuthProvider provider) async {
    throw UnimplementedError();
  }

  @override
  Future<void> reauthenticateWithRedirect(AuthProvider provider) async {}

  @override
  Future<void> reload() async {}

  @override
  Future<void> sendEmailVerification([ActionCodeSettings? actionCodeSettings]) async {}

  @override
  Future<User> unlink(String providerId) async => this;

  @override
  Future<void> updateDisplayName(String? displayName) async {}

  @override
  Future<void> updateEmail(String newEmail) async {}

  @override
  Future<void> updatePassword(String newPassword) async {}

  @override
  Future<void> updatePhoneNumber(PhoneAuthCredential phoneCredential) async {}

  @override
  Future<void> updatePhotoURL(String? photoURL) async {}

  @override
  Future<void> updateProfile({String? displayName, String? photoURL}) async {}

  @override
  Future<void> verifyBeforeUpdateEmail(String newEmail,
      [ActionCodeSettings? actionCodeSettings]) async {}

  @override
  Future<UserCredential> linkWithProvider(AuthProvider provider) async {
    throw UnimplementedError();
  }

  @override
  Future<UserCredential> reauthenticateWithProvider(AuthProvider provider) async {
    throw UnimplementedError();
  }
}

class MockUserMetadata implements UserMetadata {
  @override
  DateTime? get creationTime => DateTime.now().subtract(const Duration(days: 30));

  @override
  DateTime? get lastSignInTime => DateTime.now().subtract(const Duration(hours: 1));
}

class MockIdTokenResult implements IdTokenResult {
  @override
  Map<String, dynamic> get claims => {};

  @override
  DateTime? get expirationTime => DateTime.now().add(const Duration(hours: 1));

  @override
  DateTime? get issuedAtTime => DateTime.now().subtract(const Duration(minutes: 5));

  @override
  String? get signInProvider => 'password';

  String? get signInSecondFactor => null;

  @override
  String? get token => 'mock_token';

  @override
  DateTime? get authTime => DateTime.now().subtract(const Duration(minutes: 5));
}

class MockAuthService {
  static Future<UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    // Mock successful sign in
    await Future.delayed(const Duration(milliseconds: 500));
    return MockUserCredential();
  }

  static Future<UserCredential> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    // Mock successful sign up
    await Future.delayed(const Duration(milliseconds: 500));
    return MockUserCredential();
  }

  static Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 200));
  }
}

class MockUserCredential implements UserCredential {
  @override
  AdditionalUserInfo? get additionalUserInfo => null;

  @override
  AuthCredential? get credential => null;

  @override
  User? get user => MockUser();
}
