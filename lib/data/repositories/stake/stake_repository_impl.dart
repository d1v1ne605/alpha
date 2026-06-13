import 'package:alpha/data/models/home_market/currency_model.dart';
import 'package:alpha/data/models/stake/stake_product_model.dart';
import 'package:alpha/data/models/stake/stake_record_model.dart';
import 'package:alpha/data/models/stake/stake_register_request.dart';
import 'package:alpha/data/models/stake/stake_register_response.dart';
import 'package:alpha/data/repositories/stake/stake_repository.dart';
import 'package:alpha/data/services/home/home_api_service.dart';
import 'package:alpha/data/services/stake/stake_api_service.dart';

class StakeRepositoryImpl implements StakeRepository {
  final StakeApiService _stakeApiService;
  final HomeApiService _homeApiService;

  StakeRepositoryImpl(this._stakeApiService, this._homeApiService);

  @override
  Future<List<StakeProductResponse>> getAllStakeProduct() async {
    try {
      final reponse = _stakeApiService.getStakeProducts();
      return reponse;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<StakeRecordModel>> getStakeRecords() async {
    final result = await _stakeApiService.getStakeRecords();
    return result;
  }

  @override
  Future<StakeRegisterResponse> registerStake(
    StakeRegisterRequest request,
  ) async {
    return await _stakeApiService.registerStake(body: request);
  }
}
