import 'package:alpha/core/base/base_view.dart';
import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/presentation/pages/invite_friends/commission/tab_commission.dart';
import 'package:alpha/presentation/pages/invite_friends/overview/tab_overview.dart';
import 'package:alpha/presentation/pages/invite_friends/ranking/tab_ranking.dart';
import 'package:alpha/presentation/pages/invite_friends/referrals/tab_referrals.dart';
import 'package:alpha/presentation/pages/invite_friends/rewards/tab_rewards.dart';
import 'package:alpha/presentation/pages/profile/appbar_screen.dart';
import 'package:alpha/presentation/view_models/invite_friend/invite_friend_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../injection/injector.dart';
import 'custom_filter_bar.dart';

class InviteFriendsScreen extends StatelessWidget {
  const InviteFriendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<InviteFriendsViewModel>(
      autoDispose: false,
      viewModelBuilder: () => getIt<InviteFriendsViewModel>(),
      onModelReady: (vm) => vm.init(),
      builder:
          (BuildContext context, InviteFriendsViewModel vm, Widget? child) {
            return Scaffold(
              body: Padding(
                padding: EdgeInsets.only(
                  left: AppSpacing.space20.w,
                  right: AppSpacing.space20.w,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppBarScreen(
                      title: context.appLocaleLanguage.inviteFriends,
                      showNotification: false,
                      showScan: false,
                    ),
                    SizedBox(height: AppSpacing.space24.h),
                    Center(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: context.appLocaleLanguage.inviteFriendsAnd,
                          style: AppTextStyles.title1.copyWith(
                            color: AppColors.textPrimary,
                          ),
                          children: [
                            TextSpan(
                              text: context.appLocaleLanguage.inviteFriendsEarn,
                              style: AppTextStyles.title1.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: AppSpacing.space24.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(vm.tabs.length, (index) {
                        final tab = vm.tabs[index];
                        return InviteTabWidget(
                          tab: tab,
                          isSelected: index == vm.selectedIndex,
                          onTap: () => vm.changeTab(index),
                        );
                      }),
                    ),
                    SizedBox(height: AppSpacing.space16.h),
                    Expanded(flex: 1, child: _buildTabContent(vm)),
                  ],
                ),
              ),
            );
          },
    );
  }

  Widget _buildTabContent(InviteFriendsViewModel vm) {
    if (vm.isBusy) {
      return Center(child: CircularProgressIndicator(color: AppColors.primary));
    }
    switch (vm.selectedIndex) {
      case 0:
        return TabOverview();
      case 1:
        return TabRanking(rankingItems: vm.rankingResponse?.data ?? []);
      case 2:
        return TabRewards(
          dataList: vm.referralResponse?.reward_histories ?? [],
        );
      case 3:
        return TabReferrals(
          dataList: vm.referralResponse?.referral_history ?? [],
        );

      default:
        return TabCommission(dataList: vm.referralResponse?.commissions ?? []);
    }
  }
}
