@JS()
library cross_frame;

import 'dart:html';
import 'package:js/js.dart';

// dart:html window.open returns a WindowBase instead of a window
// this is a workaround to get an actual window object that
// we can manipulate the DOM on.
@JS('window.open')
external Window open(String url, String target, [String options]);
