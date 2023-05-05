import 'package:reflectable/reflectable.dart';

// Annotate with this class to enable reflection.
class reflector extends Reflectable {
  const reflector()
      : super(invokingCapability); // Request the capability to invoke methods.
}

const myReflectable = reflector();
