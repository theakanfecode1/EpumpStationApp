// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tankdippingstore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$TankDippingStore on _TankDippingStore, Store {
  final _$dippingsAtom = Atom(name: '_TankDippingStore.dippings');

  @override
  List<TankDipping> get dippings {
    _$dippingsAtom.reportRead();
    return super.dippings;
  }

  @override
  set dippings(List<TankDipping> value) {
    _$dippingsAtom.reportWrite(value, super.dippings, () {
      super.dippings = value;
    });
  }

  final _$getTankDippingsAsyncAction =
      AsyncAction('_TankDippingStore.getTankDippings');

  @override
  Future<String> getTankDippings(
      String tankId, String startDate, String endDate) {
    return _$getTankDippingsAsyncAction
        .run(() => super.getTankDippings(tankId, startDate, endDate));
  }

  final _$postTankDippingAsyncAction =
      AsyncAction('_TankDippingStore.postTankDipping');

  @override
  Future<String> postTankDipping(
      String tankId, String start, dynamic currentVolume) {
    return _$postTankDippingAsyncAction
        .run(() => super.postTankDipping(tankId, start, currentVolume));
  }

  @override
  String toString() {
    return '''
dippings: ${dippings}
    ''';
  }
}
