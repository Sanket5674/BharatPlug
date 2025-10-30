class ConnectorModel {
  String? connectorId;
  String? connectorType;
  String? connectorSocket;
  String? connectorStatus;
  String? connectorOutputPower;
  double? connectorCharges; // Change the data type to double

  ConnectorModel({
    this.connectorId,
    this.connectorType,
    this.connectorSocket,
    this.connectorStatus,
    this.connectorOutputPower,
    this.connectorCharges,
  });

  ConnectorModel.fromJson(Map<String, dynamic> json) {
    connectorId = json['connectorId'];
    connectorType = json['connectorType'];
    connectorSocket = json['connectorSocket'];
    connectorStatus = json['connectorStatus'];
    connectorOutputPower = json['connectorOutputPower'];
    connectorCharges = json['connectorCharges']
            is int // Check if it's an integer (e.g., 100) in the response
        ? (json['connectorCharges'] as int).toDouble() // Convert it to double
        : json['connectorCharges']
            ?.toDouble(); // Convert it to double, handling null values
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['connectorId'] = connectorId;
    data['connectorType'] = connectorType;
    data['connectorSocket'] = connectorSocket;
    data['connectorStatus'] = connectorStatus;
    data['connectorOutputPower'] = connectorOutputPower;
    data['connectorCharges'] = connectorCharges; // Keep it as double
    return data;
  }
}
