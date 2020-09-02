//http://api.epump.com.ng/Branch/DaySale/{branchId}

class DaySale {
  String product;
  dynamic volume;
  dynamic amount;
  dynamic price;
  dynamic rttAmount;
  String date;

  DaySale(
      {this.product,
      this.volume,
      this.amount,
      this.price,
      this.rttAmount,
      this.date});

  factory DaySale.fromJson(Map<String, dynamic> json) {
    return DaySale(
      product: json["product"] == null ? "" : json["product"],
      volume: json["volume"] == null ? json["volumeSold"] : json["volume"],
      amount: json["amount"] == null ? json["amountSold"] : json["amount"],
      price: json["price"] == null ? 0.00 : json["price"],
      rttAmount: json["rttAmount"] == null ? 0.00 : json["rttAmount"],
      date: json["date"] == null ? "" : json["date"],
    );
  }
}
//"product": "AGO",
//"volume": -52,
//"amount": -23110.88,
//"price": 444.44,
//"date": "2020-08-09T00:00:00Z",
//"rtt": 52,
//"rttAmount": 23110.88,
//"dateOpened": "2020-08-09T09:08:16.633",
//"dateModified": "2020-08-09T09:14:42.593",
//"type": null
