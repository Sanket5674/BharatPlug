
class AnnouncementModel {
  String? announcementId;
  String? positionName;
  String? message;
  String? icon;

  AnnouncementModel({this.announcementId, this.positionName, this.message, this.icon});

  AnnouncementModel.fromJson(Map<String, dynamic> json) {
    if(json["announcementId"] is String) {
      announcementId = json["announcementId"];
    }
    if(json["positionName"] is String) {
      positionName = json["positionName"];
    }
    if(json["message"] is String) {
      message = json["message"];
    }
    if(json["icon"] is String) {
      icon = json["icon"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["announcementId"] = announcementId;
    _data["positionName"] = positionName;
    _data["message"] = message;
    _data["icon"] = icon;
    return _data;
  }
}