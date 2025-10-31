
class UpdatedStationModel {
  String? stationId;
  String? stationName;
  String? stationArea;
  String? stationCity;
  double? stationLatitude;
  double? stationLongitude;
  String? stationStatus;
  List<Chargers>? chargers;

  UpdatedStationModel({this.stationId, this.stationName, this.stationArea, this.stationCity, this.stationLatitude, this.stationLongitude, this.stationStatus, this.chargers});

  UpdatedStationModel.fromJson(Map<String, dynamic> json) {
    if(json["stationId"] is String) {
      stationId = json["stationId"];
    }
    if(json["stationName"] is String) {
      stationName = json["stationName"];
    }
    if(json["stationArea"] is String) {
      stationArea = json["stationArea"];
    }
    if(json["stationCity"] is String) {
      stationCity = json["stationCity"];
    }
    if(json["stationLatitude"] is double) {
      stationLatitude = json["stationLatitude"];
    }
    if(json["stationLongitude"] is double) {
      stationLongitude = json["stationLongitude"];
    }
    if(json["stationStatus"] is String) {
      stationStatus = json["stationStatus"];
    }
    if(json["chargers"] is List) {
      chargers = json["chargers"] == null ? null : (json["chargers"] as List).map((e) => Chargers.fromJson(e)).toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["stationId"] = stationId;
    _data["stationName"] = stationName;
    _data["stationArea"] = stationArea;
    _data["stationCity"] = stationCity;
    _data["stationLatitude"] = stationLatitude;
    _data["stationLongitude"] = stationLongitude;
    _data["stationStatus"] = stationStatus;
    if(chargers != null) {
      _data["chargers"] = chargers?.map((e) => e.toJson()).toList();
    }
    return _data;
  }
}

class Chargers {
  String? chargerId;
  int? chargerNumber;
  int? chargerNumberOfConnector;
  String? chargerConnectorType;
  String? chargerStatus;
  int? chargerInterval;
  List<Connectors>? connectors;
  bool? active;

  Chargers({this.chargerId, this.chargerNumber, this.chargerNumberOfConnector, this.chargerConnectorType, this.chargerStatus, this.chargerInterval, this.connectors, this.active});

  Chargers.fromJson(Map<String, dynamic> json) {
    if(json["chargerId"] is String) {
      chargerId = json["chargerId"];
    }
    if(json["chargerNumber"] is int) {
      chargerNumber = json["chargerNumber"];
    }
    if(json["chargerNumberOfConnector"] is int) {
      chargerNumberOfConnector = json["chargerNumberOfConnector"];
    }
    if(json["chargerConnectorType"] is String) {
      chargerConnectorType = json["chargerConnectorType"];
    }
    if(json["chargerStatus"] is String) {
      chargerStatus = json["chargerStatus"];
    }
    if(json["chargerInterval"] is int) {
      chargerInterval = json["chargerInterval"];
    }
    if(json["connectors"] is List) {
      connectors = json["connectors"] == null ? null : (json["connectors"] as List).map((e) => Connectors.fromJson(e)).toList();
    }
    if(json["active"] is bool) {
      active = json["active"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["chargerId"] = chargerId;
    _data["chargerNumber"] = chargerNumber;
    _data["chargerNumberOfConnector"] = chargerNumberOfConnector;
    _data["chargerConnectorType"] = chargerConnectorType;
    _data["chargerStatus"] = chargerStatus;
    _data["chargerInterval"] = chargerInterval;
    if(connectors != null) {
      _data["connectors"] = connectors?.map((e) => e.toJson()).toList();
    }
    _data["active"] = active;
    return _data;
  }
}

class Connectors {
  String? connectorType;
  String? connectorStatus;
  int? connectorCharges;
  int? connectorMeterValue;
  int? connectorReservationAmount;
  bool? active;

  Connectors({this.connectorType, this.connectorStatus, this.connectorCharges, this.connectorMeterValue, this.connectorReservationAmount, this.active});

  Connectors.fromJson(Map<String, dynamic> json) {
    if(json["connectorType"] is String) {
      connectorType = json["connectorType"];
    }
    if(json["connectorStatus"] is String) {
      connectorStatus = json["connectorStatus"];
    }
    if(json["connectorCharges"] is int) {
      connectorCharges = json["connectorCharges"];
    }
    if(json["connectorMeterValue"] is int) {
      connectorMeterValue = json["connectorMeterValue"];
    }
    if(json["connectorReservationAmount"] is int) {
      connectorReservationAmount = json["connectorReservationAmount"];
    }
    if(json["active"] is bool) {
      active = json["active"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["connectorType"] = connectorType;
    _data["connectorStatus"] = connectorStatus;
    _data["connectorCharges"] = connectorCharges;
    _data["connectorMeterValue"] = connectorMeterValue;
    _data["connectorReservationAmount"] = connectorReservationAmount;
    _data["active"] = active;
    return _data;
  }
}