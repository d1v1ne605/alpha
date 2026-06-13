import 'package:alpha/core/constants/app_storage_key.dart';
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
import 'package:alpha/data/repositories/asset/asset_repository.dart';
import 'package:alpha/data/services/assets/assets_api_service.dart';
import 'package:alpha/data/services/home/home_api_service.dart';

class AssetRepositoryImpl implements AssetRepository {
  final HomeApiService _homeApiService;
  final AssetsApiService _assetsApiService;

  AssetRepositoryImpl(this._homeApiService, this._assetsApiService);

  @override
  Future<List<BalanceResponseModel>> getBalances() async {
    try {
      final getBalances = await _homeApiService.getBalances(1000, null, null);
      return getBalances;
    } catch (e) {
      print("Error fetching assets: $e");
      return [];
    }
  }

  @override
  Future<RemainsModel> getRemainsWithdraw() {
    try {
      return _assetsApiService.remainsWithdraw();
    } catch (e) {
      throw Exception('Failed to fetch remains withdraw: $e');
    }
  }

  @override
  Future<WithdrawHistoryModel> getWithdrawHistory({
    int page = 1,
    int limit = AppStorageKey.withdrawHistoryLimit,
    String? withdrawCurrency,
  }) {
    try {
      return _assetsApiService.withdrawHistory(page, limit, withdrawCurrency);
    } catch (e) {
      throw Exception('Failed to fetch withdraw history: $e');
    }
  }

  @override
  Future<ChildCurrenciesModel> getChildCurrencies(String currency) {
    try {
      return _assetsApiService.fetchChildCurrencies(currency);
    } catch (e) {
      throw Exception('Failed to fetch child currencies: $e');
    }
  }

  @override
  Future<List<BeneficiariesModel>> getBeneficiaries() {
    try {
      return _assetsApiService.fetchBeneficiaries();
    } catch (e) {
      throw Exception('Failed to fetch beneficiaries: $e');
    }
  }

  @override
  Future<WithdrawLimitModel> getWithdrawLimit() {
    try {
      return _assetsApiService.fetchWithdrawLimit();
    } catch (e) {
      throw Exception('Failed to fetch withdraw limit: $e');
    }
  }

  @override
  Future<WithdrawFeeResponseModel> getWithdrawFee(String currencyId) {
    try {
      return _assetsApiService.fetchWithdrawFee(currencyId);
    } catch (e) {
      throw Exception('Failed to fetch withdraw fee: $e');
    }
  }

  @override
  Future<MemberLevelsResponseModel> getMemberLevels() {
    try {
      return _assetsApiService.fetchMemberLevels();
    } catch (e) {
      throw Exception('Failed to fetch member levels: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getAllChildCurrenciesAndCurrencies() async {
    try {
      final results = await Future.wait([
        _assetsApiService.fetchAllChildCurrencies(),
        _homeApiService.getCurrencies(),
      ]);
      return {'allChildCurrencies': results[0], 'currencies': results[1]};
    } catch (e) {
      print('Error while fetching child currencies or currencies: $e');
      rethrow;
    }
  }

  @override
  Future<BeneficiariesModel> addBeneficiaries(
    AddBeneficiariesRequestModel request,
  ) {
    try {
      return _assetsApiService.addBeneficiaries(request);
    } catch (e) {
      throw Exception('Failed to add beneficiaries: $e');
    }
  }

  @override
  Future<BeneficiariesModel> activeBeneficiary(
    String id,
    ActiveBeneficiaryRequestModel request,
  ) {
    try {
      return _assetsApiService.activateBeneficiary(id, request);
    } catch (e) {
      throw Exception('Failed to activate beneficiary: $e');
    }
  }

  @override
  Future<void> deleteBeneficiary(
    String id,
    DeleteBeneficiaryRequestModel request,
  ) {
    try {
      return _assetsApiService.deleteBeneficiaries(id, request);
    } catch (e) {
      throw Exception('Failed to delete beneficiary: $e');
    }
  }

  @override
  Future<ExecuteWithdrawResponseModel> executeWithdraw(
    String lang,
    ExecuteWithdrawRequestModel request,
  ) {
    try {
      return _assetsApiService.executeWithdraw(request, lang);
    } catch (e) {
      throw Exception('Failed to execute withdraw: $e');
    }
  }

  @override
  Future<RecordResponse> getDepositRecordHistory({
    int page = 1,
    int limit = 25,
  }) async {
    try {
      final records = await _assetsApiService.depositRecordHistory(page, limit);
      return RecordResponse(data: records);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<RecordResponse> getWithdrawRecordHistory({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _assetsApiService.withdrawRecordHistory(
        page,
        limit,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<DepositAddressModel> getDepositAddress(String currency) {
    try {
      return _assetsApiService.fetchDepositAddress(currency);
    } catch (e) {
      throw Exception('Failed to fetch deposit address: $e');
    }
  }
}
