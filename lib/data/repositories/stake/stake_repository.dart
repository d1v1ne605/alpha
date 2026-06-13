import 'package:alpha/data/models/home_market/currency_model.dart';
import 'package:alpha/data/models/stake/stake_product_model.dart';
import 'package:alpha/data/models/stake/stake_record_model.dart';

import 'package:alpha/data/models/stake/stake_register_request.dart';
import 'package:alpha/data/models/stake/stake_register_response.dart';

abstract class StakeRepository {
  Future<List<StakeProductResponse>> getAllStakeProduct();
  Future<List<StakeRecordModel>> getStakeRecords();
  Future<StakeRegisterResponse> registerStake(StakeRegisterRequest request);
}
