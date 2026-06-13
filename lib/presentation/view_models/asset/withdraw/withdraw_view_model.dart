import 'dart:convert';

import 'package:alpha/core/base/base_view_model.dart';
import 'package:alpha/core/constants/app_storage_key.dart';
import 'package:alpha/core/mixins/loading/loading_state_mixin.dart';
import 'package:alpha/core/mixins/search/search_minxin.dart';
import 'package:alpha/core/network/app_exception.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/utils/validate.dart';
import 'package:alpha/data/models/asset/balance_response_model.dart';
import 'package:alpha/data/models/asset/beneficiaries_model.dart';
import 'package:alpha/data/models/asset/child_currencies_model.dart';
import 'package:alpha/data/models/asset/withdraw/active_beneficiary_request_model.dart';
import 'package:alpha/data/models/asset/withdraw/add_beneficiaries_request_model.dart';
import 'package:alpha/data/models/asset/withdraw/delete_beneficiary_request_model.dart';
import 'package:alpha/data/models/asset/withdraw/execute_withdraw_request_model.dart';
import 'package:alpha/data/models/asset/withdraw/remains_model.dart';
import 'package:alpha/data/models/asset/withdraw/withdraw_fee_response_model.dart';
import 'package:alpha/data/models/asset/withdraw/withdraw_history_model.dart';
import 'package:alpha/data/models/asset/withdraw/withdraw_limit_model.dart';
import 'package:alpha/data/models/home_market/currency_model.dart';
import 'package:alpha/domain/usecase/withdraw/active_beneficiary_withdraw_usecase.dart';
import 'package:alpha/domain/usecase/withdraw/add_beneficiary_withdraw_usecase.dart';
import 'package:alpha/domain/usecase/withdraw/delete_beneficiary_withdraw_usecase.dart';
import 'package:alpha/domain/usecase/withdraw/execute_withdraw_usecase.dart';
import 'package:alpha/domain/usecase/withdraw/history_withdraw_usecase.dart';
import 'package:alpha/domain/usecase/withdraw/select_coin_withdraw_usecase.dart';
import 'package:alpha/domain/usecase/withdraw/select_network_withdraw_usecase.dart';
import 'package:alpha/presentation/view_models/global_view_model.dart';
import 'package:flutter/widgets.dart';

import '../../../../core/mixins/two_fa_mixin/two_fa_mixin.dart';

