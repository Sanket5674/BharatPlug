// this is the model for vehicle services

class VehicleModel {
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
  String? vehicleMotorTorque;
  String? vehicleDriveModes;
  String? vehicleDimentions;
  String? vehicleType;
  String? vehicleRegistrationNo;
  String? vehicleNickName;


  VehicleModel(
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

      
      });

  VehicleModel.fromJson(Map<String, dynamic> json) {
    vehicleId = json['vehicleId'];
    vehicleBrandName = json['vehicleBrandName'];
    vehicleModelName = json['vehicleModelName'];
    vehicleClass = json['vehicleClass'];
    vehicleColour = json['vehicleColour'];
    vehicleBatteryType = json['vehicleBatteryType'];
    vehicleBatteryCapacity = json['vehicleBatteryCapacity'];
    vehicleAdaptorType = json['vehicleAdaptorType'];
    vehicleTimeToChargeRegular = json['vehicleTimeToChargeRegular'];
    vehicleTimeToChargeFast = json['vehicleTimeToChargeFast'];
    vehicleChargingStandard = json['vehicleChargingStandard'];
    vehicleRange = json['vehicleRange'];
    vehicleMotorType = json['vehicleMotorType'];
    vehicleMotorPower = json['vehicleMotorPower'];
    vehicleMotorTorque = json['vehicleMotorTorque'];
    vehicleDriveModes = json['vehicleDriveModes'];
    vehicleDimentions = json['vehicleDimentions'];
    vehicleType = json['vehicleType'];
    vehicleRegistrationNo = json['vehicleRegistrationNo'];
    vehicleNickName = json['vehicleNickName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['vehicleId'] = vehicleId;
    data['vehicleBrandName'] = vehicleBrandName;
    data['vehicleModelName'] = vehicleModelName;
    data['vehicleClass'] = vehicleClass;
    data['vehicleColour'] = vehicleColour;
    data['vehicleBatteryType'] = vehicleBatteryType;
    data['vehicleBatteryCapacity'] = vehicleBatteryCapacity;
    data['vehicleAdaptorType'] = vehicleAdaptorType;
    data['vehicleTimeToChargeRegular'] = vehicleTimeToChargeRegular;
    data['vehicleTimeToChargeFast'] = vehicleTimeToChargeFast;
    data['vehicleChargingStandard'] = vehicleChargingStandard;
    data['vehicleRange'] = vehicleRange;
    data['vehicleMotorType'] = vehicleMotorType;
    data['vehicleMotorPower'] = vehicleMotorPower;
    data['vehicleMotorTorque'] = vehicleMotorTorque;
    data['vehicleDriveModes'] = vehicleDriveModes;
    data['vehicleDimentions'] = vehicleDimentions;
    data['vehicleType'] = vehicleType;
    data['vehicleRegistrationNo'] = vehicleRegistrationNo;
    data['vehicleNickName'] = vehicleNickName;


    return data;
  }
}
