//http://api.epump.com.ng/Branch/BankTransaction/6a237865-91ec-4c58-8b75-d7333e4cb4e6

class BankTransaction{
  dynamic amount;


  BankTransaction({this.amount});

  factory BankTransaction.fromJson(Map<String,dynamic> json){
    return BankTransaction(
      amount: json["amount"] == null ? 0.00 :json["amount"],
    );
  }
}
