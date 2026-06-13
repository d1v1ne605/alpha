import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/utils/validate.dart';
import '../../../view_models/announcements/announcements_viewmodel.dart';

class AnnouncementBodyWidget extends StatelessWidget {
  final String body;
  final String photoUrl;

  const AnnouncementBodyWidget({
    super.key,
    required this.body,
    required this.photoUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AnnouncementsViewModel>(
      builder: (context, vm, _) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (photoUrl.isNotEmpty)
                Image.network(
                  photoUrl,
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width,
                ),

              Html(
                data: HtmlCleaner.removeHrTags(body),
                shrinkWrap: true,

                onLinkTap:
                    (
                      String? url,
                      Map<String, String> attributes,
                      dom.Element? element,
                    ) async {
                      if (url == null) return;
                      final uri = Uri.tryParse(url);
                      if (uri != null) {
                        try {
                          debugPrint("Link tapped: $url");
                          await launchUrl(
                            uri,
                            mode: LaunchMode.externalApplication,
                          );
                        } catch (e) {
                          debugPrint('Cannot open link: $e');
                        }
                      }
                    },
              ),
            ],
          ),
        );
      },
    );
  }
}
