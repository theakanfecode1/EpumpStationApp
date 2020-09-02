// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pumpstore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$PumpStore on _PumpStore, Store {
  final _$pumpsAtom = Atom(name: '_PumpStore.pumps');

  @override
  List<Pump> get pumps {
    _$pumpsAtom.reportRead();
    return super.pumps;
  }

  @override
  set pumps(List<Pump> value) {
    _$pumpsAtom.reportWrite(value, super.pumps, () {
      super.pumps = value;
    });
  }

  final _$pumpTransactionsAtom = Atom(name: '_PumpStore.pumpTransactions');

  @override
  List<PumpTransaction> get pumpTransactions {
    _$pumpTransactionsAtom.reportRead();
    return super.pumpTransactions;
  }

  @override
  set pumpTransactions(List<PumpTransaction> value) {
    _$pumpTransactionsAtom.reportWrite(value, super.pumpTransactions, () {
      super.pumpTransactions = value;
    });
  }

  final _$totalPumpTransactionAtom =
      Atom(name: '_PumpStore.totalPumpTransaction');

  @override
  dynamic get totalPumpTransaction {
    _$totalPumpTransactionAtom.reportRead();
    return super.totalPumpTransaction;
  }

  @override
  set totalPumpTransaction(dynamic value) {
    _$totalPumpTransactionAtom.reportWrite(value, super.totalPumpTransaction,
        () {
      super.totalPumpTransaction = value;
    });
  }

  final _$getPumpsAsyncAction = AsyncAction('_PumpStore.getPumps');

  @override
  Future<String> getPumps() {
    return _$getPumpsAsyncAction.run(() => super.getPumps());
  }

  final _$postRecordPumpTransactionAsyncAction =
      AsyncAction('_PumpStore.postRecordPumpTransaction');

  @override
  Future<String> postRecordPumpTransaction(
      dynamic rtt, String pumpId, dynamic closingReading) {
    return _$postRecordPumpTransactionAsyncAction.run(
        () => super.postRecordPumpTransaction(rtt, pumpId, closingReading));
  }

  final _$getPumpTransactionsAsyncAction =
      AsyncAction('_PumpStore.getPumpTransactions');

  @override
  Future<String> getPumpTransactions(
      String pumpId, String startDate, String endDate, bool eSales) {
    return _$getPumpTransactionsAsyncAction.run(
        () => super.getPumpTransactions(pumpId, startDate, endDate, eSales));
  }

  final _$postRttAsyncAction = AsyncAction('_PumpStore.postRtt');

  @override
  Future<String> postRtt(String pumpId, String comment) {
    return _$postRttAsyncAction.run(() => super.postRtt(pumpId, comment));
  }

  @override
  String toString() {
    return '''
pumps: ${pumps},
pumpTransactions: ${pumpTransactions},
totalPumpTransaction: ${totalPumpTransaction}
    ''';
  }
}
