class ChargingHistoryModel {
  String? transactionId;
  bool? key;
  String? idTag;
  String? requestTimeStamp;
  String? transactionCustomerId;
  String? transactionConnectorId;
  int? transactionConnectorNumber;
  String? transactionChargerSerialNumber;
  String? transactionHostId;
  String? transactionChargerId;
  String? transactionVendorId;
  String? transactionStationId;
  String? transactionStatus;
  String? transactionStartReason;
  String? transactionActualStopMeterValue;
  String? transactionStopReason;
  int? transactionStopTriggerInUnit;
  int? transactionRequestedAmount;
  int? transactionRequestedUnit;
  int? transactionRequestEnergy;
  int? transactionAmountCharged;
  int? transactionStopPredictedMeterValue;
  String? transactionUtr;
  String? transactionMeterStartTimeStamp;
  String? transactionMeterStopTimeStamp;
  String? transactionMeterStartDate;
  String? transactionMeterStopDate;
  double? transactionMeterStartValue;
  int? transactionMeterStopValue;
  MeterValues? meterValues;
  int? transactionChargers;
  String? initiateTransactionTime;
  double? transactionAmount;
  String? createdDate;
  String? modifiedDate;
  String? createdBy;
  String? modifiedBy;
  bool? active;
  int? txnid;

  ChargingHistoryModel(
      {this.transactionId,
      this.key,
      this.idTag,
      this.requestTimeStamp,
      this.transactionCustomerId,
      this.transactionConnectorId,
      this.transactionConnectorNumber,
      this.transactionChargerSerialNumber,
      this.transactionHostId,
      this.transactionChargerId,
      this.transactionVendorId,
      this.transactionStationId,
      this.transactionStatus,
      this.transactionStartReason,
      this.transactionActualStopMeterValue,
      this.transactionStopReason,
      this.transactionStopTriggerInUnit,
      this.transactionRequestedAmount,
      this.transactionRequestedUnit,
      this.transactionRequestEnergy,
      this.transactionAmountCharged,
      this.transactionStopPredictedMeterValue,
      this.transactionUtr,
      this.transactionMeterStartTimeStamp,
      this.transactionMeterStopTimeStamp,
      this.transactionMeterStartDate,
      this.transactionMeterStopDate,
      this.transactionMeterStartValue,
      this.transactionMeterStopValue,
      this.meterValues,
      this.transactionChargers,
      this.initiateTransactionTime,
      this.transactionAmount,
      this.createdDate,
      this.modifiedDate,
      this.createdBy,
      this.modifiedBy,
      this.active,
      this.txnid});

