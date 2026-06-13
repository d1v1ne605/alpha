import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static final String baseUrl = dotenv.env['BASE_URL']!;
  static final String socketUrlPrivate = dotenv.env['SOCKET_URL_PRIVATE']!;
  static final String socketUrlPublic = dotenv.env['SOCKET_URL_PUBLIC']!;
  static final String shareUrl = dotenv.env['SHARE_URL']!;
  static final String webviewUrl = dotenv.env['WEBVIEW_URL']!;
}
