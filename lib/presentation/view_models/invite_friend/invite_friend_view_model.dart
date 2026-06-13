import 'package:alpha/core/base/base_view_model.dart';
import 'package:alpha/core/constants/app_local_key.dart';
import 'package:alpha/core/constants/app_string_uri.dart';
import 'package:alpha/core/constants/app_svg.dart';
import 'package:alpha/core/utils/enums.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/data/models/auth/login_response_model.dart';
import 'package:alpha/data/models/referall_model/referral_response_model.dart';
import 'package:alpha/data/models/referall_model/slide_item_overview_model.dart';
import 'package:alpha/data/models/referall_model/top_ranking_response_model.dart';
import 'package:alpha/data/services/local/hive_service.dart';
import 'package:alpha/domain/usecase/referall/get_ranking_usecase.dart';
import 'package:alpha/domain/usecase/referall/get_referalls_usecase.dart';
import 'package:alpha/injection/injector.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../data/models/referall_model/invite_tab_model.dart';

class InviteFriendsViewModel extends BaseViewModel {
  ReferralResponse? referralResponse;
  TopRankingResponseModel? rankingResponse;
  String userId = '';

  List<SlideItemOverview> get slideItemsOverview => [
    SlideItemOverview(
      title: context!.appLocaleLanguage.inviteFriends,
      description: context!.appLocaleLanguage.inviteFriendsDescription,
    ),
    SlideItemOverview(
      title: context!.appLocaleLanguage.theySignUpDeposit,
      description: context!.appLocaleLanguage.theySignUpDepositDescription,
    ),
    SlideItemOverview(
      title: context!.appLocaleLanguage.getRewardedTogether,
      description: context!.appLocaleLanguage.getRewardedTogetherDescription,
    ),
  ];
  final CarouselSliderController carouselController =
      CarouselSliderController();
  int _currentIndicatorCarousel = 0;
  int get currentIndicatorCarousel => _currentIndicatorCarousel;
  set currentIndicatorCarousel(int index) {
    _currentIndicatorCarousel = index;
    notifyListeners();
  }

  List<InviteTabModel> get tabs => [
    InviteTabModel(
      icon: AppSvg.overview,
      label: context!.appLocaleLanguage.overview,
    ),
    InviteTabModel(
      icon: AppSvg.ranking,
      label: context!.appLocaleLanguage.ranking,
    ),
    InviteTabModel(
      icon: AppSvg.rewards,
      label: context!.appLocaleLanguage.rewards,
    ),
    InviteTabModel(
      icon: AppSvg.referrals,
      label: context!.appLocaleLanguage.referrals,
    ),
    InviteTabModel(
      icon: AppSvg.commission,
      label: context!.appLocaleLanguage.commission,
    ),
  ];

  final GetReferallsUsecase getReferallsUsecase = getIt<GetReferallsUsecase>();
  final GetRankingUsecase getRankingUsecase = getIt<GetRankingUsecase>();
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  InviteTabModel get selectedTab => tabs[_selectedIndex];
  final hiveService = getIt<HiveService>();

  void init() async {
    setBusy(true);
    try {
      final data = await hiveService.get(
        key: AppLocalKey.hiveKeyMainUser,
        boxName: AppLocalKey.hiveBoxNameUser,
      );
      userId = loginResponseModelFromJson(data).uid;
      referralResponse = await getReferallsUsecase();
      rankingResponse = await getRankingUsecase();
    } catch (e) {
      print("${e}");
    } finally {
      setBusy(false);
    }
  }

  void changeTab(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  void onPageChanged(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  Future<void> shareToApp(String shareUrl, ShareButtonType app) async {
    Uri? appUri;
    Uri? webUri;

    switch (app) {
      case ShareButtonType.facebook:
        appUri = Uri.parse(AppStringUri.appFacebook + shareUrl);
        webUri = Uri.parse(AppStringUri.webFacebook + shareUrl);
        break;
      case ShareButtonType.x:
        appUri = Uri.parse(AppStringUri.appX + shareUrl);
        webUri = Uri.parse(AppStringUri.webX + shareUrl);
        break;
      case ShareButtonType.telegram:
        appUri = Uri.parse(AppStringUri.appTelegram + shareUrl);
        webUri = Uri.parse(AppStringUri.webTelegram + shareUrl);
        break;
      default:
        webUri = Uri.parse(shareUrl);
    }

    if (appUri != null && await canLaunchUrl(appUri)) {
      await launchUrl(appUri, mode: LaunchMode.externalApplication);
    } else {
      await launchUrl(webUri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
