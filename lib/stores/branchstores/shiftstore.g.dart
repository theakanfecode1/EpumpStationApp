// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shiftstore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ShiftStore on _ShiftStore, Store {
  final _$shiftsAtom = Atom(name: '_ShiftStore.shifts');

  @override
  List<Shift> get shifts {
    _$shiftsAtom.reportRead();
    return super.shifts;
  }

  @override
  set shifts(List<Shift> value) {
    _$shiftsAtom.reportWrite(value, super.shifts, () {
      super.shifts = value;
    });
  }

  final _$shiftAssignmentsAtom = Atom(name: '_ShiftStore.shiftAssignments');

  @override
  List<ShiftAssignment> get shiftAssignments {
    _$shiftAssignmentsAtom.reportRead();
    return super.shiftAssignments;
  }

  @override
  set shiftAssignments(List<ShiftAssignment> value) {
    _$shiftAssignmentsAtom.reportWrite(value, super.shiftAssignments, () {
      super.shiftAssignments = value;
    });
  }

  final _$getShiftsAsyncAction = AsyncAction('_ShiftStore.getShifts');

  @override
  Future<String> getShifts() {
    return _$getShiftsAsyncAction.run(() => super.getShifts());
  }

  final _$getShiftAssignmentsAsyncAction =
      AsyncAction('_ShiftStore.getShiftAssignments');

  @override
  Future<String> getShiftAssignments(String shiftId) {
    return _$getShiftAssignmentsAsyncAction
        .run(() => super.getShiftAssignments(shiftId));
  }

  final _$closeShiftAsyncAction = AsyncAction('_ShiftStore.closeShift');

  @override
  Future<String> closeShift(String shiftId, String description) {
    return _$closeShiftAsyncAction
        .run(() => super.closeShift(shiftId, description));
  }

  final _$postShiftDepositAsyncAction =
      AsyncAction('_ShiftStore.postShiftDeposit');

  @override
  Future<String> postShiftDeposit(
      dynamic amount, String account, String tellerNumber, String shiftId) {
    return _$postShiftDepositAsyncAction.run(
        () => super.postShiftDeposit(amount, account, tellerNumber, shiftId));
  }

  final _$postAssignShiftAsyncAction =
      AsyncAction('_ShiftStore.postAssignShift');

  @override
  Future<String> postAssignShift(String shiftName, String staffId,
      String pumpId, String shiftId, dynamic openingRead) {
    return _$postAssignShiftAsyncAction.run(() => super
        .postAssignShift(shiftName, staffId, pumpId, shiftId, openingRead));
  }

  @override
  String toString() {
    return '''
shifts: ${shifts},
shiftAssignments: ${shiftAssignments}
    ''';
  }
}
