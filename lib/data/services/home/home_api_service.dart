import 'package:alpha/data/models/asset/balance_response_model.dart';
import 'package:alpha/data/models/banner_models/banner_model.dart';
import 'package:alpha/data/models/enable_two_fa/two_fa_model.dart';
import 'package:alpha/data/models/home_market/coin_model/coin_detail_model.dart';
import 'package:alpha/data/models/home_market/coin_model/coin_detail_wrapper.dart';
import 'package:alpha/data/models/home_market/coin_model/transaction_model.dart';
import 'package:alpha/data/models/home_market/crypto_model/token_response.dart';
import 'package:alpha/data/models/home_market/currency_model.dart';
import 'package:alpha/data/models/home_market/market_data_model.dart';
import 'package:alpha/data/models/home_market/market_model.dart';
import 'package:alpha/data/models/my_api_key/api_key_model.dart';
import 'package:alpha/data/models/my_api_key/update_api_key_request.dart';
import 'package:alpha/data/models/my_api_key/verify_api_key_request.dart';
import 'package:alpha/data/models/referall_model/referral_response_model.dart';
import 'package:alpha/data/models/referall_model/top_ranking_response_model.dart';
import 'package:alpha/data/models/trading/trade/cancel_all_order_request_model.dart';
import 'package:alpha/data/models/trading/trade/depth_response_model.dart';
import 'package:alpha/data/models/trading/trade/order_form_request_model.dart';
import 'package:alpha/data/models/trading/trade/order_item_model.dart';
import 'package:alpha/data/models/trading/trade/trade_history_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../models/enable_two_fa/verify_code_request.dart';

part 'home_api_service.g.dart';

@RestApi()
abstract class HomeApiService {
  factory HomeApiService(Dio dio, {String baseUrl}) = _HomeApiService;

  @GET("/spot/public/markets")
  Future<List<MarketModel>> getMarkets();

  @GET("/spot/public/currencies")
  Future<List<CurrencyModel>> getCurrencies();

  @GET("/spot/public/markets/tickers")
  Future<Map<String, MarketDataModel>> getTickers();

  @GET("/announcement/public/article/list")
  Future<List<BannerModel>> getAnnouncements();

  @GET("/announcement/public/banner/list")
  Future<List<BannerModel>> getBanners(@Query("limit") int? limit);

  @GET("/coinList/public/token/detail/{coinId}")
  Future<CoinDetailWrapper> getCoinDetail(@Path("coinId") String coinId);

  @GET("/coinList/public/tokens")
  Future<TokenResponse> getCoinCrypto();

  @GET("/spot/public/markets/{market}/trades")
  Future<List<TransactionModel>> getTranscation(@Path("market") String market);

  @GET("/spot/account/balances")
  Future<List<BalanceResponseModel>> getBalances(
    @Query("limit") int? limit,
    @Query("page") int? page,
    @Query("nonzero") bool? nonzero,
  );

  @GET("/spot/public/markets/{market}/depth")
  Future<DepthResponseModel> getOrderBook(@Path("market") String market);

  @POST("/spot/market/orders")
  Future<OrderItemModel> submitOrder(@Body() OrderFormRequestModel request);

  @GET("/spot/market/orders")
  Future<List<OrderItemModel>> getOrders(
    @Query("market") String? market,
    @Query("state") String? state,
    @Query("page") String? page,
    @Query("limit") String? limit,
    @Query("time_to") int? timeTo,
    @Query("time_from") int? timeFrom,
    @Query("type") String? type,
    @Query("ord_type") String? orderType,
    @Query("order_by") String? orderBy,
  );

  @POST("/spot/market/orders/{id}/cancel")
  Future<OrderItemModel> cancelOrderWithID(@Path("id") String uuid);

  @POST("/spot/market/orders/cancel")
  Future<List<OrderItemModel>> cancelAllOrders(
    @Body() CancelAllOrderRequestModel body,
  );

  @GET("/spot/market/trades")
  Future<List<TradeHistoryModel>> getTradeHistory(
    @Query("page") String? page,
    @Query("limit") String? limit,
    @Query("market") String? market,
    @Query("time_to") int? timeTo,
    @Query("time_from") int? timeFrom,
    @Query("type") String? type,
  );

  @GET("/referral/user/referral-dashboard")
  Future<ReferralResponse> getReferral();

  @GET("/referral/public/top-trade-ranks")
  Future<TopRankingResponseModel> getTopRankings();

  @POST("/user/resource/otp/generate_qrcode")
  Future<TwoFAModel> generateQRCode();

  @POST("/user/resource/otp/enable")
  Future<HttpResponse<dynamic>> enableVerifyCode(
    @Body() VerifyCodeRequest request,
  );

  @POST("/user/resource/otp/disable")
  Future<HttpResponse<dynamic>> disableVerifyCode(
    @Body() VerifyCodeRequest request,
  );

  @POST("/user/resource/api_keys")
  Future<ApiKeyModel> createApiKey(@Body() VerifyMyApiRequest request);

  @GET("/user/resource/api_keys")
  Future<List<ApiKeyModel>> getApiKeys();

  @PATCH("/user/resource/api_keys/{kid}")
  Future<ApiKeyModel> updateApiKeyStatus(
    @Path("kid") String kid,
    @Body() UpdateApiKeyRequest request,
  );

  @DELETE("/user/resource/api_keys/{kid}")
  Future<void> deleteApiKey(
    @Path("kid") String kid,
    @Query("totp_code") String totpCode,
  );
}
