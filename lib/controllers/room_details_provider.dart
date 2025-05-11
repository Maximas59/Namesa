import 'package:flutter/material.dart';
import 'package:namesa/core/api_services.dart';
import 'package:namesa/models/room_model.dart';

class RoomDetailsProvider extends ChangeNotifier {
  final ApiService apiService;

  RoomDetailsProvider(this.apiService);

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;
  RoomModel result = RoomModel();

  Future<void> viewRoomDetails(int roomId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    var data = await apiService.viewRoomDetails(roomId);

    // print(data);
    if (data.isNotEmpty) {
      _isLoading = false;
      _errorMessage = null;
      result = RoomModel.fromJson(data);
      notifyListeners();
    } else {
      _isLoading = false;
      _errorMessage = "No room to view";
      notifyListeners();
    }
  }
}
