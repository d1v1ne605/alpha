import 'package:alpha/data/models/stake/stake_product_model.dart';
import 'package:alpha/data/models/stake/stake_record_model.dart';
import 'package:alpha/data/models/stake/stake_register_request.dart';
import 'package:alpha/data/models/stake/stake_register_response.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'stake_api_service.g.dart';

@RestApi()
abstract class StakeApiService {
  factory StakeApiService(Dio dio, {String baseUrl}) = _StakeApiService;

  @GET("/staking/user/stake-products")
  Future<List<StakeProductResponse>> getStakeProducts();

  @POST("/staking/user/stake-register")
  Future<StakeRegisterResponse> registerStake({
    @Body() required StakeRegisterRequest body,
  });

  @GET("/staking/user/my-stakes")
  Future<List<StakeRecordModel>> getStakeRecords();
}
