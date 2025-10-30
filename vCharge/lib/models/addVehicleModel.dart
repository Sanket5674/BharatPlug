class AddVehicleModel {
  String? vehicleId;
  String? vehicleBrandName;
  String? vehicleModelName;
  String? vehicleClass;
  String? vehicleColour;
  String? vehicleBatteryType;
  String? vehicleBatteryCapacity;
  String? vehicleAdaptorType;
  String? vehicleTimeToChargeRegular;
  String? vehicleTimeToChargeFast;
  String? vehicleChargingStandard;
  String? vehicleRange;
  String? vehicleMotorType;
  String? vehicleMotorPower;
  dynamic vehicleMotorTorque;
  String? vehicleDriveModes;
  String? vehicleDimentions;
  String? vehicleType;
  String? vehicleRegistrationNo;
  String? vehicleNickName;
  dynamic vehicleConnectorType;
  dynamic createdDate;
  dynamic modifiedDate;
  bool? active;

  AddVehicleModel(
      {this.vehicleId,
      this.vehicleBrandName,
      this.vehicleModelName,
      this.vehicleClass,
      this.vehicleColour,
      this.vehicleBatteryType,
      this.vehicleBatteryCapacity,
      this.vehicleAdaptorType,
      this.vehicleTimeToChargeRegular,
      this.vehicleTimeToChargeFast,
      this.vehicleChargingStandard,
      this.vehicleRange,
      this.vehicleMotorType,
      this.vehicleMotorPower,
      this.vehicleMotorTorque,
      this.vehicleDriveModes,
      this.vehicleDimentions,
      this.vehicleType,
      this.vehicleRegistrationNo,
      this.vehicleNickName,
      this.vehicleConnectorType,
      this.createdDate,
      this.modifiedDate,
      this.active});

  AddVehicleModel.fromJson(Map<String, dynamic> json) {
    if (json["vehicleId"] is String) {
      vehicleId = json["vehicleId"];
    }
    if (json["vehicleBrandName"] is String) {
      vehicleBrandName = json["vehicleBrandName"];
    }
    if (json["vehicleModelName"] is String) {
      vehicleModelName = json["vehicleModelName"];
    }
    if (json["vehicleClass"] is String) {
      vehicleClass = json["vehicleClass"];
    }
    if (json["vehicleColour"] is String) {
      vehicleColour = json["vehicleColour"];
    }
    if (json["vehicleBatteryType"] is String) {
      vehicleBatteryType = json["vehicleBatteryType"];
    }
    if (json["vehicleBatteryCapacity"] is String) {
      vehicleBatteryCapacity = json["vehicleBatteryCapacity"];
    }
    if (json["vehicleAdaptorType"] is String) {
      vehicleAdaptorType = json["vehicleAdaptorType"];
    }
    if (json["vehicleTimeToChargeRegular"] is String) {
      vehicleTimeToChargeRegular = json["vehicleTimeToChargeRegular"];
    }
    if (json["vehicleTimeToChargeFast"] is String) {
      vehicleTimeToChargeFast = json["vehicleTimeToChargeFast"];
    }
    if (json["vehicleChargingStandard"] is String) {
      vehicleChargingStandard = json["vehicleChargingStandard"];
    }
    if (json["vehicleRange"] is String) {
      vehicleRange = json["vehicleRange"];
    }
    if (json["vehicleMotorType"] is String) {
      vehicleMotorType = json["vehicleMotorType"];
    }
    if (json["vehicleMotorPower"] is String) {
      vehicleMotorPower = json["vehicleMotorPower"];
    }
    vehicleMotorTorque = json["vehicleMotorTorque"];
    if (json["vehicleDriveModes"] is String) {
      vehicleDriveModes = json["vehicleDriveModes"];
    }
    if (json["vehicleDimentions"] is String) {
      vehicleDimentions = json["vehicleDimentions"];
    }
    if (json["vehicleType"] is String) {
      vehicleType = json["vehicleType"];
    }
    if (json["vehicleRegistrationNo"] is String) {
      vehicleRegistrationNo = json["vehicleRegistrationNo"];
    }
    if (json["vehicleNickName"] is String) {
      vehicleNickName = json["vehicleNickName"];
    }
    vehicleConnectorType = json["vehicleConnectorType"];
    createdDate = json["createdDate"];
    modifiedDate = json["modifiedDate"];
    if (json["active"] is bool) {
      active = json["active"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["vehicleId"] = vehicleId;
    _data["vehicleBrandName"] = vehicleBrandName;
    _data["vehicleModelName"] = vehicleModelName;
    _data["vehicleClass"] = vehicleClass;
    _data["vehicleColour"] = vehicleColour;
    _data["vehicleBatteryType"] = vehicleBatteryType;
    _data["vehicleBatteryCapacity"] = vehicleBatteryCapacity;
    _data["vehicleAdaptorType"] = vehicleAdaptorType;
    _data["vehicleTimeToChargeRegular"] = vehicleTimeToChargeRegular;
    _data["vehicleTimeToChargeFast"] = vehicleTimeToChargeFast;
    _data["vehicleChargingStandard"] = vehicleChargingStandard;
    _data["vehicleRange"] = vehicleRange;
    _data["vehicleMotorType"] = vehicleMotorType;
    _data["vehicleMotorPower"] = vehicleMotorPower;
    _data["vehicleMotorTorque"] = vehicleMotorTorque;
    _data["vehicleDriveModes"] = vehicleDriveModes;
    _data["vehicleDimentions"] = vehicleDimentions;
    _data["vehicleType"] = vehicleType;
    _data["vehicleRegistrationNo"] = vehicleRegistrationNo;
    _data["vehicleNickName"] = vehicleNickName;
    _data["vehicleConnectorType"] = vehicleConnectorType;
    _data["createdDate"] = createdDate;
    _data["modifiedDate"] = modifiedDate;
    _data["active"] = active;
    return _data;
  }
}
