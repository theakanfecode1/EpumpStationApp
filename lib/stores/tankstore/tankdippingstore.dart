import 'package:epump/utils/networkcalls/networkrequest.dart';
import 'package:epump/utils/networkcalls/networkstrings.dart';
import 'package:epump/utils/tank/tankdipping.dart';
import 'package:mobx/mobx.dart';

part 'tankdippingstore.g.dart';

class TankDippingStore = _TankDippingStore with _$TankDippingStore;

abstract class _TankDippingStore with Store{
  @observable
  List<TankDipping> dippings =  [];




  @action
  Future<String> getTankDippings(String tankId,String startDate,String endDate) async {
    dippings = [];
    dynamic response = await NetworkRequest.getTankDippings(tankId, startDate, endDate);

    switch(response["statusCode"]){
      case 200:
        dippings = response["object"];
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
  Future<String> postTankDipping(String tankId,String start,dynamic currentVolume) async {
    dynamic response = await NetworkRequest.postDipTank(tankId, start, currentVolume);
    switch(response["statusCode"]){
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
