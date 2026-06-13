import 'package:alpha/core/base/base_view_model.dart';
import 'package:alpha/core/constants/app_storage_key.dart';
import 'package:alpha/data/models/earn/earn_wallets.dart';
import 'package:alpha/data/models/earn/transaction_earn/rewards/reward_model_earn.dart';
import 'package:alpha/data/models/earn/transaction_earn/withdraw_record/withdraw_record_earn.dart';
import 'package:alpha/data/models/earn/withdraw_request_model.dart';
import 'package:alpha/data/models/home_market/coin_model/coin_model.dart';
import 'package:alpha/domain/usecase/earn/execute_withdraw_earn_use_case.dart';
import 'package:alpha/domain/usecase/earn/get_earn_reward_usecase.dart';
import 'package:alpha/domain/usecase/earn/get_earn_wallet_usecase.dart';
import 'package:alpha/domain/usecase/earn/get_withdraw_record_usecase.dart';
import 'package:alpha/injection/injector.dart';
import 'package:alpha/presentation/view_models/global_view_model.dart';
import 'package:alpha/presentation/view_models/locale_langue/locale_language_view_model.dart';
import 'package:flutter/material.dart';

class EarnViewModel extends BaseViewModel {
  final GlobalViewModel globalViewModel;
  final GetEarnWalletUsecase getEarnWalletUsecase;
  final ExecuteWithdrawEarnUseCase executeWithdrawEarnUseCase;
  final GetEarnRewardUsecase _getEarnRewardUsecase;
  final GetWithdrawRecordUsecase _getWithdrawRecordUseCase;

  EarnViewModel(
    this.globalViewModel,
    this.getEarnWalletUsecase,
    this.executeWithdrawEarnUseCase,
    this._getEarnRewardUsecase,
    this._getWithdrawRecordUseCase,
  ) {
    loadRewards();
    loadWithdrawRecords();
  }

  late WithdrawRecordEarn _withdrawRecordsResponse;
  late RewardModelEarn _rewards;

  List<CoinModel> get coins => globalViewModel.coins;
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;
  bool isShowingAssets = false;

  void toggleAssetVisibility() {
    isShowingAssets = !isShowingAssets;
    notifyListeners();
  }

  final searchController = TextEditingController();
  List<EarnWalletData> _allWallets = [];
  EarnWalletsResponse? _walletsResponse;

  EarnWalletsResponse? get walletsResponse => _walletsResponse;

  List<EarnWalletData> get allWallets => _allWallets;
  List<EarnWalletData> _earnWallets = [];

  List<EarnWalletData> get earnWallets => _earnWallets;
  EarnWalletData? _selectedWallet;

  EarnWalletData? get selectedWallet => _selectedWallet;
  final ValueNotifier<List<EarnWalletData>> filteredWallets = ValueNotifier([]);
  bool isWithdrawLoading = false;
  TextEditingController amountController = TextEditingController();

  void selectCurrency(int index) {
    _selectedIndex = index;
    _applyActiveFilters();
  }

  LocaleNotifier localeNotifier = getIt<LocaleNotifier>();

  String get currentLanguageCode => localeNotifier.locale.languageCode;

  RewardModelEarn get rewardsData => _rewards;

  WithdrawRecordEarn get withdrawRecordsData => _withdrawRecordsResponse;

  List<RewardData> get rewards => rewardsData.data;

  List<WithdrawRecordData> get withdrawRecords => _allWithdrawData;

  List<RewardCurrency> get rewardCurrencies =>
      rewardsData.meta.rewardCurrencies;
  List<RewardData> _filteredRewardsData = [];

  List<RewardData> get filteredRewards => _filteredRewardsData;

  void _applyActiveFilters() {
    if (_selectedIndex == 0) {
      _filteredRewardsData = List.from(_allRewardsData);
    } else {
      final currency = rewardCurrencies[_selectedIndex - 1].currencyId;
      _filteredRewardsData = _allRewardsData
          .where((r) => r.currencyId == currency)
          .toList();
    }
    notifyListeners();
  }

  double getEstimatedUsdt() {
    return _walletsResponse?.estimatedTotalAssets.usdt ?? 0.0;
  }

