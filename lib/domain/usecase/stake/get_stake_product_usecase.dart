import 'package:alpha/data/models/stake/stake_product_model.dart';
import 'package:alpha/data/models/stake/stake_register_request.dart';
import 'package:alpha/data/models/stake/stake_register_response.dart';
import 'package:alpha/data/repositories/stake/stake_repository.dart';

class GetStakeProductUsecase {
  final StakeRepository _stakeRepository;

  GetStakeProductUsecase(this._stakeRepository);

  Future<List<StakeProductResponse>> call() async {
    try {
      final response = await _stakeRepository.getAllStakeProduct();
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<StakeRegisterResponse> registerStake(
    StakeRegisterRequest request,
  ) async {
    return await _stakeRepository.registerStake(request);
  }
}
