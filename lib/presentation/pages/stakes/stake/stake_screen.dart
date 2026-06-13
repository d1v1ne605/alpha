import 'package:alpha/core/base/base_view.dart';
import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_image.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/constants/app_svg.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/widgets/app_header.dart';
import 'package:alpha/core/widgets/app_text_field.dart';
import 'package:alpha/core/widgets/custom_no_data.dart';
import 'package:alpha/data/models/stake/stake_product_model.dart';
import 'package:alpha/injection/injector.dart';
import 'package:alpha/presentation/pages/stakes/stake/stake_bottom_sheet.dart';
import 'package:alpha/presentation/pages/stakes/stake/widget/staking_product_card.dart';
import 'package:alpha/presentation/view_models/stake/stake_view_model.dart';
import 'package:alpha/routers/router_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class StakeScreen extends StatefulWidget {
  const StakeScreen({Key? key}) : super(key: key);

  @override
  State<StakeScreen> createState() => _StakeScreenState();
}

class _StakeScreenState extends State<StakeScreen> {
  @override
  Widget build(BuildContext context) {
    return BaseView<StakeViewModel>(
      padding: false,
      autoDispose: false,
      viewModelBuilder: () => getIt<StakeViewModel>(),
      onModelReady: (vm) {},
      builder: (context, vm, child) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.space20.w,
                      vertical: AppSpacing.space20.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppHeader(textTitle: context.appLocaleLanguage.stake),
                        SizedBox(height: AppSize.size20),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    context.appLocaleLanguage.staking,
                                    style: AppTextStyles.content4.copyWith(
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  SizedBox(height: AppSize.size15),
                                  Text(
                                    context
                                        .appLocaleLanguage
                                        .stakingDescription,
                                    style: AppTextStyles.content3.copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: AppSize.size30),
                            Expanded(
                              child: Image.asset(
                                AppImage.banner_stake,
                                width: AppSize.size178,
                                height: AppSize.size128,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: AppSize.size22),
                      ],
                    ),
                  ),
                ),
              ];
            },
            body: Padding(
              padding: EdgeInsets.only(
                left: AppSpacing.space20.w,
                right: AppSpacing.space20.w,
                bottom: AppSpacing.space30.h,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        context.appLocaleLanguage.exploreProducts,
                        style: AppTextStyles.content4.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          context.push(RouterPath.stakeRecord);
                        },
                        child: SvgPicture.asset(
                          AppSvg.historyIcon,
                          width: AppSize.size20,
                          height: AppSize.size20,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSize.size20),
                  AppTextField(
                    hintText: context.appLocaleLanguage.search,
                    prefixIcon: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSize.size14.w,
                      ),
                      child: Icon(Icons.search, color: AppColors.iconPrimary),
                    ),
                    fillColor: AppColors.backgroundSearch,
                    borderColor: AppColors.transparent,
                    controller: vm.searchController,
                    onChanged: vm.onSearchChanged,
                  ),
                  SizedBox(height: AppSize.size16),
                  Expanded(
                    child: (vm.isBusy || vm.isCurrenciesEmpty)
                        ? const Center(child: CircularProgressIndicator())
                        : ValueListenableBuilder<List<StakeProductResponse>>(
                            valueListenable: vm.filteredItemsNotifier,
                            builder: (context, filteredList, _) {
                              if (filteredList.isEmpty) {
                                return const Center(child: CustomNoData());
                              }
                              return ListView.separated(
                                padding: EdgeInsets.zero,
                                itemCount: filteredList.length,
                                itemBuilder: (context, index) {
                                  final product = filteredList[index];
                                  final logoUrl = vm.getLogoUrl(product);
                                  final aprRange = vm.getAprRange(product);
                                  final sortedOptions = vm.getSortedOptions(
                                    product,
                                  );

                                  return StakingProductCard(
                                    product: product,
                                    logoUrl: logoUrl,
                                    aprRange: aprRange,
                                    sortedOptions: sortedOptions,
                                    isExpanded: product.isExpanded ?? false,
                                    onToggle: () =>
                                        vm.toggleProductExpansion(index),
                                    onOptionSelected: (option) {
                                      vm.selectOption(option);
                                      StakeBottomSheet.show(context, vm: vm);
                                    },
                                    getProgressValue: vm.getProgressValue,
                                    getProgressText: vm.getProgressText,
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return SizedBox(height: AppSize.size12);
                                },
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
