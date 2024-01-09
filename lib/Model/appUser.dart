import '../Controller/request_controller.dart';

class appUser {
  int? appUserId;
  String? firstName;
  String? lastName;
  String? nickName;
  String? dateOfBirth;
  String? phoneNumber;
  String? email;
  String? password;
  String? accessStatus;
  String? country;
  int? roleId;
  int? points;

  appUser(
      this.appUserId,
      this.firstName,
      this.lastName,
      this.nickName,
      this.dateOfBirth,
      this.phoneNumber,
      this.email,
      this.password,
      this.accessStatus,
      this.country,
      this.roleId,
      this.points
      );

  appUser.getId(
      this.email,
      );

  appUser.resetPassword(
      this.appUserId,
      this.password
      );

  appUser.fromJson(Map<String, dynamic> json)
      : appUserId = json['appUserId'] as int,
        firstName = json['firstName'] as String,
        lastName = json['lastName'] as String,
        nickName = json['nickName'] as String,
        dateOfBirth = json['dateOfBirth'] as String,
        phoneNumber = json['phoneNumber'] as String,
        email = json['email'] as String,
        password = json['password'] as String,
        accessStatus = json['accessStatus'] as String,
        country = json['country'] as String,
        roleId = json['roleId'] as int,
        points = json['points'] as int;

  //toJson will be automatically called by jsonEncode when necessary
  Map<String, dynamic> toJson() => {
    'appUserId': appUserId,
    'firstName': firstName,
    'lastName': lastName,
    'nickName': nickName,
    'dateOfBirth': dateOfBirth,
    'phoneNumber': phoneNumber,
    'email': email,
    'password': password,
    'accessStatus': accessStatus,
    'country': country,
    'roleId': roleId,
    'points': points

  };

  Future<bool> save() async {
    RequestController req = RequestController(path: "/api/appuser.php");
    req.setBody(toJson());
    await req.post();
    if (req.status() == 400) {
      return true;
    } else if (req.status() == 200) {
      String data = req.result().toString();
      if (data == '{error: Email is already registered}') {
        return false;
      } else {
        return true;
      }
    } else {
      return true;
    }
  }

  Future<bool> checkTouristExistence() async {
    RequestController req = RequestController(path: "/api/appUserCheckExistence.php");
    req.setBody(toJson());
    await req.post();
    print('Json Data: ${req.result()}');
    if (req.status() == 200)  {
      Map<String, dynamic> result = req.result();

      // Ensure that the fields are converted to the expected types
      appUserId = int.parse(result['appUserId'].toString());
      roleId = int.parse(result['roleId'].toString());

      firstName = result['firstName'].toString();
      lastName = result['lastName'].toString();
      nickName = result['nickName'].toString();
      dateOfBirth = result['dateOfBirth'].toString();
      phoneNumber = result['phoneNumber'].toString();
      email = result['email'].toString();
      password = result['password'].toString();
      country = result['country'].toString();
      accessStatus = result['accessStatus'].toString();
      points = int.parse(result['points'].toString());

      return true;
    } else {
      return false;
    }
  }

  Future<bool> resetPassword() async {
    RequestController req = RequestController(path: "/api/getAppUserId.php");
    req.setBody({"appUserId": appUserId, "password": password });
    await req.put();
    if (req.status() == 400) {
      return false;
    } else if (req.status() == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> getUserId() async {
    RequestController req = RequestController(path: "/api/getAppUserId.php");
    req.setBody(toJson());
    await req.post();
    if (req.status() == 200) {
      appUserId=req.result()['appUserId'];
      print(appUserId);
      return true;
    }
    else {
      return false;
    }
  }

  Future<bool> updatePoints(int newTotalPoints) async {
    RequestController req = RequestController(path: "/api/updateTotalPoints.php");
    Map<String, dynamic> data = {"appUserId": appUserId, "points": newTotalPoints};
    req.setBody(data);

    await req.put();

    if (req.status() == 200) {
      // Points updated successfully
      points = newTotalPoints;
      return true;
    } else {
      // Failed to update points
      return false;
    }
  }

  Future<bool> deductPoints(int newTotalPoints) async {
    RequestController req = RequestController(path: "/api/updateTotalPoints.php");
    Map<String, dynamic> data = {"appUserId": appUserId, "points": newTotalPoints};
    req.setBody(data);

    await req.put();

    if (req.status() == 200) {
      return true;
    } else {
      // Failed to update points
      return false;
    }
  }

  Future<bool> updateProfile() async {
    RequestController req = RequestController(path: "/api/appuser.php");
    req.setBody({"appUserId": appUserId, "nickName": nickName,
      "phoneNumber": phoneNumber, "email": email, "password": password });
    await req.put();
    if (req.status() == 400) {
      return false;
    } else if (req.status() == 200) {
      return true;
    } else {
      return false;
    }
  }


}

