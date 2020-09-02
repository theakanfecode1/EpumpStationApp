class ShiftAssignment {
  String shiftId;
  String firstName;
  String lastName;
  String pumpName;
  dynamic openingReading;
  dynamic closingReading;

  ShiftAssignment({this.shiftId, this.firstName,this.pumpName, this.lastName,
      this.openingReading, this.closingReading});

  factory ShiftAssignment.fromJson(Map<String,dynamic> json){
    return ShiftAssignment(
      shiftId: json["shiftId"] == null ? "": json["shiftId"],
      firstName: json["firstName"] == null ? "": json["firstName"],
      lastName: json["lastName"] == null ? "": json["lastName"],
      pumpName: json["pumpName"] == null ? "": json["pumpName"],
      openingReading: json["openingReading"] == null ? 0.00: json["openingReading"],
      closingReading: json["closingReading"] == null ? 0.00: json["closingReading"],

    );
  }


}