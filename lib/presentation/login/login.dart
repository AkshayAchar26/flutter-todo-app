import 'dart:developer';

import 'package:another_flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_app/presentation/login/store/login_store.dart';
import 'package:todo_app/presentation/todo/todo_home.dart';

import '../../constants/assets.dart';
import '../../core/stores/form/form_store.dart';
import '../../core/widgets/app_icon_widget.dart';
import '../../core/widgets/empty_app_bar_widget.dart';
import '../../core/widgets/progress_indicator_widget.dart';
import '../../core/widgets/rounded_button_widget.dart';
import '../../core/widgets/textfield_widget.dart';
import '../../data/sharedpref/constants/preferences.dart';
import '../../data/sharedpref/shared_preference_helper.dart';
import '../../di/service_locator.dart';
import '../../domain/usecase/user/login_usecase.dart';
import '../../domain/usecase/user/save_auth_token_usecase.dart';
import '../../utils/device/device_utils.dart';
import '../../utils/locale/app_localization.dart';
import '../../utils/routes/routes.dart';
import '../home/store/theme/theme_store.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //text controllers:-----------------------------------------------------------
  TextEditingController _userEmailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();

  //stores:---------------------------------------------------------------------
  final ThemeStore _themeStore = getIt<ThemeStore>();
  final FormStore _formStore = getIt<FormStore>();
  final UserStore _userStore = getIt<UserStore>();
  final SharedPreferenceHelper _sharedPreferenceHelper =
      getIt<SharedPreferenceHelper>();

  //focus node:-----------------------------------------------------------------
  late FocusNode _passwordFocusNode;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final SaveAuthTokenUsecase _saveAuthTokenUsecase =
      getIt<SaveAuthTokenUsecase>();
  final LoginUseCase _loginUseCase = getIt<LoginUseCase>();

  bool _isSignIn = true;

  @override
  void initState() {
    super.initState();
    _passwordFocusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: true,
      appBar: EmptyAppBar(),
      body: _buildBody(),
    );
  }

  // body methods:--------------------------------------------------------------
  Widget _buildBody() {
    return Material(
      child: Stack(
        children: <Widget>[
          _isSignIn ? Padding(
            padding: const EdgeInsets.only(top: 140, left: 25),
            child: Text("Sign In",
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 20
            ),
            ),
          ) : Padding(
            padding: const EdgeInsets.only(top: 140, left: 25),
            child: Text("Sign Up",
              style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 20

              ),
            ),
          ),
          Center(child: _buildRightSide()),
          Observer(
            builder: (context) {
              return _userStore.success
                  ? navigate(context)
                  : _showErrorMessage(_formStore.errorStore.errorMessage);
            },
          ),
          Observer(
            builder: (context) {
              return Visibility(
                visible: _userStore.isLoading,
                child: CustomProgressIndicatorWidget(),
              );
            },
          )
        ],
      ),
    );
  }

  Widget _buildLeftSide() {
    return SizedBox.expand(
      child: Image.asset(
        Assets.carBackground,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildRightSide() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 24.0),
            _isSignIn ? _buildSignInFields() : _buildSignUpFields(),
            // Show appropriate fields based on _isSignIn
            SizedBox(height: 24.0),
            _isSignIn ? _buildSignInButton() : _buildSignUpButton(),
            // Show appropriate button based on _isSignIn
            _buildOrText(),
            _buildGoogleSignInButton(),
            _buildSignUpSignInButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSignUpButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 10),
      child: ElevatedButton(
        // buttonText: AppLocalizations.of(context).translate('login_btn_sign_up'),
        child: Text('Sign In',
          style: TextStyle(
            color: _themeStore.darkMode ? Color.fromARGB(255, 42, 42, 42) : Color.fromARGB(255, 253, 211, 42),
          ),
        ),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
          ),
          backgroundColor: _themeStore.darkMode ? Color.fromARGB(255, 253, 211, 42) : Color.fromARGB(255, 42, 42, 42),
        ),
        onPressed: () async {
          if (_formStore.canLogin) {
            DeviceUtils.hideKeyboard(context);
            try {
              _userStore.signUp(_userEmailController.text,
                  _passwordController.text, _userEmailController.text);
              _userEmailController.clear();
              _passwordController.clear();
              _usernameController.clear();
              _showSuccessMessage(
                  'Verification email sent. Please check your inbox.');
            } on FirebaseAuthException catch (e) {
              _showErrorMessage('Failed to sign up: ${e.message}');
            }
          } else {
            _showErrorMessage('Please fill in all fields');
          }
        },
      ),
    );
  }

  _showSuccessMessage(String message) {
    if (message.isNotEmpty) {
      Future.delayed(Duration(milliseconds: 0), () {
        if (message.isNotEmpty) {
          FlushbarHelper.createSuccess(
            message: message,
            // title: AppLocalizations.of(context).translate('home_tv_success'),
            title: "success",
            duration: Duration(seconds: 3),
          )..show(context);
        }
      });
    }

    return SizedBox.shrink();
  }

  Widget _buildOrText() {
    // String? orText = AppLocalizations.of(context).translate('login_or');
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Center(
          child: Text('Or', style: Theme.of(context).textTheme.bodySmall)),
    );
  }

  Widget _buildUserIdField() {
    return Observer(
      builder: (context) {
        return TextFieldWidget(
          hint: AppLocalizations.of(context).translate('login_et_user_email'),
          inputType: TextInputType.emailAddress,
          icon: Icons.email,
          iconColor: _themeStore.darkMode ? Colors.white70 : Colors.black54,
          textController: _userEmailController,
          inputAction: TextInputAction.next,
          autoFocus: false,
          onChanged: (value) {
            _formStore.setUserId(_userEmailController.text);
          },
          onFieldSubmitted: (value) {
            FocusScope.of(context).requestFocus(_passwordFocusNode);
          },
          errorText: _formStore.formErrorStore.userEmail,
        );
      },
    );
  }

  Widget _buildSignUpSignInButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _isSignIn ? Text("Create account") : Text("Already have an account?"),
          TextButton(
            onPressed: () {
              setState(() {
                _isSignIn = !_isSignIn; // Toggle between sign-in and sign-up
              });
            },
            child: Text(
              // _isSignIn
              //     ? AppLocalizations.of(context).translate('login_btn_sign_up')
              //     : AppLocalizations.of(context).translate('login_btn_sign_in'),
              _isSignIn ? "sign up" : "sign in",
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.orangeAccent),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField() {
    return Observer(
      builder: (context) {
        return TextFieldWidget(
          hint:
              AppLocalizations.of(context).translate('login_et_user_password'),
          isObscure: true,
          padding: EdgeInsets.only(top: 16.0),
          icon: Icons.lock,
          iconColor: _themeStore.darkMode ? Colors.white70 : Colors.black54,
          textController: _passwordController,
          focusNode: _passwordFocusNode,
          errorText: _formStore.formErrorStore.password,
          onChanged: (value) {
            _formStore.setPassword(_passwordController.text);
          },
        );
      },
    );
  }

  Widget _buildForgotPasswordButton() {
    return Align(
      alignment: FractionalOffset.centerRight,
      child: MaterialButton(
        padding: EdgeInsets.all(0.0),
        child: Text(
          AppLocalizations.of(context).translate('login_btn_forgot_password'),
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: Colors.orangeAccent),
        ),
        onPressed: () {},
      ),
    );
  }

  Widget _buildSignInFields() {
    return Column(
      children: [
        SizedBox(height: 24.0),
        Container(),
        _buildUserIdField(),
        SizedBox(height: 24.0),
        _buildPasswordField(),
        SizedBox(height: 24.0),
        _buildForgotPasswordButton(),
      ],
    );
  }

  Widget _buildSignUpFields() {
    return Column(
      children: [
        SizedBox(height: 24.0),
        _buildUserIdField(),
        SizedBox(height: 24.0),
        _buildPasswordField(),
      ],
    );
  }

  Widget _buildSignInButton() {
    return ElevatedButton(
      child: Text('Sign In',
      style: TextStyle(
        color: _themeStore.darkMode ? Color.fromARGB(255, 42, 42, 42) : Color.fromARGB(255, 253, 211, 42),
      ),
      ),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
        ),
        backgroundColor: _themeStore.darkMode ? Color.fromARGB(255, 253, 211, 42) : Color.fromARGB(255, 42, 42, 42),
      ),
      onPressed: () async {
        if (_formStore.canLogin) {
          DeviceUtils.hideKeyboard(context);
          try {
            await _userStore.login(
                _userEmailController.text, _passwordController.text);
            _userEmailController.clear();
            _passwordController.clear();
            _usernameController.clear();

            final loginStatus = await _sharedPreferenceHelper.isLoggedIn;
            if (loginStatus) {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => TodoHome()));
            }
          } on FirebaseAuthException catch (e) {
            if (e.code == 'invalid-credential') {
              _showErrorMessage("Invalid email or password.");
            } else {
              print('Error: ${e.code}');
              _showErrorMessage("An error occurred. Please try again.");
            }
          } catch (e) {
            log('Error: $e');
            _showErrorMessage('An error occurred. Please try again.');
          }
        } else {
          _showErrorMessage('Please fill in all fields');
        }
      },
    );
  }

  Widget _buildGoogleSignInButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: ElevatedButton(
        child: Text('Sign in with google',
          style: TextStyle(
            color: _themeStore.darkMode ? Color.fromARGB(255, 42, 42, 42) : Color.fromARGB(255, 253, 211, 42),
          ),
        ),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
          ),
          backgroundColor: _themeStore.darkMode ? Color.fromARGB(255, 253, 211, 42) : Color.fromARGB(255, 42, 42, 42),
        ),
        onPressed: _signInWithGoogle,
      ),
    );
  }

  void _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);

        User userCred = await userCredential.user!;
        String? token = await userCred.getIdToken();

        if (token != null && token.isNotEmpty) {
          await _saveAuthTokenUsecase.call(params: token);
          final user = await _loginUseCase.call(
              params: LoginParams(
                  email: _userEmailController.text,
                  password: _passwordController.text));

          if (user != null) {
            _userStore.loginStatusSignInWithGoogle(token, user.userId);
          }
        }

        final loginStatus = await _sharedPreferenceHelper.isLoggedIn;
        if (loginStatus) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => TodoHome()));
        }
      }
    } catch (error) {
      print('Google sign-in error: $error');
    }
  }

  Widget navigate(BuildContext context) {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool(Preferences.is_logged_in, true);
    });

    Future.delayed(Duration(milliseconds: 0), () {
      Navigator.of(context).pushNamedAndRemoveUntil(
          Routes.home, (Route<dynamic> route) => false);
    });

    return Container();
  }

  // General Methods:-----------------------------------------------------------
  _showErrorMessage(String message) {
    if (message.isNotEmpty) {
      Future.delayed(Duration(milliseconds: 0), () {
        if (message.isNotEmpty) {
          FlushbarHelper.createError(
            message: message,
            title: AppLocalizations.of(context).translate('home_tv_error'),
            duration: Duration(seconds: 3),
          )..show(context);
        }
      });
    }

    return SizedBox.shrink();
  }

  // dispose:-------------------------------------------------------------------
  @override
  void dispose() {
    // Clean up the controller when the Widget is removed from the Widget tree
    _userEmailController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }
}
