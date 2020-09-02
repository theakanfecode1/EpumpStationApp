

class BranchStaff{
  String id;
  String firstName;
  String lastName;
  String phone;
  String email;

  BranchStaff({this.id,this.firstName, this.lastName, this.phone,this.email});

  factory BranchStaff.fromJson(Map<String,dynamic> json){
    return BranchStaff(
      id: json["id"] == null ? "":json["id"],
      firstName: json["firstName"] == null ? "":json["firstName"],
      lastName: json["lastName"] == null ? "":json["lastName"],
      phone: json["phone"] == null ? "":json["phone"],
      email: json["email"] == null ? "":json["email"],


    );
  }


}