  CoinModel? findCurrencyByWallet(String walletCurrencyId) {
    try {
      return coins.firstWhere(
        (coin) =>
            coin.base_unit.toLowerCase() == walletCurrencyId.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  Future<void> loadEarnWallets() async {
    try {
      final response = await getEarnWalletUsecase();
      _walletsResponse = response;
      final allWallets = response.wallets.map((e) => e.wallet).toList();
      _allWallets = allWallets;
      _earnWallets = List.from(_allWallets);
      filteredWallets.value = List.from(_allWallets);
    } catch (e) {
      rethrow;
    }
  }

  void selectCoinWithdraw(EarnWalletData wallet) {
    _selectedWallet = wallet;
    notifyListeners();
  }

  void onSearchChanged(String query) {
    if (query.isEmpty) {
      filteredWallets.value = List.from(_allWallets);
    } else {
      final lowerQuery = query.toLowerCase();
      filteredWallets.value = _allWallets
          .where(
            (wallet) =>
                wallet.currencyName.toLowerCase().contains(lowerQuery) ||
                wallet.currencyId.toLowerCase().contains(lowerQuery),
          )
          .toList();
    }
    notifyListeners();
  }

  List<EarnWalletData> getWalletsByAssetId(String assetId) {
    return _earnWallets
        .where((w) => w.currencyId.toLowerCase() == assetId.toLowerCase())
        .toList();
  }

  EarnWalletData? getFirstWalletByAssetId(String assetId) {
    try {
      return getWalletsByAssetId(assetId).first;
    } catch (_) {
      return null;
    }
  }

  Future<void> executeWithdraw() async {
    if (_selectedWallet == null || amountController.text.isEmpty) return;
    final amount = double.tryParse(amountController.text);
    if (amount == null || amount <= 0) return;
    isWithdrawLoading = true;
    notifyListeners();
    final request = WithdrawRequestModel(
      currency: _selectedWallet!.currencyId,
      amount: amount,
    );
    try {
      await executeWithdrawEarnUseCase.call(request);
      amountController.clear();
      await loadEarnWallets();
      _selectedWallet = getFirstWalletByAssetId(request.currency);
    } catch (e) {
      rethrow;
    } finally {
      isWithdrawLoading = false;
      notifyListeners();
    }
  }

  int _currentPageRewards = 1;
  int _totalPagesRewards = 1;
  bool _isLoadingMoreRewards = false;
  final Set<int> _triggeredPagesRewards = {};
  List<RewardData> _allRewardsData = [];

  bool get isLoadingMoreRewards => _isLoadingMoreRewards;

  Set<int> get triggeredPagesRewards => _triggeredPagesRewards;

  int get currentPageRewards => _currentPageRewards;

  int get totalPagesRewards => _totalPagesRewards;

  Future<void> loadRewards({
    bool isLoadMore = false,
    bool isRefresh = false,
  }) async {
    final bool isInitialLoad = !isLoadMore && !isRefresh;

    if (isInitialLoad) setBusy(true);
    if (isLoadMore) {
      _isLoadingMoreRewards = true;
      Future.microtask(notifyListeners);
    }
    if (isRefresh) {
      _currentPageRewards = 1;
      _triggeredPagesRewards.clear();
      _allRewardsData.clear();
    }

    try {
      final response = await _getEarnRewardUsecase(
        _currentPageRewards,
        10,
        currentLanguageCode,
        AppStorageKey.holding,
      );

      _rewards = response;
      _totalPagesRewards = response.meta.totalPages;

      // Gộp dữ liệu, giữ nguyên thứ tự load
      if (isLoadMore) {
        _allRewardsData.addAll(response.data);
      } else {
        _allRewardsData = List.from(response.data);
      }

      _applyActiveFilters();
    } catch (e) {
      setError('Error loading rewards: $e');
    } finally {
      if (isLoadMore) _isLoadingMoreRewards = false;
      if (isInitialLoad) setBusy(false);
      notifyListeners();
    }
  }

  Future<void> loadMoreRewards() async {
    if (_isLoadingMoreRewards || _currentPageRewards >= _totalPagesRewards) {
      return;
    }
    _currentPageRewards++;
    await loadRewards(isLoadMore: true);
  }

  int _currentPageWithdraw = 1;
  int _totalPagesWithdraw = 1;
  bool _isLoadingMoreWithdraw = false;
  final Set<int> _triggeredPagesWithdraw = {};
  List<WithdrawRecordData> _allWithdrawData = [];

  bool get isLoadingMoreWithdraw => _isLoadingMoreWithdraw;

  Set<int> get triggeredPagesWithdraw => _triggeredPagesWithdraw;

  Future<void> loadWithdrawRecords({
    bool isLoadMore = false,
    bool isRefresh = false,
  }) async {
    final bool isInitialLoad = !isLoadMore && !isRefresh;

    if (isInitialLoad) setBusy(true);
    if (isLoadMore) {
      _isLoadingMoreWithdraw = true;
      Future.microtask(notifyListeners);
    }
    if (isRefresh) {
      _currentPageWithdraw = 1;
      _triggeredPagesWithdraw.clear();
      _allWithdrawData.clear();
    }

    try {
      final response = await _getWithdrawRecordUseCase(
        _currentPageWithdraw,
        10,
        currentLanguageCode,
      );

      _withdrawRecordsResponse = response;
      _totalPagesWithdraw = response.meta.totalPages;

      if (isLoadMore) {
        _allWithdrawData.addAll(response.data);
      } else {
        _allWithdrawData = List.from(response.data);
      }
    } catch (e) {
      setError('Error loading withdraw records: $e');
    } finally {
      if (isLoadMore) _isLoadingMoreWithdraw = false;
      if (isInitialLoad) setBusy(false);
      notifyListeners();
    }
  }

  Future<void> loadMoreWithdrawRecords() async {
    if (_isLoadingMoreWithdraw || _currentPageWithdraw >= _totalPagesWithdraw) {
      return;
    }
    _currentPageWithdraw++;
    await loadWithdrawRecords(isLoadMore: true);
  }

  void selectWalletById(String assetId) {
    try {
      final walletToSelect = _allWallets.firstWhere(
        (wallet) => wallet.currencyId.toLowerCase() == assetId.toLowerCase(),
      );
      _selectedWallet = walletToSelect;
      notifyListeners();
    } catch (e) {
      _selectedWallet = null;
      notifyListeners();
    }
  }

  Future<void> refreshRewards() async {
    await loadRewards(isRefresh: true);
  }

  Future<void> refreshWithdrawRecords() async {
    await loadWithdrawRecords(isRefresh: true);
  }
}
