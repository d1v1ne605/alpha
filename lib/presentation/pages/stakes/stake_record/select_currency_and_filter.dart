import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/constants/app_svg.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/widgets/app_bottom_sheet.dart';
import 'package:alpha/data/models/home_market/currency_model.dart';
import 'package:alpha/presentation/pages/profile/change_pasword/handle_bar.dart';
import 'package:alpha/presentation/view_models/stake/stake_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class SelectCurrencyAndFilter extends StatefulWidget {
  const SelectCurrencyAndFilter({super.key});

  @override
  State<SelectCurrencyAndFilter> createState() =>
      _SelectCurrencyAndFilterState();
}

class _SelectCurrencyAndFilterState extends State<SelectCurrencyAndFilter> {
  StakeViewModel? _stakeViewModel;
  late List<Tab> tabs;

  StakeViewModel get vm {
    return _stakeViewModel ??= Provider.of<StakeViewModel>(
      context,
      listen: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSize.size20.w),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => _showCurrencyBottomSheet(),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSize.size10.w,
                  vertical: AppSize.size10.h,
                ),
                decoration: BoxDecoration(
                  color: AppColors.buttonBackground,
                  borderRadius: BorderRadius.circular(AppSize.size4.r),
                  border: Border.all(
                    color: AppColors.buttonBackground,
                    width: 1,
                  ),
                ),
                child: Selector<StakeViewModel, String?>(
                  selector: (_, vm) => vm.selectedCurrencyIdForFilterRecord,
                  builder: (context, selectedCurrency, child) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedCurrency ??
                            context.appLocaleLanguage.selectCurrency,
                        style: TextStyle(
                          color: selectedCurrency != null
                              ? Colors.white
                              : AppColors.grey,
                          fontSize: AppSize.size14.sp,
                        ),
                      ),
                      SvgPicture.asset(
                        AppSvg.dropDown,
                        width: AppSize.size10.w,
                        height: AppSize.size6.h,
                        color: AppColors.neutralGray,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: AppSize.size12.w),
          GestureDetector(
            onTap: () => _showFilterBottomSheet(),
            child: SvgPicture.asset(
              AppSvg.filterOutlined,
              width: AppSize.size24.w,
              height: AppSize.size24.h,
              color: AppColors.neutralGray,
            ),
          ),
        ],
      ),
    );
  }

  void _showCurrencyBottomSheet() {
    AppBottomSheetWidget.show(
      context: context,
      child: ChangeNotifierProvider.value(
        value: vm,
        child: Column(
          children: [
            SizedBox(height: AppSpacing.space10.h),
            HandleBar(),
            SizedBox(height: AppSpacing.space18.h),
            Text(
              context.appLocaleLanguage.selectCurrency,
              style: AppTextStyles.title2.copyWith(fontWeight: FontWeight.w700),
            ),
            Selector<StakeViewModel, List<CurrencyModel>>(
              selector: (_, vm) => vm.recordFilterableCurrencies,
              builder: (context, currencies, child) {
                int? selectedCurrencyIndex = context
                    .select<StakeViewModel, int?>(
                      (vm) => vm.recordSelectedCurrencyIndex,
                    );
                return Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: currencies.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return ListTile(
                          title: Text(
                            context.appLocaleLanguage.allCurrencies,
                            style: AppTextStyles.title2.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          trailing: Icon(
                            selectedCurrencyIndex == -1
                                ? Icons.radio_button_checked
                                : Icons.radio_button_off,
                            color: selectedCurrencyIndex == -1
                                ? AppColors.primary
                                : AppColors.textTertiary,
                          ),
                          onTap: () {
                            vm.recordSelectedCurrencyIndex = -1;
                            Navigator.pop(context);
                          },
                        );
                      }

                      final currency = currencies[index - 1];
                      final bool isSelected = selectedCurrencyIndex == index;

                      return ListTile(
                        leading: Image.network(
                          currency.icon_url,
                          width: AppSize.size32.w,
                          height: AppSize.size32.h,
                        ),
                        title: Row(
                          children: [
                            Text(currency.id.toUpperCase()),
                            SizedBox(width: AppSize.size10.w),
                            Text(
                              currency.name,
                              style: AppTextStyles.content3.copyWith(
                                fontWeight: FontWeight.w400,
                                color: AppColors.textTertiary,
                              ),
                            ),
                          ],
                        ),
                        trailing: Icon(
                          isSelected
                              ? Icons.radio_button_checked
                              : Icons.radio_button_off,
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textTertiary,
                        ),
                        onTap: () {
                          vm.recordSelectedCurrencyIndex = index;
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                );
              },
            ),
            SizedBox(height: AppSpacing.space12.h),
          ],
        ),
      ),
      maxChildSize: AppSize.size0_6,
      minChildSize: AppSize.size0_6,
    );
  }

  void _showFilterBottomSheet() {
    AppBottomSheetWidget.show(
      context: context,
      child: ChangeNotifierProvider.value(
        value: vm,
        child: Column(
          children: [
            SizedBox(height: AppSpacing.space10.h),
            HandleBar(),
            SizedBox(height: AppSpacing.space18.h),
            Text(
              context.appLocaleLanguage.filter,
              style: AppTextStyles.title2.copyWith(fontWeight: FontWeight.w700),
            ),
            SizedBox(height: AppSpacing.space18.h),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: vm.recordFilterTypes.length,
                itemBuilder: (context, index) {
                  final filter = vm.recordFilterTypes[index];

                  return Builder(
                    builder: (context) {
                      final bool isSelected =
                          context.select<StakeViewModel, int>(
                            (vm) => vm.recordSelectedFilterIndex,
                          ) ==
                          index;

                      return ListTile(
                        title: Text(
                          filter,
                          style: AppTextStyles.title2.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        trailing: SvgPicture.asset(
                          isSelected ? AppSvg.checkComlete : AppSvg.checkRadio,
                          width: AppSize.size16.w,
                          height: AppSize.size16.h,
                        ),
                        onTap: () async {
                          vm.recordSelectedFilterIndex = index;
                          Navigator.pop(context);
                        },
                      );
                    },
                  );
                },
              ),
            ),
            SizedBox(height: AppSpacing.space12.h),
          ],
        ),
      ),
      maxChildSize: AppSize.size0_5,
      minChildSize: AppSize.size0_5,
    );
  }
}
