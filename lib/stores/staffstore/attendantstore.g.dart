// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendantstore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AttendantStore on _AttendantStore, Store {
  final _$staffsAtom = Atom(name: '_AttendantStore.staffs');

  @override
  List<BranchStaff> get staffs {
    _$staffsAtom.reportRead();
    return super.staffs;
  }

  @override
  set staffs(List<BranchStaff> value) {
    _$staffsAtom.reportWrite(value, super.staffs, () {
      super.staffs = value;
    });
  }

  final _$statesAtom = Atom(name: '_AttendantStore.states');

  @override
  List<State> get states {
    _$statesAtom.reportRead();
    return super.states;
  }

  @override
  set states(List<State> value) {
    _$statesAtom.reportWrite(value, super.states, () {
      super.states = value;
    });
  }

  final _$getStaffAsyncAction = AsyncAction('_AttendantStore.getStaff');

  @override
  Future<String> getStaff() {
    return _$getStaffAsyncAction.run(() => super.getStaff());
  }

  final _$getStatesAsyncAction = AsyncAction('_AttendantStore.getStates');

  @override
  Future<String> getStates() {
    return _$getStatesAsyncAction.run(() => super.getStates());
  }

  final _$createStaffAsyncAction = AsyncAction('_AttendantStore.createStaff');

  @override
  Future<String> createStaff(String firstName, String lastName, String gender,
      String phoneNumber, String email, String streetAddress, String state) {
    return _$createStaffAsyncAction.run(() => super.createStaff(
        firstName, lastName, gender, phoneNumber, email, streetAddress, state));
  }

  @override
  String toString() {
    return '''
staffs: ${staffs},
states: ${states}
    ''';
  }
}
