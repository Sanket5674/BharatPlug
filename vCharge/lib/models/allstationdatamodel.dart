class AllStationDataModel {
  String? stationId;
  Location? location;
  String? stationName;
  String? stationHostId;
  String? stationVendorId;
  String? stationArea;
  String? stationAddressLineOne;
  String? stationAddressLineTwo;
  String? stationZipCode;
  String? stationCity;
  double? stationLatitude;
  double? stationLongitude;
  String? stationLocationUrl;
  String? stationParkingArea;
  String? stationContactNumber;
  String? stationOpeningTime;
  String? stationClosingTime;
  int? chargerNumber;
  String? stationParkingType;
  String? stationStatus;
  String? stationPowerStandard;
  List<String>? stationAmenity;
  List<Chargers>? chargers;
  List<String>? userAccessList;
  String? createdDate;
  String? modifiedDate;
  String? createdBy;
  String? modifiedBy;
  bool? active;

  AllStationDataModel(
      {this.stationId,
      this.location,
      this.stationName,
      this.stationHostId,
      this.stationVendorId,
      this.stationArea,
      this.stationAddressLineOne,
      this.stationAddressLineTwo,
      this.stationZipCode,
      this.stationCity,
      this.stationLatitude,
      this.stationLongitude,
      this.stationLocationUrl,
      this.stationParkingArea,
      this.stationContactNumber,
      this.stationOpeningTime,
      this.stationClosingTime,
      this.chargerNumber,
      this.stationParkingType,
      this.stationStatus,
      this.stationPowerStandard,
      this.stationAmenity,
      this.chargers,
      this.userAccessList,
      this.createdDate,
      this.modifiedDate,
      this.createdBy,
      this.modifiedBy,
      this.active});

  AllStationDataModel.fromJson(Map<String, dynamic> json) {
    if (json["stationId"] is String) {
      stationId = json["stationId"];
    }
    if (json["location"] is Map) {
      location =
          json["location"] == null ? null : Location.fromJson(json["location"]);
    }
    if (json["stationName"] is String) {
      stationName = json["stationName"];
    }
    if (json["stationHostId"] is String) {
      stationHostId = json["stationHostId"];
    }
    if (json["stationVendorId"] is String) {
      stationVendorId = json["stationVendorId"];
    }
    if (json["stationArea"] is String) {
      stationArea = json["stationArea"];
    }
    if (json["stationAddressLineOne"] is String) {
      stationAddressLineOne = json["stationAddressLineOne"];
    }
    if (json["stationAddressLineTwo"] is String) {
      stationAddressLineTwo = json["stationAddressLineTwo"];
    }
    if (json["stationZipCode"] is String) {
      stationZipCode = json["stationZipCode"];
    }
    if (json["stationCity"] is String) {
      stationCity = json["stationCity"];
    }
    if (json["stationLatitude"] is double) {
      stationLatitude = json["stationLatitude"];
    }
    if (json["stationLongitude"] is double) {
      stationLongitude = json["stationLongitude"];
    }
    if (json["stationLocationURL"] is String) {
      stationLocationUrl = json["stationLocationURL"];
    }
    if (json["stationParkingArea"] is String) {
      stationParkingArea = json["stationParkingArea"];
    }
    if (json["stationContactNumber"] is String) {
      stationContactNumber = json["stationContactNumber"];
    }
    if (json["stationOpeningTime"] is String) {
      stationOpeningTime = json["stationOpeningTime"];
    }
    if (json["stationClosingTime"] is String) {
      stationClosingTime = json["stationClosingTime"];
    }
    if (json["chargerNumber"] is int) {
      chargerNumber = json["chargerNumber"];
    }
    if (json["stationParkingType"] is String) {
      stationParkingType = json["stationParkingType"];
    }
    if (json["stationStatus"] is String) {
      stationStatus = json["stationStatus"];
    }
    if (json["stationPowerStandard"] is String) {
      stationPowerStandard = json["stationPowerStandard"];
    }
    if (json["stationAmenity"] is List) {
      stationAmenity = json["stationAmenity"] == null
          ? null
          : List<String>.from(json["stationAmenity"]);
    }
    if (json["chargers"] is List) {
      chargers = json["chargers"] == null
          ? null
          : (json["chargers"] as List)
              .map((e) => Chargers.fromJson(e))
              .toList();
    }
    if (json["userAccessList"] is List) {
      userAccessList = json["userAccessList"] == null
          ? null
          : List<String>.from(json["userAccessList"]);
    }
    if (json["createdDate"] is String) {
      createdDate = json["createdDate"];
    }
    if (json["modifiedDate"] is String) {
      modifiedDate = json["modifiedDate"];
    }
    if (json["createdBy"] is String) {
      createdBy = json["createdBy"];
    }
    if (json["modifiedBy"] is String) {
      modifiedBy = json["modifiedBy"];
    }
    if (json["active"] is bool) {
      active = json["active"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["stationId"] = stationId;
    if (location != null) {
      _data["location"] = location?.toJson();
    }
    _data["stationName"] = stationName;
    _data["stationHostId"] = stationHostId;
    _data["stationVendorId"] = stationVendorId;
    _data["stationArea"] = stationArea;
    _data["stationAddressLineOne"] = stationAddressLineOne;
    _data["stationAddressLineTwo"] = stationAddressLineTwo;
    _data["stationZipCode"] = stationZipCode;
    _data["stationCity"] = stationCity;
    _data["stationLatitude"] = stationLatitude;
    _data["stationLongitude"] = stationLongitude;
    _data["stationLocationURL"] = stationLocationUrl;
    _data["stationParkingArea"] = stationParkingArea;
    _data["stationContactNumber"] = stationContactNumber;
    _data["stationOpeningTime"] = stationOpeningTime;
    _data["stationClosingTime"] = stationClosingTime;
    _data["chargerNumber"] = chargerNumber;
    _data["stationParkingType"] = stationParkingType;
    _data["stationStatus"] = stationStatus;
    _data["stationPowerStandard"] = stationPowerStandard;
    if (stationAmenity != null) {
      _data["stationAmenity"] = stationAmenity;
    }
    if (chargers != null) {
      _data["chargers"] = chargers?.map((e) => e.toJson()).toList();
    }
    if (userAccessList != null) {
      _data["userAccessList"] = userAccessList;
    }
    _data["createdDate"] = createdDate;
    _data["modifiedDate"] = modifiedDate;
    _data["createdBy"] = createdBy;
    _data["modifiedBy"] = modifiedBy;
    _data["active"] = active;
    return _data;
  }
}

class Chargers {
  String? chargerId;
  String? chargerName;
  int? chargerNumber;
  String? chargerInputVoltage;
  String? chargerOutputVoltage;
  String? chargerMinInputAmpere;
  String? chargerMaxInputAmpere;
  String? chargerOutputAmpere;
  String? chargerInputFrequency;
  String? chargerOutputFrequency;
  String? chargerIpRating;
  String? chargerMountType;
  int? chargerNumberOfConnector;
  String? chargerLastHeartBeatTimeStamp;
  String? isRfid;
  String? chargerPointSerialNumber;
  String? chargerOcppProtocol;
  String? chargerConnectorType;
  String? isAppSupport;
  String? isTbCutOff;
  String? isAntitheft;
  String? isLedDisplay;
  String? isLedIndications;
  String? isSmart;
  String? chargerStatus;
  String? chargePointVendor;
  String? chargePointModel;
  String? chargeBoxSerialNumber;
  String? meterType;
  String? firmwareVersion;
  String? iccid;
  String? imsi;
  String? meterSerialNumber;
  String? diagnosticsStatus;
  String? diagnosticsTimeStamp;
  String? chargerSerialNumber;
  int? chargerInterval;
  String? createdDate;
  String? modifiedDate;
  String? createdBy;
  String? modifiedBy;
  List<Connectors>? connectors;
  bool? active;

  Chargers(
      {this.chargerId,
      this.chargerName,
      this.chargerNumber,
      this.chargerInputVoltage,
      this.chargerOutputVoltage,
      this.chargerMinInputAmpere,
      this.chargerMaxInputAmpere,
      this.chargerOutputAmpere,
      this.chargerInputFrequency,
      this.chargerOutputFrequency,
      this.chargerIpRating,
      this.chargerMountType,
      this.chargerNumberOfConnector,
      this.chargerLastHeartBeatTimeStamp,
      this.isRfid,
      this.chargerPointSerialNumber,
      this.chargerOcppProtocol,
      this.chargerConnectorType,
      this.isAppSupport,
      this.isTbCutOff,
      this.isAntitheft,
      this.isLedDisplay,
      this.isLedIndications,
      this.isSmart,
      this.chargerStatus,
      this.chargePointVendor,
      this.chargePointModel,
      this.chargeBoxSerialNumber,
      this.meterType,
      this.firmwareVersion,
      this.iccid,
      this.imsi,
      this.meterSerialNumber,
      this.diagnosticsStatus,
      this.diagnosticsTimeStamp,
      this.chargerSerialNumber,
      this.chargerInterval,
      this.createdDate,
      this.modifiedDate,
      this.createdBy,
      this.modifiedBy,
      this.connectors,
      this.active});

  Chargers.fromJson(Map<String, dynamic> json) {
    if (json["chargerId"] is String) {
      chargerId = json["chargerId"];
    }
    if (json["chargerName"] is String) {
      chargerName = json["chargerName"];
    }
    if (json["chargerNumber"] is int) {
      chargerNumber = json["chargerNumber"];
    }
    if (json["chargerInputVoltage"] is String) {
      chargerInputVoltage = json["chargerInputVoltage"];
    }
    if (json["chargerOutputVoltage"] is String) {
      chargerOutputVoltage = json["chargerOutputVoltage"];
    }
    if (json["chargerMinInputAmpere"] is String) {
      chargerMinInputAmpere = json["chargerMinInputAmpere"];
    }
    if (json["chargerMaxInputAmpere"] is String) {
      chargerMaxInputAmpere = json["chargerMaxInputAmpere"];
    }
    if (json["chargerOutputAmpere"] is String) {
      chargerOutputAmpere = json["chargerOutputAmpere"];
    }
    if (json["chargerInputFrequency"] is String) {
      chargerInputFrequency = json["chargerInputFrequency"];
    }
    if (json["chargerOutputFrequency"] is String) {
      chargerOutputFrequency = json["chargerOutputFrequency"];
    }
    if (json["chargerIPRating"] is String) {
      chargerIpRating = json["chargerIPRating"];
    }
    if (json["chargerMountType"] is String) {
      chargerMountType = json["chargerMountType"];
    }
    if (json["chargerNumberOfConnector"] is int) {
      chargerNumberOfConnector = json["chargerNumberOfConnector"];
    }
    if (json["chargerLastHeartBeatTimeStamp"] is String) {
      chargerLastHeartBeatTimeStamp = json["chargerLastHeartBeatTimeStamp"];
    }
    if (json["isRFID"] is String) {
      isRfid = json["isRFID"];
    }
    if (json["chargerPointSerialNumber"] is String) {
      chargerPointSerialNumber = json["chargerPointSerialNumber"];
    }
    if (json["chargerOCPPProtocol"] is String) {
      chargerOcppProtocol = json["chargerOCPPProtocol"];
    }
    if (json["chargerConnectorType"] is String) {
      chargerConnectorType = json["chargerConnectorType"];
    }
    if (json["isAppSupport"] is String) {
      isAppSupport = json["isAppSupport"];
    }
    if (json["isTBCutOff"] is String) {
      isTbCutOff = json["isTBCutOff"];
    }
    if (json["isAntitheft"] is String) {
      isAntitheft = json["isAntitheft"];
    }
    if (json["isLEDDisplay"] is String) {
      isLedDisplay = json["isLEDDisplay"];
    }
    if (json["isLEDIndications"] is String) {
      isLedIndications = json["isLEDIndications"];
    }
    if (json["isSmart"] is String) {
      isSmart = json["isSmart"];
    }
    if (json["chargerStatus"] is String) {
      chargerStatus = json["chargerStatus"];
    }
    if (json["chargePointVendor"] is String) {
      chargePointVendor = json["chargePointVendor"];
    }
    if (json["chargePointModel"] is String) {
      chargePointModel = json["chargePointModel"];
    }
    if (json["chargeBoxSerialNumber"] is String) {
      chargeBoxSerialNumber = json["chargeBoxSerialNumber"];
    }
    if (json["meterType"] is String) {
      meterType = json["meterType"];
    }
    if (json["firmwareVersion"] is String) {
      firmwareVersion = json["firmwareVersion"];
    }
    if (json["iccid"] is String) {
      iccid = json["iccid"];
    }
    if (json["imsi"] is String) {
      imsi = json["imsi"];
    }
    if (json["meterSerialNumber"] is String) {
      meterSerialNumber = json["meterSerialNumber"];
    }
    if (json["diagnosticsStatus"] is String) {
      diagnosticsStatus = json["diagnosticsStatus"];
    }
    if (json["diagnosticsTimeStamp"] is String) {
      diagnosticsTimeStamp = json["diagnosticsTimeStamp"];
    }
    if (json["chargerSerialNumber"] is String) {
      chargerSerialNumber = json["chargerSerialNumber"];
    }
    if (json["chargerInterval"] is int) {
      chargerInterval = json["chargerInterval"];
    }
    if (json["createdDate"] is String) {
      createdDate = json["createdDate"];
    }
    if (json["modifiedDate"] is String) {
      modifiedDate = json["modifiedDate"];
    }
    if (json["createdBy"] is String) {
      createdBy = json["createdBy"];
    }
    if (json["modifiedBy"] is String) {
      modifiedBy = json["modifiedBy"];
    }
    if (json["connectors"] is List) {
      connectors = json["connectors"] == null
          ? null
          : (json["connectors"] as List)
              .map((e) => Connectors.fromJson(e))
              .toList();
    }
    if (json["active"] is bool) {
      active = json["active"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["chargerId"] = chargerId;
    _data["chargerName"] = chargerName;
    _data["chargerNumber"] = chargerNumber;
    _data["chargerInputVoltage"] = chargerInputVoltage;
    _data["chargerOutputVoltage"] = chargerOutputVoltage;
    _data["chargerMinInputAmpere"] = chargerMinInputAmpere;
    _data["chargerMaxInputAmpere"] = chargerMaxInputAmpere;
    _data["chargerOutputAmpere"] = chargerOutputAmpere;
    _data["chargerInputFrequency"] = chargerInputFrequency;
    _data["chargerOutputFrequency"] = chargerOutputFrequency;
    _data["chargerIPRating"] = chargerIpRating;
    _data["chargerMountType"] = chargerMountType;
    _data["chargerNumberOfConnector"] = chargerNumberOfConnector;
    _data["chargerLastHeartBeatTimeStamp"] = chargerLastHeartBeatTimeStamp;
    _data["isRFID"] = isRfid;
    _data["chargerPointSerialNumber"] = chargerPointSerialNumber;
    _data["chargerOCPPProtocol"] = chargerOcppProtocol;
    _data["chargerConnectorType"] = chargerConnectorType;
    _data["isAppSupport"] = isAppSupport;
    _data["isTBCutOff"] = isTbCutOff;
    _data["isAntitheft"] = isAntitheft;
    _data["isLEDDisplay"] = isLedDisplay;
    _data["isLEDIndications"] = isLedIndications;
    _data["isSmart"] = isSmart;
    _data["chargerStatus"] = chargerStatus;
    _data["chargePointVendor"] = chargePointVendor;
    _data["chargePointModel"] = chargePointModel;
    _data["chargeBoxSerialNumber"] = chargeBoxSerialNumber;
    _data["meterType"] = meterType;
    _data["firmwareVersion"] = firmwareVersion;
    _data["iccid"] = iccid;
    _data["imsi"] = imsi;
    _data["meterSerialNumber"] = meterSerialNumber;
    _data["diagnosticsStatus"] = diagnosticsStatus;
    _data["diagnosticsTimeStamp"] = diagnosticsTimeStamp;
    _data["chargerSerialNumber"] = chargerSerialNumber;
    _data["chargerInterval"] = chargerInterval;
    _data["createdDate"] = createdDate;
    _data["modifiedDate"] = modifiedDate;
    _data["createdBy"] = createdBy;
    _data["modifiedBy"] = modifiedBy;
    if (connectors != null) {
      _data["connectors"] = connectors?.map((e) => e.toJson()).toList();
    }
    _data["active"] = active;
    return _data;
  }
}

class Connectors {
  String? connectorId;
  int? connectorNumber;
  String? connectorType;
  String? connectorSocket;
  String? connectorStatus;
  String? connectorLastUnavailableTimeStamp;
  String? connectorLastAvailableTimeStamp;
  String? connectorOutputPower;
  int? connectorCharges;
  double? connectorMeterValue;
  String? connectorReservationId;
  String? connectorReservationTimeStamp;
  String? connectorReservationStatus;
  int? connectorReservationAmount;
  String? connectorErrorCode;
  String? connectorInfo;
  String? connectorTimeStamp;
  String? connectorMeterRequestTimeStamp;
  String? connectorUnitType;
  String? createdDate;
  String? modifiedDate;
  String? createdBy;
  String? modifiedBy;
  bool? active;

  Connectors(
      {this.connectorId,
      this.connectorNumber,
      this.connectorType,
      this.connectorSocket,
      this.connectorStatus,
      this.connectorLastUnavailableTimeStamp,
      this.connectorLastAvailableTimeStamp,
      this.connectorOutputPower,
      this.connectorCharges,
      this.connectorMeterValue,
      this.connectorReservationId,
      this.connectorReservationTimeStamp,
      this.connectorReservationStatus,
      this.connectorReservationAmount,
      this.connectorErrorCode,
      this.connectorInfo,
      this.connectorTimeStamp,
      this.connectorMeterRequestTimeStamp,
      this.connectorUnitType,
      this.createdDate,
      this.modifiedDate,
      this.createdBy,
      this.modifiedBy,
      this.active});

  Connectors.fromJson(Map<String, dynamic> json) {
    if (json["connectorId"] is String) {
      connectorId = json["connectorId"];
    }
    if (json["connectorNumber"] is int) {
      connectorNumber = json["connectorNumber"];
    }
    if (json["connectorType"] is String) {
      connectorType = json["connectorType"];
    }
    if (json["connectorSocket"] is String) {
      connectorSocket = json["connectorSocket"];
    }
    if (json["connectorStatus"] is String) {
      connectorStatus = json["connectorStatus"];
    }
    if (json["connectorLastUnavailableTimeStamp"] is String) {
      connectorLastUnavailableTimeStamp =
          json["connectorLastUnavailableTimeStamp"];
    }
    if (json["connectorLastAvailableTimeStamp"] is String) {
      connectorLastAvailableTimeStamp = json["connectorLastAvailableTimeStamp"];
    }
    if (json["connectorOutputPower"] is String) {
      connectorOutputPower = json["connectorOutputPower"];
    }
    if (json["connectorCharges"] is int) {
      connectorCharges = json["connectorCharges"];
    }
    if (json["connectorMeterValue"] is double) {
      connectorMeterValue = json["connectorMeterValue"];
    }
    if (json["connectorReservationId"] is String) {
      connectorReservationId = json["connectorReservationId"];
    }
    if (json["connectorReservationTimeStamp"] is String) {
      connectorReservationTimeStamp = json["connectorReservationTimeStamp"];
    }
    if (json["connectorReservationStatus"] is String) {
      connectorReservationStatus = json["connectorReservationStatus"];
    }
    if (json["connectorReservationAmount"] is int) {
      connectorReservationAmount = json["connectorReservationAmount"];
    }
    if (json["connectorErrorCode"] is String) {
      connectorErrorCode = json["connectorErrorCode"];
    }
    if (json["connectorInfo"] is String) {
      connectorInfo = json["connectorInfo"];
    }
    if (json["connectorTimeStamp"] is String) {
      connectorTimeStamp = json["connectorTimeStamp"];
    }
    if (json["connectorMeterRequestTimeStamp"] is String) {
      connectorMeterRequestTimeStamp = json["connectorMeterRequestTimeStamp"];
    }
    if (json["connectorUnitType"] is String) {
      connectorUnitType = json["connectorUnitType"];
    }
    if (json["createdDate"] is String) {
      createdDate = json["createdDate"];
    }
    if (json["modifiedDate"] is String) {
      modifiedDate = json["modifiedDate"];
    }
    if (json["createdBy"] is String) {
      createdBy = json["createdBy"];
    }
    if (json["modifiedBy"] is String) {
      modifiedBy = json["modifiedBy"];
    }
    if (json["active"] is bool) {
      active = json["active"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["connectorId"] = connectorId;
    _data["connectorNumber"] = connectorNumber;
    _data["connectorType"] = connectorType;
    _data["connectorSocket"] = connectorSocket;
    _data["connectorStatus"] = connectorStatus;
    _data["connectorLastUnavailableTimeStamp"] =
        connectorLastUnavailableTimeStamp;
    _data["connectorLastAvailableTimeStamp"] = connectorLastAvailableTimeStamp;
    _data["connectorOutputPower"] = connectorOutputPower;
    _data["connectorCharges"] = connectorCharges;
    _data["connectorMeterValue"] = connectorMeterValue;
    _data["connectorReservationId"] = connectorReservationId;
    _data["connectorReservationTimeStamp"] = connectorReservationTimeStamp;
    _data["connectorReservationStatus"] = connectorReservationStatus;
    _data["connectorReservationAmount"] = connectorReservationAmount;
    _data["connectorErrorCode"] = connectorErrorCode;
    _data["connectorInfo"] = connectorInfo;
    _data["connectorTimeStamp"] = connectorTimeStamp;
    _data["connectorMeterRequestTimeStamp"] = connectorMeterRequestTimeStamp;
    _data["connectorUnitType"] = connectorUnitType;
    _data["createdDate"] = createdDate;
    _data["modifiedDate"] = modifiedDate;
    _data["createdBy"] = createdBy;
    _data["modifiedBy"] = modifiedBy;
    _data["active"] = active;
    return _data;
  }
}

class Location {
  String? type;
  List<double>? coordinates;

  Location({this.type, this.coordinates});

  Location.fromJson(Map<String, dynamic> json) {
    if (json["type"] is String) {
      type = json["type"];
    }
    if (json["coordinates"] is List) {
      coordinates = json["coordinates"] == null
          ? null
          : List<double>.from(json["coordinates"]);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["type"] = type;
    if (coordinates != null) {
      _data["coordinates"] = coordinates;
    }
    return _data;
  }
}
