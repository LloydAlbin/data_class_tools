// Logging
import 'package:data_class_tools/src/handlers/logging.dart';
import 'package:logging/logging.dart';
import 'package:data_class_tools/response_class.dart';

const _localLogLevel = Level.SEVERE;

class BoolResponse extends Response {
  bool? passFail;

  BoolResponse();

  BoolResponse.fromJson(dynamic jsonInput, String valueName)
      : passFail = jsonInput['data'][0][valueName] {
    super.fromJSONResponse(jsonInput);
  }

  Map<String, dynamic> _toMap() {
    return {
      'passFail': passFail,
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
