import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

import '../../../core/stores/error/error_store.dart';
import '../../../core/stores/form/form_store.dart';
import '../../../domain/entity/user/user.dart';
import '../../../domain/usecase/user/is_logged_in_usecase.dart';
import '../../../domain/usecase/user/login_usecase.dart';
import '../../../domain/usecase/user/remove_auth_token_usecase.dart';
import '../../../domain/usecase/user/save_auth_token_usecase.dart';
import '../../../domain/usecase/user/save_login_in_status_usecase.dart';
import '../../../domain/usecase/user/save_userId_usecase.dart';
import '../login.dart';

part 'login_store.g.dart';

class UserStore = _UserStore with _$UserStore;

abstract class _UserStore with Store {
  // constructor:---------------------------------------------------------------
  _UserStore(
      this._isLoggedInUseCase,
      this._saveLoginStatusUseCase,
      this._loginUseCase,
      this.formErrorStore,
      this._removeAuthTokenUsecase,
      this._saveAuthTokenUsecase,
      this._saveUseridUsecase,
      this.errorStore,
      ) {
    // setting up disposers
    _setupDisposers();

    // checking if user is logged in
    _isLoggedInUseCase.call(params: null).then((value) async {
      isLoggedIn = value;
    });
  }

  // use cases:-----------------------------------------------------------------
  final IsLoggedInUseCase _isLoggedInUseCase;
  final SaveLoginStatusUseCase _saveLoginStatusUseCase;
  final LoginUseCase _loginUseCase;
  final RemoveAuthTokenUsecase _removeAuthTokenUsecase;
  final SaveAuthTokenUsecase _saveAuthTokenUsecase;
  final SaveUseridUsecase _saveUseridUsecase;

  // stores:--------------------------------------------------------------------
  // for handling form errors
  final FormErrorStore formErrorStore;

  // store for handling error messages
  final ErrorStore errorStore;

  // disposers:-----------------------------------------------------------------
  late List<ReactionDisposer> _disposers;


  void _setupDisposers() {
    _disposers = [
      reaction((_) => success, (_) => success = false, delay: 200),
    ];
  }

  // empty responses:-----------------------------------------------------------
  static ObservableFuture<User?> emptyLoginResponse =
  ObservableFuture.value(null);

  // store variables:-----------------------------------------------------------
  bool isLoggedIn = false;

  @observable
  bool success = false;

  @observable
  ObservableFuture<User?> loginFuture = emptyLoginResponse;

  @computed
  bool get isLoading => loginFuture.status == FutureStatus.pending;

  // actions:-------------------------------------------------------------------
  @action
  Future login(String email, String password) async {
    loginFuture = ObservableFuture.value(null);
    success = false;
    isLoggedIn = false;

    try {
      firebase.UserCredential userCredential = await firebase
          .FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);


      String? token = await userCredential.user?.getIdToken();

      if (token != null && token.isNotEmpty) {
        await _saveAuthTokenUsecase(params: token);
        final User? user = await _loginUseCase.call(params: LoginParams(email: email, password: password));
        log("Login state : $user");
        if (user != null ) {
          await _saveLoginStatusUseCase.call(params: true);
          await _saveUseridUsecase.call(params: user.userId);
          isLoggedIn = true;
          success = true;
        } else {
          print('Login failed: User or userId is null');
        }

      } else {
        print('Login failed: Invalid token');
      }
    } catch (e) {
      print('Login error: $e');
      throw e;
    } finally {
      loginFuture = ObservableFuture.value(null);
    }
  }

  @action
  Future signUp(String email, String password, String username) async {
    try {
      firebase.UserCredential userCredential = await firebase
          .FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      firebase.User? user = userCredential.user;

      // Handle successful sign-up
      if (user != null) {
        await user.sendEmailVerification();


        if (user.emailVerified) {
          await _saveLoginStatusUseCase.call(params: true);
        }
      }
    } on firebase.FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        errorStore.errorMessage = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        errorStore.errorMessage = 'The account already exists for that email.';
      } else {
        errorStore.errorMessage = e.message ?? 'Sign up failed';
      }
      print(e);
      this.isLoggedIn = false;
      this.success = false;
    } catch (e) {
      errorStore.errorMessage = 'Sign up failed';
      print(e);
      this.isLoggedIn = false;
      this.success = false;
    }
  }

  // In your UserStore
  @action
  Future<void> logout( BuildContext context) async {
    try {
      await firebase.FirebaseAuth.instance.signOut(); // Sign out first
      this.isLoggedIn = false;
      await _saveLoginStatusUseCase.call(params: false);
      await _removeAuthTokenUsecase.call(params: null);
      await _saveUseridUsecase.call(params: '');
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()), (Route<dynamic> route) => false);
    } catch (e) {
      print('Logout error: $e');
      // Handle the error appropriately (e.g., show an error message)
    }
  }

  // general methods:-----------------------------------------------------------
  void dispose() {
    for (final d in _disposers) {
      d();
    }
  }

  @action
  Future<void> loginStatusSignInWithGoogle(String token,String userId) async {
    await _saveLoginStatusUseCase.call(params: true);
    await _saveUseridUsecase.call(params: userId);
    isLoggedIn = true;
    success = true;
  }
}
