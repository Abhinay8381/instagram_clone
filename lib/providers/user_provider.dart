import 'package:flutter/widgets.dart';
import 'package:instagram_clone/models/user_model.dart';
import 'package:instagram_clone/resources/auth_functions.dart';

class UserProvider with ChangeNotifier {
  final AuthFunctions _authFunctions = AuthFunctions();
  User? _user;
  User? get getUser => _user;

  Future<void> refreshUser() async {
    User user = await _authFunctions.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
