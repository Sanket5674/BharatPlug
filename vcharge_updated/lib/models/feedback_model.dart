
class FeedbackModel {
  String? feedbackId;
  String? userFirstName;
  String? feedbackCustomerId;
  String? feedbackStationId;
  String? feedbackHostId;
  String? feedbackVendorId;
  String? feedbackText;
  String? feedbackRating;
  String? feedbackDate;
  String? feedbackStatus;
  String? createDate;
  String? modifiedDate;
  String? createBy;
  String? modifiedBy;
  bool? active;

  FeedbackModel({this.feedbackId,this.userFirstName, this.feedbackCustomerId, this.feedbackStationId, this.feedbackHostId, this.feedbackVendorId, this.feedbackText, this.feedbackRating, this.feedbackDate, this.feedbackStatus, this.createDate, this.modifiedDate, this.createBy, this.modifiedBy, this.active});

  FeedbackModel.fromJson(Map<String, dynamic> json) {
    if(json["feedbackId"] is String) {
      feedbackId = json["feedbackId"];
    }
    if(json["userFirstName"] is String) {
      userFirstName = json["userFirstName"];
    }
    if(json["feedbackCustomerId"] is String) {
      feedbackCustomerId = json["feedbackCustomerId"];
    }
    if(json["feedbackStationId"] is String) {
      feedbackStationId = json["feedbackStationId"];
    }
    if(json["feedbackHostId"] is String) {
      feedbackHostId = json["feedbackHostId"];
    }
    if(json["feedbackVendorId"] is String) {
      feedbackVendorId = json["feedbackVendorId"];
    }
    if(json["feedbackText"] is String) {
      feedbackText = json["feedbackText"];
    }
    if(json["feedbackRating"] is String) {
      feedbackRating = json["feedbackRating"];
    }
    if(json["feedbackDate"] is String) {
      feedbackDate = json["feedbackDate"];
    }
    if(json["feedbackStatus"] is String) {
      feedbackStatus = json["feedbackStatus"];
    }
    if(json["createDate"] is String) {
      createDate = json["createDate"];
    }
    if(json["modifiedDate"] is String) {
      modifiedDate = json["modifiedDate"];
    }
    if(json["createBy"] is String) {
      createBy = json["createBy"];
    }
    if(json["modifiedBy"] is String) {
      modifiedBy = json["modifiedBy"];
    }
    if(json["active"] is bool) {
      active = json["active"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["feedbackId"] = feedbackId;
    _data["userFirstName"] = userFirstName;
    _data["feedbackCustomerId"] = feedbackCustomerId;
    _data["feedbackStationId"] = feedbackStationId;
    _data["feedbackHostId"] = feedbackHostId;
    _data["feedbackVendorId"] = feedbackVendorId;
    _data["feedbackText"] = feedbackText;
    _data["feedbackRating"] = feedbackRating;
    _data["feedbackDate"] = feedbackDate;
    _data["feedbackStatus"] = feedbackStatus;
    _data["createDate"] = createDate;
    _data["modifiedDate"] = modifiedDate;
    _data["createBy"] = createBy;
    _data["modifiedBy"] = modifiedBy;
    _data["active"] = active;
    return _data;
  }
}