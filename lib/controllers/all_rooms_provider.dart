import 'package:flutter/material.dart';
import 'package:namesa/core/api_services.dart';

class AllRoomsProvider extends ChangeNotifier {
  final ApiService apiService;

  AllRoomsProvider(this.apiService) {
    viewAllRooms();
  }

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  Map<String, dynamic> result = {};

  // void finishLoad() {
  //   notifyListeners();
  // }

  Future<void> viewAllRooms({int pageIndex = 1}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    var data = await apiService.viewAllRooms(6, pageIndex);
    // print(data);

    if (data.isNotEmpty) {
      _isLoading = false;
      _errorMessage = null;
      result = data;
      // print(result);
      notifyListeners();
    } else {
      _isLoading = false;
      _errorMessage = "No room to view";
      notifyListeners();
    }
  }
}
