//http://api.epump.com.ng/Account/login

class AccountLogin {
  String email;
  String firstName;
  String lastName;
  String token;
  String role;
  String phoneNumber;

  AccountLogin({
    this.email,
    this.firstName,
    this.lastName,
    this.token,
    this.role,
    this.phoneNumber,
  });
  factory AccountLogin.fromJson(Map<String, dynamic> json) => AccountLogin(
    email: json["email"]==null?"":json["email"],
    firstName: json["firstName"]==null?"":json["firstName"],
    phoneNumber: json["phone"]==null?"":json["phone"],
    lastName: json["lastName"]==null?"":json["lastName"],
    token: json["token"]==null?"":json["token"],
    role: json["role"]==null?"":json["role"]
  );
}
