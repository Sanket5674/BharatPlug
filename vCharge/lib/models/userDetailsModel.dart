// this is the model for the userDetailsModel


class UserDetailsModel {
  String? userId;
  String? userFirstName;
  String? userLastName;
  String? userDateOfBirth;
  String? userGender;
  String? userEmail;
  String? userContactNo;
  String? userAddress;
  String? userVehicleRegNo;
  String? userVehicleChargerType;
  String? userCity;
  String? userPincode;

  UserDetailsModel(
      {this.userId,
      this.userFirstName,
      this.userLastName,
      this.userDateOfBirth,
      this.userGender,
      this.userEmail,
      this.userContactNo,
      this.userAddress,
      this.userVehicleRegNo,
      this.userVehicleChargerType,
      this.userCity,
      this.userPincode});

}
