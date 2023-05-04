import 'package:flutter/material.dart';
import 'package:rellai_frontend/models/user.dart';
import 'package:rellai_frontend/services/api_service.dart';

class UserModel extends ChangeNotifier {
  AppUser? user;

  void load(String id) async {
    user = await ApiService().getUserInfo();
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }
}
