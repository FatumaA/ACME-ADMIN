import 'package:acme_admin/constants/constants.dart';
import 'package:acme_admin/state/auth.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Profile extends StatefulWidget {
  // final User activeUser;
  const Profile({
    super.key,
    // required this.activeUser
  });

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  displayFeedback(String message, bool isError, bool isWarning) {
    return snackbar(message, isError, isWarning, context);
  }

  returnActiveUserName(BuildContext context) {
    final activeUserName =
        context.read<AuthStateLocal>().activeUser!.userMetadata!['name'];
    return activeUserName;
  }

  @override
  void initState() {
    super.initState();
    // _name.text = widget.activeUser.userMetadata!['name'];
    // _email.text = widget.activeUser.email!;
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeUser = context.watch<AuthStateLocal>().activeUser;
    _name.text = activeUser!.userMetadata!['name'];
    _email.text = activeUser.email!;
    return Scaffold(
      body: Form(
        key: _formKey,
        child: ListView(
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.all(60.0),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 30.0),
              child: Column(
                children: [
                  const Text(
                    'Profile Details',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const Text('Update Details by typing into the fields below.'),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    'Note: Email address cannot be updated.',
                    style: TextStyle(color: Colors.amber[900]),
                  ),
                ],
              ),
            ),
            const Text(
              'Name:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty || value.length < 3) {
                  return 'Please enter a name that is atleast 6 characters long';
                }
                return null;
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              controller: _name,
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              'Email:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            TextFormField(
              enableInteractiveSelection: false,
              decoration: const InputDecoration(
                enabled: false,
                border: OutlineInputBorder(),
              ),
              controller: _email,
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              'Password:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter new password to update password',
              ),
              controller: _password,
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: double.infinity,
              height: 40,
              child: ElevatedButton(
                child: const Text(
                  'Update Profile',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // check if password is empty before updating and if there is a change in name
                    final isPasswordTyped = _password.text.isNotEmpty;
                    final hasNameChanged =
                        (activeUser.userMetadata!['name'] != _name.text);

                    if (isPasswordTyped && _password.text.length < 6) {
                      _password.text = '';
                      return displayFeedback(
                          'Password should be atleast 6 characters',
                          true,
                          false);
                    }

                    if (!isPasswordTyped && !hasNameChanged) {
                      return displayFeedback(
                          'No profile changes detected', false, true);
                    }

                    final res = await context.read<AuthStateLocal>().updateUser(
                        passwordValue: _password.text,
                        nameValue: _name.text) as UserResponse;

                    res.user != null
                        ? displayFeedback(
                            'Profile updated successfully', false, false)
                        : displayFeedback(
                            'An error occured, try again', true, false);
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
