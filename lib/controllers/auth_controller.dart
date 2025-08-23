import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';


class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  var user = Rxn<User>();

  @override
  void onInit() {
    super.onInit();
    user.bindStream(_auth.authStateChanges());
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return; 

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Firebase credential oluştur
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Firebase login
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      // Kullanıcı Firestore’a kaydedilsin
      final User? firebaseUser = userCredential.user;
      if (firebaseUser != null) {
      final userDoc = _db.collection("users").doc(firebaseUser.uid);

      final docSnapshot = await userDoc.get();
      if (!docSnapshot.exists) {
        await userDoc.set({
          "uid": firebaseUser.uid,
          "fullName": firebaseUser.displayName,
          "email": firebaseUser.email,
          "createdAt": DateTime.now(),
          "lastLogin": DateTime.now(),
        });
      } else {
        // Var olan kullanıcı için sadece lastLogin güncellensin
        await userDoc.update({
          "lastLogin": DateTime.now(),
        });
      }
    }
  } catch (e) {
    print("Google sign in error: $e");
  }
}
  Future<void> signOut() async {
    await GoogleSignIn().signOut();
    await _auth.signOut();
  }

  // Kullanıcı oturumda mı?
  bool get isLoggedIn => user.value != null;
}
