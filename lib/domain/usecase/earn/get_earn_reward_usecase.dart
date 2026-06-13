import 'package:alpha/data/models/earn/transaction_earn/rewards/reward_model_earn.dart';
import 'package:alpha/data/repositories/earn/earn_repository.dart';

class GetEarnRewardUsecase {
  EarnRepository _earnRepository;

  GetEarnRewardUsecase(this._earnRepository);

  Future<RewardModelEarn> call(
    int page,
    int limit,
    String language,
    String productType,
  ) async {
    return await _earnRepository.getEarnRewards(
      page,
      limit,
      language,
      productType,
    );
  }
}
