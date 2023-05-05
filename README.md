<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

TODO: Put a short description of the package here that helps potential users
know whether this package might be useful for them.

This package includes a bunch of tools to make your Class's even more powerfull.

```dart
get('fieldName');
set('fieldName', 'value');
getType('fieldName');
.toCSV();
.toJSON();
.fromCSV();
.fromJSON();
```

Improvments for List's

```dart
.toCSV();
.toJSON();
.fromCSV();
.fromJSON();
.multisort(List<bool> criteria, dynamic preference, [List<String>? sorttype]);
toUrlEncode({required Map<String, dynamic>? extras});
```

## Features

TODO: List what your package can do. Maybe include images, gifs, or videos.

## Getting started

TODO: List prerequisites and provide or point to information on how to
start using the package.

## Usage

TODO: Include short and useful examples for package users. Add longer examples
to `/example` folder.

```dart
import 'package:data_class_tools/data_class_tools.dart';
import 'package:uuid_type/uuid_type.dart';

enum roles { Guest, Registered, Subscribed }

@myReflectable
class MyTestClass {
  int a;
  double b;
  num c;
  var d;
  String e;
  Uuid f;
  bool g;
  roles h;
  DateTime i;
  Duration j;
  Uri k;
  BigInt l;
  DateTime? m;

  MyTestClass(
    this.a,
    this.b,
    this.c,
    this.d,
    this.e,
    this.f,
    this.g,
    this.h,
    this.i,
    this.j,
    this.k,
    this.l,
    this.m,
  );

  List<FieldMapping> toFieldMap() {
    return [
      FieldMapping('a', 'int', a, 'aa'),
      FieldMapping('b', 'double', b, 'bb'),
      FieldMapping('c', 'num', c, 'cc'),
      FieldMapping('d', 'var', d, 'dd'),
      FieldMapping('e', 'String', e, 'ee'),
      FieldMapping('f', 'Uuid', f, 'ff'),
      FieldMapping('g', 'bool', g, 'gg'),
      FieldMapping('h', 'roles', h, 'hh'),
      FieldMapping('i', 'DateTime', i, 'ii'),
      FieldMapping('j', 'Duration', j, 'jj'),
      FieldMapping('k', 'Uri', k, 'kk'),
      FieldMapping('l', 'BigInt', l, 'll'),
      FieldMapping('m', 'DateTime?', m, 'mm'),
    ];
  }

  //set function to set the properties of Item
  void set(String propertyName, dynamic propertyValue) {
    log.info("(set) Starting", minLoggingLevel: _localLogLevel);
    try {
      var instanceMirror = myReflectable.reflect(this);
      instanceMirror.invokeSetter(
          propertyName, fixType(getType(propertyName), propertyValue));
    } on Exception catch (exception) {
      log.shout('(set) Result Exception: ${exception.toString()}',
          minLoggingLevel: _localLogLevel);
      //throw ArgumentError('propery not found');
    } catch (error) {
      log.shout('(set) Result Error Code: ${error.toString()}',
          minLoggingLevel: _localLogLevel);
      //throw ArgumentError('propery not found');
    }
    log.info("(set) Finishing", minLoggingLevel: _localLogLevel);
  }

  ///get function to get the properties of Item
  dynamic get(String propertyName) {
    return (toFieldMap()
            .where((item) => item.fieldName == propertyName)
            .toList())[0]
        .value;
  }

  ///get function to get the properties of Item
  String getType(String propertyName) {
    return (toFieldMap()
            .where((item) => item.fieldName == propertyName)
            .toList())[0]
        .fieldType;
  }
}
```

## Testing

```sh
flutter test test/data_class_tools_test.dart
```

## Additional information

TODO: Tell users more about the package: where to find more information, how to
contribute to the package, how to file issues, what response they can expect
from the package authors, and more.
