import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'registration_page.dart';
import 'package:rellai_frontend/screens/auth/reset_password_page.dart';
import '../professional/routing_page.dart';
import 'package:rellai_frontend/utils/show_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import "package:local_auth/local_auth.dart";

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool _rememberMe = false;
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _biometricAvailable = false;
  String? _email;
  String? _password;

  void _dismissKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  Future<void> _checkBiometricAvailability() async {
    final localAuth = LocalAuthentication();
    bool canCheckBiometrics = await localAuth.canCheckBiometrics;

    if (canCheckBiometrics) {
      List<BiometricType> availableBiometrics =
          await localAuth.getAvailableBiometrics();
      bool hasBiometrics = availableBiometrics.isNotEmpty;

      setState(() {
        _biometricAvailable = hasBiometrics;
      });
    }
  }

  Future<void> _authenticateWithBiometrics(BuildContext context) async {
    final localAuth = LocalAuthentication();
    bool canUseBiometrics = await localAuth.canCheckBiometrics;

    if (canUseBiometrics) {
      try {
        bool didAuthenticate = await localAuth.authenticate(
          localizedReason: 'Please authenticate to login',
        );

        if (didAuthenticate) {
          _handleAuthenticationSuccess(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Biometric Authentication failed")),
          );
        }
      } catch (e) {
        print(e);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Biometric authentication not available")),
      );
    }
  }

  void _handleAuthenticationSuccess(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString("email");
    String? password = prefs.getString("password");

    if (email != null && password != null) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);

        if (!userCredential.user!.emailVerified) {
          _handleEmailVerification(context);
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MainScreen()),
          );
        }
      } on FirebaseAuthException catch (e) {
        String message = 'Si è verificato un errore. Riprova più tardi.';

        if (e.code == 'user-not-found') {
          message = 'Nessun utente trovato con questa email.';
        } else if (e.code == 'wrong-password') {
          message = 'Password errata per questo utente.';
        }

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
      }
    }
  }

  void _signIn(BuildContext context) async {
    HapticFeedback.heavyImpact();
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: _emailController.text,
                password: _passwordController.text);

        if (!userCredential.user!.emailVerified) {
          _handleEmailVerification(context);
        } else {
          _handleRememberMe(true);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MainScreen()),
          );
        }
      } on FirebaseAuthException catch (e) {
        String message = 'Si è verificato un errore. Riprova più tardi.';

        if (e.code == 'user-not-found') {
          message = 'Nessun utente trovato con questa email.';
        } else if (e.code == 'wrong-password') {
          message = 'Password errata per questo utente.';
        }

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _handleEmailVerification(BuildContext context) {
    showCustomDialog(
      context,
      "Verifica la tua mail",
      "Non hai ancora confermato la tua mail, invia di nuovo la conferma ed accettala per utilizzare il servizio",
      "Invia mail di verifica",
      () {
        FirebaseAuth.instance.currentUser?.sendEmailVerification();
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
        );
      },
    );
  }

  void _handleRememberMe(bool value) async {
    _rememberMe = value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("remember_me", value);
    prefs.setString('email', _emailController.text);
    prefs.setString('password', _passwordController.text);

    setState(() {
      _rememberMe = value;
    });
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void _loadUserEmailPassword() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var email = prefs.getString("email") ?? "";
      var password = prefs.getString("password") ?? "";
      var rememberMe = prefs.getBool("remember_me") ?? false;

      if (rememberMe) {
        setState(() {
          _rememberMe = true;
        });
        _email = email;
        _password = password;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _loadUserEmailPassword();
    _checkBiometricAvailability();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _dismissKeyboard(context),
      child: Scaffold(
        body: Center(
          child: _isLoading
              ? const CircularProgressIndicator()
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: AutofillGroup(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Image.asset('assets/rellai-logo.png', height: 120),
                            const SizedBox(height: 80.0),
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              autofillHints: const [AutofillHints.email],
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.email),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Inserisci la tua email';
                                }
                                // Validate email
                                return null;
                              },
                            ),
                            const SizedBox(height: 16.0),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: !_isPasswordVisible,
                              autofillHints: const [AutofillHints.password],
                              decoration: InputDecoration(
                                labelText: 'Password',
                                border: const OutlineInputBorder(),
                                prefixIcon: const Icon(Icons.lock),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: _togglePasswordVisibility,
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Inserisci la tua password';
                                }
                                // Validate password
                                return null;
                              },
                            ),
                            const SizedBox(height: 16.0),
                            (_biometricAvailable &&
                                    _email != null &&
                                    _password != null)
                                ? ElevatedButton(
                                    onPressed: () {
                                      _authenticateWithBiometrics(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      padding: const EdgeInsets.all(16.0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        side: BorderSide(
                                            color:
                                                Theme.of(context).primaryColor),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(Icons.tag_faces,
                                            color:
                                                Theme.of(context).primaryColor),
                                        const SizedBox(
                                            width:
                                                10.0), // Add some space between the icon and the text
                                        Text(
                                          'Login Biometrico',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor),
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(),
                            (_biometricAvailable &&
                                    _email != null &&
                                    _password != null)
                                ? const SizedBox(height: 16.0)
                                : Container(),
                            ElevatedButton(
                              onPressed: _isLoading
                                  ? null
                                  : () {
                                      _signIn(context);
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                                padding: const EdgeInsets.all(16.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              child: const Text(
                                'Accedi',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const RegistrationScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                'Non hai un account? Registrati qui.',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ResetPasswordPage(),
                                  ),
                                );
                              },
                              child: Text(
                                'Password dimenticata? Reimpostala qui.',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
