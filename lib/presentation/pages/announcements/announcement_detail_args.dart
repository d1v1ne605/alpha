import '../../../data/models/banner_models/banner_model.dart';

class AnnouncementDetailArgs {
  final BannerModel item;
  final String tabTitle;
  final String subTabTitle;

  AnnouncementDetailArgs({
    required this.item,
    required this.tabTitle,
    required this.subTabTitle,
  });
}
