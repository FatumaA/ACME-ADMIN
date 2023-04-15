import 'package:acme_admin/state/db.dart';
import 'package:flutter/material.dart';
import 'package:acme_admin/routes/router.dart';
import 'package:acme_admin/state/auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL']!,
      anonKey: dotenv.env['SUPABASE_ANON_KEY']!);
  setPathUrlStrategy();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final dbState = DBStateLocal();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthStateLocal>(create: (_) => authState),
        ChangeNotifierProvider<DBStateLocal>(create: (_) => dbState),
      ],
      child: MaterialApp.router(
        routerConfig: router,
        title: 'ACME LTD',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
      ),
    );
  }
}
