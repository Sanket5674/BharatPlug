// this is the model which is used for booking services

class BookingModel {
  String? bookingId;
  String? bookingType;
  String? hostId;
  String? customerId;
  String? vendorId;
  String? stationId;
  String? bookingDate;
  String? bookingTime;
  String? bookingCancellationReason;
  String? bookingStatus;
  String? bookingReqDate;
  String? bookingCancellationReqDate;
  String? bookingSocket;
  String? chargerId;
  String? connectorId;
  String? stationName;
  double? bookingAmount;

  BookingModel(
      {this.bookingId,
      this.bookingType,
      this.hostId,
      this.customerId,
      this.vendorId,
      this.stationId,
      this.bookingDate,
      this.bookingTime,
      this.bookingCancellationReason,
      this.bookingStatus,
      this.bookingReqDate,
      this.bookingCancellationReqDate,
      this.bookingSocket,
      this.chargerId,
      this.connectorId,
      this.stationName,
      this.bookingAmount});

  BookingModel.fromJson(Map<String, dynamic> json) {
    bookingId = json['bookingId'];
    bookingType = json['bookingType'];
    hostId = json['hostId'];
    customerId = json['customerId'];
    vendorId = json['vendorId'];
    stationId = json['stationId'];
    bookingDate = json['bookingDate'];
    bookingTime = json['bookingTime'];
    bookingCancellationReason = json['bookingCancellationReason'];
    bookingStatus = json['bookingStatus'];
    bookingReqDate = json['bookingReqDate'];
    bookingCancellationReqDate = json['bookingCancellationReqDate'];
    bookingSocket = json['bookingSocket'];
    chargerId = json['chargerId'];
    connectorId = json['connectorId'];
    stationName = json['stationName'];
    bookingAmount = json['bookingAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['bookingId'] = bookingId;
    data['bookingType'] = bookingType;
    data['hostId'] = hostId;
    data['customerId'] = customerId;
    data['vendorId'] = vendorId;
    data['stationId'] = stationId;
    data['bookingDate'] = bookingDate;
    data['bookingTime'] = bookingTime;
    data['bookingCancellationReason'] = bookingCancellationReason;
    data['bookingStatus'] = bookingStatus;
    data['bookingReqDate'] = bookingReqDate;
    data['bookingCancellationReqDate'] = bookingCancellationReqDate;
    data['bookingSocket'] = bookingSocket;
    data['chargerId'] = chargerId;
    data['connectorId'] = connectorId;
    data['stationName'] = stationName;
    data['bookingAmount'] = bookingAmount;
    return data;
  }
}
