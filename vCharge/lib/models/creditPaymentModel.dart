class CreditPaymentModel {
  String? id;
  num? paymentAmount;
  String? paymentOrderId;
  String? currency;
  String? userId;
  String? createdAt;
  String? userEmail;
  String? userContact;
  String? paymentMethod;
  bool? userAccountCredited;

  CreditPaymentModel(
      {this.id,
      this.paymentAmount,
      this.paymentOrderId,
      this.currency,
      this.userId,
      this.createdAt,
      this.userEmail,
      this.userContact,
      this.paymentMethod,
      this.userAccountCredited});

  CreditPaymentModel.fromJson(Map<String, dynamic> json) {
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
    if (json["userEmail"] is String) {
      userEmail = json["userEmail"];
    }
    if (json["userContact"] is String) {
      userContact = json["userContact"];
    }
    if (json["paymentMethod"] is String) {
      paymentMethod = json["paymentMethod"];
    }
    if (json["userAccountCredited"] is bool) {
      userAccountCredited = json["userAccountCredited"];
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
    _data["userEmail"] = userEmail;
    _data["userContact"] = userContact;
    _data["paymentMethod"] = paymentMethod;
    _data["userAccountCredited"] = userAccountCredited;
    return _data;
  }
}
