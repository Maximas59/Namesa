import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:namesa/core/cached_data.dart';

class ApiService {
  final _baseUrl = 'https://10.0.2.2:7245/api/Account/';
  final _baseRoomUrl = 'https://10.0.2.2:7245/api/Room/';
  final _baseReserveUrl = 'https://10.0.2.2:7245/api/User/';
  final _baseStaffUrl = 'https://10.0.2.2:7245/api/Staff/';
  final _baseServiceUrl = 'https://10.0.2.2:7245/api/Service/';
  final _baseGuestUrl = 'https://10.0.2.2:7245/api/Guest/';

  final Dio _dio;

  ApiService(this._dio) {
    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
  }

  Future<Map<String, dynamic>> login(
      {required String username, required String password}) async {
    try {
      var response = await _dio.post('${_baseUrl}login',
          data: {"email": username, "password": password});
      return response.data;
    } catch (e) {
      // print(e.toString());
      return {};
    }
  }

  Future<Map<String, dynamic>> register(
      {required String username,
      required String email,
      required String address,
      required String password,
      required String userType,
      required String employementType,
      required String gender}) async {
    try {
      var response = await _dio.post('${_baseUrl}register', data: {
        "username": username,
        "email": email,
        "address": address,
        "password": password,
        "userType": userType,
        "employementType": employementType,
        "gender": gender
      }, options: Options(validateStatus: (status) {
        return status == 500; // Accept responses below 500
      }));
      // print(response.data);
      return response.data;
    } catch (e) {
      // print(e.toString());
      return {};
    }
  }

  Future<Map<String, dynamic>> createRoom(
      {required String roomType,
      required double price,
      required int numOfBeds,
      required bool isSea}) async {
    try {
      var response = await _dio.post('${_baseRoomUrl}CreateRoom',
          options: Options(headers: {
            "Authorization": "Bearer ${MyCache.getString(key: "token")}"
          }),
          data: {
            "roomType": roomType,
            "price": price,
            "numberOfBeds": numOfBeds,
            "isSea": isSea
          });
      // print(response.data!);
      return response.data;
    } catch (e) {
      // print(e);
      // print(e.toString());
      return {};
    }
  }

  Future<Map<String, dynamic>> updateRoom({
    required int roomId,
    required String roomType,
    bool isAvailable = true,
    required double price,
    required int numOfBeds,
    required bool isSea,
    int numberOfReviwers = 0,
    int rate = 0,
  }) async {
    try {
      var response = await _dio.put('${_baseRoomUrl}UpdateRoom',
          options: Options(headers: {
            "Authorization": "Bearer ${MyCache.getString(key: "token")}"
          }),
          data: {
            "id": roomId,
            "roomType": roomType,
            "isAvaliable": isAvailable,
            "price": price,
            "numberOfBeds": numOfBeds,
            "isSea": isSea,
            "numberOfReviewers": numberOfReviwers,
            "rate": rate
          });
      return response.data;
    } catch (e) {
      // print(e);
      // print(e.toString());
      return {};
    }
  }

  Future<Map<String, dynamic>> deleteRoom(int roomId) async {
    try {
      var response = await _dio.delete('${_baseRoomUrl}DeleteRoom',
          options: Options(headers: {
            "Authorization": "Bearer ${MyCache.getString(key: "token")}"
          }),
          queryParameters: {"roomId": roomId});
      // print(response.data);
      return response.data;
    } catch (e) {
      // print(e.toString());
      return {};
    }
  }

  Future<Map<String, dynamic>> viewRoomDetails(int roomId) async {
    try {
      var response = await _dio.get('${_baseRoomUrl}ViewRoomDetails',
          options: Options(headers: {
            "Authorization": "Bearer ${MyCache.getString(key: "token")}"
          }),
          queryParameters: {"roomId": roomId});
      // print(response.data);
      return response.data;
    } catch (e) {
      // print(e.toString());
      return {};
    }
  }

  Future<Map<String, dynamic>> viewAllRooms(int pageSize, int pageIndex) async {
    try {
      var response = await _dio.get('${_baseRoomUrl}ViewAllRooms',
          options: Options(headers: {
            "Authorization": "Bearer ${MyCache.getString(key: "token")}"
          }),
          queryParameters: {"pageSize": pageSize, "pageIndex": pageIndex});
      // print("From api service");
      // print(response.data);
      return response.data;
    } catch (e) {
      // print(e.toString());
      return {};
    }
  }

  Future<Map<String, dynamic>> getAllUsersReservations() async {
    try {
      var response = await _dio.get('${_baseStaffUrl}GetAllUserReservations',
          options: Options(headers: {
            "Authorization": "Bearer ${MyCache.getString(key: "token")}"
          }));
      // print(response.data);
      return response.data;
    } catch (e) {
      // print(e.toString());
      return {};
    }
  }

