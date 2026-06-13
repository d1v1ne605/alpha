import 'package:alpha/data/models/earn/earn_wallets.dart';
import 'package:alpha/data/models/earn/product/product_earn_model.dart';
import 'package:alpha/data/models/earn/transaction_earn/rewards/reward_model_earn.dart';
import 'package:alpha/data/models/earn/transaction_earn/withdraw_record/withdraw_record_earn.dart';
import 'package:alpha/data/models/earn/withdraw_request_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'earn_api_service.g.dart';

@RestApi()
abstract class EarnApiService {
  factory EarnApiService(Dio dio, {String baseUrl}) = _EarnApiService;

  @GET("/earn/user/earn-wallets")
  Future<EarnWalletsResponse> getEarnWallets();

  @GET("/earn/user/products")
  Future<ProductEarnResponse> getEarnProducts();

  @GET("/earn/user/withdraws/history")
  Future<WithdrawRecordEarn> getWithdrawEarnHistory(
    @Query("page") int page,
    @Query("limit") int limit,
    @Query("language") String language,
  );

  @GET("/earn/user/rewards")
  Future<RewardModelEarn> getEarnRewards(
    @Query("page") int page,
    @Query("limit") int limit,
    @Query("language") String language,
    @Query("product_type") String productType,
  );

  @POST("/earn/user/withdraws/withdraw/Ymdn")
  Future<void> withdrawEarn(@Body() WithdrawRequestModel body);
}
