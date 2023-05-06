library data_class_tools;

import 'package:data_class_tools/src/handlers/logging.dart';
import 'package:logging/logging.dart';

final _localLogLevel = Level.INFO;

class Response {
  ServerInfo? serverInfo;

  Response();

  //Response.fromJSONResponse(dynamic jsonInput)
  //    : serverInfo = ServerInfo.fromJSON(jsonInput);

  void fromJSONResponse(dynamic jsonInput) {
    log.info("(Response.fromJSONResponse(dynamic jsonInput)) Starting",
        minLoggingLevel: _localLogLevel);
    serverInfo = ServerInfo.fromJSONToClass(jsonInput);
  }

  Map<String, dynamic> _toMap() {
    return {
      'serverInfo': serverInfo,
    };
  }

  dynamic get(String propertyName) {
    var _mapRep = _toMap();
    if (_mapRep.containsKey(propertyName)) {
      return _mapRep[propertyName];
    }
    throw ArgumentError('property not found');
  }
}

class ServerInfo {
  ErrorResponse errorInfo;
  int apiVersion;

  ServerInfo(
    this.errorInfo,
    this.apiVersion,
  );

  ServerInfo.fromJSONToClass(dynamic jsonInput)
      : errorInfo = ErrorResponse.fromJSONToClass(jsonInput['error']),
        apiVersion = jsonInput['version'];

  Map<String, dynamic> _toMap() {
    return {
      'errorInfo': errorInfo,
      'apiVersion': apiVersion,
    };
  }

  dynamic get(String propertyName) {
    var _mapRep = _toMap();
    if (_mapRep.containsKey(propertyName)) {
      return _mapRep[propertyName];
    }
    throw ArgumentError('property not found');
  }
}

class ErrorResponse {
  int status;
  String? displayMessage;
  String? internalMessage;
  bool forceLogout;
  bool forceUpgrade;

  ErrorResponse(
    this.status,
    this.displayMessage,
    this.internalMessage,
    this.forceLogout,
    this.forceUpgrade,
  );

// This function only works properly if the first value in _toJsonMap() is the primary key
  ErrorResponse.fromJSONToClass(dynamic jsonInput)
      : status = 0,
        forceLogout = true,
        forceUpgrade = true {
    log.info(
        "(ErrorResponse.fromJSONResponse(${jsonInput.toString()})) Starting",
        minLoggingLevel: _localLogLevel);
    status = jsonInput['status'];
    displayMessage = jsonInput['displaymessage'];
    internalMessage = jsonInput['internalmessage'];
    forceLogout = jsonInput['forcelogout'];
    forceUpgrade = jsonInput['forceupgrade'];
  }

  Map<String, dynamic> _toMap() {
    return {
      'status': status,
      'displayMessage': displayMessage,
      'internalMessage': internalMessage,
      'forceLogout': forceLogout,
      'forceUpgrade': forceUpgrade,
    };
  }

  dynamic get(String propertyName) {
    var _mapRep = _toMap();
    if (_mapRep.containsKey(propertyName)) {
      return _mapRep[propertyName];
    }
    throw ArgumentError('property not found');
  }
}
