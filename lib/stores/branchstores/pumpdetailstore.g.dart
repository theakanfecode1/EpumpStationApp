// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pumpdetailstore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$PumpDetailsStore on _PumpDetailsStore, Store {
  final _$pumpDetailsAtom = Atom(name: '_PumpDetailsStore.pumpDetails');

  @override
  PumpDetail get pumpDetails {
    _$pumpDetailsAtom.reportRead();
    return super.pumpDetails;
  }

  @override
  set pumpDetails(PumpDetail value) {
    _$pumpDetailsAtom.reportWrite(value, super.pumpDetails, () {
      super.pumpDetails = value;
    });
  }

  final _$getPumpDetailsAsyncAction =
      AsyncAction('_PumpDetailsStore.getPumpDetails');

  @override
  Future<String> getPumpDetails(String id) {
    return _$getPumpDetailsAsyncAction.run(() => super.getPumpDetails(id));
  }

  @override
  String toString() {
    return '''
pumpDetails: ${pumpDetails}
    ''';
  }
}
