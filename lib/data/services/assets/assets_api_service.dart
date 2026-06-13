import 'package:alpha/data/models/asset/Record/record_model.dart';
import 'package:alpha/data/models/asset/beneficiaries_model.dart';
import 'package:alpha/data/models/asset/child_currencies_model.dart';
import 'package:alpha/data/models/asset/deposit_address_model.dart';
import 'package:alpha/data/models/asset/member_levels_response_model.dart';
import 'package:alpha/data/models/asset/withdraw/active_beneficiary_request_model.dart';
import 'package:alpha/data/models/asset/withdraw/add_beneficiaries_request_model.dart';
import 'package:alpha/data/models/asset/withdraw/delete_beneficiary_request_model.dart';
import 'package:alpha/data/models/asset/withdraw/execute_withdraw_request_model.dart';
import 'package:alpha/data/models/asset/withdraw/execute_withdraw_response_model.dart';
import 'package:alpha/data/models/asset/withdraw/remains_model.dart';
import 'package:alpha/data/models/asset/withdraw/withdraw_fee_response_model.dart';
import 'package:alpha/data/models/asset/withdraw/withdraw_history_model.dart';
import 'package:alpha/data/models/asset/withdraw/withdraw_limit_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'assets_api_service.g.dart';

@RestApi()
abstract class AssetsApiService {
  factory AssetsApiService(Dio dio, {String baseUrl}) = _AssetsApiService;

  @GET('/withdrawLimit/private/withdrawLimit/remains')
  Future<RemainsModel> remainsWithdraw();

  @GET('/wallet/user/wallet/withdraw-history/list')
  Future<WithdrawHistoryModel> withdrawHistory(
    @Query('page') int page,
    @Query('limit') int limit,
    @Query('withdraw_currency') String? withdrawCurrency,
  );

  @GET('/wallet/user/wallet/withdraw-history/list')
  Future<RecordResponse> withdrawRecordHistory(
    @Query('page') int page,
    @Query('limit') int limit,
  );

  @GET('/spot/account/deposits')
  Future<List<RecordData>> depositRecordHistory(
    @Query('page') int page,
    @Query('limit') int limit,
  );

  @GET('/wallet/public/wallet/relation-currency/fetch-detail-coin')
  Future<ChildCurrenciesModel> fetchChildCurrencies(
    @Query('currency') String currency,
  );

  @GET('/spot/account/beneficiaries')
  Future<List<BeneficiariesModel>> fetchBeneficiaries();

  @GET('/wallet/user/wallet/withdraw-limit')
  Future<WithdrawLimitModel> fetchWithdrawLimit();

  @GET('/wallet/user/wallet/withdraw-fee')
  Future<WithdrawFeeResponseModel> fetchWithdrawFee(
    @Query('currency_id') String currencyId,
  );

  @GET('/spot/public/member-levels')
  Future<MemberLevelsResponseModel> fetchMemberLevels();

  @GET('/wallet/public/wallet/relation-currency/fetch-all-coin')
  Future<ChildCurrenciesModel> fetchAllChildCurrencies();

  @POST('/spot/account/beneficiaries')
  Future<BeneficiariesModel> addBeneficiaries(
    @Body() AddBeneficiariesRequestModel request,
  );

  @PATCH('/spot/account/beneficiaries/{id}/activate')
  Future<BeneficiariesModel> activateBeneficiary(
    @Path('id') String id,
    @Body() ActiveBeneficiaryRequestModel request,
  );

  @POST('/wallet/user/wallet/beneficiary/{id}')
  Future<void> deleteBeneficiaries(
    @Path('id') String id,
    @Body() DeleteBeneficiaryRequestModel request,
  );

  @POST('/wallet/user/wallet/withdraw-v2/create')
  Future<ExecuteWithdrawResponseModel> executeWithdraw(
    @Body() ExecuteWithdrawRequestModel request,
    @Query("lang") String lang,
  );

  @GET('/spot/account/deposit_address/{currency}')
  Future<DepositAddressModel> fetchDepositAddress(
    @Path('currency') String currency,
  );
}
