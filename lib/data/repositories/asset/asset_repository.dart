import 'package:alpha/data/models/asset/Record/record_model.dart';
import 'package:alpha/data/models/asset/balance_response_model.dart';
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

abstract class AssetRepository {
  Future<List<BalanceResponseModel>> getBalances();

  Future<RemainsModel> getRemainsWithdraw();

  Future<WithdrawHistoryModel> getWithdrawHistory({
    int page,
    int limit,
    String? withdrawCurrency,
  });

  Future<ChildCurrenciesModel> getChildCurrencies(String currency);

  Future<List<BeneficiariesModel>> getBeneficiaries();

  Future<WithdrawLimitModel> getWithdrawLimit();

  Future<WithdrawFeeResponseModel> getWithdrawFee(String currencyId);

  Future<MemberLevelsResponseModel> getMemberLevels();

  Future<Map<String, dynamic>> getAllChildCurrenciesAndCurrencies();

  Future<BeneficiariesModel> addBeneficiaries(
    AddBeneficiariesRequestModel request,
  );

  Future<BeneficiariesModel> activeBeneficiary(
    String id,
    ActiveBeneficiaryRequestModel request,
  );

  Future<void> deleteBeneficiary(
    String id,
    DeleteBeneficiaryRequestModel request,
  );

  Future<ExecuteWithdrawResponseModel> executeWithdraw(
    String lang,
    ExecuteWithdrawRequestModel request,
  );

  Future<RecordResponse> getDepositRecordHistory({int page, int limit});

  Future<RecordResponse> getWithdrawRecordHistory({int page, int limit});

  Future<DepositAddressModel> getDepositAddress(String currency);
}
