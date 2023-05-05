/*
Level.All (Everything)
Level.OFF (No logging)
Level.SHOUT
Level.SEVERE
Level.WARNING
Level.INFO
Level.CONFIG
Level.FINE
Level.FINER
Level.FINEST

log.shout(logged_content);
log.severe(logged_content);
log.warning(logged_content);
log.info(logged_content);
log.config(logged_content);
log.fine(logged_content);
log.finer(logged_content);
log.finest(logged_content);

log.fine(() => [1, 2, 3, 4, 5].map((e) => e * 4).join("-"));
*/

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

//final log = Logger('Corilate');
final log = CustomLogger('PostgresConf', Level.WARNING);

//final appLogLevel = Level.ALL;
Level appLogLevel = Level.OFF;

const logLevel = Level;

/*
enableLogging() {
  //Logger.root.level = appLogLevel; // defaults to Level.INFO

  Logger.root.onRecord.listen((record) {
    if (kDebugMode) {
      print('${record.level.name}: ${record.time}: ${record.message}');
    }
  });
}

changeLoggingLevel(final newLevel) {
  Logger.root.level = newLevel; // defaults to Level.INFO
}

resetLoggingLevel() {
  Logger.root.level = appLogLevel; // defaults to Level.INFO
}
*/

class CustomLogger {
  String name;
  Level logLevel;
  late Logger log;

  CustomLogger(this.name, this.logLevel) {
    log = Logger(name);
    Logger.root.level = logLevel; // defaults to Level.INFO
    appLogLevel = logLevel;

    Logger.root.onRecord.listen((record) {
      if (kDebugMode) {
        print('${record.level.name}: ${record.time}: ${record.message}');
      }
    });
  }

  finest(Object? message,
      {Object? error, StackTrace? stackTrace, Level? minLoggingLevel}) {
    if (minLoggingLevel != null) {
      if (logLevel != minLoggingLevel) {
        Logger.root.level = minLoggingLevel;
      }
    }
    log.finest(message, error, stackTrace);
    if (minLoggingLevel != null) {
      if (logLevel != minLoggingLevel) {
        Logger.root.level = logLevel;
      }
    }
  }

  finer(Object? message,
      {Object? error, StackTrace? stackTrace, Level? minLoggingLevel}) {
    if (minLoggingLevel != null) {
      if (logLevel != minLoggingLevel) {
        Logger.root.level = minLoggingLevel;
      }
    }
    log.finer(message, error, stackTrace);
    if (minLoggingLevel != null) {
      if (logLevel != minLoggingLevel) {
        Logger.root.level = logLevel;
      }
    }
  }

  fine(Object? message,
      {Object? error, StackTrace? stackTrace, Level? minLoggingLevel}) {
    if (minLoggingLevel != null) {
      if (logLevel != minLoggingLevel) {
        Logger.root.level = minLoggingLevel;
      }
    }
    log.fine(message, error, stackTrace);
    if (minLoggingLevel != null) {
      if (logLevel != minLoggingLevel) {
        Logger.root.level = logLevel;
      }
    }
  }

  config(Object? message,
      {Object? error, StackTrace? stackTrace, Level? minLoggingLevel}) {
    if (minLoggingLevel != null) {
      if (logLevel != minLoggingLevel) {
        Logger.root.level = minLoggingLevel;
      }
    }
    log.config(message, error, stackTrace);
    if (minLoggingLevel != null) {
      if (logLevel != minLoggingLevel) {
        Logger.root.level = logLevel;
      }
    }
  }

  info(Object? message,
      {Object? error, StackTrace? stackTrace, Level? minLoggingLevel}) {
    if (minLoggingLevel != null) {
      if (logLevel != minLoggingLevel) {
        Logger.root.level = minLoggingLevel;
      }
    }
    log.info(message, error, stackTrace);
    if (minLoggingLevel != null) {
      if (logLevel != minLoggingLevel) {
        Logger.root.level = logLevel;
      }
    }
  }

  warning(Object? message,
      {Object? error, StackTrace? stackTrace, Level? minLoggingLevel}) {
    if (minLoggingLevel != null) {
      if (logLevel != minLoggingLevel) {
        Logger.root.level = minLoggingLevel;
      }
    }
    log.warning(message, error, stackTrace);
    if (minLoggingLevel != null) {
      if (logLevel != minLoggingLevel) {
        Logger.root.level = logLevel;
      }
    }
  }

  severe(Object? message,
      {Object? error, StackTrace? stackTrace, Level? minLoggingLevel}) {
    if (minLoggingLevel != null) {
      if (logLevel != minLoggingLevel) {
        Logger.root.level = minLoggingLevel;
      }
    }
    log.severe(message, error, stackTrace);
    if (minLoggingLevel != null) {
      if (logLevel != minLoggingLevel) {
        Logger.root.level = logLevel;
      }
    }
  }

  shout(Object? message,
      {Object? error, StackTrace? stackTrace, Level? minLoggingLevel}) {
    if (minLoggingLevel != null) {
      if (logLevel != minLoggingLevel) {
        Logger.root.level = minLoggingLevel;
      }
    }
    log.shout(message, error, stackTrace);
    if (minLoggingLevel != null) {
      if (logLevel != minLoggingLevel) {
        Logger.root.level = logLevel;
      }
    }
  }
}
