import 'package:epump/utils/company/productprice.dart';
import 'package:epump/utils/networkcalls/networkrequest.dart';
import 'package:epump/utils/networkcalls/networkstrings.dart';
import 'package:mobx/mobx.dart';

part 'pricechangestore.g.dart';

class PriceChangeStore = _PriceChangeStore with _$PriceChangeStore;

abstract class _PriceChangeStore with Store {

  @observable
  List<ProductPrice> products = [];

  @action
  Future<String> getProducts() async {
    products = [];
    dynamic response = await NetworkRequest.getProductPrice();
    switch (response["statusCode"]) {
      case 200:
        products = response["object"];
        return NetworkStrings.SUCCESSFUL;
        break;
      case 401:
        return NetworkStrings.UNAUTHORIZED;
        break;
      case 400:
        return NetworkStrings.BAD_REQUEST;
        break;
      case 500:
        return NetworkStrings.SERVER_ERROR;
        break;
      case 600:
        return NetworkStrings.CONNECTION_ERROR;
        break;
      default:
        return NetworkStrings.UNKNOWN_ERROR;
        break;
    }
  }

  @action
  Future<String> priceChange(String id,String productId,dynamic price,String password) async {
    dynamic response = await NetworkRequest.changePrice(id, productId, price, password);
    switch (response["statusCode"]) {
      case 200:
        return NetworkStrings.SUCCESSFUL;
        break;
      case 401:
        return NetworkStrings.UNAUTHORIZED;
        break;
      case 400:
        return NetworkStrings.BAD_REQUEST;
        break;
      case 500:
        return NetworkStrings.SERVER_ERROR;
        break;
      case 600:
        return NetworkStrings.CONNECTION_ERROR;
        break;
      default:
        return NetworkStrings.UNKNOWN_ERROR;
        break;
    }
  }

}

