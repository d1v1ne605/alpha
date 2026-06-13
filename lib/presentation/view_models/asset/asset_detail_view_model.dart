import 'package:alpha/core/base/base_view_model.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/data/models/asset/asset_detail_model.dart';
import 'package:alpha/data/models/earn/earn_wallets.dart';
import 'package:alpha/data/models/earn/product/product_earn_model.dart';
import 'package:alpha/data/models/home_market/coin_model/coin_model.dart';
import 'package:alpha/data/models/mockdata/asset_mockdata.dart';
import 'package:alpha/domain/usecase/asset/get_rate_usecase.dart';
import 'package:alpha/domain/usecase/earn/get_earn_product_usecase.dart';
import 'package:alpha/domain/usecase/earn/get_earn_wallet_usecase.dart';
import 'package:alpha/injection/injector.dart';
import 'package:alpha/presentation/view_models/global_view_model.dart';

class AssetDetailViewModel extends BaseViewModel {
  bool isShowingAssets = false;
  final List<CoinModel> marketList = [];
  final GetRateUsecase getRateUsecase = getIt<GetRateUsecase>();
  final GlobalViewModel basicViewModel = getIt<GlobalViewModel>();
  final GetEarnWalletUsecase getEarnWalletUsecase;
  final GetEarnProductUsecase getEarnProductUsecase;

  AssetDetailViewModel(this.getEarnWalletUsecase, this.getEarnProductUsecase) {
    loadEarnWallets();
    loadEarnProducts();
  }

  AssetDetailModel assetDetail = AssetDetailModel(
    asset: defaultAsset,
    overview: defaultValue,
  );

  void init(AssetDetailModel assetDetail) {
    loadAssetDetail(assetDetail);
  }

  List<EarnWalletData> _earnWallets = [];

  List<EarnWalletData> get earnWallets => _earnWallets;

  Future<void> loadEarnWallets() async {
    try {
      final response = await getEarnWalletUsecase();
      final allWallets = response.wallets.map((e) => e.wallet).toList();
      _earnWallets = allWallets;
    } catch (e) {
      rethrow;
    }
  }

  List<ProductEarnData> _earnProducts = [];

  List<ProductEarnData> get earnProducts => _earnProducts;

  Future<void> loadEarnProducts() async {
    try {
      final response = await getEarnProductUsecase();
      _earnProducts = response.data;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> loadAssetDetail(AssetDetailModel assetDetail) async {
    try {
      setBusy(true);
      final rate = await getRateUsecase();
      final equivalent =
          rate * (assetDetail.asset.spot + assetDetail.asset.frozen);
      final filteredMarketList = basicViewModel.coins
          .where((coin) => coin.base_unit == assetDetail.asset.id)
          .toList();

      marketList
        ..clear()
        ..addAll(filteredMarketList);
      this.assetDetail = assetDetail.copyWith(
        equivalent: equivalent,
        marketList: filteredMarketList,
      );
    } catch (e) {
      print('${context?.appLocaleLanguage.failAsset} $e');
    } finally {
      setBusy(false);
      notifyListeners();
    }
  }

  void toggleAssetVisibility() {
    isShowingAssets = !isShowingAssets;
    notifyListeners();
  }

  List<ProductEarnData> getProductsByAssetId(String assetId) {
    return _earnProducts
        .where((p) => p.currencyId.toLowerCase() == assetId.toLowerCase())
        .toList();
  }

  ProductEarnData? getFirstProductByAssetId(String assetId) {
    try {
      return getProductsByAssetId(assetId).first;
    } catch (_) {
      return null;
    }
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
}
