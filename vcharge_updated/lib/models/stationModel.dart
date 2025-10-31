import 'chargerModel.dart';

class StationModel {
  String? stationId;
  String? stationName;
  String? stationHostId;
  String? stationVendorId;
  String? stationArea;
  double? stationLatitude;
  double? stationLongitude;
  String? stationLocationURL;
  String? stationAddressLineOne;
  String? stationAddressLineTwo;
  String? stationCity;
  String? stationZipCode;
  String? stationParkingArea;
  String? stationContactNumber;
  String? stationOpeningTime;
  String? stationClosingTime;
  int? chargerNumber;
  String? stationParkingType;
  List<String>? stationAmenity;
  List<ChargerModel>? chargers;
  String? stationShareId;
  String? stationStatus;
  String? stationPowerStandard;

  StationModel(
      {this.stationId,
      this.stationName,
      this.stationHostId,
      this.stationVendorId,
      this.stationArea,
      this.stationLatitude,
      this.stationLongitude,
      this.stationLocationURL,
      this.stationAddressLineOne,
      this.stationAddressLineTwo,
      this.stationCity,
      this.stationZipCode,
      this.stationParkingArea,
      this.stationContactNumber,
      this.stationOpeningTime,
      this.stationClosingTime,
      this.chargerNumber,
      this.stationParkingType,
      this.stationAmenity,
      this.chargers,
      this.stationShareId,
      this.stationStatus,
      this.stationPowerStandard});

  StationModel.fromJson(Map<String, dynamic> json) {
    stationId = json['stationId'];
    stationName = json['stationName'];
    stationHostId = json['stationHostId'];
    stationVendorId = json['stationVendorId'];
    stationArea = json['stationArea'];
    stationLatitude = json['stationLatitude'];
    stationLongitude = json['stationLongitude'];
    stationLocationURL = json['stationLocationURL'];
    stationAddressLineOne = json['stationAddressLineOne'];
    stationAddressLineTwo = json['stationAddressLineTwo'];
    stationCity = json['stationCity'];
    stationZipCode = json['stationZipCode'];
    stationParkingArea = json['stationParkingArea'];
    stationContactNumber = json['stationContactNumber'];
    stationOpeningTime = json['stationOpeningTime'];
    stationClosingTime = json['stationClosingTime'];
    chargerNumber = json['chargerNumber'];
    stationParkingType = json['stationParkingType'];
    stationAmenity = json['stationAmenity'].cast<String>();
    if (json['chargers'] != null) {
      chargers = <ChargerModel>[];
      json['chargers'].forEach((v) {
        chargers?.add(ChargerModel.fromJson(v));
      });
    }
    stationShareId = json['stationShareId'];
    stationStatus = json['stationStatus'];
    stationPowerStandard = json['stationPowerStandard'];
  }

  // get stationClosingTime => null;
  //
  // get stationOpeningTime => null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['stationId'] = stationId;
    data['stationName'] = stationName;
    data['stationHostId'] = stationHostId;
    data['stationVendorId'] = stationVendorId;
    data['stationArea'] = stationArea;
    data['stationLatitude'] = stationLatitude;
    data['stationLongitude'] = stationLongitude;
    data['stationLocationURL'] = stationLocationURL;
    data['stationAddressLineOne'] = stationAddressLineOne;
    data['stationAddressLineTwo'] = stationAddressLineTwo;
    data['stationCity'] = stationCity;
    data['stationZipCode'] = stationZipCode;
    data['stationParkingArea'] = stationParkingArea;
    data['stationContactNumber'] = stationContactNumber;
    data['stationOpeningTime'] = stationOpeningTime;
    data['stationClosingTime'] = stationClosingTime;
    data['chargerNumber'] = chargerNumber;
    data['stationParkingType'] = stationParkingType;
    data['stationAmenity'] = stationAmenity;
    if (chargers != null) {
      data['chargers'] = chargers!.map((v) => v.toJson()).toList();
    }
    data['stationShareId'] = stationShareId;
    data['stationStatus'] = stationStatus;
    data['stationPowerStandard'] = stationPowerStandard;
    return data;
  }
}

//Following is the model for some specific details of station
class RequiredStationDetailsModel {
  String? stationId;
  String? stationName;
  String? stationArea;
  String? stationCity;
  double? stationLatitude;
  double? stationLongitude;
  String? stationStatus;
  String? stationParkingType;
  List<Chargers>? chargers;
  List<Connectors>? connectors;

  RequiredStationDetailsModel({
    this.stationId,
    this.stationName,
    this.stationArea,
    this.stationLatitude,
    this.stationLongitude,
    this.stationCity,
    this.stationStatus,
    this.stationParkingType,
    this.chargers,
    this.connectors,
  });

