class AllServicesModel {
  int? statusCode;
  String? message;
  List<Data>? data;

  AllServicesModel({this.statusCode, this.message, this.data});

  AllServicesModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  int? serviceType;
  int? serviceFees;

  Data({this.id, this.serviceType, this.serviceFees});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    serviceType = json['serviceType'];
    serviceFees = json['serviceFees'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['serviceType'] = serviceType;
    data['serviceFees'] = serviceFees;
    return data;
  }
}
