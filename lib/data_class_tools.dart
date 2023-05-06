library data_class_tools;

import 'package:uuid_type/uuid_type.dart';

// ignore:unused_import
import 'package:reflectable/reflectable.dart';

import 'package:data_class_tools/src/handlers/logging.dart';
import 'package:data_class_tools/duration_class_tools.dart';
import 'package:logging/logging.dart';

final _localLogLevel = Level.INFO;

extension DataClassTools on dynamic {
  String toUrlEncode({required Map<String, dynamic>? extras}) {
    List<String> body2 = [];

    if (extras != null) {
      extras.keys.map((key) => body2.add(
          "${Uri.encodeComponent(key)}=${Uri.encodeComponent(extras[key].toString())}"));
    }

    this.toFieldMap().forEach((item) {
      if (item.postgresFieldName != null) {
        body2.add(
            "${Uri.encodeComponent(item.postgresFieldName!)}=${Uri.encodeComponent(item.value.toString())}");
      }
    });
    String body = body2.join("&");

    return body;
  }

  String toHeaderCSV(
      {required List<String>? includeFields,
      required List<String>? excludeFields}) {
    List<String> csvFields = [];
    String csvRow = "";
    bool useIncludedFields = false;

    if (includeFields != null) {
      if (includeFields.length > 0) {
        useIncludedFields = true;
      }
    }
    if (useIncludedFields == true) {
      csvFields = includeFields!;
    } else {
      this.toFieldMap().forEach((item) => csvFields.add(item.fieldName));
    }
    if (excludeFields != null) {
      for (String field in excludeFields) {
        csvFields.remove(field);
      }
    }

    for (String field in csvFields) {
      if (csvRow != "") {
        csvRow = csvRow + ",";
      }
      csvRow = '$csvRow"$field"';
    }

    return csvRow;
  }

  String toCSV(
      {required List<String>? includeFields,
      required List<String>? excludeFields}) {
    List<String> csvFields = [];
    String csvRow = "";
    bool useIncludedFields = false;

    if (includeFields != null) {
      if (includeFields.length > 0) {
        useIncludedFields = true;
      }
    }
    if (useIncludedFields == true) {
      csvFields = includeFields!;
    } else {
      //var _mapRep = data._toMap();
      this.toFieldMap().forEach((item) => csvFields.add(item.fieldName));
    }
    if (excludeFields != null) {
      for (String field in excludeFields) {
        csvFields.remove(field);
      }
    }

    for (String field in csvFields) {
      if (csvRow != "") {
        csvRow = csvRow + ",";
      }
      var value = get(field);
      if (value is double ||
          value is int ||
          value is bool ||
          value.toString() == "null") {
        csvRow = '$csvRow${value.toString()}';
      } else {
        csvRow = '$csvRow"${value.toString()}"';
      }
    }

    return csvRow;
  }

  String toJSON(
      {required List<String>? includeFields,
      required List<String>? excludeFields}) {
    List<String> jsonFields = [];
    String jsonRow = "";
    bool useIncludedFields = false;

    if (includeFields != null) {
      if (includeFields.length > 0) {
        useIncludedFields = true;
      }
    }
    if (useIncludedFields == true) {
      jsonFields = includeFields!;
    } else {
      var _mapRep = this.toFieldMap();
      _mapRep.forEach((item) => jsonFields.add(item.fieldName));
    }
    if (excludeFields != null) {
      for (String field in excludeFields) {
        jsonFields.remove(field);
      }
    }

    for (String field in jsonFields) {
      if (jsonRow != "") {
        jsonRow = jsonRow + ",";
      } else {
        jsonRow = "{"; // Empty row, start with {
      }
      var value = get(field);
      if (value is double ||
          value is int ||
          value is bool ||
          value.toString() == "null") {
        jsonRow = '$jsonRow"$field":${value.toString()}';
      } else {
        jsonRow = '$jsonRow"$field":"${value.toString()}"';
      }
    }
    if (jsonRow != "") {
      jsonRow = "$jsonRow}"; // End of row, end with }
    }

    return jsonRow;
  }
}

// This is where we can put in any special field type confersions that are needed for the fromJson to Class
// Need to add handeling for enum's
dynamic fixType(String fieldType, dynamic value,
    {Map<String, dynamic>? fieldEnums}) {
  if (value == null) {
    return value;
  }
  if (fieldEnums != null) {
    if (fieldEnums.containsKey(value.toString())) {
      return fieldEnums[value.toString()];
    }
  }
  switch (fieldType) {
    case 'DateTime':
      return DateTime.parse(value.toString());
    case 'DateTime?':
      return DateTime.tryParse(value.toString());
    case 'Uuid':
      return Uuid.parse(value.toString());
    case 'Uuid?':
      return Uuid.tryParse(value.toString());
    case 'Duration':
      return parseDuration(value);
    case 'Duration?':
      return tryParseDuration(value);
    case 'Uri':
      return Uri.parse(value.toString());
    case 'Uri?':
      return Uri.tryParse(value.toString());
    case 'BigInt':
      return BigInt.parse(value.toString());
    case 'BigInt?':
      return BigInt.tryParse(value.toString());
  }
  return value;
}

class FieldMapping {
  String fieldName;
  String fieldType;
  dynamic value;
  String? postgresFieldName;

  FieldMapping(
    this.fieldName,
    this.fieldType,
    this.value,
    this.postgresFieldName,
  );

  ///Mapping the properties
  Map<String, dynamic> _toMap() {
    return {
      'fieldName': fieldName,
      'fieldType': fieldType,
      'value': value,
      'postgresFieldName': postgresFieldName,
    };
  }

  ///get function to get the properties of Item
  dynamic get(String propertyName) {
    var _mapRep = _toMap();
    if (_mapRep.containsKey(propertyName)) {
      return _mapRep[propertyName];
    }
    throw ArgumentError('propery not found');
  }
}
