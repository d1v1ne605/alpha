import 'package:alpha/core/base/base_view.dart';
import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_storage_key.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/utils/lang/language.dart';
import 'package:alpha/core/widgets/app_header.dart';
import 'package:alpha/injection/injector.dart';
import 'package:alpha/presentation/view_models/locale_langue/locale_language_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({Key? key}) : super(key: key);

  String getLanguageName(String code) {
    switch (code) {
      case AppStorageKey.englishCode:
        return AppStorageKey.englishLanguage;
      case AppStorageKey.germanCode:
        return AppStorageKey.germanLanguage;
      case AppStorageKey.koreanCode:
        return AppStorageKey.koreanLanguage;
      case AppStorageKey.russianCode:
        return AppStorageKey.russianLanguage;
      case AppStorageKey.turkishCode:
        return AppStorageKey.turkishLanguage;
      case AppStorageKey.chineseCode:
        return AppStorageKey.chineseLanguage;
      default:
        return AppStorageKey.englishLanguage;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<LocaleNotifier>(
      autoDispose: false,
      padding: false,
      viewModelBuilder: () => getIt<LocaleNotifier>(),
      builder: (context, vm, _) {
        final options = Language.all;
        final selected = vm.locale;
        return Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: Scaffold(
            body: Column(
              children: [
                AppHeader(
                  textTitle: context.appLocaleLanguage.languageSelection,
                  onTap: () => context.pop(),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      final locale = options[index];
                      return ListTile(
                        title: Text(
                          getLanguageName(locale.languageCode),
                          style: const TextStyle(fontSize: 16),
                        ),
                        trailing: Icon(
                          locale == selected
                              ? Icons.radio_button_checked
                              : Icons.radio_button_off,
                          color: locale == selected
                              ? Colors.orange
                              : AppColors.textTertiary,
                        ),
                        onTap: () {
                          vm.setLocale(locale);
                          context.pop();
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
