import 'package:alpha/data/models/earn/earn_wallets.dart';
import 'package:alpha/data/models/earn/product/product_earn_model.dart';
import 'package:alpha/data/models/earn/transaction_earn/rewards/reward_model_earn.dart';
import 'package:alpha/data/models/earn/transaction_earn/withdraw_record/withdraw_record_earn.dart';
import 'package:alpha/data/models/earn/withdraw_request_model.dart';
import 'package:alpha/data/repositories/earn/earn_repository.dart';
import 'package:alpha/data/services/earn/earn_api_service.dart';

class EarnRepositoryImpl implements EarnRepository {
  final EarnApiService _earnApiService;

  EarnRepositoryImpl(this._earnApiService);

  @override
  Future<EarnWalletsResponse> getEarnWallets() async {
    try {
      final response = await _earnApiService.getEarnWallets();
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ProductEarnResponse> getEarnProducts() {
    try {
      final response = _earnApiService.getEarnProducts();
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> withdrawEarn(WithdrawRequestModel request) async {
    try {
      await _earnApiService.withdrawEarn(request);
    } catch (e) {
      print('❌ Lỗi khi gọi API withdrawEarn: $e');
      rethrow;
    }
  }

  @override
  Future<RewardModelEarn> getEarnRewards(
    int page,
    int limit,
    String language,
    String productType,
  ) {
    try {
      final response = _earnApiService.getEarnRewards(
        page,
        limit,
        language,
        productType,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<WithdrawRecordEarn> getWithdrawEarnHistory(
    int page,
    int limit,
    String language,
  ) {
    try {
      final response = _earnApiService.getWithdrawEarnHistory(
        page,
        limit,
        language,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
