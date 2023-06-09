import 'package:acme_admin/constants/constants.dart';
import 'package:acme_admin/state/auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key}) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  Future<List> checkIfUserExistsAndAdmin(String email, String password) async {
    final response = await supaClient
        .from('agent')
        .select()
        .eq('email', email)
        .eq('password', password)
        .eq('is_admin', true);
    return response;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
        key: _formKey,
        child: ListView(
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.all(24.0),
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  'Sign In to ACME',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            TextFormField(
              validator: (value) {
                if (value == null ||
                    value.isEmpty ||
                    !EmailValidator.validate(_email.text)) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
              decoration: const InputDecoration(
                icon: Icon(Icons.email),
                border: OutlineInputBorder(),
                hintText: 'Enter your email',
              ),
              controller: _email,
            ),
            const SizedBox(
              height: 16,
            ),
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty || value.length < 6) {
                  return 'Please enter a password that is atleast 6 characters long';
                }
                return null;
              },
              decoration: const InputDecoration(
                icon: Icon(Icons.lock),
                prefixStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
                hintText: 'Enter your password',
              ),
              controller: _password,
            ),
            const SizedBox(
              height: 16,
            ),
            SizedBox(
              width: double.infinity,
              height: 40,
              child: ElevatedButton(
                child: const Text(
                  'Sign In',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onPressed: () async {
                  // if (_formKey.currentState!.validate()) {
                  // await supaClient.auth.signUp(
                  //   email: 'admin@acme.com',
                  //   password: '123456',
                  //   data: {'name': 'Acme Admin', 'user_role': 'admin'},
                  // );
                  final res = await context
                      .read<AuthStateLocal>()
                      .login('agent@acme.com', '123456');

                  // context.go('/dashboard');
                  // .login(_email.text, _password.text);
                  // if (res.error != null) {
                  //   _email.text = '';
                  //   _password.text = '';
                  //   snackbar(
                  //       'An error occured, please doubke check your login details',
                  //       true,
                  //       context);
                  // }
                  // }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
