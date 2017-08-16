import 'dart:io';

import 'package:bliss/bliss.dart';

void main() {
  Server server = new Server(InternetAddress.ANY_IP_V6, 9090)
    ..setStaticHandler('build/web', errorResponses: {404: '404.html'})
    ..start();
}
