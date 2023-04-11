import 'package:acme_admin/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthStateLocal extends ChangeNotifier {
  Session? _activeSession;
  Session? get activeSession => _activeSession;
  User? _activeUser;
  User? get activeUser => _activeUser;
  bool get loggedIn => _activeSession != null;

  login(String email, String password) async {
    final res = await supaClient.auth
        .signInWithPassword(email: email, password: password);
    print('from localauthstate: $res');
    _activeSession = res.session;
    _activeSession = activeSession;
    _activeUser = res.user;
    _activeUser = activeUser;
    notifyListeners();
    return res;
  }

  Future<void> logout() async {
    await supaClient.auth.signOut();
    _activeSession = null;
    print('test logout from AuthStateLocal');
    notifyListeners();
  }
}
