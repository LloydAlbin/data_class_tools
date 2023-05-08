import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
//import 'package:http/retry.dart';
import 'package:data_class_tools/src/handlers/logging.dart';
import 'package:logging/logging.dart';

final _localLogLevel = Level.WARNING;

/*class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    log.info("MyHttpOverrides: (createHttpClient)",
        minLoggingLevel: _localLogLevel);
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}*/

Future<http.Response?> webApi(final bool useGetMethod, final String urlAddress,
    final String? body) async {
  //HttpOverrides.global = MyHttpOverrides();
  http.Response? result;
  if (useGetMethod == true) {
    if (body == null) {
      log.info("Get URL: (webApi) $urlAddress",
          minLoggingLevel: _localLogLevel);
      result = await http.get(Uri.parse(urlAddress));
    } else {
      log.info("Get URL: (webApi) $urlAddress?$body",
          minLoggingLevel: _localLogLevel);
      result = await http.get(Uri.parse("$urlAddress?$body"));
    }
  } else {
    if (body == null) {
      log.info("Post URL: (webApi) $urlAddress",
          minLoggingLevel: _localLogLevel);
      result = await http.post(
        Uri.parse(urlAddress),
        encoding: Encoding.getByName("utf-8"),
      );
    } else {
      log.info("Post URL: (webApi) $urlAddress",
          minLoggingLevel: _localLogLevel);
      log.info("Post Data: (webApi) $body", minLoggingLevel: _localLogLevel);
      // https://stackoverflow.com/questions/49797558/how-to-make-http-post-request-with-url-encoded-body-in-flutter
      List<int> bodyBytes = utf8.encode(body);
      result = await http.post(
        Uri.parse(urlAddress),
        headers: {"Content-Length": bodyBytes.length.toString()},
        body: bodyBytes,
        encoding: Encoding.getByName("utf-8"),
      );
      log.info(
          '(webApi) - Result Status Code: ${result.statusCode} - ${result.reasonPhrase}',
          minLoggingLevel: _localLogLevel);
      log.info('(webApi) - Result Data: ${result.body}',
          minLoggingLevel: _localLogLevel);
    }
  }

  return result;
}
