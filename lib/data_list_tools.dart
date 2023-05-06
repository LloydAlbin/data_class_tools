library data_class_tools;

import 'package:uuid_type/uuid_type.dart';

// ignore:unused_import
import 'package:reflectable/reflectable.dart';

import 'package:data_class_tools/src/handlers/logging.dart';
import 'package:logging/logging.dart';
import 'data_class_tools.dart';

final _localLogLevel = Level.INFO;

extension DataListTools<T> on List<T> {
  String toCSVFromList(
      {required final List<String>? includeFields,
      required final List<String>? excludeFields}) {
    final List<String>? incFields = includeFields;
    final List<String>? excFields = excludeFields;
    String csvData = "";
    List<String> csvDataList = [];
    log.info(
        "(toCSVFromList(includeFields: ${incFields.toString()}, excludeFields: ${excFields.toString()})) Starting",
        minLoggingLevel: _localLogLevel);

    bool firstRow = true;
    for (dynamic item in this) {
      if (firstRow == true) {
        log.info(
            "(toCSVFromList.toHeaderCSV(includeFields: ${incFields.toString()}, excludeFields: ${excFields.toString()})) Starting",
            minLoggingLevel: _localLogLevel);
        csvDataList.add(DataClassTools(item)
            .toHeaderCSV(includeFields: incFields, excludeFields: excFields));
      }
      log.info(
          "(toCSVFromList.toCSV(includeFields: ${incFields.toString()}, excludeFields: ${excFields.toString()})) Starting",
          minLoggingLevel: _localLogLevel);
      csvDataList.add(DataClassTools(item)
          .toCSV(includeFields: incFields, excludeFields: excFields));
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

  void fromJSONToList(dynamic jsonResults) {
    for (var index = 0; index < jsonResults.length; index++) {
      log.info("(fromJSONToList) (fromJson) index: $index",
          minLoggingLevel: _localLogLevel);
      //dynamic newAttendee = <T>.fromJSON(jsonResults[index]);
      log.info("(fromJSONToList) (fromJson) add Row",
          minLoggingLevel: _localLogLevel);
      //this.add(newAttendee);
    }
  }
}
