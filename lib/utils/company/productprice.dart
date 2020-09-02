
class ProductPrice{
  String productId;
  String productName;
  dynamic currentSellingPrice;
  bool selling;

  ProductPrice({this.productId, this.productName, this.currentSellingPrice,
      this.selling});

  factory ProductPrice.fromJson(Map<String,dynamic> json){
    return ProductPrice(
      productId: json["productId"] == null ? "" :json["productId"],
      productName: json["productName"] == null ? "" :json["productName"],
      currentSellingPrice: json["currentSellingPrice"] == null ? 0 :json["currentSellingPrice"],
      selling: json["selling"],




    );
  }


}