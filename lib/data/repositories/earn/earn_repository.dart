import 'package:alpha/data/models/earn/earn_wallets.dart';
import 'package:alpha/data/models/earn/product/product_earn_model.dart';
import 'package:alpha/data/models/earn/transaction_earn/rewards/reward_model_earn.dart';
import 'package:alpha/data/models/earn/transaction_earn/withdraw_record/withdraw_record_earn.dart';
import 'package:alpha/data/models/earn/withdraw_request_model.dart';

abstract class EarnRepository {
  Future<EarnWalletsResponse> getEarnWallets();

  Future<ProductEarnResponse> getEarnProducts();

  Future<void> withdrawEarn(WithdrawRequestModel request);

  Future<WithdrawRecordEarn> getWithdrawEarnHistory(
    int page,
    int limit,
    String language,
  );

  Future<RewardModelEarn> getEarnRewards(
    int page,
    int limit,
    String language,
    String productType,
  );
}
