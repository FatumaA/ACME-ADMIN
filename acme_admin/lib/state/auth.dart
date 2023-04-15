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

  logout() async {
    await supaClient.auth.signOut();
    _activeSession = null;
    _activeSession = activeSession;
    print('Logout from AuthStateLocal');
    notifyListeners();
  }

  Future<UserResponse?> updateUser(
      {required String passwordValue, required String nameValue}) async {
    final isPasswordTyped = passwordValue.isNotEmpty;
    final hasNameChanged = (activeUser!.userMetadata!['name'] != nameValue);

    print('ISPASSWORDTYPED: $isPasswordTyped, HASNAMECHANGED: $hasNameChanged');

    // if password and name changed
    if (isPasswordTyped && hasNameChanged) {
      final res = await supaClient.auth.updateUser(
        UserAttributes(
          password: passwordValue,
          data: {
            'name': nameValue,
          },
        ),
      );
      _activeUser = res.user;
      _activeUser = activeUser;
      notifyListeners();
      print('password and name changed : ${res.toString()}');
      return res;
    }

    // if no password but name changed
    if (!isPasswordTyped && hasNameChanged) {
      final res = await supaClient.auth.updateUser(
        UserAttributes(
          data: {
            'name': nameValue,
          },
        ),
      );
      _activeUser = res.user;
      _activeUser = activeUser;
      notifyListeners();
      print('only name changed: $res');
      return res;
    }

    // if no name but password changed
    if (isPasswordTyped && !hasNameChanged) {
      final res = await supaClient.auth.updateUser(
        UserAttributes(
          password: passwordValue,
        ),
      );
      _activeUser = res.user;
      _activeUser = activeUser;
      notifyListeners();
      print('only password changed: ${res.toString()}');
      return res;
    }
  }
}
