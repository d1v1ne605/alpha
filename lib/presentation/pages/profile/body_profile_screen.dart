import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/presentation/pages/profile/section_title.dart';
import 'package:alpha/routers/router_name.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_svg.dart';
import 'menu_item.dart';

class BodyProfileScreen extends StatelessWidget {
  const BodyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(title: context.appLocaleLanguage.trade),
        SizedBox(height: AppSpacing.space20.h),
        GridView.count(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          childAspectRatio: 1.7,
          children: [
            MenuItem(
              label: context.appLocaleLanguage.market,
              icon: AppSvg.market,
            ),
            MenuItem(
              label: context.appLocaleLanguage.spotTrading,
              icon: AppSvg.spotTrade,
            ),
          ],
        ),
        SectionTitle(title: context.appLocaleLanguage.earn),
        SizedBox(height: AppSpacing.space20.h),
        GridView.count(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          childAspectRatio: 1.7,
          children: [
            MenuItem(
              label: context.appLocaleLanguage.staking,
              icon: AppSvg.stake,
              onTap: () {
                context.pushNamed(RouterName.stake);
              },
            ),
            MenuItem(
              label: context.appLocaleLanguage.competition,
              icon: AppSvg.competition,
            ),
          ],
        ),
        SectionTitle(title: context.appLocaleLanguage.recommend),
        SizedBox(height: AppSpacing.space20.h),
        GridView.count(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          childAspectRatio: 1.7,
          children: [
            MenuItem(
              label: context.appLocaleLanguage.asset_fee,
              icon: AppSvg.asset_fee,
              onTap: () {
                context.pushNamed(RouterName.assetFee);
              },
            ),
            MenuItem(
              label: context.appLocaleLanguage.referral,
              icon: AppSvg.friend,
              onTap: () {
                context.pushNamed(RouterName.inviteFriend);
              },
            ),
            MenuItem(
              label: context.appLocaleLanguage.submit_listing,
              icon: AppSvg.submit_listing,
              onTap: () {
                context.pushNamed(RouterName.announcements);
              },
            ),
            MenuItem(
              label: context.appLocaleLanguage.language,
              icon: AppSvg.language,
              onTap: () {
                context.pushNamed(RouterName.language);
              },
            ),
          ],
        ),
      ],
    );
  }
}
