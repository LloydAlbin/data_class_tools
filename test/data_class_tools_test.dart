import 'dart:convert';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:uuid_type/uuid_type.dart';

import 'package:data_class_tools/data_class_tools.dart';
import 'package:data_class_tools/data_list_tools.dart';
import 'package:data_class_tools/response_class.dart';
import 'package:data_class_tools/bool_response.dart';

import 'reflection.dart';
import 'data_class_tools_test.reflectable.dart';
// ignore:unused_import
import 'package:reflectable/reflectable.dart';

import 'package:data_class_tools/src/handlers/logging.dart';
import 'package:logging/logging.dart';

final _localLogLevel = Level.INFO;

enum roles { Guest, Registered, Subscribed }

// If updating this class, you then need to run
// flutter pub run build_runner build

class MyTestClassResponse extends Response {
  List<MyTestClass> myTestClassList = [];

  MyTestClassResponse();

  MyTestClassResponse.fromJSONtoClass(dynamic jsonInput) {
    super.fromJSONResponse(jsonInput);
    for (var index = 0; index < jsonInput['data'].length; index++) {
      log.info("(Response) (fromJson) index: $index",
          minLoggingLevel: _localLogLevel);
      MyTestClass newRow = MyTestClass.fromJSON(jsonInput['data'][index]);
      log.info("(Response) (fromJson) add Row",
          minLoggingLevel: _localLogLevel);
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
  Point? o;

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

  final Map<String, dynamic> _fieldEnums = {
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

  Future<BoolResponse> writeToAPI() async {
    return await DataClassTools(this).writeToAPI(
        'https://apitest.eventtools.org/write_test200pass',
        false,
        null,
        'passFail');
  }
}

void main() {
  initializeReflectable();

  MyTestClass myTestClass = MyTestClass(
    1,
    2.3,
    4,
    '5',
    '6',
    Uuid.parse('171ee8fd-a7fb-421c-8f0e-4b1931655c15'),
    true,
    roles.Guest,
    DateTime.parse('2003-05-05'),
    Duration(hours: 2, minutes: 3, seconds: 2),
    Uri.parse('https://www.google.com/api/fetch?test=value'),
    BigInt.parse('99999'),
    DateTime.parse('2003-05-05'),
    Uuid.parse('171ee8fd-a7fb-421c-8f0e-4b1931655c15'),
  );

  test('Basic Class Test', () {
    log.info("(Basic Class Test) Starting", minLoggingLevel: _localLogLevel);
    expect(myTestClass.a, 1);
    expect(myTestClass.b, 2.3);
    expect(myTestClass.c, 4);
    expect(myTestClass.d, '5');
    expect(myTestClass.e, '6');
    expect(myTestClass.f.toString(), '171ee8fd-a7fb-421c-8f0e-4b1931655c15');
    expect(myTestClass.g, true);
    expect(myTestClass.h, roles.Guest);
    expect(myTestClass.i.toString(), '2003-05-05 00:00:00.000');
    expect(myTestClass.j.toString(),
        Duration(hours: 2, minutes: 3, seconds: 2).toString());
    expect(myTestClass.k.toString(),
        'https://www.google.com/api/fetch?test=value');
    expect(myTestClass.l.toString(), '99999');
    expect(myTestClass.m.toString(), '2003-05-05 00:00:00.000');
    expect(myTestClass.n.toString(), '171ee8fd-a7fb-421c-8f0e-4b1931655c15');
    log.info("(Basic Class Test) Finishing", minLoggingLevel: _localLogLevel);
  });
  test('Setting Int', () {
    log.info("(Setting Int) Starting", minLoggingLevel: _localLogLevel);
    myTestClass.set('a', 2);
    expect(myTestClass.a, 2);
    log.info("(Setting Int) Finishing", minLoggingLevel: _localLogLevel);
  });
  test('Getting Int', () {
    log.info("(Getting Int) Starting", minLoggingLevel: _localLogLevel);
    expect(myTestClass.get('a'), 2);
    log.info("(Getting Int) Finishing", minLoggingLevel: _localLogLevel);
  });
  test('Setting DateTime', () {
    log.info("(Setting DateTime) Starting", minLoggingLevel: _localLogLevel);
    myTestClass.set('i', '2003-06-06 00:00:00.000');
    expect(myTestClass.i.toString(), '2003-06-06 00:00:00.000');
    log.info("(Setting DateTime) Finishing", minLoggingLevel: _localLogLevel);
  });
  test('Getting DateTime', () {
    log.info("(Getting DateTime) Starting", minLoggingLevel: _localLogLevel);
    expect(myTestClass.get('i').toString(), '2003-06-06 00:00:00.000');
    log.info("(Getting DateTime) Finishing", minLoggingLevel: _localLogLevel);
  });
  test('Setting DateTime (Date Only)', () {
    log.info("(Setting DateTime (Date Only)) Starting",
        minLoggingLevel: _localLogLevel);
    myTestClass.set('i', '2003-07-07');
    expect(myTestClass.i.toString(), '2003-07-07 00:00:00.000');
    log.info("(Setting DateTime (Date Only)) Finishing",
        minLoggingLevel: _localLogLevel);
  });
  test('Getting DateTime (Date Only)', () {
    log.info("(Getting DateTime (Date Only)) Starting",
        minLoggingLevel: _localLogLevel);
    expect(myTestClass.get('i').toString(), '2003-07-07 00:00:00.000');
    log.info("(Getting DateTime (Date Only)) Finishing",
        minLoggingLevel: _localLogLevel);
  });
  test('Setting DateTime?', () {
    log.info("(Setting DateTime?) Starting", minLoggingLevel: _localLogLevel);
    myTestClass.set('m', '2003-06-06 00:00:00.000');
    expect(myTestClass.m.toString(), '2003-06-06 00:00:00.000');
    log.info("(Setting DateTime?) Finishing", minLoggingLevel: _localLogLevel);
  });
  test('Getting DateTime?', () {
    log.info("(Getting DateTime?) Starting", minLoggingLevel: _localLogLevel);
    expect(myTestClass.get('m').toString(), '2003-06-06 00:00:00.000');
    log.info("(Getting DateTime?) Finishing", minLoggingLevel: _localLogLevel);
  });
  test('Setting DateTime? (null)', () {
    log.info("(Setting DateTime? (null)) Starting",
        minLoggingLevel: _localLogLevel);
    myTestClass.set('m', null);
    expect(myTestClass.m, null);
    log.info("(Setting DateTime? (null)) Finishing",
        minLoggingLevel: _localLogLevel);
  });
  test('Getting DateTime? (null)', () {
    log.info("(Getting DateTime? (null)) Starting",
        minLoggingLevel: _localLogLevel);
    expect(myTestClass.get('m'), null);
    log.info("(Getting DateTime? (null)) Finishing",
        minLoggingLevel: _localLogLevel);
  });
  test('Setting DateTime? (' 'null' ')', () {
    log.info("('Setting DateTime? (' 'null' ')) Starting",
        minLoggingLevel: _localLogLevel);
    myTestClass.set('m', '2003-06-06 00:00:00.000');
    expect(myTestClass.m.toString(), '2003-06-06 00:00:00.000');
    myTestClass.set('m', 'null');
    expect(myTestClass.m, null);
    log.info("('Setting DateTime? (' 'null' ')) Finishing",
        minLoggingLevel: _localLogLevel);
  });
  test('Getting DateTime? (' 'null' ') Starting', () {
    log.info("(Getting DateTime? (' 'null' ')) Starting",
        minLoggingLevel: _localLogLevel);
    expect(myTestClass.get('m'), null);
    log.info("(Getting DateTime? (' 'null' ')) Finishing",
        minLoggingLevel: _localLogLevel);
  });
  test('Setting DateTime? (bad to null)', () {
    log.info("(Setting DateTime? (bad to null)) Starting",
        minLoggingLevel: _localLogLevel);
    myTestClass.set('m', '2003-06-06 00:00:00.000');
    expect(myTestClass.m.toString(), '2003-06-06 00:00:00.000');
    myTestClass.set('m', 'bad');
    expect(myTestClass.m, null);
    log.info("(Setting DateTime? (bad to null)) Finishing",
        minLoggingLevel: _localLogLevel);
  });
  test('Getting DateTime? (bad to null)', () {
    log.info("(Getting DateTime? (bad to null)) Starting",
        minLoggingLevel: _localLogLevel);
    expect(myTestClass.get('m'), null);
    log.info("(Getting DateTime? (bad to null)) Finishing",
        minLoggingLevel: _localLogLevel);
  });
  test('Setting DateTime? (Date Only)', () {
    log.info("(Setting DateTime? (Date Only)) Starting",
        minLoggingLevel: _localLogLevel);
    myTestClass.set('m', '2003-07-07');
    expect(myTestClass.m.toString(), '2003-07-07 00:00:00.000');
    log.info("(Setting DateTime? (Date Only)) Finishing",
        minLoggingLevel: _localLogLevel);
  });
  test('Getting DateTime? (Date Only)', () {
    log.info("(Getting DateTime? (Date Only)) Starting",
        minLoggingLevel: _localLogLevel);
    expect(myTestClass.get('m').toString(), '2003-07-07 00:00:00.000');
    log.info("(Getting DateTime? (Date Only)) Finishing",
        minLoggingLevel: _localLogLevel);
  });
  test('Setting Uuid', () {
    log.info("(Setting Uuid) Starting", minLoggingLevel: _localLogLevel);
    myTestClass.set('f', '171ee8fd-a7fb-421c-8f0e-4b1931655c16');
    expect(myTestClass.f.toString(), '171ee8fd-a7fb-421c-8f0e-4b1931655c16');
    log.info("(Setting Uuid) Finishing", minLoggingLevel: _localLogLevel);
  });
  test('Getting Uuid', () {
    log.info("(Getting Uuid) Starting", minLoggingLevel: _localLogLevel);
    expect(myTestClass.get('f').toString(),
        '171ee8fd-a7fb-421c-8f0e-4b1931655c16');
    log.info("(Getting Uuid) Finishing", minLoggingLevel: _localLogLevel);
  });
  test('Setting Uuid?', () {
    log.info("(Setting Uuid?) Starting", minLoggingLevel: _localLogLevel);
    myTestClass.set('n', '171ee8fd-a7fb-421c-8f0e-4b1931655c16');
    expect(myTestClass.n.toString(), '171ee8fd-a7fb-421c-8f0e-4b1931655c16');
    log.info("(Setting Uuid?) Finishing", minLoggingLevel: _localLogLevel);
  });
  test('Getting Uuid?', () {
    log.info("(Getting Uuid?) Starting", minLoggingLevel: _localLogLevel);
    expect(myTestClass.get('n').toString(),
        '171ee8fd-a7fb-421c-8f0e-4b1931655c16');
    log.info("(Getting Uuid?) Finishing", minLoggingLevel: _localLogLevel);
  });
  test('Setting Uuid? (bad to null)', () {
    log.info("(Setting Uuid? (bad to null)) Starting",
        minLoggingLevel: _localLogLevel);
    myTestClass.set('n', 'bad');
    expect(myTestClass.n, null);
    log.info("(Setting Uuid? (bad to null)) Finishing",
        minLoggingLevel: _localLogLevel);
  });
  test('Getting Uuid? (bad to null)', () {
    log.info("(Getting Uuid? (bad to null)) Starting",
        minLoggingLevel: _localLogLevel);
    expect(myTestClass.get('n'), null);
    log.info("(Getting Uuid? (bad to null)) Finishing",
        minLoggingLevel: _localLogLevel);
  });
  test('class.toUrlEncode(extras: null)', () {
    log.info("(class.toUrlEncode(extras: null)) Starting",
        minLoggingLevel: _localLogLevel);
    expect(myTestClass.toUrlEncode(extras: null),
        'aa=2&bb=2.3&cc=4&dd=5&ee=6&ff=171ee8fd-a7fb-421c-8f0e-4b1931655c16&gg=true&hh=roles.Guest&ii=2003-07-07%2000%3A00%3A00.000&jj=2%3A03%3A02.000000&kk=https%3A%2F%2Fwww.google.com%2Fapi%2Ffetch%3Ftest%3Dvalue&ll=99999&mm=2003-07-07%2000%3A00%3A00.000&nn=null');
    log.info("(class.toUrlEncode(extras: null)) Finishing",
        minLoggingLevel: _localLogLevel);
  });
  test('class.toJSON(includeFields: [], excludeFields: [])', () {
    log.info("(class.toJSON(includeFields: [], excludeFields: [])) Starting",
        minLoggingLevel: _localLogLevel);
    expect(myTestClass.toJSON(includeFields: [], excludeFields: []),
        '{"a":2,"b":2.3,"c":4,"d":"5","e":"6","f":"171ee8fd-a7fb-421c-8f0e-4b1931655c16","g":true,"h":"roles.Guest","i":"2003-07-07 00:00:00.000","j":"2:03:02.000000","k":"https://www.google.com/api/fetch?test=value","l":"99999","m":"2003-07-07 00:00:00.000","n":null}');
    log.info("(class.toJSON(includeFields: [], excludeFields: [])) Finishing",
        minLoggingLevel: _localLogLevel);
  });
  test('class.toJSON(includeFields: [' 'a' ', ' 'b' '], excludeFields: [])',
      () {
    log.info(
        "(class.toJSON(includeFields: [''a'', ''b''], excludeFields: [])) Starting",
        minLoggingLevel: _localLogLevel);
    expect(myTestClass.toJSON(includeFields: ['a', 'b'], excludeFields: []),
        '{"a":2,"b":2.3}');
    log.info(
        "(class.toJSON(includeFields: [''a'', ''b''], excludeFields: [])) Finishing",
        minLoggingLevel: _localLogLevel);
  });
  test('class.toJSON(includeFields: [], excludeFields: [' 'a' ', ' 'b' '])',
      () {
    log.info(
        "(class.toJSON(includeFields: [], excludeFields: [''a'', ''b''])) Starting",
        minLoggingLevel: _localLogLevel);
    expect(myTestClass.toJSON(includeFields: [], excludeFields: ['a', 'b']),
        '{"c":4,"d":"5","e":"6","f":"171ee8fd-a7fb-421c-8f0e-4b1931655c16","g":true,"h":"roles.Guest","i":"2003-07-07 00:00:00.000","j":"2:03:02.000000","k":"https://www.google.com/api/fetch?test=value","l":"99999","m":"2003-07-07 00:00:00.000","n":null}');
    log.info(
        "(class.toJSON(includeFields: [], excludeFields: [''a'', ''b''])) Finishing",
        minLoggingLevel: _localLogLevel);
  });
  test('class.toCSV(includeFields: [], excludeFields: [])', () {
    log.info("(class.toCSV(includeFields: [], excludeFields: [])) Starting",
        minLoggingLevel: _localLogLevel);
    expect(myTestClass.toCSV(includeFields: [], excludeFields: []),
        '2,2.3,4,"5","6","171ee8fd-a7fb-421c-8f0e-4b1931655c16",true,"roles.Guest","2003-07-07 00:00:00.000","2:03:02.000000","https://www.google.com/api/fetch?test=value","99999","2003-07-07 00:00:00.000",null');
    log.info("(class.toCSV(includeFields: [], excludeFields: [])) Finishing",
        minLoggingLevel: _localLogLevel);
  });
  test("class.toCSV(includeFields: ['a', 'b'], excludeFields: [])", () {
    log.info(
        "(class.toCSV(includeFields: ['a', 'b'], excludeFields: [])) Starting",
        minLoggingLevel: _localLogLevel);
    expect(myTestClass.toCSV(includeFields: ['a', 'b'], excludeFields: []),
        '2,2.3');
    log.info(
        "(class.toCSV(includeFields: ['a', 'b'], excludeFields: [])) Finishing",
        minLoggingLevel: _localLogLevel);
  });
  test("class.toCSV(includeFields: [], excludeFields: ['a', 'b'])", () {
    log.info(
        "(class.toCSV(includeFields: [], excludeFields: ['a', 'b'])) Starting",
        minLoggingLevel: _localLogLevel);
    expect(myTestClass.toCSV(includeFields: [], excludeFields: ['a', 'b']),
        '4,"5","6","171ee8fd-a7fb-421c-8f0e-4b1931655c16",true,"roles.Guest","2003-07-07 00:00:00.000","2:03:02.000000","https://www.google.com/api/fetch?test=value","99999","2003-07-07 00:00:00.000",null');
    log.info(
        "(class.toCSV(includeFields: [], excludeFields: ['a', 'b'])) Finishing",
        minLoggingLevel: _localLogLevel);
  });
  test("class.toCSV(includeFields: ['a', 'b'], excludeFields: ['a'])", () {
    log.info(
        "(class.toCSV(includeFields: ['a', 'b'], excludeFields: ['a'])) Starting",
        minLoggingLevel: _localLogLevel);
    expect(myTestClass.toCSV(includeFields: ['a', 'b'], excludeFields: ['a']),
        '2.3');
    log.info(
        "(class.toCSV(includeFields: ['a', 'b'], excludeFields: ['a'])) Finishing",
        minLoggingLevel: _localLogLevel);
  });
  test("class.toCSV(includeFields: ['a'], excludeFields: ['a', 'b'])", () {
    log.info(
        "(class.toCSV(includeFields: ['a'], excludeFields: ['a', 'b'])) Starting",
        minLoggingLevel: _localLogLevel);
    expect(
        myTestClass.toCSV(includeFields: ['a'], excludeFields: ['a', 'b']), '');
    log.info(
        "(class.toCSV(includeFields: ['a'], excludeFields: ['a', 'b'])) Finishing",
        minLoggingLevel: _localLogLevel);
  });
  test('class.toHeaderCSV(includeFields: [], excludeFields: [])', () {
    log.info(
        "(class.toHeaderCSV(includeFields: [], excludeFields: [])) Starting",
        minLoggingLevel: _localLogLevel);
    expect(myTestClass.toHeaderCSV(includeFields: [], excludeFields: []),
        '"a","b","c","d","e","f","g","h","i","j","k","l","m","n"');
    log.info(
        "(class.toHeaderCSV(includeFields: [], excludeFields: [])) Finishing",
        minLoggingLevel: _localLogLevel);
  });
  test(
      'class.toHeaderCSV(includeFields: [' 'a' ', ' 'b' '], excludeFields: [])',
      () {
    log.info(
        "(class.toHeaderCSV(includeFields: ['a', 'b'], excludeFields: [])) Starting",
        minLoggingLevel: _localLogLevel);
    expect(
        myTestClass.toHeaderCSV(includeFields: ['a', 'b'], excludeFields: []),
        '"a","b"');
    log.info(
        "(class.toHeaderCSV(includeFields: ['a', 'b'], excludeFields: [])) Finishing",
        minLoggingLevel: _localLogLevel);
  });
  test(
      'class.toHeaderCSV(includeFields: [], excludeFields: [' 'a' ', ' 'b' '])',
      () {
    log.info(
        "(class.toHeaderCSV(includeFields: [], excludeFields: ['a', 'b'])) Starting",
        minLoggingLevel: _localLogLevel);
    expect(
        myTestClass.toHeaderCSV(includeFields: [], excludeFields: ['a', 'b']),
        '"c","d","e","f","g","h","i","j","k","l","m","n"');
    log.info(
        "(class.toHeaderCSV(includeFields: [], excludeFields: ['a', 'b'])) Finishing",
        minLoggingLevel: _localLogLevel);
  });
  test("class.toHeaderCSV(includeFields: ['a'], excludeFields: ['a', 'b'])",
      () {
    log.info(
        "(class.toHeaderCSV(includeFields: ['a'], excludeFields: ['a', 'b'])) Starting",
        minLoggingLevel: _localLogLevel);
    expect(
        myTestClass
            .toHeaderCSV(includeFields: ['a'], excludeFields: ['a', 'b']),
        '');
    log.info(
        "(class.toHeaderCSV(includeFields: ['a'], excludeFields: ['a', 'b'])) Finishing",
        minLoggingLevel: _localLogLevel);
  });
  test("class.toHeaderCSV(includeFields: ['a', 'b'], excludeFields: ['a'])",
      () {
    log.info(
        "(class.toHeaderCSV(includeFields: ['a', 'b'], excludeFields: ['a'])) Starting",
        minLoggingLevel: _localLogLevel);
    expect(
        myTestClass
            .toHeaderCSV(includeFields: ['a', 'b'], excludeFields: ['a']),
        '"b"');
    log.info(
        "(class.toHeaderCSV(includeFields: ['a', 'b'], excludeFields: ['a'])) Finishing",
        minLoggingLevel: _localLogLevel);
  });

  List<MyTestClass> myTestClassList = [];
  myTestClassList.add(myTestClass);
  test('List.toCSVFromList(includeFields: [], excludeFields: [])', () {
    log.info(
        "(List.toCSVFromList(includeFields: [], excludeFields: [])) Starting",
        minLoggingLevel: _localLogLevel);
    expect(myTestClassList.toCSVFromList(includeFields: [], excludeFields: []),
        '"a","b","c","d","e","f","g","h","i","j","k","l","m","n"\r\n2,2.3,4,"5","6","171ee8fd-a7fb-421c-8f0e-4b1931655c16",true,"roles.Guest","2003-07-07 00:00:00.000","2:03:02.000000","https://www.google.com/api/fetch?test=value","99999","2003-07-07 00:00:00.000",null\r\n');
    log.info(
        "(List.toCSVFromList(includeFields: [], excludeFields: [])) Finishing",
        minLoggingLevel: _localLogLevel);
  });
  test("List.toCSVFromList(includeFields: ['a', 'b'], excludeFields: [])", () {
    log.info(
        "(List.toCSVFromList(includeFields: ['a', 'b'], excludeFields: [])) Starting",
        minLoggingLevel: _localLogLevel);
    expect(
        myTestClassList
            .toCSVFromList(includeFields: ['a', 'b'], excludeFields: []),
        '"a","b"\r\n2,2.3\r\n');
    log.info(
        "(List.toCSVFromList(includeFields: ['a', 'b'], excludeFields: [])) Finishing",
        minLoggingLevel: _localLogLevel);
  });
  test("List.toCSVFromList(includeFields: [], excludeFields: ['a', 'b'])", () {
    log.info(
        "(List.toCSVFromList(includeFields: [], excludeFields: ['a', 'b'])) Starting",
        minLoggingLevel: _localLogLevel);
    expect(
        myTestClassList
            .toCSVFromList(includeFields: [], excludeFields: ['a', 'b']),
        '"c","d","e","f","g","h","i","j","k","l","m","n"\r\n4,"5","6","171ee8fd-a7fb-421c-8f0e-4b1931655c16",true,"roles.Guest","2003-07-07 00:00:00.000","2:03:02.000000","https://www.google.com/api/fetch?test=value","99999","2003-07-07 00:00:00.000",null\r\n');
    log.info(
        "(List.toCSVFromList(includeFields: [], excludeFields: ['a', 'b'])) Finishing",
        minLoggingLevel: _localLogLevel);
  });
// This test if failing for some unknown reason
  test("List.toCSVFromList(includeFields: ['a'], excludeFields: ['a', 'b'])",
      () {
    log.info(
        "(List.toCSVFromList(includeFields: ['a'], excludeFields: ['a', 'b'])) Starting",
        minLoggingLevel: _localLogLevel);
    expect(
        myTestClassList
            .toCSVFromList(includeFields: ['a'], excludeFields: ['a', 'b']),
        '');
    log.info(
        "(List.toCSVFromList(includeFields: ['a'], excludeFields: ['a', 'b'])) Finishing",
        minLoggingLevel: _localLogLevel);
  });
  test("List.toCSVFromList(includeFields: ['a', 'b'], excludeFields: ['a'])",
      () {
    log.info(
        "(List.toCSVFromList(includeFields: ['a', 'b'], excludeFields: ['a'])) Starting",
        minLoggingLevel: _localLogLevel);
    expect(
        myTestClassList
            .toCSVFromList(includeFields: ['a', 'b'], excludeFields: ['a']),
        '"b"\r\n2.3\r\n');
    log.info(
        "(List.toCSVFromList(includeFields: ['a', 'b'], excludeFields: ['a'])) Finishing",
        minLoggingLevel: _localLogLevel);
  });
  //myTestClassList.add(myTestClass);
  test("List.toJSONFromList(includeFields: [], excludeFields: [])", () {
    log.info(
        "(List.toJSONFromList(includeFields: [], excludeFields: [])) Starting",
        minLoggingLevel: _localLogLevel);
    expect(myTestClassList.toJSONFromList(includeFields: [], excludeFields: []),
        '[{"a":2,"b":2.3,"c":4,"d":"5","e":"6","f":"171ee8fd-a7fb-421c-8f0e-4b1931655c16","g":true,"h":"roles.Guest","i":"2003-07-07 00:00:00.000","j":"2:03:02.000000","k":"https://www.google.com/api/fetch?test=value","l":"99999","m":"2003-07-07 00:00:00.000","n":null}]');
    log.info(
        "(List.toJSONFromList(includeFields: [], excludeFields: [])) Finishing",
        minLoggingLevel: _localLogLevel);
  });
  test("List.toJSONFromList(includeFields: [], excludeFields: ['a','b'])", () {
    log.info(
        "(List.toJSONFromList(includeFields: [], excludeFields: ['a','b'])) Starting",
        minLoggingLevel: _localLogLevel);
    expect(
        myTestClassList
            .toJSONFromList(includeFields: [], excludeFields: ['a', 'b']),
        '[{"c":4,"d":"5","e":"6","f":"171ee8fd-a7fb-421c-8f0e-4b1931655c16","g":true,"h":"roles.Guest","i":"2003-07-07 00:00:00.000","j":"2:03:02.000000","k":"https://www.google.com/api/fetch?test=value","l":"99999","m":"2003-07-07 00:00:00.000","n":null}]');
    log.info(
        "(List.toJSONFromList(includeFields: [], excludeFields: ['a','b'])) Finishing",
        minLoggingLevel: _localLogLevel);
  });
  test("List.toJSONFromList(includeFields: ['a','b'], excludeFields: [])", () {
    log.info(
        "(List.toJSONFromList(includeFields: ['a','b'], excludeFields: [])) Starting",
        minLoggingLevel: _localLogLevel);
    expect(
        myTestClassList
            .toJSONFromList(includeFields: ['a', 'b'], excludeFields: []),
        '[{"a":2,"b":2.3}]');
    log.info(
        "(List.toJSONFromList(includeFields: ['a','b'], excludeFields: [])) Finishing",
        minLoggingLevel: _localLogLevel);
  });
  test("List.toJSONFromList(includeFields: ['a'], excludeFields: ['a','b'])",
      () {
    log.info(
        "(List.toJSONFromList(includeFields: ['a'], excludeFields: ['a','b'])) Starting",
        minLoggingLevel: _localLogLevel);
    expect(
        myTestClassList
            .toJSONFromList(includeFields: ['a'], excludeFields: ['a', 'b']),
        '[]');
    log.info(
        "(List.toJSONFromList(includeFields: ['a'], excludeFields: ['a','b'])) Finishing",
        minLoggingLevel: _localLogLevel);
  });
  test("List.toJSONFromList(includeFields: ['a','b'], excludeFields: ['a'])",
      () {
    log.info(
        "(List.toJSONFromList(includeFields: ['a','b'], excludeFields: ['a'])) Starting",
        minLoggingLevel: _localLogLevel);
    expect(
        myTestClassList
            .toJSONFromList(includeFields: ['a', 'b'], excludeFields: ['a']),
        '[{"b":2.3}]');
    log.info(
        "(List.toJSONFromList(includeFields: ['a','b'], excludeFields: ['a'])) Finishing",
        minLoggingLevel: _localLogLevel);
  });
  test("MyTestClass.fromJSON(dynamic jsonInput)", () {
    log.info("(MyTestClass.fromJSON(dynamic jsonInput)) Starting",
        minLoggingLevel: _localLogLevel);
    MyTestClass x = MyTestClass.fromJSON(json.decode(
        '{"aa":2,"bb":2.3,"cc":4,"dd":"5","ee":"6","ff":"171ee8fd-a7fb-421c-8f0e-4b1931655c16","gg":true,"hh":"roles.Guest","ii":"2003-07-07 00:00:00.000","jj":"2:03:02.000000","kk":"https://www.google.com/api/fetch?test=value","ll":"99999","mm":"2003-07-07 00:00:00.000","nn":null}'));
    expect(x.a, 2);
    expect(x.b, 2.3);
    expect(x.c, 4);
    expect(x.d, '5');
    expect(x.e, '6');
    expect(x.f.toString(), '171ee8fd-a7fb-421c-8f0e-4b1931655c16');
    expect(x.g, true);
    expect(x.h, roles.Guest);
    expect(x.i.toString(), '2003-07-07 00:00:00.000');
    expect(
        x.j.toString(), Duration(hours: 2, minutes: 3, seconds: 2).toString());
    expect(x.k.toString(), 'https://www.google.com/api/fetch?test=value');
    expect(x.l.toString(), '99999');
    expect(x.m.toString(), '2003-07-07 00:00:00.000');
    expect(x.n, null);
    log.info("(MyTestClass.fromJSON(dynamic jsonInput)) Finishing",
        minLoggingLevel: _localLogLevel);
  });
  test("MyTestClassResponse.fromJSONtoClass(dynamic jsonInput)", () {
    dynamic jsonInput = json.decode(
        '{"data":[{"aa":2,"bb":2.3,"cc":4,"dd":"5","ee":"6","ff":"171ee8fd-a7fb-421c-8f0e-4b1931655c16","gg":true,"hh":"roles.Guest","ii":"2003-07-07 00:00:00.000","jj":"2:03:02.000000","kk":"https://www.google.com/api/fetch?test=value","ll":"99999","mm":"2003-07-07 00:00:00.000","nn":null}],"error":{"status":200,"displaymessage":null,"internalmessage":null,"forcelogout":false,"forceupgrade":false},"version":2}');
    MyTestClassResponse x = MyTestClassResponse.fromJSONtoClass(jsonInput);
    expect(x.myTestClassList[0].b, 2.3);
    expect(x.myTestClassList[0].c, 4);
    expect(x.myTestClassList[0].d, '5');
    expect(x.myTestClassList[0].e, '6');
    expect(x.myTestClassList[0].f.toString(),
        '171ee8fd-a7fb-421c-8f0e-4b1931655c16');
    expect(x.myTestClassList[0].g, true);
    expect(x.myTestClassList[0].h, roles.Guest);
    expect(x.myTestClassList[0].i.toString(), '2003-07-07 00:00:00.000');
    expect(x.myTestClassList[0].j.toString(),
        Duration(hours: 2, minutes: 3, seconds: 2).toString());
    expect(x.myTestClassList[0].k.toString(),
        'https://www.google.com/api/fetch?test=value');
    expect(x.myTestClassList[0].l.toString(), '99999');
    expect(x.myTestClassList[0].m.toString(), '2003-07-07 00:00:00.000');
    expect(x.myTestClassList[0].n, null);
    expect(x.serverInfo?.errorInfo.status, 200);
    expect(x.serverInfo?.errorInfo.displayMessage, null);
    expect(x.serverInfo?.errorInfo.internalMessage, null);
    expect(x.serverInfo?.errorInfo.forceLogout, false);
    expect(x.serverInfo?.errorInfo.forceUpgrade, false);
    expect(x.serverInfo?.apiVersion, 2);
    expect(
        x.myTestClassList.toJSONFromList(includeFields: [], excludeFields: []),
        '[{"a":2,"b":2.3,"c":4,"d":"5","e":"6","f":"171ee8fd-a7fb-421c-8f0e-4b1931655c16","g":true,"h":"roles.Guest","i":"2003-07-07 00:00:00.000","j":"2:03:02.000000","k":"https://www.google.com/api/fetch?test=value","l":"99999","m":"2003-07-07 00:00:00.000","n":null}]');
    expect(
        x.myTestClassList.toCSVFromList(includeFields: [], excludeFields: []),
        '"a","b","c","d","e","f","g","h","i","j","k","l","m","n"\r\n2,2.3,4,"5","6","171ee8fd-a7fb-421c-8f0e-4b1931655c16",true,"roles.Guest","2003-07-07 00:00:00.000","2:03:02.000000","https://www.google.com/api/fetch?test=value","99999","2003-07-07 00:00:00.000",null\r\n');
    expect(x.myTestClassList[0].toUrlEncode(extras: null),
        'aa=2&bb=2.3&cc=4&dd=5&ee=6&ff=171ee8fd-a7fb-421c-8f0e-4b1931655c16&gg=true&hh=roles.Guest&ii=2003-07-07%2000%3A00%3A00.000&jj=2%3A03%3A02.000000&kk=https%3A%2F%2Fwww.google.com%2Fapi%2Ffetch%3Ftest%3Dvalue&ll=99999&mm=2003-07-07%2000%3A00%3A00.000&nn=null');
  });
  test(
      "MyTestClass.writeToAPI(final String urlAddress, final bool useGetMethod, final Map<String, dynamic>? extras, String variable) (No such URL)",
      () async {
    BoolResponse x = await DataClassTools(myTestClass).writeToAPI(
        'https://apitest.eventtools.org/write_test200pass',
        false,
        null,
        'passFail');
    expect(x.passFail, false);
    expect(x.serverInfo?.errorInfo.status, 501);
    expect(x.serverInfo?.errorInfo.displayMessage,
        'Failed host lookup: \'apitest.eventtools.org\'');
    expect(x.serverInfo?.errorInfo.internalMessage,
        'Failed host lookup: \'apitest.eventtools.org\'');
    expect(x.serverInfo?.errorInfo.forceLogout, false);
    expect(x.serverInfo?.errorInfo.forceUpgrade, false);
    expect(x.serverInfo?.apiVersion, 2);
  });
  test(
      "MyTestClass.writeToAPI(final String urlAddress, final bool useGetMethod, final Map<String, dynamic>? extras, String variable) (No such URL)",
      () async {
    BoolResponse x = await myTestClass.writeToAPI();
    expect(x.passFail, false);
    expect(x.serverInfo?.errorInfo.status, 501);
    expect(x.serverInfo?.errorInfo.displayMessage,
        'Failed host lookup: \'apitest.eventtools.org\'');
    expect(x.serverInfo?.errorInfo.internalMessage,
        'Failed host lookup: \'apitest.eventtools.org\'');
    expect(x.serverInfo?.errorInfo.forceLogout, false);
    expect(x.serverInfo?.errorInfo.forceUpgrade, false);
    expect(x.serverInfo?.apiVersion, 2);
  });
}
