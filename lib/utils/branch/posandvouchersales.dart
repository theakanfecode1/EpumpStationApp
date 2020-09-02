//http://api.epump.com.ng/Branch/POSandVoucherSales/{branchId}

class PosAndVoucherSales{

  String date;
  String productName;
  dynamic amountSoldRetainership;
  dynamic amountSoldVoucher;
  dynamic amountSoldRemis;

  PosAndVoucherSales({this.date, this.productName, this.amountSoldRetainership,
      this.amountSoldVoucher, this.amountSoldRemis});

  factory PosAndVoucherSales.fromJson(Map<String,dynamic> json){
    return PosAndVoucherSales(
      date: json["date"]==null?"":json["date"],
      productName: json["productName"]==null?"":json["productName"],
      amountSoldRetainership: json["amountSoldRetainership"]==null?0.00:json["amountSoldRetainership"],
      amountSoldVoucher: json["amountSoldVoucher"]==null?0.00:json["amountSoldVoucher"],
      amountSoldRemis: json["amountSoldRemis"]==null?0.00:json["amountSoldRemis"]
    );
  }


}

//{
//"branchId": "6a237865-91ec-4c58-8b75-d7333e4cb4e6",
//"date": "2020-08-09T00:00:00Z",
//"volSoldRetainership": 0,
//"volSoldVoucher": 0,
//"volSoldRemis": 0,
//"amountSoldRetainership": 0,
//"amountSoldVoucher": 0,
//"amountSoldRemis": 0,
//"priceSoldCredit": 0,
//"id": "3f978226-5c17-40d0-940b-a9af25aeaa9f",
//"profit": 0,
//"productName": "AGO"
//},