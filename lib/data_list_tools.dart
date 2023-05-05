library data_class_tools;

import 'package:uuid_type/uuid_type.dart';

// ignore:unused_import
import 'package:reflectable/reflectable.dart';

import 'package:data_class_tools/src/handlers/logging.dart';
import 'package:logging/logging.dart';
import 'data_class_tools.dart';

final _localLogLevel = Level.INFO;

extension DataListTools on List {
  String toCSVFromList(
      {required List<String>? includeFields,
      required List<String>? excludeFields}) {
    String csvData = "";
    List<String> csvDataList = [];

    bool firstRow = true;
    for (dynamic item in this) {
      if (firstRow == true) {
        csvDataList.add(DataClassTools(item).toHeaderCSV(
            includeFields: includeFields, excludeFields: excludeFields));
      }
      csvDataList.add(DataClassTools(item)
          .toCSV(includeFields: includeFields, excludeFields: excludeFields));
      firstRow = false;
    }
    csvData = csvDataList.join('\r\n');
    if (csvData.length > 0) {
      csvData = '$csvData\r\n';
    }

    return csvData;
  }

  String toJSONFromList(
      {required List<String>? includeFields,
      required List<String>? excludeFields}) {
    String jsonData = "";
    List<String> jsonDataList = [];
    for (dynamic item in this) {
      jsonDataList.add(DataClassTools(item)
          .toJSON(includeFields: includeFields, excludeFields: excludeFields));
    }
    jsonData = "[${jsonDataList.join(',')}]";
    return jsonData;
  }
}