class WithdrawViewModel extends BaseViewModel
    with TwoFAMixin, SearchMixin<CurrencyModel>, LoadingStateMixin {
  final GlobalViewModel _globalViewModel;
  final SelectCoinWithdrawUseCase _selectCoinWithdrawUseCase;
  final SelectNetworkWithdrawUseCase _selectNetworkWithdrawUseCase;
  final HistoryWithdrawUseCase _historyWithdrawUseCase;
  final AddBeneficiaryWithdrawUseCase _addBeneficiaryWithdrawUseCase;
  final ActiveBeneficiaryWithdrawUseCase _activeBeneficiaryWithdrawUseCase;
  final DeleteBeneficiaryWithdrawUseCase _deleteBeneficiaryWithdrawUseCase;
  final ExecuteWithdrawUseCase _executeWithdrawUseCase;
  final String? currency;

  WithdrawViewModel(
    this._globalViewModel,
    this._selectCoinWithdrawUseCase,
    this._selectNetworkWithdrawUseCase,
    this._historyWithdrawUseCase,
    this._addBeneficiaryWithdrawUseCase,
    this._activeBeneficiaryWithdrawUseCase,
    this._deleteBeneficiaryWithdrawUseCase,
    this._executeWithdrawUseCase,
    this.currency,
  ) {
    getAvailableCoins(currency: currency);
  }

  List<CurrencyModel> _availableCoins = [];

  List<CurrencyModel> get availableCoins => _availableCoins;

  set availableCoins(List<CurrencyModel> value) {
    _availableCoins = value;
    notifyListeners();
  }

  bool get is2FAEnabled => currentUser?.otp ?? false;

  BeneficiariesModel? _beneficiarySelected;

  BeneficiariesModel? get beneficiarySelected => _beneficiarySelected;

  set beneficiarySelected(BeneficiariesModel? value) {
    _beneficiarySelected = value;
    Future.microtask(() => notifyListeners());
  }

  WithdrawFeeResponseModel? _withdrawFee;

  WithdrawFeeResponseModel? get withdrawFee => _withdrawFee;

  RemainsModel? _remaining;

  RemainsModel? get remaining => _remaining;

  ChildCurrenciesModel? _childCurrencies;

  ChildCurrenciesModel? get childCurrencies => _childCurrencies;

  List<BeneficiariesModel>? _beneficiaries;

  List<BeneficiariesModel>? get beneficiaries => _beneficiaries;

  WithdrawLimitModel? _withdrawLimit;

  WithdrawLimitModel? get withdrawLimit => _withdrawLimit;

  WithdrawHistoryModel? _withdrawHistory;

  WithdrawHistoryModel? get withdrawHistory => _withdrawHistory;

  BalanceResponseModel? _balance;

  BalanceResponseModel? get balance => _balance;

  double _onInputValueChange = 0.0;

  double get onInputValueChange => _onInputValueChange;

  set onInputValueChange(double value) {
    _onInputValueChange = value;
    notifyListeners();
  }

  set balance(BalanceResponseModel? value) {
    _globalViewModel.balanceResponseModel = value;
    _balance = value;
  }

  CurrencyModel? _coinSelected;

  CurrencyModel? get coinSelected => _coinSelected;

  set coinSelected(CurrencyModel? value) {
    _coinSelected = value;
  }

  CurrencyModel? _networkSelected;

  CurrencyModel? get networkSelected => _networkSelected;

  set networkSelected(CurrencyModel? value) {
    _networkSelected = value;
  }

  List<BeneficiariesModel> _availableBeneficiaries = [];

  List<BeneficiariesModel> get availableBeneficiaries =>
      _availableBeneficiaries;

  Fee? _selectedFee;

  Fee? get selectedFee => _selectedFee;

  set selectedFee(Fee? value) {
    _selectedFee = value;
    Future.microtask(() => notifyListeners());
  }

  TextEditingController amountController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController nameAddressController = TextEditingController();
  final addNewWithdrawAddressFormKey = GlobalKey<FormState>();
  final executeWithdrawAddressFormKey = GlobalKey<FormState>();
  final TextEditingController pinController = TextEditingController();

  List<CurrencyModel> get filterCoins => filteredItems;

  bool? _isSelectedNetwork = false;

  bool? get isSelectedNetwork => _isSelectedNetwork;

  set isSelectedNetwork(bool? value) {
    _isSelectedNetwork = value;
  }

  static const String loadingSelectNetworkKey =
      AppStorageKey.loadingSelectNetworkKey;
  static const String loadingBeneficiariesKey =
      AppStorageKey.loadingBeneficiariesKey;
  static const String loadingExecutingWithdrawKey =
      AppStorageKey.loadingExecutingWithdrawKey;
  static const String isLoadingDeleteBeneficiaryKey =
      AppStorageKey.isLoadingDeleteBeneficiary;

  bool get isLoadingSelectNetwork => isLoading(loadingSelectNetworkKey);

  bool get isLoadingBeneficiaries => isLoading(loadingBeneficiariesKey);

  bool get isLoadingExecutingWithdraw => isLoading(loadingExecutingWithdrawKey);

  bool get isLoadingDeleteBeneficiary =>
      isLoading(isLoadingDeleteBeneficiaryKey);

  bool get shouldShowAddressSection {
    return (isSelectedNetwork != null &&
        isSelectedNetwork! &&
        networkSelected!.withdrawal_enabled &&
        is2FAEnabled &&
        coinSelected!.withdrawal_enabled);
  }

  @override
  List<CurrencyModel> get allItems => availableCoins;

  @override
  String getSearchField(CurrencyModel item) {
    return '${item.name.toLowerCase()} ${item.id.toLowerCase()}';
  }

  Future<List<CurrencyModel>> getAvailableCoins({String? currency}) async {
    try {
      setBusy(true);
      availableCoins = await _globalViewModel.filterCoinForDepositAndWithdraw();
      if (availableCoins.isNotEmpty) {
        _coinSelected = currency != null
            ? availableCoins.firstWhere(
                (coin) => coin.id.toLowerCase() == currency.toLowerCase(),
                orElse: () => availableCoins[0],
              )
            : availableCoins[0];
      }

      initializeSearch();

      await selectCoinWithdraw(_coinSelected!, isLoaded: false);
      return availableCoins;
    } catch (e) {
      setError('${AppStorageKey.failedToLoadAvailableCoins}: $e');
      return availableCoins;
    } finally {
      setBusy(false);
    }
  }

  Future<void> selectCoinWithdraw(
    CurrencyModel currency, {
    bool isLoaded = true,
  }) async {
    try {
      networkSelected = null;
      if (isLoaded) setBusy(true);
      final isCoinExist = _availableCoins.any((coin) => coin.id == currency.id);
      if (isCoinExist) {
        coinSelected = currency;
      }
      final SelectCoinWithdrawData result = await _selectCoinWithdrawUseCase
          .call(withdrawCurrency: currency.id);

      _remaining = result.remains;
      _childCurrencies = result.childCurrencies;
      _beneficiaries = result.beneficiaries;
      _withdrawLimit = result.withdrawLimit;
      balance = result.balances;

      _availableBeneficiaries.clear();
      amountController.clear();
      otpController.clear();
      _isSelectedNetwork = null;
      _selectedFee = null;
    } catch (e) {
      setError('${AppStorageKey.failedToLoadWithdrawData}: $e');
    } finally {
      if (isLoaded) setBusy(false);
    }
  }

  void selectNetworkWithdraw(CurrencyModel network) async {
    try {
      await withLoading(loadingSelectNetworkKey, () async {
        if (network.id.isNotEmpty) {
          _isSelectedNetwork = true;
          _networkSelected = childCurrencies?.childCurrenciesData.firstWhere(
            (currency) => currency.id == network.id,
            orElse: () => throw Exception(AppStorageKey.networkNotFound),
          );
          _isSelectedNetwork = is2FAEnabled;

          _availableBeneficiaries = (beneficiaries ?? [])
              .where((b) => b.currency == network.id)
              .toList();
        }

        final SelectNetworkWithdrawData result =
            await _selectNetworkWithdrawUseCase.call(network.id);
        _remaining = result.remains;
        _withdrawFee = result.withdrawFee;
        _selectedFee = null;
        _beneficiarySelected = null;
      }, () => {});
    } catch (e) {
      setError('${AppStorageKey.failedToSelectNetworkForWithdraw}: $e');
    }
  }

  void loadWithdrawHistory({
    int page = 1,
    int limit = AppStorageKey.withdrawHistoryLimit,
    String? withdrawCurrency,
  }) async {
    try {
      final WithdrawHistoryModel history = await _historyWithdrawUseCase.call(
        page: page,
        limit: limit,
        withdrawCurrency: withdrawCurrency,
      );
      _withdrawHistory = history;
    } catch (e) {
      setError('${AppStorageKey.failedToLoadWithdrawHistory}: $e');
    }
  }

  BeneficiariesModel? get selectBeneficiary {
    if (beneficiarySelected == null && availableBeneficiaries.isNotEmpty) {
      final activeAddress = availableBeneficiaries.firstWhere(
        (addr) => addr.state == AppStorageKey.keyActiveAddressWithdraw,
        orElse: () => availableBeneficiaries.first,
      );
      beneficiarySelected = activeAddress;
      return activeAddress;
    }
    return null;
  }

  Future<BeneficiariesModel?> addBeneficiary() async {
    try {
      return await withLoading(
        loadingBeneficiariesKey,
        () async {
          final data = jsonEncode({'address': addressController.text});
          final response = await _addBeneficiaryWithdrawUseCase.call(
            AddBeneficiariesRequestModel(
              currency: _networkSelected!.id,
              data: data,
              name: nameAddressController.text,
            ),
          );
          if (beneficiaries == null) {
            throw Exception(AppStorageKey.failedToAddBeneficiary);
          }

          beneficiaries?.insert(0, response);
          _availableBeneficiaries.insert(0, response);
          return response;
        },
        () {
          addressController.clear();
          nameAddressController.clear();
        },
      );
    } on ValidationException catch (e) {
      setError(e.message);
      return null;
    } catch (e) {
      setError('${AppStorageKey.failedToActiveBeneficiary}: $e');
      return null;
    }
  }

  Future<void> activateBeneficiary(int id, String pin) async {
    try {
      await withLoading(
        loadingBeneficiariesKey,
        () async {
          final response = await _activeBeneficiaryWithdrawUseCase.call(
            id,
            ActiveBeneficiaryRequestModel(pin: pin, id: id),
          );

          if (beneficiaries == null) {
            throw Exception(AppStorageKey.failedToActiveBeneficiary);
          }

          final index = _availableBeneficiaries.indexWhere(
            (b) => b.id == response.id,
          );
          if (index != -1) {
            _availableBeneficiaries[index] = response;
          }

          final beneIndex = beneficiaries!.indexWhere(
            (b) => b.id == response.id,
          );
          if (beneIndex != -1) {
            beneficiaries![beneIndex] = response;
          }
          beneficiarySelected = response;
        },
        () {
          if (errorMessage == null) {
            pinController.clear();
          }
        },
      );
    } on ValidationException catch (e) {
      setError(e.message);
    } catch (e) {
      setError('${AppStorageKey.failedToActiveBeneficiary}: $e');
    }
  }

  Future<bool> deleteBeneficiary(int id, String address) async {
    try {
      await withLoading(isLoadingDeleteBeneficiaryKey, () async {
        final response = await _deleteBeneficiaryWithdrawUseCase.call(
          id.toString(),
          DeleteBeneficiaryRequestModel(address: address),
          context,
        );
        if (!response) throw Exception(AppStorageKey.failedToDeleteBeneficiary);
        beneficiaries!.removeWhere((b) => b.id == id);
        _availableBeneficiaries.removeWhere((b) => b.id == id);
        if (beneficiarySelected?.id == id) {
          beneficiarySelected = null;
        }
      }, () => {});
      return true;
    } on ServerException catch (e) {
      setError(e.message);
      return false;
    } catch (e) {
      setError(AppStorageKey.failedToDeleteBeneficiary);
      return false;
    }
  }

  Future<void> executeWithdraw() async {
    try {
      await withLoading(
        loadingExecutingWithdrawKey,
        () async {
          final validateError = validateExecuteWithdraw();
          if (validateError != null) {
            setError(validateError);
            setLoading(loadingExecutingWithdrawKey, false);
            return;
          }

          final ExecuteWithdrawResult result = await _executeWithdrawUseCase
              .call(
                request: ExecuteWithdrawRequestModel(
                  uid: beneficiarySelected!.uid,
                  feeCurrency: _selectedFee!.feeCurrency,
                  fee: _selectedFee!.feeAmount.toString(),
                  amount: double.parse(amountController.text),
                  currency: _networkSelected!.id,
                  otp: otpController.text,
                  beneficiaryId: beneficiarySelected!.id.toString(),
                ),
                context: context,
              );
          _remaining = result.remains;

          //update balance
          final rawBalance =
              result.executeWithdrawResponse.data!.newWithdrawBalance;
          final match = RegExp(r'([\d.]+)').firstMatch(rawBalance);
          final extractedBalance = match?.group(1);
          _balance = _balance?.copyWith(balance: extractedBalance ?? '0');
        },
        () {
          if (errorMessage == null) {
            amountController.clear();
            otpController.clear();
            WidgetsBinding.instance.addPostFrameCallback((_) {
              executeWithdrawAddressFormKey.currentState?.reset();
            });
          }
        },
      );
    } on ServerException catch (e) {
      setError(e.message);
    } catch (e) {
      setError(AppStorageKey.failedToExecuteWithdraw);
    }
  }

  double calculateMinWithdrawAmount() {
    if (selectedFee == null || coinSelected == null) {
      return 0;
    }

    return selectedFee!.feeCurrency == coinSelected!.id
        ? (selectedFee!.feeAmount +
              (coinSelected?.min_withdraw_amount != null
                  ? double.parse(coinSelected!.min_withdraw_amount)
                  : 0))
        : (coinSelected?.min_withdraw_amount != null
              ? double.parse(coinSelected!.min_withdraw_amount)
              : 0);
  }

  double calculateReceivedAmount() {
    if (selectedFee == null || coinSelected == null) {
      return 0;
    }
    return selectedFee!.feeCurrency == coinSelected!.id
        ? ((double.tryParse(amountController.text) ?? 0) -
                  selectedFee!.feeAmount)
              .truncateToDecimalPlaces(coinSelected!.precision)
        : (double.tryParse(amountController.text) ?? 0).truncateToDecimalPlaces(
            coinSelected!.precision,
          );
  }

  double convertUsdToUsdt() {
    if (coinSelected == null) {
      return 0;
    }
    return ((double.tryParse(amountController.text) ?? 0) *
            (double.tryParse(coinSelected!.price) ?? 0))
        .truncateToDecimalPlaces(6);
  }

  String? validateAmount() {
    if (amountController.text.isEmpty) {
      return context?.appLocaleLanguage.amountRequired;
    }
    if (double.tryParse(amountController.text) == null) {
      return context?.appLocaleLanguage.invalidAmount;
    }
    if (double.parse(amountController.text) <= 0) {
      return context?.appLocaleLanguage.amountMustBePositive;
    }
    if (double.tryParse(amountController.text)! <
        calculateMinWithdrawAmount()) {
      return context?.appLocaleLanguage.amountLessThanMin;
    }
    if ((double.tryParse(amountController.text)! *
            double.parse(coinSelected!.price)) >
        remaining!.remains) {
      return context?.appLocaleLanguage.amountGreaterThanDailyLimit;
    }
    if (double.tryParse(amountController.text)! >
        double.parse(balance?.balance ?? '0')) {
      return context?.appLocaleLanguage.balanceNotEnough;
    }
    return null;
  }

  String? validateOtp() {
    if (otpController.text.isEmpty) {
      return context?.appLocaleLanguage.otpRequired;
    }
    if (otpController.text.length != 6) {
      return context?.appLocaleLanguage.otpMustBe6Digits;
    }
    return null;
  }

  String? validateExecuteWithdraw() {
    String? address = beneficiarySelected?.addressData.address;
    final addressError = WithdrawValidate.isValidBlockchainAddress(
      address,
      coinSelected?.id,
      context!,
    );
    if (addressError != null) return addressError;

    if (beneficiarySelected?.state != AppStorageKey.keyActiveAddressWithdraw) {
      return context?.appLocaleLanguage.addressNotActive;
    }

    if (selectedFee == null ||
        selectedFee!.feeAmount.isNaN ||
        selectedFee!.feeAmount < 0) {
      return context?.appLocaleLanguage.withdrawFeeNotValid;
    }

    if (calculateReceivedAmount() < 0) {
      return context?.appLocaleLanguage.receivedAmountGreaterThanZero;
    }
    if (convertUsdToUsdt() < 0) {
      return context?.appLocaleLanguage.usdtGreaterThanZero;
    }
    return null;
  }

  void handleAddressSelected(String? beneficiaryId) {
    try {
      _beneficiarySelected = beneficiaries?.firstWhere(
        (b) => b.id.toString() == beneficiaryId,
        orElse: () => throw Exception(AppStorageKey.beneficiaryNotFound),
      );
    } catch (e) {
      setError('${AppStorageKey.failedToSelectAddress}: $e');
    }
  }

  @override
  void dispose() {
    pinController.dispose();
    amountController.dispose();
    otpController.dispose();
    nameAddressController.dispose();
    addressController.dispose();
    super.dispose();
  }
}