  Future<Map<String, dynamic>> approveUserReservations(
      int reservationId) async {
    try {
      var response = await _dio.put('${_baseStaffUrl}ApproveOnReservation',
          options: Options(headers: {
            "Authorization": "Bearer ${MyCache.getString(key: "token")}"
          }),
          queryParameters: {"id": reservationId});
      // print(response.data);
      return response.data;
    } catch (e) {
      // print(e.toString());
      return {};
    }
  }

  Future<Map<String, dynamic>> rejectUserReservations(int reservationId) async {
    try {
      var response = await _dio.put('${_baseStaffUrl}RejectOnReservation',
          options: Options(headers: {
            "Authorization": "Bearer ${MyCache.getString(key: "token")}"
          }),
          queryParameters: {"id": reservationId});
      // print(response.data);
      return response.data;
    } catch (e) {
      // print(e.toString());
      return {};
    }
  }

  Future<Map<String, dynamic>> reserveRoom(
      int roomId, String checkIn, String checkOut, int paymentMethod) async {
    try {
      // print("From api service");
      var response = await _dio.post('${_baseReserveUrl}Reserve',
          options: Options(headers: {
            "Authorization": "Bearer ${MyCache.getString(key: "token")}"
          }),
          data: {
            "RoomId": roomId,
            "From": checkIn,
            "To": checkOut,
            "PaymentMethod": paymentMethod
          });
      // print(response.data);
      return response.data;
    } catch (e) {
      // print(e.toString());
      // print(e.toString());
      return {};
    }
  }

  Future<Map<String, dynamic>> getReservations() async {
    try {
      var response = await _dio.get(
        '${_baseReserveUrl}GetAllMyReservations',
        options: Options(headers: {
          "Authorization": "Bearer ${MyCache.getString(key: "token")}"
        }),
      );
      // print("From api service");
      // print(response.data);
      return response.data;
    } catch (e) {
      // print(e.toString());
      return {};
    }
  }

  Future<Map<String, dynamic>> getReservationDetails(int reservationId) async {
    try {
      var response = await _dio.get('${_baseReserveUrl}GetReservationDetails',
          options: Options(headers: {
            "Authorization": "Bearer ${MyCache.getString(key: "token")}"
          }),
          queryParameters: {"reservationId": reservationId});
      // print("From api service");
      // print(response.data);
      return response.data;
    } catch (e) {
      // print(e.toString());
      // print(e.toString());
      return {};
    }
  }

  Future<Map<String, dynamic>> cancelReservation(int reservationId) async {
    try {
      var response = await _dio.delete('${_baseReserveUrl}CancelReservation',
          options: Options(headers: {
            "Authorization": "Bearer ${MyCache.getString(key: "token")}"
          }),
          queryParameters: {"reservationId": reservationId});
      // print("From api service");
      // print(response.data);
      return response.data;
    } catch (e) {
      // print(e.toString());
      // print(e.toString());
      return {};
    }
  }

  Future<Map<String, dynamic>> updateReservation(int reservationId,
      String checkIn, String checkOut, int paymentMethod) async {
    try {
      var response = await _dio.put('${_baseReserveUrl}UpdateReservation',
          options: Options(headers: {
            "Authorization": "Bearer ${MyCache.getString(key: "token")}"
          }),
          data: {
            "ReservationId": reservationId,
            "From": checkIn,
            "To": checkOut,
            "PaymentMethod": paymentMethod
          });
      // print("From api service");
      // print(response.data);
      return response.data;
    } catch (e) {
      // print(e.toString());
      // print(e.toString());
      return {};
    }
  }

  Future<Map<String, dynamic>> getAllUserServices() async {
    try {
      var response = await _dio.get('${_baseServiceUrl}GetAllUsersServices',
          options: Options(headers: {
            "Authorization": "Bearer ${MyCache.getString(key: "token")}"
          }));
      return response.data;
    } catch (e) {
      // print(e);
      // print(e.toString());
      return {};
    }
  }

  Future<Map<String, dynamic>> approveUserServices(
      int serviceId, int guestId) async {
    try {
      var response = await _dio.put('${_baseServiceUrl}ApproveUserService',
          options: Options(headers: {
            "Authorization": "Bearer ${MyCache.getString(key: "token")}"
          }),
          queryParameters: {"serviceId": serviceId, 'guestId': guestId});
      return response.data;
    } catch (e) {
      // print(e);
      // print(e.toString());
      return {};
    }
  }

  Future<Map<String, dynamic>> rejectUserServices(
      int serviceId, int guestId) async {
    try {
      var response = await _dio.put('${_baseServiceUrl}RejectUserService',
          options: Options(headers: {
            "Authorization": "Bearer ${MyCache.getString(key: "token")}"
          }),
          queryParameters: {"serviceId": serviceId, 'guestId': guestId});
      return response.data;
    } catch (e) {
      // print(e);
      // print(e.toString());
      return {};
    }
  }

