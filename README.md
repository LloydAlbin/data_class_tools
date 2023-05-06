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

How to create a class containing the following features:

```dart
List<FieldMapping> toFieldMap()
final Map<String, dynamic>? _fieldEnums
void set(String propertyName, dynamic propertyValue)
dynamic get(String propertyName)
String getType(String propertyName)
class.fromJSON(dynamic jsonInput)
class.fromCSV(); // Not Included Yet
```

data_class_tools.dart adds the following items to your above class:

```dart
String class.toCSV({required List<String>? includeFields, required List<String>? excludeFields})
String class.toJSON({required List<String>? includeFields, required List<String>? excludeFields})
String class.toHeaderCSV({required List<String>? includeFields, required List<String>? excludeFields})
String class.toUrlEncode({required Map<String, dynamic>? extras})
class FieldMapping
dynamic fixType(String fieldType, dynamic value, {Map<String, dynamic>? fieldEnums}) 
```

How to create a Response using the above class and containing the following features:

```dart
response.fromJSONtoClass(dynamic jsonInput)
response.fromCSVToList(); // Not Included Yet
```


data_list_tools.dart adds the following items to your above List that contains the above class

```dart
String list.toCSVFromList({required List<String>? includeFields, required List<String>? excludeFields})
String list.toJSONFromList({required List<String>? includeFields, required List<String>? excludeFields})
multisort(List<bool> criteria, dynamic preference, [List<String>? sorttype]); // Not Included Yet
```

Improvements for Duration

```dart
Duration parseDuration(String s)
Duration? tryParseDuration(String? s)
```

Support for the folowing Dart field types within your class

```dart
int
double
num
var
String
Uuid
bool
enum
DateTime
Duration
Uri
BigInt
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

class MyTestClassResponse extends Response {
  List<MyTestClass> myTestClassList = [];

  MyTestClassResponse();

  MyTestClassResponse.fromJSONtoClass(dynamic jsonInput) {
    super.fromJSONResponse(jsonInput);
    for (var index = 0; index < jsonInput['data'].length; index++) {
      MyTestClass newRow = MyTestClass.fromJSON(jsonInput['data'][index]);
      myTestClassList.add(newRow);
    }
  }
}

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
  Uuid? n;

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
    this.n,
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
      FieldMapping('n', 'Uuid?', n, 'nn'),
    ];
  }

  final Map<String, dynamic>? _fieldEnums = {
    'roles.Guest': roles.Guest,
    'roles.Registered': roles.Registered,
    'roles.Subscribed': roles.Subscribed
  };

  //set function to set the properties of Item
  void set(String propertyName, dynamic propertyValue) {
    log.info("(set) Starting", minLoggingLevel: _localLogLevel);
    try {
      var instanceMirror = myReflectable.reflect(this);
      instanceMirror.invokeSetter(
          propertyName,
          fixType(getType(propertyName), propertyValue,
              fieldEnums: _fieldEnums));
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

  // All non-bullables be be initialized before the function can fill then in from the JSON.
  // fromJSON(dynamic jsonInput) : field = value, field = value ... {}
  MyTestClass.fromJSON(dynamic jsonInput)
      : a = 0,
        b = 0.0,
        c = 0,
        d = '0',
        e = '0',
        f = Uuid.parse('171ee8fd-a7fb-421c-8f0e-4b1931655c00'),
        g = false,
        h = roles.Registered,
        i = DateTime.parse('1970-01-01'),
        j = Duration(hours: 0),
        k = Uri.parse('https://www.google.com/api/fetch?test=badvalue'),
        l = BigInt.parse('9999999999') {
    log.info("(fromJSON) starting loop of toFieldMap()",
        minLoggingLevel: _localLogLevel);
    for (FieldMapping item in toFieldMap()) {
      if (item.postgresFieldName != null) {
        log.info("(fromJSON) using toFieldMap() key ${item.postgresFieldName}",
            minLoggingLevel: _localLogLevel);
        log.info(
            "(fromJSON) using JSON value ${jsonInput[item.postgresFieldName].toString()}",
            minLoggingLevel: _localLogLevel);
        log.info("(fromJSON) setting value", minLoggingLevel: _localLogLevel);
        set(item.fieldName, jsonInput[item.postgresFieldName]);
      }
    }

    // Extra items to be set that are not part of the data being received via JSON can be set here using either method
    //set('field', false);
    //field=false
    
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

## Issues

- The .fromJSON and the .toJSON do not have the same variables name. The .fromJSON uses the postgres field names and the .toJSON uses the class field names, and the .toUrlEncode uses the postgres field names as the .fromJSON and the .toUrlEncode are the inverses of each other. But this makes me think that we maybe should have a flag on the .toJSON to say if we want the class field names or the postgres field names.

## Bugs

- List.toCSVFromList(includeFields: ['a'], excludeFields: ['a', 'b']) where you are using both include and exclude fields is broken. The includeFields is becomming null part way through the process.
