
class UserDataModel {
  String? userId;
  String? userFirstName;
  String? userLastName;
  String? userEmail;
  String? userContactNo;
  String? userProfilePhoto;
  String? password;
  String? roleId;
  String? token;
  int? userCurrentTxniId;
  String? modifiedDate;
  Wallets? wallets;
  List<dynamic>? vehicles;
  List<dynamic>? transactions;
  List<dynamic>? userHistory;
  List<dynamic>? favorites;
  List<dynamic>? notificationPrefernces;
  bool? active;

  UserDataModel({this.userId, this.userFirstName, this.userLastName, this.userEmail, this.userContactNo, this.userProfilePhoto, this.password, this.roleId, this.token, this.userCurrentTxniId, this.modifiedDate, this.wallets, this.vehicles, this.transactions, this.userHistory, this.favorites, this.notificationPrefernces, this.active});

  UserDataModel.fromJson(Map<String, dynamic> json) {
    if(json["userId"] is String) {
      userId = json["userId"];
    }
    if(json["userFirstName"] is String) {
      userFirstName = json["userFirstName"];
    }
    if(json["userLastName"] is String) {
      userLastName = json["userLastName"];
    }
    if(json["userEmail"] is String) {
      userEmail = json["userEmail"];
    }
    if(json["userContactNo"] is String) {
      userContactNo = json["userContactNo"];
    }
    if(json["userProfilePhoto"] is String) {
      userProfilePhoto = json["userProfilePhoto"];
    }
    if(json["password"] is String) {
      password = json["password"];
    }
    if(json["roleId"] is String) {
      roleId = json["roleId"];
    }
    if(json["token"] is String) {
      token = json["token"];
    }
    if(json["userCurrentTXNIId"] is int) {
      userCurrentTxniId = json["userCurrentTXNIId"];
    }
    if(json["modifiedDate"] is String) {
      modifiedDate = json["modifiedDate"];
    }
    if(json["wallets"] is Map) {
      wallets = json["wallets"] == null ? null : Wallets.fromJson(json["wallets"]);
    }
    if(json["vehicles"] is List) {
      vehicles = json["vehicles"] ?? [];
    }
    if(json["transactions"] is List) {
      transactions = json["transactions"] ?? [];
    }
    if(json["userHistory"] is List) {
      userHistory = json["userHistory"] ?? [];
    }
    if(json["favorites"] is List) {
      favorites = json["favorites"] ?? [];
    }
    if(json["notificationPrefernces"] is List) {
      notificationPrefernces = json["notificationPrefernces"] ?? [];
    }
    if(json["active"] is bool) {
      active = json["active"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["userId"] = userId;
    _data["userFirstName"] = userFirstName;
    _data["userLastName"] = userLastName;
    _data["userEmail"] = userEmail;
    _data["userContactNo"] = userContactNo;
    _data["userProfilePhoto"] = userProfilePhoto;
    _data["password"] = password;
    _data["roleId"] = roleId;
    _data["token"] = token;
    _data["userCurrentTXNIId"] = userCurrentTxniId;
    _data["modifiedDate"] = modifiedDate;
    if(wallets != null) {
      _data["wallets"] = wallets?.toJson();
    }
    if(vehicles != null) {
      _data["vehicles"] = vehicles;
    }
    if(transactions != null) {
      _data["transactions"] = transactions;
    }
    if(userHistory != null) {
      _data["userHistory"] = userHistory;
    }
    if(favorites != null) {
      _data["favorites"] = favorites;
    }
    if(notificationPrefernces != null) {
      _data["notificationPrefernces"] = notificationPrefernces;
    }
    _data["active"] = active;
    return _data;
  }
}

class Wallets {
  int? walletAmount;
  bool? active;

  Wallets({this.walletAmount, this.active});

  Wallets.fromJson(Map<String, dynamic> json) {
    if(json["walletAmount"] is int) {
      walletAmount = json["walletAmount"];
    }
    if(json["active"] is bool) {
      active = json["active"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["walletAmount"] = walletAmount;
    _data["active"] = active;
    return _data;
  }
}