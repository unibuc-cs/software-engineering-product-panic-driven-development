import 'package:ansicolor/ansicolor.dart';

String colored(dynamic message, String color) {
  var pen = AnsiPen();
  if (color == 'red') {
    pen = pen..red();
  }
  else if (color == 'green') {
    pen = pen..xterm(10);
  }
  else if (color == 'blue') {
    pen = pen..xterm(45);
  }
  else if (color == 'grey') {
    pen = pen..xterm(237);
  }
  else {
    pen.reset();
  }
  return pen(message.toString());
}

String redColored(message)   => colored(message, 'red');
String greenColored(message) => colored(message, 'green');
String blueColored(message)  => colored(message, 'blue');
String greyColored(message)  => colored(message, 'grey');

void startupLog(address, port) =>
  print('${blueColored('[STARTED]')} Listening at http://$address:$port');
