import 'package:url_launcher/url_launcher.dart';

mixin LaunchUrl {
  void launchSocialUrl(String url) {
    final uri = Uri.parse(url);
    launchUrl(uri, mode: LaunchMode.externalApplication).then((launched) {
      if (!launched) {
        launchUrl(uri, mode: LaunchMode.platformDefault);
      }
    });
  }
}
