import 'package:alpha/core/constants/app_storage_key.dart';
import 'package:alpha/data/models/asset/withdraw/withdraw_history_model.dart';
import 'package:alpha/data/repositories/asset/asset_repository.dart';

class HistoryWithdrawUseCase {
  final AssetRepository _assetRepository;

  HistoryWithdrawUseCase(this._assetRepository);

  Future<WithdrawHistoryModel> call({
    int page = 1,
    int limit = AppStorageKey.withdrawHistoryLimit,
    String? withdrawCurrency,
  }) async {
    try {
      final result = await _assetRepository.getWithdrawHistory(
        page: page,
        limit: limit,
        withdrawCurrency: withdrawCurrency,
      );
      return result;
    } catch (e) {
      throw Exception('Failed to load withdraw history: $e');
    }
  }
}
