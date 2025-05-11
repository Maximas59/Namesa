class RoomModel {
  Data? data;

  RoomModel({this.data});

  RoomModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? roomType;
  double? price;
  int? numberOfBeds;
  bool? isSea;
  bool? isAvaliable;
  int? rate;
  int? numberOfReviewers;

  Data(
      {this.roomType,
      this.price,
      this.numberOfBeds,
      this.isSea,
      this.isAvaliable,
      this.rate,
      this.numberOfReviewers});

  Data.fromJson(Map<String, dynamic> json) {
    roomType = json['roomType'];
    price = json['price'];
    numberOfBeds = json['numberOfBeds'];
    isSea = json['isSea'];
    isAvaliable = json['isAvaliable'];
    rate = json['rate'];
    numberOfReviewers = json['numberOfReviewers'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['roomType'] = roomType;
    data['price'] = price;
    data['numberOfBeds'] = numberOfBeds;
    data['isSea'] = isSea;
    data['isAvaliable'] = isAvaliable;
    data['rate'] = rate;
    data['numberOfReviewers'] = numberOfReviewers;
    return data;
  }
}
