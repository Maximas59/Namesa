import 'package:flutter/material.dart';
import 'package:namesa/core/api_services.dart';
import 'package:namesa/core/cached_data.dart';
import 'package:namesa/models/reservation_model.dart';

class ReserveProvider extends ChangeNotifier {
  final ApiService apiService;

  ReserveProvider(this.apiService);

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;
  dynamic result;
  List<dynamic> reservations = [];
  String message = '';

  Future<void> reserveRoom(
      int roomId, String checkIn, String checkOut, int paymentMethod) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    var data =
        await apiService.reserveRoom(roomId, checkIn, checkOut, paymentMethod);

    result = ReservationResponse.fromJson(data);
    // print(data);
    if (data['data'] != null) {
      _isLoading = false;
      _errorMessage = null;
      MyCache.setString(key: 'token', value: data['data']['token']);
      MyCache.setString(key: 'role', value: "guest");
      // print(MyCache.getString(key: 'token'));
      notifyListeners();
    } else {
      _isLoading = false;
      _errorMessage = data['message'];
      // print("meesage");
      // print(_errorMessage);
      notifyListeners();
    }
  }

  Future<void> checkout(int reservationId) async {
    _isLoading = true;
    message = '';
    notifyListeners();

    var data = await apiService.checkout(reservationId);
    print("dataaaaaaa");
    print(data);
    if (data.isNotEmpty) {
      _isLoading = false;
      message = data['message'];
      notifyListeners();
    } else {
      _isLoading = false;
      // message = data['message'];
      notifyListeners();
      // throw Exception("Can't Checkout");
    }
  }

  Future<void> getAllReservations() async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await apiService.getReservations();
      // print("response");
      // print(response);
      if (response['statusCode'] == 200) {
        reservations = response['data'] ?? []; // Ensure empty list if no data
      } else {
        reservations = [];
      }
    } catch (e) {
      reservations = []; // Ensure list resets on error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    // print("reservations");
    // print(reservations);
  }

  Future<void> getReservationDetails(int reservationId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    var data = await apiService.getReservationDetails(reservationId);

    // print(data);
    if (data.isNotEmpty) {
      _isLoading = false;
      _errorMessage = null;
      result = ReservationResponse.fromJson(data);
      // print(data['data']);
      // print(result.data!.guestName);
      // print("reservations");
      notifyListeners();
    } else {
      _isLoading = false;
      _errorMessage = data['message'];
      notifyListeners();
    }
  }

  Future<void> cancelReservation(int reservationId) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await apiService.cancelReservation(reservationId);

      if (response['statusCode'] == 200) {
        reservations.removeWhere(
            (reservation) => reservation['reservationId'] == reservationId);

        // Force UI update when the last item is removed
        if (reservations.isEmpty) {
          reservations.clear(); // Explicitly clear
        }

        message = response['message'];
      }
    } catch (e) {
      message = "Failed to cancel reservation";
    } finally {
      _isLoading = false;
      notifyListeners(); // Make sure UI rebuilds
    }
  }

  Future<void> updateReservation(int reservationId, String checkIn,
      String checkOut, int paymentMethod) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    var data = await apiService.updateReservation(
        reservationId, checkIn, checkOut, paymentMethod);

    // print(data);
    if (data.isNotEmpty) {
      _isLoading = false;
      _errorMessage = null;
      // print("message");
      // print(data['message']);
      // print(message);
      message = data['message'];
      // result = ReservationResponse.fromJson(data);
      // print(result.data!.guestName);
      // print("reservations");
      notifyListeners();
    } else {
      _isLoading = false;
      _errorMessage = data['message'];
      message = data['message'];
      notifyListeners();
    }
    notifyListeners();
  }
}
