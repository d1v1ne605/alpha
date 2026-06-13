import 'dart:convert';

import 'package:alpha/core/base/base_view_model.dart';
import 'package:alpha/core/constants/app_storage_key.dart';
import 'package:alpha/core/mixins/local_storage/local_storage_mixin.dart';
import 'package:alpha/core/network/app_exception.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/data/models/auth/register_body_request_model.dart';
import 'package:alpha/domain/usecase/auth/register_usecase.dart';
import 'package:alpha/injection/injector.dart';
import 'package:alpha/presentation/view_models/locale_langue/locale_language_view_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ChooseLanguageViewModel extends BaseViewModel with LocalStorageMixin {
  late final String email;
  late final String password;
  String? displayName;
  final RegisterUseCase registerUseCase;
  String? referralCode;
  Map<String, String>? selectedLanguage;
  bool isChecked = false;

  ChooseLanguageViewModel(this.registerUseCase);

  void init(RegisterBodyRequest bodyFromRegister) {
    email = bodyFromRegister.email;
    password = bodyFromRegister.password;
    referralCode = bodyFromRegister.refid;
  }

  void setLanguage(dynamic country) {
    String language;
    String countryCode = country.countryCode ?? '';
    String countryName = country.name ?? '';
    switch (countryCode) {
      case AppStorageKey.kCountryUS:
        language = AppStorageKey.englishCode;
        break;
      case AppStorageKey.kCountryCN:
        language = AppStorageKey.chineseCode;
        break;
      case AppStorageKey.kCountryKR:
        language = AppStorageKey.koreanCode;
        break;
      case AppStorageKey.kCountryBD:
        language = AppStorageKey.kLangBD;
        break;
      case AppStorageKey.kCountryVN:
        language = AppStorageKey.kLangVN;
        break;
      case AppStorageKey.kCountryTR:
        language = AppStorageKey.turkishCode;
        break;
      case AppStorageKey.kCountryMY:
        language = AppStorageKey.kLangMY;
        break;
      case AppStorageKey.kCountryRU:
        language = AppStorageKey.russianCode;
        break;
      case AppStorageKey.kCountryDE:
        language = AppStorageKey.germanCode;
        break;
      default:
        language = AppStorageKey.englishCode;
        break;
    }
    final Map<String, String> languageMap = {
      AppStorageKey.chooseLanguage: language,
      AppStorageKey.chooseCountry: countryName,
    };
    selectedLanguage = languageMap;
    displayName = countryName;
    notifyListeners();
  }

  void setChecked(bool? value) {
    isChecked = value ?? false;
    notifyListeners();
  }

  void _setLanguageFromResponse(dynamic responseData) {
    if (responseData == null) return;
    try {
      if (responseData is Map<String, dynamic>) {
        final dataField = responseData[AppStorageKey.kDataField];
        if (dataField is String) {
          final Map<String, dynamic> dataJson = jsonDecode(dataField);
          final String? language = dataJson[AppStorageKey.kLanguageField];
          if (language != null) {
            final localeNotifier = getIt<LocaleNotifier>();
            localeNotifier.setLocale(Locale(language));
          }
        } else {
          print("${AppStorageKey.kLogDataFieldNotString}: $dataField");
        }
      } else {
        print(
          "${AppStorageKey.kLogUnexpectedResponseType} ${responseData.runtimeType}",
        );
      }
    } catch (e) {
      print("${AppStorageKey.kLogErrorParsingLanguage}: $e");
    }
  }

  Future<String?> handleNextPressed(BuildContext context) async {
    setBusy(true);
    if (isChecked == false) {
      setBusy(false);
      return context.appLocaleLanguage.chooseLanguageValidate;
    }
    if (selectedLanguage == null || selectedLanguage!.isEmpty) {
      setBusy(false);
      return context.appLocaleLanguage.chooseLanguageValidate2;
    }
    try {
      final response = await registerUseCase(
        RegisterBodyRequest(
          email: email,
          password: password,
          refid: (referralCode?.isNotEmpty ?? false) ? referralCode : null,
          data: jsonEncode(selectedLanguage),
        ),
      );
      _setLanguageFromResponse(response);
      return null;
    } on DioException catch (e) {
      if (e.error is ValidationException) {
        final ve = e.error as ValidationException;
        return ve.errors.isNotEmpty ? ve.errors.join('\n') : ve.message;
      } else {
        return context.appLocaleLanguage.registerErrorMessage;
      }
    } catch (e) {
      return context.appLocaleLanguage.registerErrorMessage;
    } finally {
      setBusy(false);
      notifyListeners();
    }
    return null;
  }
}
