import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_png.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/env/env.dart';
import 'package:alpha/core/utils/enums.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/widgets/app_bottom_sheet.dart';
import 'package:alpha/core/widgets/app_display_box.dart';
import 'package:alpha/presentation/pages/invite_friends/overview/overview_slider.dart';
import 'package:alpha/presentation/pages/invite_friends/overview/section_title.dart';
import 'package:alpha/presentation/pages/invite_friends/overview/share_button_bar.dart';
import 'package:alpha/presentation/pages/invite_friends/overview/sheet_content.dart';
import 'package:alpha/presentation/pages/invite_friends/share_widget/show_data_box.dart';
import 'package:alpha/presentation/view_models/invite_friend/invite_friend_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class TabOverview extends StatelessWidget {
  const TabOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Consumer<InviteFriendsViewModel>(
        builder: (context, vm, child) {
          final String referralLink = Env.shareUrl + vm.userId;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              OverviewSlider(),
              SectionTitle(
                title: context.appLocaleLanguage.yourReferral,
                child: CodeDisplayBox(
                  code: vm.userId,
                  onCopy: () =>
                      Clipboard.setData(ClipboardData(text: vm.userId)),
                ),
              ),
              SizedBox(height: AppSpacing.space15.h),
              SectionTitle(
                title: context.appLocaleLanguage.yourReferralLink,
                child: Column(
                  children: [
                    CodeDisplayBox(
                      code: vm.userId.isNotEmpty ? referralLink : '',
                      onCopy: () =>
                          Clipboard.setData(ClipboardData(text: referralLink)),
                    ),
                    SizedBox(height: AppSpacing.space15.h),
                    ShareButtonBar(
                      onButtonTap: (type) {
                        switch (type) {
                          case ShareButtonType.facebook:
                            AppBottomSheetWidget.show(
                              context: context,
                              backgroundColor: AppColors.navBottom,
                              child: ShareSheet(
                                title:
                                    context.appLocaleLanguage.shareOnFacebook,
                                description: context
                                    .appLocaleLanguage
                                    .shareFacebookDescription,
                                imageAsset: AppPng.inviteBanner,
                                onShare: () {
                                  vm.shareToApp(referralLink, type);
                                },
                              ),
                            );
                            break;
                          case ShareButtonType.telegram:
                            AppBottomSheetWidget.show(
                              context: context,
                              backgroundColor: AppColors.navBottom,
                              child: ShareSheet(
                                title:
                                    context.appLocaleLanguage.shareOnTelegram,
                                description: context
                                    .appLocaleLanguage
                                    .shareTelegramDescription,
                                imageAsset: AppPng.inviteBanner,
                                onShare: () {
                                  vm.shareToApp(referralLink, type);
                                },
                              ),
                            );
                            break;
                          case ShareButtonType.x:
                            AppBottomSheetWidget.show(
                              context: context,
                              backgroundColor: AppColors.navBottom,
                              child: ShareSheet(
                                title: context.appLocaleLanguage.shareOnX,
                                description:
                                    context.appLocaleLanguage.shareXDescription,
                                imageAsset: AppPng.inviteBanner,
                                onShare: () {
                                  vm.shareToApp(referralLink, type);
                                },
                              ),
                            );
                            break;
                          case ShareButtonType.qrCode:
                            AppBottomSheetWidget.show(
                              context: context,
                              backgroundColor: AppColors.navBottom,
                              child: ShareSheet(
                                title: context.appLocaleLanguage.shareOnQRCode,
                                description: context
                                    .appLocaleLanguage
                                    .shareQRCodeDescription,
                                urlLink: referralLink,
                                showButton: false,
                                imageAsset: '',
                                onShare: () {
                                  vm.shareToApp(referralLink, type);
                                },
                              ),
                            );
                            break;
                        }
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.space15.h),
              ..._dataBoxes(context, vm),
            ],
          );
        },
      ),
    );
  }

  List<Widget> _dataBoxes(BuildContext context, InviteFriendsViewModel vm) => [
    _dataBox(
      context.appLocaleLanguage.inviteUser,
      vm.referralResponse?.referral_history.length.toString(),
    ),
    SizedBox(height: AppSpacing.space12.h),
    _dataBox(
      context.appLocaleLanguage.estimatedRevenue,
      vm.referralResponse?.estimated_earnings.toString(),
    ),
    SizedBox(height: AppSpacing.space12.h),
    _dataBox(
      context.appLocaleLanguage.activePayouts,
      vm.referralResponse?.commissions.length.toString(),
    ),
  ];

  Widget _dataBox(String? title, String? value) => ShowDataBox(
    content: Padding(
      padding: EdgeInsets.symmetric(
        vertical: AppSpacing.space10.h,
        horizontal: AppSpacing.space16.w,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            (title == null || title.isEmpty) ? "" : title,
            style: AppTextStyles.body.copyWith(
              color: AppColors.textTertiary,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: AppSpacing.space6.h),
          Text(
            (value == null || value.toString().isEmpty) ? "" : value.toString(),
            style: AppTextStyles.content5.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ),
  );
}
