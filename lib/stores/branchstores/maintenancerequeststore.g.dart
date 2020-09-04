// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'maintenancerequeststore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$MaintenanceRequestStore on _MaintenanceRequestStore, Store {
  final _$requestsAtom = Atom(name: '_MaintenanceRequestStore.requests');

  @override
  List<MaintenanceRequest> get requests {
    _$requestsAtom.reportRead();
    return super.requests;
  }

  @override
  set requests(List<MaintenanceRequest> value) {
    _$requestsAtom.reportWrite(value, super.requests, () {
      super.requests = value;
    });
  }

  final _$propertiesAtom = Atom(name: '_MaintenanceRequestStore.properties');

  @override
  List<String> get properties {
    _$propertiesAtom.reportRead();
    return super.properties;
  }

  @override
  set properties(List<String> value) {
    _$propertiesAtom.reportWrite(value, super.properties, () {
      super.properties = value;
    });
  }

  final _$getMaintenanceRequestAsyncAction =
      AsyncAction('_MaintenanceRequestStore.getMaintenanceRequest');

  @override
  Future<String> getMaintenanceRequest() {
    return _$getMaintenanceRequestAsyncAction
        .run(() => super.getMaintenanceRequest());
  }

  final _$getMPropertiesAsyncAction =
      AsyncAction('_MaintenanceRequestStore.getMProperties');

  @override
  Future<String> getMProperties() {
    return _$getMPropertiesAsyncAction.run(() => super.getMProperties());
  }

  final _$submitMaintenanceRequestAsyncAction =
      AsyncAction('_MaintenanceRequestStore.submitMaintenanceRequest');

  @override
  Future<String> submitMaintenanceRequest(
      String description, String type, String typeName, String imageString) {
    return _$submitMaintenanceRequestAsyncAction.run(() => super
        .submitMaintenanceRequest(description, type, typeName, imageString));
  }

  final _$uploadImageAsyncAction =
      AsyncAction('_MaintenanceRequestStore.uploadImage');

  @override
  Future<String> uploadImage(dynamic filename) {
    return _$uploadImageAsyncAction.run(() => super.uploadImage(filename));
  }

  final _$resolveRequestAsyncAction =
      AsyncAction('_MaintenanceRequestStore.resolveRequest');

  @override
  Future<String> resolveRequest(String id, dynamic amount) {
    return _$resolveRequestAsyncAction
        .run(() => super.resolveRequest(id, amount));
  }

  @override
  String toString() {
    return '''
requests: ${requests},
properties: ${properties}
    ''';
  }
}
