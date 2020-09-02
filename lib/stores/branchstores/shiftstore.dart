

import 'package:epump/utils/branch/shift.dart';
import 'package:epump/utils/branch/shiftassignment.dart';
import 'package:epump/utils/networkcalls/networkrequest.dart';
import 'package:epump/utils/networkcalls/networkstrings.dart';
import 'package:mobx/mobx.dart';

part 'shiftstore.g.dart';

class ShiftStore = _ShiftStore with _$ShiftStore;

abstract class _ShiftStore with Store{

  @observable
  List<Shift> shifts = [];

  @observable
  List<ShiftAssignment> shiftAssignments = [];

  @action
  Future<String> getShifts() async {
    shifts = [];
    dynamic response = await NetworkRequest.getShifts();

    switch(response["statusCode"]){
      case 200:
        shifts = response["object"];
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
  Future<String> getShiftAssignments(String shiftId) async {
    shiftAssignments = [];
    dynamic response = await NetworkRequest.getShiftAssignment(shiftId);

    switch(response["statusCode"]){
      case 200:
        shiftAssignments = response["object"];
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
  Future<String> closeShift(String shiftId,String description) async {
    dynamic response = await NetworkRequest.postCloseShift(shiftId, description);

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

  @action
  Future<String> postShiftDeposit(dynamic amount,String account,String tellerNumber,String shiftId) async {
    dynamic response = await NetworkRequest.postShiftDeposit(amount, account, tellerNumber, shiftId);

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

  @action
  Future<String> postAssignShift(String shiftName,String staffId,String pumpId,String shiftId,dynamic openingRead) async {
    dynamic response = await NetworkRequest.postAssignShift(shiftName, staffId, pumpId, shiftId, openingRead);

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