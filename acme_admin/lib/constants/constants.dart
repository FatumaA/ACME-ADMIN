import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supaClient = Supabase.instance.client;

AppBar appBar(String title) => AppBar(
      title: Text(title),
      // automaticallyImplyLeading: false,
    );

dynamic snackbar(String message, bool isError, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('The user does not exist'),
      duration: Duration(seconds: 2),
      backgroundColor: Colors.red,
    ),
  );
}
