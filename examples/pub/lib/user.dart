import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final userProvider = StreamProvider<UserIdentity?>((ref) {
  return FirebaseAuth.instance.userChanges().map((event) {
    if (event == null) return null;
    return UserIdentity(
      displayName: event.displayName,
      email: event.email!,
      id: event.uid,
      photoUrl: event.photoURL,
      serverAuthCode: null,
    );
  });
});

class UserIdentity implements GoogleIdentity {
  UserIdentity({
    required this.displayName,
    required this.email,
    required this.id,
    required this.photoUrl,
    required this.serverAuthCode,
  });

  @override
  final String? displayName;

  @override
  final String email;

  @override
  final String id;

  @override
  final String? photoUrl;

  @override
  final String? serverAuthCode;
}
