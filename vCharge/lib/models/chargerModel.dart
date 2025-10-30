// this model is there for the charger service


import 'package:vcharge/models/connectorModel.dart';

class ChargerModel {
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
  String? chargerIPRating;
  String? chargerMountType;
  int? chargerNumberOfConnector;
  String? isRFID;
  String? chargerSerialNumber;
  String? chargerOCPPProtocol;
  String? chargerConnectorType;
  String? isAppSupport;
  String? isTBCutOff;
  String? isAntitheft;
  String? isLEDDisplay;
  String? isLEDIndications;
  String? isSmart;
  List<ConnectorModel>? connectors;

  ChargerModel(
      {
      this.chargerId,
      this.chargerName,
      this.chargerNumber,
      this.chargerInputVoltage,
      this.chargerOutputVoltage,
      this.chargerMinInputAmpere,
      this.chargerMaxInputAmpere,
      this.chargerOutputAmpere,
      this.chargerInputFrequency,
      this.chargerOutputFrequency,
      this.chargerIPRating,
      this.chargerMountType,
      this.chargerNumberOfConnector,
      this.isRFID,
      this.chargerSerialNumber,
      this.chargerOCPPProtocol,
      this.chargerConnectorType,
      this.isAppSupport,
      this.isTBCutOff,
      this.isAntitheft,
      this.isLEDDisplay,
      this.isLEDIndications,
      this.isSmart,
      this.connectors});

  ChargerModel.fromJson(Map<String, dynamic> json) {
    chargerId = json['chargerId'];
    chargerName = json['chargerName'];
    chargerNumber = json['chargerNumber'];
    chargerInputVoltage = json['chargerInputVoltage'];
    chargerOutputVoltage = json['chargerOutputVoltage'];
    chargerMinInputAmpere = json['chargerMinInputAmpere'];
    chargerMaxInputAmpere = json['chargerMaxInputAmpere'];
    chargerOutputAmpere = json['chargerOutputAmpere'];
    chargerInputFrequency = json['chargerInputFrequency'];
    chargerOutputFrequency = json['chargerOutputFrequency'];
    chargerIPRating = json['chargerIPRating'];
    chargerMountType = json['chargerMountType'];
    chargerNumberOfConnector = json['chargerNumberOfConnector'];
    isRFID = json['isRFID'];
    chargerSerialNumber = json['chargerSerialNumber'];
    chargerOCPPProtocol = json['chargerOCPPProtocol'];
    chargerConnectorType = json['chargerConnectorType'];
    isAppSupport = json['isAppSupport'];
    isTBCutOff = json['isTBCutOff'];
    isAntitheft = json['isAntitheft'];
    isLEDDisplay = json['isLEDDisplay'];
    isLEDIndications = json['isLEDIndications'];
    isSmart = json['isSmart'];
    if (json['connectors'] != null) {
      connectors = <ConnectorModel>[];
      json['connectors'].forEach((v) {
        connectors!.add(ConnectorModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['chargerId'] = chargerId;
    data['chargerName'] = chargerName;
    data['chargerNumber'] = chargerNumber;
    data['chargerInputVoltage'] = chargerInputVoltage;
    data['chargerOutputVoltage'] = chargerOutputVoltage;
    data['chargerMinInputAmpere'] = chargerMinInputAmpere;
    data['chargerMaxInputAmpere'] = chargerMaxInputAmpere;
    data['chargerOutputAmpere'] = chargerOutputAmpere;
    data['chargerInputFrequency'] = chargerInputFrequency;
    data['chargerOutputFrequency'] = chargerOutputFrequency;
    data['chargerIPRating'] = chargerIPRating;
    data['chargerMountType'] = chargerMountType;
    data['chargerNumberOfConnector'] = chargerNumberOfConnector;
    data['isRFID'] = isRFID;
    data['chargerSerialNumber'] = chargerSerialNumber;
    data['chargerOCPPProtocol'] = chargerOCPPProtocol;
    data['chargerConnectorType'] = chargerConnectorType;
    data['isAppSupport'] = isAppSupport;
    data['isTBCutOff'] = isTBCutOff;
    data['isAntitheft'] = isAntitheft;
    data['isLEDDisplay'] = isLEDDisplay;
    data['isLEDIndications'] = isLEDIndications;
    data['isSmart'] = isSmart;
    if (connectors != null) {
      data['connectors'] = connectors!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
