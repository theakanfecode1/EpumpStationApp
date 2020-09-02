// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tankstore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$TankStore on _TankStore, Store {
  final _$tanksAtom = Atom(name: '_TankStore.tanks');

  @override
  List<Tank> get tanks {
    _$tanksAtom.reportRead();
    return super.tanks;
  }

  @override
  set tanks(List<Tank> value) {
    _$tanksAtom.reportWrite(value, super.tanks, () {
      super.tanks = value;
    });
  }

  final _$getTanksAsyncAction = AsyncAction('_TankStore.getTanks');

  @override
  Future<String> getTanks() {
    return _$getTanksAsyncAction.run(() => super.getTanks());
  }

  final _$startFillAsyncAction = AsyncAction('_TankStore.startFill');

  @override
  Future<String> startFill(
      String plateNumber, String tankId, dynamic dipVolume) {
    return _$startFillAsyncAction
        .run(() => super.startFill(plateNumber, tankId, dipVolume));
  }

  @override
  String toString() {
    return '''
tanks: ${tanks}
    ''';
  }
}
