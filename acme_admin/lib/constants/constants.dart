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

dynamic snackbar(
    String message, bool? isError, bool? isWarning, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 3),
      backgroundColor: isError == true
          ? Colors.red
          : isWarning == true
              ? Colors.amber[900]
              : Colors.green,
    ),
  );
}
