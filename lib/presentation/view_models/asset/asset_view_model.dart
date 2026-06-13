import 'package:alpha/core/base/base_view_model.dart';
import 'package:alpha/core/constants/app_local_key.dart';
import 'package:alpha/core/mixins/listener_mixin/add_listener_mixin.dart';
import 'package:alpha/core/mixins/listener_mixin/remove_listener_mixin.dart';
import 'package:alpha/core/mixins/local_storage/local_storage_mixin.dart';
import 'package:alpha/core/mixins/search/search_minxin.dart';
import 'package:alpha/data/models/asset/asset_model.dart';
import 'package:alpha/data/models/asset/asset_overview.dart';
import 'package:alpha/presentation/view_models/global_view_model.dart';

class AssetViewModel extends BaseViewModel
    with
        LocalStorageMixin,
        AddListenerMixin,
        RemoveListenerMixin,
        SearchMixin<AssetModel> {
  final GlobalViewModel _globalViewModel;

  get globalViewModel => _globalViewModel;

  AssetViewModel(this._globalViewModel) {
    initLocalStorage(_globalViewModel.hiveService);
    initializeSearch();
  }

  GlobalViewModel get globalVM => _globalViewModel;

  List<AssetModel> get allAssets => _globalViewModel.allAssets;

  List<AssetModel> _filteredAssets = [];

  List<AssetModel> get filteredAssets =>
      getCachedData<List<AssetModel>>(AppLocalKey.filteredAssetsKey) ??
      _filteredAssets;

  AssetOverview? get assetOverview => _globalViewModel.assetOverview;

  bool isShowingAssets = false;

  @override
  List<AssetModel> get allItems =>
      _filteredAssets.isNotEmpty ? _filteredAssets : allAssets;

  void onGlobalViewModelChanged() {
    if (_globalViewModel.isNotifyPollingBalancesAndCurrencies) {
      _updateFilteredAssetsAfterPolling();
      return;
    }
    if (_globalViewModel.allAssets.isNotEmpty) {
      init();
    }
  }

  void _updateFilteredItemsNotifier() {
    if (searchQuery.isEmpty) {
      filteredItemsNotifier.value = List.from(_filteredAssets);
    } else {
      updateSearchQuery(searchQuery);
    }
  }

  void _updateFilteredAssetsAfterPolling() {
    if (filteredAssets.isEmpty) {
      _globalViewModel.isNotifyPollingBalancesAndCurrencies = false;
      return;
    }
    if (!_globalViewModel.isUpdatedAssets) {
      _globalViewModel.isNotifyPollingBalancesAndCurrencies = false;
      return;
    }
    final updatedAssets = filteredAssets.map((asset) {
      final balance = _globalViewModel.balances[asset.id];
      return asset.copyWith(
        spot: double.tryParse(balance?.balance ?? '0') ?? 0.0,
        frozen: double.tryParse(balance?.locked ?? '0') ?? 0.0,
      );
    }).toList();
    _filteredAssets = updatedAssets;
    setCachedData(AppLocalKey.filteredAssetsKey, _filteredAssets);
    _updateFilteredItemsNotifier();
    _globalViewModel.isNotifyPollingBalancesAndCurrencies = false;
    notifyListeners();
  }

  void init() async {
    if (allAssets.isEmpty) {
      _filteredAssets = [];
      clearCachedData(AppLocalKey.assetOverviewKey);
      filteredItemsNotifier.value = [];
      selectiveNotify([
        AppLocalKey.filteredAssetsKey,
        AppLocalKey.assetOverviewKey,
      ]);
      await _globalViewModel.loadAssets();
    }
    _filteredAssets = List.from(allAssets);
    setCachedData(AppLocalKey.filteredAssetsKey, _filteredAssets);
    _updateFilteredItemsNotifier();
    selectiveNotify([
      AppLocalKey.filteredAssetsKey,
      AppLocalKey.assetOverviewKey,
    ]);
  }

  @override
  String getSearchField(AssetModel item) {
    return '${item.name.toLowerCase()} ${item.id.toLowerCase()}';
  }

  void toggleAssetVisibility() {
    isShowingAssets = !isShowingAssets;
    selectiveNotify([AppLocalKey.isShowingAssetsKey]);
  }

  @override
  void dispose() {
    disposeResources();
    super.dispose();
  }
}
