import 'package:flutter/foundation.dart';
import 'package:rellai_frontend/models/user.dart';
import 'package:rellai_frontend/services/api/user.dart';

class UserProvider with ChangeNotifier {
  AppUser? _currentUser;

  AppUser? get user => _currentUser;

  Future<bool> updateUser() async {
    _currentUser = await UserCRUD().getCurrentUser();
    notifyListeners();
    return true;
  }

  void clearAll() {
    _currentUser = null;
    notifyListeners();
  }
}
