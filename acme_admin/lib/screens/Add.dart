import 'package:acme_admin/constants/constants.dart';
import 'package:acme_admin/state/auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Add extends StatefulWidget {
  final String activeUserRole;
  const Add({Key? key, required this.activeUserRole}) : super(key: key);

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();

  // Future<List> sendNewUserEmail() async {}

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: ListView(
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.all(24.0),
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  'Add New User',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty || value.length < 3) {
                  return 'Please enter a name that is atleast 6 characters long';
                }
                return null;
              },
              decoration: const InputDecoration(
                icon: Icon(Icons.person),
                prefixStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
                hintText: 'Enter Name',
              ),
              controller: _name,
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
                hintText: 'Enter Email',
              ),
              controller: _email,
            ),
            const SizedBox(
              height: 16,
            ),
            SizedBox(
              width: double.infinity,
              height: 40,
              child: ElevatedButton(
                child: const Text(
                  'Add',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // sign up the new user
                    final _password = 'password123';
                    final res = await supaClient.auth.admin.createUser(
                      AdminUserAttributes(
                        email: _email.text,
                        password: _password,
                        data: {
                          'name': _name.text,
                          'user_role': widget.activeUserRole == 'admin'
                              ? 'agent'
                              : 'customer'
                        },
                      ),
                    );
                    // supaClient.auth
                    //     .signUp(password: _password, email: _email.text, data: {
                    //   'name': _name.text,
                    //   'user_role': widget.activeUserRole == 'admin'
                    //       ? 'agent'
                    //       : 'customer'
                    // });
                    print('ADD.DART!!! $res');
                    // if success: send them an email with their email and password login details
                    if (res.user != null) {
                      await supaClient.functions.invoke('sendNewUserEmail',
                          body: {'email': _email.text, 'password': _password});
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