  RequiredStationDetailsModel.fromJson(Map<String, dynamic> json) {
    stationId = json['stationId'];
    stationName = json['stationName'];
    stationArea = json['stationArea'];
    stationLatitude = json['stationLatitude'];
    stationLongitude = json['stationLongitude'];
    stationCity = json['stationCity'];
    stationStatus = json['stationStatus'];
    stationParkingType = json['stationParkingType'];

    if (json['chargers'] != null) {
      chargers =
          (json['chargers'] as List).map((e) => Chargers.fromJson(e)).toList();
      connectors = chargers!
          .expand((charger) => charger.connectors ?? <Connectors>[])
          .toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['stationId'] = stationId;
    data['stationName'] = stationName;
    data['stationArea'] = stationArea;
    data['stationLatitude'] = stationLatitude;
    data['stationLongitude'] = stationLongitude;
    data['stationCity'] = stationCity;
    data['stationStatus'] = stationStatus;
    data['stationParkingType'] = stationParkingType;
    if (chargers != null) {
      data['chargers'] = chargers!.map((charger) => charger.toJson()).toList();
    }

    // if (connectors != null) {
    //   data['connectors'] =
    //       connectors!.map((connector) => connector.toJson()).toList();
    // }

    return data;
  }
}

//Following is the model for some specific details of station for favourite page
class FavoriteStationDetailsModel {
  String? stationId;
  String? stationName;
  String? stationAddressLineOne;
  String? stationAddressLineTwo;
  String? stationArea;
  String? stationStatus;

  FavoriteStationDetailsModel({
    this.stationId,
    this.stationName,
    this.stationAddressLineOne,
    this.stationAddressLineTwo,
    this.stationArea,
    this.stationStatus,
  });

  FavoriteStationDetailsModel.fromJson(Map<String, dynamic> json) {
    stationId = json['stationId'];
    stationName = json['stationName'];
    stationAddressLineOne = json['stationAddressLineOne'];
    stationAddressLineTwo = json['stationAddressLineTwo'];
    stationArea = json['stationArea'];
    stationStatus = json['stationStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['stationId'] = stationId;
    data['stationName'] = stationName;
    data['stationAddressLineOne'] = stationAddressLineOne;
    data['stationAddressLineTwo'] = stationAddressLineTwo;
    data['stationArea'] = stationArea;
    data['stationStatus'] = stationStatus;
    return data;
  }
}

class Chargers {
  String? chargerId;
  String? chargerType;
  int? chargerNumber;
  int? chargerNumberOfConnector;
  String? chargerConnectorType;
  String? chargerStatus;
  int? chargerInterval;
  List<Connectors>? connectors;
  bool? active;

  Chargers(
      {this.chargerId,
      this.chargerType,
      this.chargerNumber,
      this.chargerNumberOfConnector,
      this.chargerConnectorType,
      this.chargerStatus,
      this.chargerInterval,
      this.connectors,
      this.active});

  Chargers.fromJson(Map<String, dynamic> json) {
    if (json["chargerId"] is String) {
      chargerId = json["chargerId"];
    }
    if (json["chargerType"] is String) {
      chargerType = json["chargerType"];
    }
    if (json["chargerNumber"] is int) {
      chargerNumber = json["chargerNumber"];
    }
    if (json["chargerNumberOfConnector"] is int) {
      chargerNumberOfConnector = json["chargerNumberOfConnector"];
    }
    if (json["chargerConnectorType"] is String) {
      chargerConnectorType = json["chargerConnectorType"];
    }
    if (json["chargerStatus"] is String) {
      chargerStatus = json["chargerStatus"];
    }
    if (json["chargerInterval"] is int) {
      chargerInterval = json["chargerInterval"];
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
    _data["chargerType"] = chargerType;
    _data["chargerNumber"] = chargerNumber;
    _data["chargerNumberOfConnector"] = chargerNumberOfConnector;
    _data["chargerConnectorType"] = chargerConnectorType;
    _data["chargerStatus"] = chargerStatus;
    _data["chargerInterval"] = chargerInterval;
    if (connectors != null) {
      _data["connectors"] = connectors?.map((e) => e.toJson()).toList();
    }
    _data["active"] = active;
    return _data;
  }
}

class Connectors {
  String? connectorType;
  String? connectorSocket;
  String? connectorStatus;
  int? connectorCharges;
  int? connectorMeterValue;
  int? connectorReservationAmount;
  bool? active;

  Connectors(
      {this.connectorType,
      this.connectorStatus,
      this.connectorSocket,
      this.connectorCharges,
      this.connectorMeterValue,
      this.connectorReservationAmount,
      this.active});

  Connectors.fromJson(Map<String, dynamic> json) {
    if (json["connectorType"] is String) {
      connectorType = json["connectorType"];
    }
    if (json["connectorSocket"] is String) {
      connectorSocket = json["connectorSocket"];
    }
    if (json["connectorStatus"] is String) {
      connectorStatus = json["connectorStatus"];
    }
    if (json["connectorCharges"] is int) {
      connectorCharges = json["connectorCharges"];
    }
    if (json["connectorMeterValue"] is int) {
      connectorMeterValue = json["connectorMeterValue"];
    }
    if (json["connectorReservationAmount"] is int) {
      connectorReservationAmount = json["connectorReservationAmount"];
    }
    if (json["active"] is bool) {
      active = json["active"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["connectorType"] = connectorType;
    _data["connectorSocket"] = connectorSocket;
    _data["connectorStatus"] = connectorStatus;
    _data["connectorCharges"] = connectorCharges;
    _data["connectorMeterValue"] = connectorMeterValue;
    _data["connectorReservationAmount"] = connectorReservationAmount;
    _data["active"] = active;
    return _data;
  }
}
