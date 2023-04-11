import 'package:flutter/material.dart';

class ShowDetail extends StatelessWidget {
  final String id = '';
  ShowDetail({super.key, required id});

  @override
  Widget build(BuildContext context) {
    return Text(id);
  }
}