  Future<Map<String, dynamic>> getAllServices() async {
    try {
      var response = await _dio.get('${_baseServiceUrl}GetAllServices',
          options: Options(headers: {
            "Authorization": "Bearer ${MyCache.getString(key: "token")}"
          }));
      return response.data;
    } catch (e) {
      // print(e);
      // print(e.toString());
      return {};
    }
  }

  Future<Map<String, dynamic>> getServiceDetails(int id) async {
    try {
      var response = await _dio.get('${_baseServiceUrl}GetAllServices',
          options: Options(headers: {
            "Authorization": "Bearer ${MyCache.getString(key: "token")}"
          }),
          queryParameters: {"serviceId": id});
      return response.data;
    } catch (e) {
      // print(e);
      // print(e.toString());
      return {};
    }
  }

  Future<Map<String, dynamic>> createService(
      {required int serviceType, num? serviceFees}) async {
    try {
      var response = await _dio.post('${_baseServiceUrl}CreateService',
          options: Options(headers: {
            "Authorization": "Bearer ${MyCache.getString(key: "token")}"
          }),
          data: {"serviceType": serviceType, "serviceFees": serviceFees ?? 0});
      // print("============Response from create serviceeee==================");
      // print(response.headers);
      return response.data;
    } catch (e) {
      // print(e);
      // print(e.toString());
      return {};
    }
  }

  Future<Map<String, dynamic>> updateService(
      {required int serviceId,
      required int serviceType,
      double? serviceFees}) async {
    try {
      var response = await _dio.put('${_baseServiceUrl}UpdateService',
          options: Options(headers: {
            "Authorization": "Bearer ${MyCache.getString(key: "token")}"
          }),
          data: {
            "id": serviceId,
            "serviceType": serviceType,
            "serviceFees": serviceFees ?? 0
          });
      return response.data;
    } catch (e) {
      // print(e);
      // print(e.toString());
      return {};
    }
  }

  Future<Map<String, dynamic>> deleteService(int serviceId) async {
    try {
      var response = await _dio.delete('${_baseServiceUrl}DeleteService',
          options: Options(headers: {
            "Authorization": "Bearer ${MyCache.getString(key: "token")}"
          }),
          queryParameters: {"serviceId": serviceId});
      // print(response.realUri);
      return response.data;
    } catch (e) {
      // print(e);
      // print(e.toString());
      return {};
    }
  }

  Future<Map<String, dynamic>> getAllAvailableServices() async {
    try {
      var response = await _dio.get('${_baseGuestUrl}GetAllAvailableServices',
          options: Options(headers: {
            "Authorization": "Bearer ${MyCache.getString(key: "token")}"
          }));
      return response.data;
    } catch (e) {
      // print(e);
      // print(e.toString());
      return {};
    }
  }

  Future<Map<String, dynamic>> getRequestedService(int serviceId) async {
    try {
      var response = await _dio.get(
          '${_baseGuestUrl}GetRequestedServiceDetails',
          options: Options(headers: {
            "Authorization": "Bearer ${MyCache.getString(key: "token")}"
          }),
          queryParameters: {'serviceId': serviceId});
      return response.data;
    } catch (e) {
      // print(e);
      // print(e.toString());
      return {};
    }
  }

  Future<Map<String, dynamic>> getAllMyRequestedServices() async {
    try {
      var response = await _dio.get('${_baseGuestUrl}GetAllMyRequestedServices',
          options: Options(headers: {
            "Authorization": "Bearer ${MyCache.getString(key: "token")}"
          }));
      return response.data;
    } catch (e) {
      // print(e);
      // print(e.toString());
      return {};
    }
  }

  Future<Map<String, dynamic>> requestAService(int serviceId) async {
    try {
      var response = await _dio.post('${_baseGuestUrl}RequestService',
          options: Options(
            headers: {
              "Authorization": "Bearer ${MyCache.getString(key: "token")}"
            },
          ),
          queryParameters: {"serviceId": serviceId});
      return response.data;
    } catch (e) {
      // print(e);
      // print(e.toString());
      return {};
    }
  }

  Future<Map<String, dynamic>> checkout(int reservationId) async {
    try {
      var response = await _dio.put('${_baseGuestUrl}CheckOut',
          options: Options(
            headers: {
              "Authorization": "Bearer ${MyCache.getString(key: "token")}"
            },
          ),
          queryParameters: {"reservationId": reservationId});
      // print("response");
      // print(response);
      return response.data;
    } catch (e) {
      // print(e);
      // print(MyCache.getString(key: 'token'));
      // print(e.toString());
      return {};
    }
  }
}
