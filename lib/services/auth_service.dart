import 'package:bi_suru_app/models/owner_model.dart';
import 'package:bi_suru_app/models/responses/auth_response.dart';
import 'package:bi_suru_app/models/user_model.dart';
import 'package:bi_suru_app/services/database_service.dart';
import 'package:bi_suru_app/services/hive_service.dart';
import 'package:bi_suru_app/utils/extensions.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  DatabaseService databaseService = DatabaseService();

  Future<AuthResponse> userRegister({required UserModel userModel, required String password}) async {
    late UserCredential userCredential;
    try {
      userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: userModel.email,
        password: password,
      );
    } on FirebaseAuthException catch (error) {
      return AuthResponse(isSuccessful: false, message: getMessageFromErrorCode(error), user: null);
    }

    userModel.uid = userCredential.user!.uid;
    await databaseService.createNewUserModel(userModel: userModel);

    return AuthResponse(isSuccessful: true, message: 'Başarılı', user: userCredential.user);
  }

  Future<AuthResponse> login({required String email, required String password}) async {
    late UserCredential userCredential;
    try {
      userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (error) {
      return AuthResponse(isSuccessful: false, message: getMessageFromErrorCode(error), user: null);
    }

    return AuthResponse(isSuccessful: true, message: 'Başarılı', user: userCredential.user);
  }

  Future<AuthResponse> ownerRegister({required OwnerModel ownerModel, required String password}) async {
    late UserCredential userCredential;
    try {
      userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: ownerModel.email,
        password: password,
      );
    } on FirebaseAuthException catch (error) {
      return AuthResponse(isSuccessful: false, message: getMessageFromErrorCode(error), user: null);
    }

    print('auth ok ');

    ownerModel.uid = userCredential.user!.uid;
    await databaseService.createNewOwnerModel(ownerModel: ownerModel);

    return AuthResponse(isSuccessful: true, message: 'Başarılı', user: userCredential.user);
  }

  User? getUser() {
    return firebaseAuth.currentUser;
  }

  Future<void> logout() async {
    await HiveService().delete('user-type');
    await firebaseAuth.signOut();
  }
}
