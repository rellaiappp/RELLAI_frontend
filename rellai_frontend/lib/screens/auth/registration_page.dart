import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:rellai_frontend/utils/show_dialog.dart';
import 'package:rellai_frontend/services/api/user.dart';
import 'package:rellai_frontend/models/user.dart';

import 'login_page.dart';

enum Role { homeowner, business }

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();
  bool _isPasswordVisible = false; // Traccia la visibilità delle password
  bool _isLoading = false;

  Role _selectedRole = Role.business;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Nascondi la tastiera quando viene toccato fuori dai campi di input
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text('Registrazione'),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildRoleSegmentedButton(),
                    const SizedBox(height: 16.0),
                    _buildTextField(_firstNameController, 'Nome',
                        TextInputType.text, _validateNome),
                    const SizedBox(height: 16.0),
                    _buildTextField(_lastNameController, 'Cognome',
                        TextInputType.text, _validateCognome),
                    const SizedBox(height: 16.0),
                    _buildTextField(_emailController, 'Email',
                        TextInputType.emailAddress, _validateEmail,
                        focusNode: _emailFocusNode),
                    const SizedBox(height: 16.0),
                    _buildPasswordField(
                        _passwordController,
                        'Password',
                        _passwordFocusNode,
                        _togglePasswordVisibility,
                        _isPasswordVisible,
                        _validatePassword),
                    const SizedBox(height: 16.0),
                    _buildPasswordField(
                        _confirmPasswordController,
                        'Conferma Password',
                        _confirmPasswordFocusNode,
                        _togglePasswordVisibility,
                        _isPasswordVisible,
                        _validateConfirmPassword),
                    const SizedBox(height: 16.0),
                    _buildRegisterButton(),
                    const SizedBox(height: 16.0),
                    _buildLoginLink(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleSegmentedButton() {
    return SegmentedButton<Role>(
      segments: const [
        ButtonSegment<Role>(
          value: Role.homeowner,
          label: Text('Committente'),
          icon: Icon(Icons.person),
        ),
        ButtonSegment<Role>(
          value: Role.business,
          label: Text('Azienda'),
          icon: Icon(Icons.business),
        ),
      ],
      selected: {_selectedRole},
      onSelectionChanged: (Set<Role> newSelection) {
        setState(() {
          _selectedRole = newSelection.first;
        });
      },
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText,
      TextInputType keyboardType, FormFieldValidator<String> validator,
      {FocusNode? focusNode}) {
    return TextFormField(
      textCapitalization: TextCapitalization.sentences,
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
      ),
      validator: validator,
      textInputAction: focusNode == _confirmPasswordFocusNode
          ? TextInputAction.done
          : TextInputAction.next,
      onFieldSubmitted: (value) {
        if (focusNode == _emailFocusNode) {
          _passwordFocusNode.requestFocus();
        } else if (focusNode == _passwordFocusNode) {
          _confirmPasswordFocusNode.requestFocus();
        } else {
          _register(context);
        }
      },
    );
  }

  Widget _buildPasswordField(
      TextEditingController controller,
      String labelText,
      FocusNode focusNode,
      void Function() toggleVisibility,
      bool isPasswordVisible,
      FormFieldValidator<String> validator) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      obscureText: !isPasswordVisible,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(
            isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: toggleVisibility,
        ),
      ),
      validator: validator,
      textInputAction: focusNode == _confirmPasswordFocusNode
          ? TextInputAction.done
          : TextInputAction.next,
      onFieldSubmitted: (value) {
        if (focusNode == _passwordFocusNode) {
          _confirmPasswordFocusNode.requestFocus();
        } else {
          _register(context);
        }
      },
    );
  }

  Widget _buildRegisterButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).primaryColor,
        padding: const EdgeInsets.all(16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      onPressed: _isLoading
          ? null
          : () {
              _register(context);
            },
      child: _isLoading
          ? const CircularProgressIndicator()
          : const Text(
              'Registrati',
              style: TextStyle(color: Colors.white),
            ),
    );
  }

  Widget _buildLoginLink() {
    return Center(
      child: InkWell(
        onTap: () async {
          final loggedInUser = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginPage(),
            ),
          );
          if (loggedInUser != null && !(loggedInUser as User).emailVerified) {
            _showEmailVerificationDialog();
          }
        },
        child: Text(
          'Hai già un account? Accedi qui.',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }

  String? _validateNome(String? value) {
    if (value == null || value.isEmpty) {
      return 'Inserisci il tuo nome.';
    }
    return null;
  }

  String? _validateCognome(String? value) {
    if (value == null || value.isEmpty) {
      return 'Inserisci il tuo cognome.';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Inserisci un indirizzo email.';
    }
    if (!EmailValidator.validate(value)) {
      return 'Inserisci un indirizzo email valido.';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Inserisci una password.';
    }
    if (value.length < 6) {
      return 'La password deve contenere almeno 6 caratteri.';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    final password = _passwordController.text;
    if (value == null || value.isEmpty) {
      return 'Conferma la tua password.';
    }
    if (value != password) {
      return 'Le password non corrispondono.';
    }
    return null;
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void _register(context) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        final user = userCredential.user!;
        user.sendEmailVerification();

        final appUser = AppUser(
          authId: user.uid,
          email: user.email!,
          role: _selectedRole
              .toString()
              .split('.')
              .last, // Convert enum value to string
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
        );

        await UserCRUD().createUser(appUser, await user.getIdToken());

        showCustomDialog(
          context,
          'Registrazione avvenuta con successo',
          'Conferma la tua email per poter accedere al servizio',
          'OK',
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
      } on FirebaseAuthException catch (e) {
        String message = 'Si è verificato un errore. Riprova più tardi.';

        if (e.code == 'email-already-in-use') {
          message = 'L\'indirizzo email è già in uso da un altro account.';
        } else if (e.code == 'weak-password') {
          message = 'La password fornita è troppo debole.';
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

  void _showEmailVerificationDialog() {
    showCustomDialog(
      context,
      'Registrazione avvenuta con successo',
      'Conferma la tua email per poter accedere al servizio',
      'OK',
      () {
        Navigator.of(context).pop();
      },
    );
  }
}
