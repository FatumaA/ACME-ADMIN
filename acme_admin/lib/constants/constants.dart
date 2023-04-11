import 'package:acme_admin/state/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supaClient = Supabase.instance.client;

AppBar appBar(String title) => AppBar(
      title: Text(title),
      // automaticallyImplyLeading: false,
    );

String checkUserRole(BuildContext context) {
  final activeUser = context.read<AuthStateLocal>().activeUser;
  return activeUser?.userMetadata?['user_role'];
}

dynamic snackbar(String message, bool isError, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('The user does not exist'),
      duration: Duration(seconds: 2),
      backgroundColor: Colors.red,
    ),
  );
}
