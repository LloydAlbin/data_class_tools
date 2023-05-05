library data_class_tools;

import 'package:uuid_type/uuid_type.dart';

// ignore:unused_import
import 'package:reflectable/reflectable.dart';

import 'package:data_class_tools/src/handlers/logging.dart';
import 'package:logging/logging.dart';
import 'data_class_tools.dart';

final _localLogLevel = Level.INFO;

extension DataListTools on List {
  String toCSV(
      {required List<String>? includeFields,
      required List<String>? excludeFields}) {
    String csvData = "";

    bool firstRow = true;
    for (dynamic item in this) {
      if (firstRow == true) {
        csvData = DataClassTools(item).toHeaderCSV(
            includeFields: includeFields, excludeFields: excludeFields);
      }
      csvData =
          "$csvData${DataClassTools(item).toCSV(includeFields: includeFields, excludeFields: excludeFields)}";
      firstRow = false;
    }
    return csvData;
  }
}
