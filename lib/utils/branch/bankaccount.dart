//http://api.epump.com.ng/Branch/BankAccounts/branchID

class BankAccount{
  String name;
  String accountNumber;
  String accountName;
  String id;

  BankAccount({this.name, this.accountNumber, this.accountName, this.id});

  factory BankAccount.fromJson(Map<String,dynamic> json){
    return BankAccount(
      name: json["name"]==null?"":json["name"],
      accountNumber: json["accountNumber"]==null?"":json["accountNumber"],
      accountName: json["accountName"]==null?"":json["accountName"],
      id: json["id"]==null?"":json["id"],

    );
  }


}