  ChargingHistoryModel.fromJson(Map<String, dynamic> json) {
    if (json["transactionId"] is String) {
      transactionId = json["transactionId"];
    }
    if (json["key"] is bool) {
      key = json["key"];
    }
    if (json["idTag"] is String) {
      idTag = json["idTag"];
    }
    if (json["requestTimeStamp"] is String) {
      requestTimeStamp = json["requestTimeStamp"];
    }
    if (json["transactionCustomerId"] is String) {
      transactionCustomerId = json["transactionCustomerId"];
    }
    if (json["transactionConnectorId"] is String) {
      transactionConnectorId = json["transactionConnectorId"];
    }
    if (json["transactionConnectorNumber"] is int) {
      transactionConnectorNumber = json["transactionConnectorNumber"];
    }
    if (json["transactionChargerSerialNumber"] is String) {
      transactionChargerSerialNumber = json["transactionChargerSerialNumber"];
    }
    if (json["transactionHostId"] is String) {
      transactionHostId = json["transactionHostId"];
    }
    if (json["transactionChargerId"] is String) {
      transactionChargerId = json["transactionChargerId"];
    }
    if (json["transactionVendorId"] is String) {
      transactionVendorId = json["transactionVendorId"];
    }
    if (json["transactionStationId"] is String) {
      transactionStationId = json["transactionStationId"];
    }
    if (json["transactionStatus"] is String) {
      transactionStatus = json["transactionStatus"];
    }
    if (json["transactionStartReason"] is String) {
      transactionStartReason = json["transactionStartReason"];
    }
    if (json["transactionActualStopMeterValue"] is String) {
      transactionActualStopMeterValue = json["transactionActualStopMeterValue"];
    }
    if (json["transactionStopReason"] is String) {
      transactionStopReason = json["transactionStopReason"];
    }
    if (json["transactionStopTriggerInUnit"] is int) {
      transactionStopTriggerInUnit = json["transactionStopTriggerInUnit"];
    }
    if (json["transactionRequestedAmount"] is int) {
      transactionRequestedAmount = json["transactionRequestedAmount"];
    }
    if (json["transactionRequestedUnit"] is int) {
      transactionRequestedUnit = json["transactionRequestedUnit"];
    }
    if (json["transactionRequestEnergy"] is int) {
      transactionRequestEnergy = json["transactionRequestEnergy"];
    }
    if (json["transactionAmountCharged"] is int) {
      transactionAmountCharged = json["transactionAmountCharged"];
    }
    if (json["transactionStopPredictedMeterValue"] is int) {
      transactionStopPredictedMeterValue =
          json["transactionStopPredictedMeterValue"];
    }
    if (json["transactionUTR"] is String) {
      transactionUtr = json["transactionUTR"];
    }
    if (json["transactionMeterStartTimeStamp"] is String) {
      transactionMeterStartTimeStamp = json["transactionMeterStartTimeStamp"];
    }
    if (json["transactionMeterStopTimeStamp"] is String) {
      transactionMeterStopTimeStamp = json["transactionMeterStopTimeStamp"];
    }
    if (json["transactionMeterStartDate"] is String) {
      transactionMeterStartDate = json["transactionMeterStartDate"];
    }
    if (json["transactionMeterStopDate"] is String) {
      transactionMeterStopDate = json["transactionMeterStopDate"];
    }
    if (json["transactionMeterStartValue"] is double) {
      transactionMeterStartValue = json["transactionMeterStartValue"];
    }
    if (json["transactionMeterStopValue"] is int) {
      transactionMeterStopValue = json["transactionMeterStopValue"];
    }
    if (json["meterValues"] is Map) {
      meterValues = json["meterValues"] == null
          ? null
          : MeterValues.fromJson(json["meterValues"]);
    }
    if (json["transactionChargers"] is int) {
      transactionChargers = json["transactionChargers"];
    }
    if (json["initiateTransactionTime"] is String) {
      initiateTransactionTime = json["initiateTransactionTime"];
    }
    if (json["transactionAmount"] is double) {
      transactionAmount = json["transactionAmount"];
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
    if (json["txnid"] is int) {
      txnid = json["txnid"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["transactionId"] = transactionId;
    _data["key"] = key;
    _data["idTag"] = idTag;
    _data["requestTimeStamp"] = requestTimeStamp;
    _data["transactionCustomerId"] = transactionCustomerId;
    _data["transactionConnectorId"] = transactionConnectorId;
    _data["transactionConnectorNumber"] = transactionConnectorNumber;
    _data["transactionChargerSerialNumber"] = transactionChargerSerialNumber;
    _data["transactionHostId"] = transactionHostId;
    _data["transactionChargerId"] = transactionChargerId;
    _data["transactionVendorId"] = transactionVendorId;
    _data["transactionStationId"] = transactionStationId;
    _data["transactionStatus"] = transactionStatus;
    _data["transactionStartReason"] = transactionStartReason;
    _data["transactionActualStopMeterValue"] = transactionActualStopMeterValue;
    _data["transactionStopReason"] = transactionStopReason;
    _data["transactionStopTriggerInUnit"] = transactionStopTriggerInUnit;
    _data["transactionRequestedAmount"] = transactionRequestedAmount;
    _data["transactionRequestedUnit"] = transactionRequestedUnit;
    _data["transactionRequestEnergy"] = transactionRequestEnergy;
    _data["transactionAmountCharged"] = transactionAmountCharged;
    _data["transactionStopPredictedMeterValue"] =
        transactionStopPredictedMeterValue;
    _data["transactionUTR"] = transactionUtr;
    _data["transactionMeterStartTimeStamp"] = transactionMeterStartTimeStamp;
    _data["transactionMeterStopTimeStamp"] = transactionMeterStopTimeStamp;
    _data["transactionMeterStartDate"] = transactionMeterStartDate;
    _data["transactionMeterStopDate"] = transactionMeterStopDate;
    _data["transactionMeterStartValue"] = transactionMeterStartValue;
    _data["transactionMeterStopValue"] = transactionMeterStopValue;
    if (meterValues != null) {
      _data["meterValues"] = meterValues?.toJson();
    }
    _data["transactionChargers"] = transactionChargers;
    _data["initiateTransactionTime"] = initiateTransactionTime;
    _data["transactionAmount"] = transactionAmount;
    _data["createdDate"] = createdDate;
    _data["modifiedDate"] = modifiedDate;
    _data["createdBy"] = createdBy;
    _data["modifiedBy"] = modifiedBy;
    _data["active"] = active;
    _data["txnid"] = txnid;
    return _data;
  }
}

class MeterValues {
  MeterValues();

  MeterValues.fromJson(Map<String, dynamic> json) {}

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};

    return _data;
  }
}
