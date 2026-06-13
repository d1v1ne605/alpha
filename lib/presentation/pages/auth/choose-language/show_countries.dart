import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/presentation/view_models/auth/choose_language_view_model.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ShowCountries extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final heightBottomSheet =
        MediaQuery.of(context).size.height * AppSize.size0_75;
    return Consumer<ChooseLanguageViewModel>(
      builder: (context, vm, child) => GestureDetector(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            vertical: AppSpacing.space14.h,
            horizontal: AppSpacing.space16.w,
          ),
          decoration: BoxDecoration(
            color: AppColors.transparent,
            borderRadius: BorderRadius.circular(AppSize.size4.r),
            border: Border.all(color: AppColors.stock, width: AppSize.size1.w),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                vm.displayName ?? context.appLocaleLanguage.chooseLanguageHint,
                style: AppTextStyles.content3.copyWith(
                  color: vm.displayName == null
                      ? AppColors.subtitleText
                      : AppColors.textPrimary,
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.subtitleText,
                size: AppSize.size24.w,
              ),
            ],
          ),
        ),
        onTap: () => showCountryPicker(
          context: context,
          onSelect: (Country country) {
            _onSelectCountry(context, vm, country);
          },

          countryListTheme: CountryListThemeData(
            flagSize: AppSize.size24.w,
            backgroundColor: AppColors.background,
            textStyle: AppTextStyles.content4.copyWith(
              color: AppColors.textPrimary,
            ),
            bottomSheetHeight: heightBottomSheet.h,
            borderRadius: BorderRadius.zero,
            inputDecoration: InputDecoration(
              labelText: context.appLocaleLanguage.search,
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSize.size4.r),
                borderSide: BorderSide(
                  color: AppColors.borderInput,
                  width: AppSize.size1.w,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSize.size4.r),
                borderSide: BorderSide(
                  color: AppColors.primary,
                  width: AppSize.size1.w,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onSelectCountry(
    BuildContext context,
    ChooseLanguageViewModel vm,
    Country country,
  ) {
    vm.setLanguage(country);
  }
}
