import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../main.dart';
import '../models/user_model.dart';

/// Firebase Authentication service for user registration, login, logout,
/// and password reset.
class AuthService {
  FirebaseAuth? _auth;
  FirebaseFirestore? _firestore;

  FirebaseAuth? get _authInstance {
    if (!firebaseReady) return null;
    _auth ??= FirebaseAuth.instance;
    return _auth;
  }

  FirebaseFirestore? get _firestoreInstance {
    if (!firebaseReady) return null;
    _firestore ??= FirebaseFirestore.instance;
    return _firestore;
  }

  /// Current authenticated user (null if signed out).
  User? get currentUser => _authInstance?.currentUser;

  /// Auth state stream.
  Stream<User?> get authStateChanges {
    if (_authInstance != null) return _authInstance!.authStateChanges();
    return Stream.value(null);
  }

  /// Sign in with email and password.
  Future<UserModel?> signIn({
    required String email,
    required String password,
  }) async {
    if (_authInstance == null) {
      // Demo mode — role based on email
      final isAdmin = email.toLowerCase().contains('admin');
      return UserModel(
        id: 'demo-user',
        fullName: isAdmin ? 'Djemila Bonkoungou' : 'Amadou Ouédraogo',
        email: email,
        phone: '+226 70 00 00 00',
        farmName: isAdmin ? 'BioSmart Admin' : 'Ferme BioSmart',
        role: isAdmin ? 'admin' : 'user',
        profileImageUrl: '',
        location: 'Plateau Central, Burkina Faso',
        createdAt: DateTime.now(),
      );
    }
    try {
      final credential = await _authInstance!.signInWithEmailAndPassword(
        email: email, password: password,
      );
      if (credential.user != null) {
        return await _fetchUserProfile(credential.user!.uid);
      }
      return null;
    } on FirebaseAuthException catch (e) {
      throw AuthException(_mapAuthError(e.code));
    } catch (e) {
      throw AuthException('Erreur inattendue: ${e.toString()}');
    }
  }

  /// Register a new user with email and password.
  Future<UserModel?> signUp({
    required String email, required String password,
    required String fullName, required String phone,
    required String farmName, String? biodigesterType,
    double? biodigesterCapacity, String? location,
  }) async {
    if (_authInstance == null) {
      return UserModel(
        id: 'demo-user', fullName: fullName, email: email,
        phone: phone, farmName: farmName, role: 'user',
        profileImageUrl: '', biodigesterType: biodigesterType,
        biodigesterCapacity: biodigesterCapacity,
        location: location ?? 'Plateau Central, Burkina Faso',
        createdAt: DateTime.now(),
      );
    }
    try {
      final credential = await _authInstance!.createUserWithEmailAndPassword(
        email: email, password: password,
      );
      final user = credential.user;
      if (user == null) throw AuthException('Échec de création du compte.');
      await user.updateDisplayName(fullName);
      final profile = UserModel(
        id: user.uid, fullName: fullName, email: email,
        phone: phone, farmName: farmName, role: 'user',
        profileImageUrl: '', biodigesterType: biodigesterType,
        biodigesterCapacity: biodigesterCapacity,
        location: location ?? 'Plateau Central, Burkina Faso',
        createdAt: DateTime.now(),
      );
      await _firestoreInstance?.collection('users').doc(user.uid).set(profile.toJson());
      return profile;
    } on FirebaseAuthException catch (e) {
      throw AuthException(_mapAuthError(e.code));
    } catch (e) {
      throw AuthException('Erreur inattendue: ${e.toString()}');
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    if (_authInstance == null) return;
    try {
      await _authInstance!.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw AuthException(_mapAuthError(e.code));
    }
  }

  Future<void> signOut() async {
    await _authInstance?.signOut();
  }

  Future<UserModel?> _fetchUserProfile(String uid) async {
    try {
      final doc = await _firestoreInstance?.collection('users').doc(uid).get();
      if (doc != null && doc.exists) return UserModel.fromJson(doc.data()!);
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<UserModel?> getCurrentUserProfile() async {
    if (_authInstance == null) {
      return UserModel(
        id: 'demo-user', fullName: 'Amadou Ouédraogo', email: 'demo@biosmart.bf',
        phone: '+226 70 00 00 00', farmName: 'Ferme BioSmart',
        role: 'admin', profileImageUrl: '',
        location: 'Plateau Central, Burkina Faso', createdAt: DateTime.now(),
      );
    }
    final user = _authInstance!.currentUser;
    if (user == null) return null;
    return await _fetchUserProfile(user.uid);
  }

  Future<void> updateUserProfile(Map<String, dynamic> updates) async {
    if (_authInstance == null) return;
    final user = _authInstance!.currentUser;
    if (user == null) throw AuthException('Non connecté.');
    await _firestoreInstance?.collection('users').doc(user.uid).update(updates);
  }

  /// Map Firebase error codes to French messages.
  String _mapAuthError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'Aucun compte trouvé avec cet email.';
      case 'wrong-password':
        return 'Mot de passe incorrect.';
      case 'email-already-in-use':
        return 'Cet email est déjà utilisé.';
      case 'weak-password':
        return 'Le mot de passe est trop faible (min. 6 caractères).';
      case 'invalid-email':
        return 'Adresse email invalide.';
      case 'too-many-requests':
        return 'Trop de tentatives. Réessayez plus tard.';
      case 'user-disabled':
        return 'Ce compte a été désactivé.';
      case 'network-request-failed':
        return 'Erreur réseau. Vérifiez votre connexion.';
      default:
        return 'Erreur d\'authentification: $code';
    }
  }
}

/// Custom auth exception with user-friendly message.
class AuthException implements Exception {
  final String message;
  const AuthException(this.message);

  @override
  String toString() => message;
}
