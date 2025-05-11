import 'package:flutter/material.dart';
import 'package:namesa/core/api_services.dart';
import 'package:namesa/core/cached_data.dart';

class RegisterProvider extends ChangeNotifier {
  final ApiService apiService;

  RegisterProvider(this.apiService);

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  Future<void> register(
      String username,
      String email,
      String address,
      String password,
      String userType,
      String employementType,
      String gender) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    var data = await apiService.register(
        username: username,
        email: email,
        address: address,
        password: password,
        userType: userType,
        employementType: employementType,
        gender: gender);

    // print(data);
    if (data.isNotEmpty) {
      _isLoading = false;
      _errorMessage = null;
      // print(data["token"]);
      MyCache.setString(key: "token", value: data["token"]);
      notifyListeners();
    } else {
      _isLoading = false;
      _errorMessage = "Try Again Please";
      notifyListeners();
    }
  }
}
