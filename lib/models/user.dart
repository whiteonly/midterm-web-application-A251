class User {//create a class User for API response from backend(php) and frontend(flutter)
  String? userId;
  String? userEmail;
  String? userName;
  String? userPassword;
  String? userPhone;
  String? userRegdate;

  User(
      {this.userId,
      this.userEmail,
      this.userName,
      this.userPassword,
      this.userPhone,
      this.userRegdate});

  User.fromJson(Map<String, dynamic> json) {//map json data to user model
    userId = json['user_id'];
    userEmail = json['email'];
    userName = json['name'];
    userPassword = json['password'];
    userPhone = json['phone'];
    userRegdate = json['reg_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};//map user model to json data
    data['user_id'] = userId;
    data['email'] = userEmail;
    data['name'] = userName;
    data['password'] = userPassword;
    data['phone'] = userPhone;
    data['reg_date'] = userRegdate;
    return data;
  }
}
