

import 'package:epump/utils/branch/tank.dart';
import 'package:epump/utils/networkcalls/networkrequest.dart';
import 'package:epump/utils/networkcalls/networkstrings.dart';
import 'package:mobx/mobx.dart';

part 'tankstore.g.dart';

class TankStore = _TankStore with _$TankStore;

abstract class _TankStore with Store{

  @observable
  List<Tank> tanks = [];

  @action
  Future<String> getTanks() async {
    tanks = [];
    dynamic response = await NetworkRequest.getTanks();

    switch(response["statusCode"]){
      case 200:
        tanks = response["object"];
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
  Future<String> startFill(String plateNumber,String tankId,dynamic dipVolume) async {
    tanks = [];
    dynamic response = await NetworkRequest.postStartFill(plateNumber, tankId, dipVolume);
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