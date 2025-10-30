class SupportModel {
  String? supportCustomerId;
  String? supportHostId;
  String? supportStationId;
  String? supportVendorId;
  String? supportSubject;
  String? supportDescription;
  String? supportStatus;
  String? supportAssignedTo;
  String? supportPriority;
  String? supportCategory;
  String? subSupportCategory;
  String? supportSideResponse;
  String? customerSideResponse;
  String? supportImageLink;
  String? createdBy;

  SupportModel(
      {this.supportCustomerId,
      this.supportHostId,
      this.supportStationId,
      this.supportVendorId,
      this.supportSubject,
      this.supportDescription,
      this.supportStatus,
      this.supportAssignedTo,
      this.supportPriority,
      this.supportCategory,
      this.subSupportCategory,
      this.supportSideResponse,
      this.customerSideResponse,
      this.supportImageLink,
      this.createdBy});

  SupportModel.fromJson(Map<String, dynamic> json) {
    supportCustomerId = json['supportCustomerId'];
    supportHostId = json['supportHostId'];
    supportStationId = json['supportStationId'];
    supportVendorId = json['supportVendorId'];
    supportSubject = json['supportSubject'];
    supportDescription = json['supportDescription'];
    supportStatus = json['supportStatus'];
    supportAssignedTo = json['supportAssignedTo'];
    supportPriority = json['supportPriority'];
    supportCategory = json['supportCategory'];
    subSupportCategory = json['subSupportCategory'];
    supportSideResponse = json['supportSideResponse'];
    customerSideResponse = json['customerSideResponse'];
    supportImageLink = json['supportImageLink'];
    createdBy = json['createdBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['supportCustomerId'] = supportCustomerId;
    data['supportHostId'] = supportHostId;
    data['supportStationId'] = supportStationId;
    data['supportVendorId'] = supportVendorId;
    data['supportSubject'] = supportSubject;
    data['supportDescription'] = supportDescription;
    data['supportStatus'] = supportStatus;
    data['supportAssignedTo'] = supportAssignedTo;
    data['supportPriority'] = supportPriority;
    data['supportCategory'] = supportCategory;
    data['subSupportCategory'] = subSupportCategory;
    data['supportSideResponse'] = supportSideResponse;
    data['customerSideResponse'] = customerSideResponse;
    data['supportImageLink'] = supportImageLink;
    data['createdBy'] = createdBy;
    return data;
  }
}
