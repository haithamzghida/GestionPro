import 'package:flutter/foundation.dart';

class UserModel with ChangeNotifier {
  String _role = '';

  String get role => _role;

  void setUserRole(String newRole) {
    _role = newRole;
    notifyListeners();
  }
}
