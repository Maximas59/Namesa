import 'package:flutter/material.dart';
import 'package:namesa/core/api_services.dart';
import 'package:namesa/models/all_services_model.dart';

class ServiceProvider extends ChangeNotifier {
  final ApiService apiService;

  ServiceProvider(this.apiService);

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String? _message;

  String? get message => _message;
  AllServicesModel result = AllServicesModel();
  AllServicesModel available = AllServicesModel();
  dynamic userServices = [];
  dynamic requestedServices = [];
  dynamic requestedServiceDetails;
  dynamic userReservations = [];

  Future<void> getAllUserReservations() async {
    _isLoading = true;
    _message = null;
    notifyListeners();

    var data = await apiService.getAllUsersReservations();
    // print("DATA");
    // print(data);
    if (data.isNotEmpty) {
      _isLoading = false;
      _message = data['message'];
      userReservations = data['data'].toList();
      // print(result);
      notifyListeners();
    } else {
      _isLoading = false;
      _message = data['message'];
      notifyListeners();
    }
  }

  Future<void> approveUserReservations(int reservationId) async {
    _isLoading = true;
    _message = null;
    notifyListeners();

    var data = await apiService.approveUserReservations(reservationId);
    // print("DATA");
    // print(data);
    if (data.isNotEmpty) {
      _isLoading = false;
      _message = data['message'];
      // userReservations = data['data'].toList();
      // print(result);
      notifyListeners();
    } else {
      _isLoading = false;
      _message = data['message'];
      notifyListeners();
    }
  }

  Future<void> rejectUserReservations(int reservationId) async {
    _isLoading = true;
    _message = null;
    notifyListeners();

    var data = await apiService.rejectUserReservations(reservationId);
    // print("DATA");
    // print(data);
    if (data.isNotEmpty) {
      _isLoading = false;
      _message = data['message'];
      // userReservations = data['data'].toList();
      // print(result);
      notifyListeners();
    } else {
      _isLoading = false;
      _message = data['message'];
      notifyListeners();
    }
  }

  Future<void> getAllUserServices() async {
    _isLoading = true;
    _message = null;
    notifyListeners();

    var data = await apiService.getAllUserServices();
    // print("DATA");
    // print(data);
    if (data.isNotEmpty) {
      _isLoading = false;
      _message = data['message'];
      userServices = data['data'].toList();
      // print(result);
      notifyListeners();
    } else {
      _isLoading = false;
      _message = data['message'];
      notifyListeners();
    }
  }

  Future<void> approveUserService(int serviceId, int guestId) async {
    _isLoading = true;
    _message = null;
    notifyListeners();

    var data = await apiService.approveUserServices(serviceId, guestId);
    // print("DATA");
    // print(data['message']);
    if (data.isNotEmpty) {
      _isLoading = false;
      _message = data['message'];
      // print(result);
      notifyListeners();
    } else {
      _isLoading = false;
      _message = data['message'];
      notifyListeners();
    }
  }

  Future<void> rejectUserService(int serviceId, int guestId) async {
    _isLoading = true;
    _message = null;
    notifyListeners();

    var data = await apiService.rejectUserServices(serviceId, guestId);
    // print("DATA");
    // print(data['message']);
    if (data.isNotEmpty) {
      _isLoading = false;
      _message = data['message'];
      // print(result);
      notifyListeners();
    } else {
      _isLoading = false;
      _message = data['message'];
      notifyListeners();
    }
  }

  Future<void> getAllService() async {
    _isLoading = true;
    _message = null;
    notifyListeners();

    var data = await apiService.getAllServices();
    // print("DATA");
    // print(data);
    if (data.isNotEmpty) {
      _isLoading = false;
      _message = data['message'];
      result = AllServicesModel.fromJson(data);
      // print(result);
      notifyListeners();
    } else {
      _isLoading = false;
      _message = data['message'];
      notifyListeners();
    }
  }

  Future<void> getAllAvailableService() async {
    _isLoading = true;
    _message = null;
    notifyListeners();

    var data = await apiService.getAllAvailableServices();
    // print("DATAaaaaaaa");
    // print(data);
    if (data.isNotEmpty) {
      _isLoading = false;
      _message = data['message'];
      available = AllServicesModel.fromJson(data);
      // print(result);
      notifyListeners();
      // return available;
    } else {
      _isLoading = false;
      _message = data['message'];
      notifyListeners();
      // return AllServicesModel();
    }
  }

  Future<void> getAllMyRequestedServices() async {
    _isLoading = true;
    _message = null;
    notifyListeners();

    var data = await apiService.getAllMyRequestedServices();
    // print("DATAaaaaaaa");
    // print(data);
    if (data.isNotEmpty) {
      _isLoading = false;
      _message = data['message'];
      requestedServices = data['data'].toList();
      // print(requestedServices);
      notifyListeners();
      // return available;
    } else {
      _isLoading = false;
      _message = data['message'];
      notifyListeners();
      // return AllServicesModel();
    }
  }

  Future<void> getRequestedService(int serviceId) async {
    _isLoading = true;
    _message = null;
    notifyListeners();

    var data = await apiService.getRequestedService(serviceId);
    // print("Req DATAaaaaaaa");
    // print(data);
    if (data.isNotEmpty) {
      _isLoading = false;
      _message = data['message'];
      requestedServiceDetails = data['data'];
      // print(result);
      notifyListeners();
      // return available;
    } else {
      _isLoading = false;
      _message = data['message'];
      notifyListeners();
      // return AllServicesModel();
    }
  }

  Future<void> requestAService(int serviceId) async {
    _isLoading = true;
    _message = null;
    notifyListeners();

    var data = await apiService.requestAService(serviceId);
    // print("DATAaaaaaaa");
    // print(data);
    if (data.isNotEmpty) {
      _isLoading = false;
      _message = data['message'];
      notifyListeners();
    } else {
      _isLoading = false;
      _message = data['message'];
      notifyListeners();
    }
  }

  Future<void> createService(int serviceType, num serviceFees) async {
    _isLoading = true;
    _message = null;
    notifyListeners();

    // print(serviceFees);
    var data = await apiService.createService(
        serviceType: serviceType, serviceFees: serviceFees);
    // print(data);
    if (data.isNotEmpty) {
      _isLoading = false;
      _message = data['message'];
      // print(message);
      notifyListeners();
    } else {
      _isLoading = false;
      _message = data['message'];
      notifyListeners();
    }
  }

  Future<void> updateService(
      int id, int serviceType, double? serviceFees) async {
    _isLoading = true;
    _message = null;
    notifyListeners();

    var data = await apiService.updateService(
        serviceId: id, serviceType: serviceType, serviceFees: serviceFees ?? 0);
    if (data.isNotEmpty) {
      _isLoading = false;
      _message = data['message'];
      // print(data);
      notifyListeners();
    } else {
      _isLoading = false;
      _message = data['message'];
      notifyListeners();
    }
  }

  Future<void> deleteService(int serviceId) async {
    _isLoading = true;
    _message = null;
    notifyListeners();

    var data = await apiService.deleteService(serviceId = serviceId);
    // print("dataaaaaaaaaaaa");
    // print(serviceId);
    if (data.isNotEmpty) {
      _isLoading = false;
      _message = data['message'];

      notifyListeners();
    } else {
      _isLoading = false;
      _message = data['message'];
      // print("failed");
      notifyListeners();
    }
  }
}
