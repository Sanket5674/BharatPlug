class PaymentDetailsModel {
  String? id;
  num? paymentAmount;
  String? paymentOrderId;
  String? currency;
  String? userId;
  String? createdAt;
  int? createdAtEpoch;
  String? userEmail;
  dynamic paymentId;
  String? userContact;
  String? paymentMethod;
  bool? userAccountCredited;
  dynamic paymentStatus;
  dynamic paymentUserId;
  dynamic paymentEvent;
  dynamic paymentEntity;
  List<dynamic>? paymentContains;
  dynamic paymentAccountId;
  int? paymentAmounTransferred;
  dynamic paymentCurrency;
  int? paymentAmountRefunded;
  dynamic paymentRefundStatus;
  bool? paymentCaptured;
  dynamic paymentDescription;
  dynamic paymentBank;
  dynamic paymentWallet;
  int? paymentFee;
  int? paymentTax;
  int? paymentBaseAmount;
  int? paymentTransfferedAmount;
  dynamic paymentBankTransactionId;
  dynamic paymentCreatedDate;
  dynamic paymentTokenId;
  dynamic paymentErrorCode;
  dynamic paymentErrorDescription;
  dynamic paymentErrorSource;
  dynamic paymentErrorStep;
  dynamic paymentErrorReason;
  PaymentUpiDto? paymentUpiDto;
  PaymentUser? paymentUser;
  PaymentCardDto? paymentCardDto;
  List<dynamic>? refund;

  PaymentDetailsModel(
      {this.id,
      this.paymentAmount,
      this.paymentOrderId,
      this.currency,
      this.userId,
      this.createdAt,
      this.createdAtEpoch,
      this.userEmail,
      this.paymentId,
      this.userContact,
      this.paymentMethod,
      this.userAccountCredited,
      this.paymentStatus,
      this.paymentUserId,
      this.paymentEvent,
      this.paymentEntity,
      this.paymentContains,
      this.paymentAccountId,
      this.paymentAmounTransferred,
      this.paymentCurrency,
      this.paymentAmountRefunded,
      this.paymentRefundStatus,
      this.paymentCaptured,
      this.paymentDescription,
      this.paymentBank,
      this.paymentWallet,
      this.paymentFee,
      this.paymentTax,
      this.paymentBaseAmount,
      this.paymentTransfferedAmount,
      this.paymentBankTransactionId,
      this.paymentCreatedDate,
      this.paymentTokenId,
      this.paymentErrorCode,
      this.paymentErrorDescription,
      this.paymentErrorSource,
      this.paymentErrorStep,
      this.paymentErrorReason,
      this.paymentUpiDto,
      this.paymentUser,
      this.paymentCardDto,
      this.refund});

  PaymentDetailsModel.fromJson(Map<String, dynamic> json) {
    if (json["id"] is String) {
      id = json["id"];
    }
    if (json["paymentAmount"] is int) {
      paymentAmount = json["paymentAmount"];
    }
    if (json["paymentOrderId"] is String) {
      paymentOrderId = json["paymentOrderId"];
    }
    if (json["currency"] is String) {
      currency = json["currency"];
    }
    if (json["userId"] is String) {
      userId = json["userId"];
    }
    if (json["createdAt"] is String) {
      createdAt = json["createdAt"];
    }
    if (json["createdAtEpoch"] is int) {
      createdAtEpoch = json["createdAtEpoch"];
    }
    if (json["userEmail"] is String) {
      userEmail = json["userEmail"];
    }
    paymentId = json["paymentId"];
    if (json["userContact"] is String) {
      userContact = json["userContact"];
    }
    if (json["paymentMethod"] is String) {
      paymentMethod = json["paymentMethod"];
    }
    if (json["userAccountCredited"] is bool) {
      userAccountCredited = json["userAccountCredited"];
    }
    paymentStatus = json["paymentStatus"];
    paymentUserId = json["paymentUserId"];
    paymentEvent = json["paymentEvent"];
    paymentEntity = json["paymentEntity"];
    if (json["paymentContains"] is List) {
      paymentContains = json["paymentContains"] ?? [];
    }
    paymentAccountId = json["paymentAccountId"];
    if (json["paymentAmounTransferred"] is int) {
      paymentAmounTransferred = json["paymentAmounTransferred"];
    }
    paymentCurrency = json["paymentCurrency"];
    if (json["paymentAmountRefunded"] is int) {
      paymentAmountRefunded = json["paymentAmountRefunded"];
    }
    paymentRefundStatus = json["paymentRefundStatus"];
    if (json["paymentCaptured"] is bool) {
      paymentCaptured = json["paymentCaptured"];
    }
    paymentDescription = json["paymentDescription"];
    paymentBank = json["paymentBank"];
    paymentWallet = json["paymentWallet"];
    if (json["paymentFee"] is int) {
      paymentFee = json["paymentFee"];
    }
    if (json["paymentTax"] is int) {
      paymentTax = json["paymentTax"];
    }
    if (json["paymentBaseAmount"] is int) {
      paymentBaseAmount = json["paymentBaseAmount"];
    }
    if (json["paymentTransfferedAmount"] is int) {
      paymentTransfferedAmount = json["paymentTransfferedAmount"];
    }
    paymentBankTransactionId = json["paymentBankTransactionId"];
    paymentCreatedDate = json["paymentCreatedDate"];
    paymentTokenId = json["paymentTokenId"];
    paymentErrorCode = json["paymentErrorCode"];
    paymentErrorDescription = json["paymentErrorDescription"];
    paymentErrorSource = json["paymentErrorSource"];
    paymentErrorStep = json["paymentErrorStep"];
    paymentErrorReason = json["paymentErrorReason"];
    if (json["paymentUpiDto"] is Map) {
      paymentUpiDto = json["paymentUpiDto"] == null
          ? null
          : PaymentUpiDto.fromJson(json["paymentUpiDto"]);
    }
    if (json["paymentUser"] is Map) {
      paymentUser = json["paymentUser"] == null
          ? null
          : PaymentUser.fromJson(json["paymentUser"]);
    }
    if (json["paymentCardDto"] is Map) {
      paymentCardDto = json["paymentCardDto"] == null
          ? null
          : PaymentCardDto.fromJson(json["paymentCardDto"]);
    }
    if (json["refund"] is List) {
      refund = json["refund"] ?? [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["paymentAmount"] = paymentAmount;
    _data["paymentOrderId"] = paymentOrderId;
    _data["currency"] = currency;
    _data["userId"] = userId;
    _data["createdAt"] = createdAt;
    _data["createdAtEpoch"] = createdAtEpoch;
    _data["userEmail"] = userEmail;
    _data["paymentId"] = paymentId;
    _data["userContact"] = userContact;
    _data["paymentMethod"] = paymentMethod;
    _data["userAccountCredited"] = userAccountCredited;
    _data["paymentStatus"] = paymentStatus;
    _data["paymentUserId"] = paymentUserId;
    _data["paymentEvent"] = paymentEvent;
    _data["paymentEntity"] = paymentEntity;
    if (paymentContains != null) {
      _data["paymentContains"] = paymentContains;
    }
    _data["paymentAccountId"] = paymentAccountId;
    _data["paymentAmounTransferred"] = paymentAmounTransferred;
    _data["paymentCurrency"] = paymentCurrency;
    _data["paymentAmountRefunded"] = paymentAmountRefunded;
    _data["paymentRefundStatus"] = paymentRefundStatus;
    _data["paymentCaptured"] = paymentCaptured;
    _data["paymentDescription"] = paymentDescription;
    _data["paymentBank"] = paymentBank;
    _data["paymentWallet"] = paymentWallet;
    _data["paymentFee"] = paymentFee;
    _data["paymentTax"] = paymentTax;
    _data["paymentBaseAmount"] = paymentBaseAmount;
    _data["paymentTransfferedAmount"] = paymentTransfferedAmount;
    _data["paymentBankTransactionId"] = paymentBankTransactionId;
    _data["paymentCreatedDate"] = paymentCreatedDate;
    _data["paymentTokenId"] = paymentTokenId;
    _data["paymentErrorCode"] = paymentErrorCode;
    _data["paymentErrorDescription"] = paymentErrorDescription;
    _data["paymentErrorSource"] = paymentErrorSource;
    _data["paymentErrorStep"] = paymentErrorStep;
    _data["paymentErrorReason"] = paymentErrorReason;
    if (paymentUpiDto != null) {
      _data["paymentUpiDto"] = paymentUpiDto?.toJson();
    }
    if (paymentUser != null) {
      _data["paymentUser"] = paymentUser?.toJson();
    }
    if (paymentCardDto != null) {
      _data["paymentCardDto"] = paymentCardDto?.toJson();
    }
    if (refund != null) {
      _data["refund"] = refund;
    }
    return _data;
  }
}

class PaymentCardDto {
  bool? cardEmi;
  dynamic cardEntity;
  dynamic cardId;
  dynamic cardIIn;
  dynamic cardIssuer;
  dynamic cardNetwork;
  dynamic cardLastFourDigits;
  dynamic cardHolderName;
  dynamic cardSubType;
  dynamic cardType;
  bool? cardInternational;

  PaymentCardDto(
      {this.cardEmi,
      this.cardEntity,
      this.cardId,
      this.cardIIn,
      this.cardIssuer,
      this.cardNetwork,
      this.cardLastFourDigits,
      this.cardHolderName,
      this.cardSubType,
      this.cardType,
      this.cardInternational});

  PaymentCardDto.fromJson(Map<String, dynamic> json) {
    if (json["cardEmi"] is bool) {
      cardEmi = json["cardEmi"];
    }
    cardEntity = json["cardEntity"];
    cardId = json["cardId"];
    cardIIn = json["cardIIn"];
    cardIssuer = json["cardIssuer"];
    cardNetwork = json["cardNetwork"];
    cardLastFourDigits = json["cardLastFourDigits"];
    cardHolderName = json["cardHolderName"];
    cardSubType = json["cardSubType"];
    cardType = json["cardType"];
    if (json["cardInternational"] is bool) {
      cardInternational = json["cardInternational"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["cardEmi"] = cardEmi;
    _data["cardEntity"] = cardEntity;
    _data["cardId"] = cardId;
    _data["cardIIn"] = cardIIn;
    _data["cardIssuer"] = cardIssuer;
    _data["cardNetwork"] = cardNetwork;
    _data["cardLastFourDigits"] = cardLastFourDigits;
    _data["cardHolderName"] = cardHolderName;
    _data["cardSubType"] = cardSubType;
    _data["cardType"] = cardType;
    _data["cardInternational"] = cardInternational;
    return _data;
  }
}

class PaymentUser {
  dynamic userId;
  dynamic userFirstName;
  dynamic userLastName;
  dynamic userEmail;
  dynamic userContactNo;
  dynamic userAddress;
  dynamic userCity;
  dynamic userState;
  dynamic userPincode;

  PaymentUser(
      {this.userId,
      this.userFirstName,
      this.userLastName,
      this.userEmail,
      this.userContactNo,
      this.userAddress,
      this.userCity,
      this.userState,
      this.userPincode});

  PaymentUser.fromJson(Map<String, dynamic> json) {
    userId = json["userId"];
    userFirstName = json["userFirstName"];
    userLastName = json["userLastName"];
    userEmail = json["userEmail"];
    userContactNo = json["userContactNo"];
    userAddress = json["userAddress"];
    userCity = json["userCity"];
    userState = json["userState"];
    userPincode = json["userPincode"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["userId"] = userId;
    _data["userFirstName"] = userFirstName;
    _data["userLastName"] = userLastName;
    _data["userEmail"] = userEmail;
    _data["userContactNo"] = userContactNo;
    _data["userAddress"] = userAddress;
    _data["userCity"] = userCity;
    _data["userState"] = userState;
    _data["userPincode"] = userPincode;
    return _data;
  }
}

class PaymentUpiDto {
  dynamic upipayerAccountType;
  dynamic upivpa;
  dynamic upiflow;

  PaymentUpiDto({this.upipayerAccountType, this.upivpa, this.upiflow});

  PaymentUpiDto.fromJson(Map<String, dynamic> json) {
    upipayerAccountType = json["upipayerAccountType"];
    upivpa = json["upivpa"];
    upiflow = json["upiflow"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["upipayerAccountType"] = upipayerAccountType;
    _data["upivpa"] = upivpa;
    _data["upiflow"] = upiflow;
    return _data;
  }
}
