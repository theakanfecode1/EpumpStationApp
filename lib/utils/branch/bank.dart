

class Bank{
  String bankName;
  String bankCode;

  Bank({this.bankName, this.bankCode});

  factory Bank.fromJson(Map<String,dynamic> json){
    return Bank(
      bankName: json["bankName"] == null ? json["bankName"] : json["bankName"],
      bankCode: json["bankCode"] == null ? json["bankCode"] : json["bankCode"],
    );
  }

}