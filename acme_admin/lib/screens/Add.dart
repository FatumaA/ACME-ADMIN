import 'package:acme_admin/state/auth.dart';
import 'package:flutter/material.dart';
import 'package:acme_admin/constants/constants.dart';
import 'package:email_validator/email_validator.dart';
import 'package:provider/provider.dart';

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
    final activeUser = context.read<AuthStateLocal>().activeUser;
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
            const SizedBox(
              height: 16,
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
                    // create password
                    final _password = 'password123';

                    // invoke func that signs up user on BE then sends them an email
                    final res = await supaClient.functions
                        .invoke('sendNewUserEmail', body: {
                      'email': _email.text,
                      'password': _password,
                      'name': _name.text,
                      'role': widget.activeUserRole == 'admin'
                          ? 'agent'
                          : 'customer',
                      'agent_id': widget.activeUserRole == 'agent'
                          ? activeUser?.id
                          : null,
                    });
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
