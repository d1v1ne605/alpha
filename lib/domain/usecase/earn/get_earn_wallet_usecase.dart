import 'package:alpha/data/models/earn/earn_wallets.dart';
import 'package:alpha/data/repositories/earn/earn_repository.dart';

class GetEarnWalletUsecase {
  EarnRepository _earnRepository;

  GetEarnWalletUsecase(this._earnRepository);

  Future<EarnWalletsResponse> call() async {
    return await _earnRepository.getEarnWallets();
  }
}
