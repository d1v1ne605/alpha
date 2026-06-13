import 'package:alpha/core/env/env.dart';
import 'package:alpha/core/network/auth_change_notifier.dart';
import 'package:alpha/core/network/dio_factory.dart';
import 'package:alpha/core/utils/socket/socket_manager.dart';
import 'package:alpha/data/repositories/asset/asset_repository.dart';
import 'package:alpha/data/repositories/asset/asset_repository_impl.dart';
import 'package:alpha/data/repositories/auth/forgot_password/forgot_password_repository.dart';
import 'package:alpha/data/repositories/auth/forgot_password/forgot_password_repository_impl.dart';
import 'package:alpha/data/repositories/auth/login/auth_repository.dart';
import 'package:alpha/data/repositories/auth/login/auth_repository_impl.dart';
import 'package:alpha/data/repositories/auth/register/register_repository.dart';
import 'package:alpha/data/repositories/auth/register/register_repository_impl.dart';
import 'package:alpha/data/repositories/change_password/change_password_repository.dart';
import 'package:alpha/data/repositories/earn/earn_repository.dart';
import 'package:alpha/data/repositories/earn/earn_repository_impl.dart';
import 'package:alpha/data/repositories/global/global_repository.dart';
import 'package:alpha/data/repositories/global/global_repository_impl.dart';
import 'package:alpha/data/repositories/home/home_reponsitory.dart';
import 'package:alpha/data/repositories/home/home_reponsitory_impl.dart';
import 'package:alpha/data/repositories/my_api_key/my_api_key_repository.dart';
import 'package:alpha/data/repositories/my_api_key/my_api_key_repository_impl.dart';
import 'package:alpha/data/repositories/referral/referral_repository.dart';
import 'package:alpha/data/repositories/referral/referral_repository_impl.dart';
import 'package:alpha/data/repositories/stake/stake_repository.dart';
import 'package:alpha/data/repositories/stake/stake_repository_impl.dart';
import 'package:alpha/data/repositories/trading/trade/trade_repository.dart';
import 'package:alpha/data/repositories/trading/trade/trade_repository_impl.dart';
import 'package:alpha/data/services/assets/assets_api_service.dart';
import 'package:alpha/data/services/auth/auth_api_service.dart';
import 'package:alpha/data/services/earn/earn_api_service.dart';
import 'package:alpha/data/services/home/home_api_service.dart';
import 'package:alpha/data/services/local/hive_service.dart';
import 'package:alpha/data/services/stake/stake_api_service.dart';
import 'package:alpha/domain/usecase/asset/get_assets_usecase.dart';
import 'package:alpha/domain/usecase/asset/get_filter_coins_usecase.dart';
import 'package:alpha/domain/usecase/asset/get_filter_network_usecase.dart';
import 'package:alpha/domain/usecase/asset/get_rate_usecase.dart';
import 'package:alpha/domain/usecase/auth/login_usecase.dart';
import 'package:alpha/domain/usecase/auth/register_usecase.dart';
import 'package:alpha/domain/usecase/auth/reset_password_usecase.dart';
import 'package:alpha/domain/usecase/auth/verify_email_usecase.dart';
import 'package:alpha/domain/usecase/deposit/get_child_currency_usecase.dart';
import 'package:alpha/domain/usecase/deposit/get_deposit_address_usecase.dart';
import 'package:alpha/domain/usecase/earn/execute_withdraw_earn_use_case.dart';
import 'package:alpha/domain/usecase/earn/get_earn_product_usecase.dart';
import 'package:alpha/domain/usecase/earn/get_earn_reward_usecase.dart';
import 'package:alpha/domain/usecase/earn/get_earn_wallet_usecase.dart';
import 'package:alpha/domain/usecase/earn/get_withdraw_record_usecase.dart';
import 'package:alpha/domain/usecase/home/announcement_usecase.dart';
import 'package:alpha/domain/usecase/home/get_balances_and_currencies.dart';
import 'package:alpha/domain/usecase/home/get_coin_crypto_usecase.dart';
import 'package:alpha/domain/usecase/home/get_coins_usecase.dart';
import 'package:alpha/domain/usecase/my_api_key/my_api_key_usecase.dart';
import 'package:alpha/domain/usecase/records/get_deposit_records_usecase.dart';
import 'package:alpha/domain/usecase/records/get_withdraw_records_usecase.dart';
import 'package:alpha/domain/usecase/referall/get_ranking_usecase.dart';
import 'package:alpha/domain/usecase/referall/get_referalls_usecase.dart';
import 'package:alpha/domain/usecase/stake/get_stake_product_usecase.dart';
import 'package:alpha/domain/usecase/stake/get_stake_records_usecase.dart';
import 'package:alpha/domain/usecase/trading/cancel_order_uuid_usecase.dart';
import 'package:alpha/domain/usecase/trading/get_coin_detail_usecase.dart';
import 'package:alpha/domain/usecase/trading/get_order_book_usecase.dart';
import 'package:alpha/domain/usecase/trading/get_orders_usecase.dart';
import 'package:alpha/domain/usecase/trading/get_trade_history_usecase.dart';
import 'package:alpha/domain/usecase/trading/submit_order_usecase.dart';
import 'package:alpha/domain/usecase/withdraw/active_beneficiary_withdraw_usecase.dart';
import 'package:alpha/domain/usecase/withdraw/add_beneficiary_withdraw_usecase.dart';
import 'package:alpha/domain/usecase/withdraw/delete_beneficiary_withdraw_usecase.dart';
import 'package:alpha/domain/usecase/withdraw/execute_withdraw_usecase.dart';
import 'package:alpha/domain/usecase/withdraw/history_withdraw_usecase.dart';
import 'package:alpha/domain/usecase/withdraw/select_coin_withdraw_usecase.dart';
import 'package:alpha/domain/usecase/withdraw/select_network_withdraw_usecase.dart';
import 'package:alpha/presentation/view_models/asset/asset_detail_view_model.dart';
import 'package:alpha/presentation/view_models/asset/asset_view_model.dart';
import 'package:alpha/presentation/view_models/asset/record/record_view_model.dart';
import 'package:alpha/presentation/view_models/asset/withdraw/withdraw_view_model.dart';
import 'package:alpha/presentation/view_models/asset_fee/asset_fee_view_model.dart';
import 'package:alpha/presentation/view_models/auth/choose_language_view_model.dart';
import 'package:alpha/presentation/view_models/auth/forgot_password_view_model.dart';
import 'package:alpha/presentation/view_models/auth/login_view_model.dart';
import 'package:alpha/presentation/view_models/auth/register_view_model.dart';
import 'package:alpha/presentation/view_models/deposit/deposit_view_model.dart';
import 'package:alpha/presentation/view_models/earn/earn_view_model.dart';
import 'package:alpha/presentation/view_models/earn/withdraw_earn/withdraw_earn_viewmodel.dart';
import 'package:alpha/presentation/view_models/global_view_model.dart';
import 'package:alpha/presentation/view_models/home/home_view_model.dart';
import 'package:alpha/presentation/view_models/invite_friend/invite_friend_view_model.dart';
import 'package:alpha/presentation/view_models/locale_langue/locale_language_view_model.dart';
import 'package:alpha/presentation/view_models/main/main_view_model.dart';
import 'package:alpha/presentation/view_models/stake/stake_view_model.dart';
import 'package:alpha/presentation/view_models/trading/order_view_model.dart';
import 'package:alpha/presentation/view_models/trading/trade_view_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../data/repositories/account_log/account_log_reponsitory.dart';
import '../data/repositories/account_log/account_log_reponsitory_impl.dart';
import '../data/repositories/change_password/change_password_repository_impl.dart';
import '../data/repositories/two_fa/two_fa_repository.dart';
import '../data/repositories/two_fa/two_fa_repository_impl.dart';
import '../data/services/account_log/account_log_api_service.dart';
import '../domain/usecase/account_log/account_log_usecase.dart';
import '../domain/usecase/change_password/change_password_usecase.dart';
import '../domain/usecase/home/home_banner_usecase.dart';
import '../domain/usecase/trading/get_transcation_usecase.dart';
import '../domain/usecase/two_fa/two_fa_usecase.dart';
import '../presentation/view_models/announcements/announcements_viewmodel.dart';
import '../presentation/view_models/change_password/change_password_view_model.dart';
import '../presentation/view_models/profile/profile_view_model.dart';

final getIt = GetIt.instance;
final apiUrl = dotenv.env['BASE_URL']!;

void setupDependencies(GoRouter router) {
  getIt.registerSingleton<HiveService>(HiveService());
  // Register Services
  getIt.registerLazySingleton<AuthApiService>(
    () => AuthApiService(DioFactory.createDio(Env.baseUrl, router: router)),
  );
  getIt.registerLazySingleton<AssetsApiService>(
    () => AssetsApiService(DioFactory.createDio(apiUrl, router: router)),
  );
  getIt.registerLazySingleton<EarnApiService>(
    () => EarnApiService(DioFactory.createDio(apiUrl, router: router)),
  );
  getIt.registerLazySingleton<StakeApiService>(
    () => StakeApiService(DioFactory.createDio(apiUrl, router: router)),
  );

  // Register Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt()),
  );
  getIt.registerLazySingleton<StakeRepository>(
    () => StakeRepositoryImpl(getIt(), getIt<HomeApiService>()),
  );

  getIt.registerLazySingleton<SocketManager>(() => SocketManager());
  getIt.registerLazySingleton<TradeRepository>(
    () => TradeRepositoryImpl(getIt()),
  );

  getIt.registerLazySingleton<GlobalRepository>(
    () => GlobalRepositoryImpl(getIt()),
  );

  // Register ViewModel
  getIt.registerSingleton<AuthChangeNotifier>(AuthChangeNotifier());
  getIt.registerLazySingleton<LocaleNotifier>(() => LocaleNotifier());

  getIt.registerFactory(
    () => LoginViewModel(LoginUseCase(getIt()), VerifyEmailUsecase(getIt())),
  );

  getIt.registerLazySingleton<HomeApiService>(
    () => HomeApiService(DioFactory.createDio(apiUrl, router: router)),
  );
  getIt.registerLazySingleton<HomeReponsitory>(
    () => HomeRepositoryImpl(getIt()),
  );
  getIt.registerLazySingleton<GlobalViewModel>(
    () => GlobalViewModel(
      GetCoinsUsecase(getIt()),
      HomeBannerUseCase(getIt()),
      getIt<SocketManager>(),
      GetFilterCoinsUseCase(getIt()),
      GetBalancesAndCurrencies(getIt()),
    ),
  );

  getIt.registerLazySingleton<EarnViewModel>(
    () => EarnViewModel(
      getIt<GlobalViewModel>(),
      GetEarnWalletUsecase(getIt()),
      ExecuteWithdrawEarnUseCase(getIt()),
      GetEarnRewardUsecase(getIt()),
      GetWithdrawRecordUsecase(getIt()),
    ),
  );
  getIt.registerLazySingleton<HomeViewModel>(
    () => HomeViewModel(
      HomeBannerUseCase(getIt()),
      getIt<GlobalViewModel>(),
      GetCoinDetailUsecase(getIt()),
      GetCoinCryptoUsecase(getIt()),
    ),
  );

  getIt.registerLazySingleton<MainViewModel>(() => MainViewModel());

  getIt.registerLazySingleton<TradeViewModel>(
    () => TradeViewModel(
      getIt<GlobalViewModel>(),
      GetOrderBookUseCase(getIt()),
      GetCoinDetailUsecase(getIt()),
      GetTranscationUsecase(getIt()),
      SubmitOrderUseCase(getIt()),
      GetOrdersUseCase(getIt()),
      CancelOrderUuidUseCase(getIt()),
      GetTradeHistoryUseCase(getIt()),
    ),
  );
  getIt.registerFactory<OrderViewModel>(
    () => OrderViewModel(
      getIt<GlobalViewModel>(),
      GetTranscationUsecase(getIt()),
      GetOrdersUseCase(getIt()),
      CancelOrderUuidUseCase(getIt()),
      GetTradeHistoryUseCase(getIt()),
    ),
  );

  // other dependencies
  getIt.registerLazySingleton<FlutterSecureStorage>(
    () => FlutterSecureStorage(),
  );

  getIt.registerLazySingleton<RegisterRepository>(
    () => RegisterRepositoryImpl(getIt()),
  );
  getIt.registerFactory(() => RegisterViewModel(RegisterUseCase(getIt())));
  getIt.registerFactory(
    () => ChooseLanguageViewModel(RegisterUseCase(getIt())),
  );
  getIt.registerLazySingleton<AssetRepository>(
    () =>
        AssetRepositoryImpl(getIt<HomeApiService>(), getIt<AssetsApiService>()),
  );
  getIt.registerSingleton<GetAssetsUseCase>(
    GetAssetsUseCase(getIt<AssetRepository>(), getIt<GlobalRepository>()),
  );
  getIt.registerLazySingleton<GetDepositRecordUsecase>(
    () => GetDepositRecordUsecase(getIt<AssetRepository>()),
  );
  getIt.registerLazySingleton<GetDepositAddressUsecase>(
    () => GetDepositAddressUsecase(getIt<AssetRepository>()),
  );
  getIt.registerLazySingleton<GetWithdrawRecordsUsecase>(
    () => GetWithdrawRecordsUsecase(getIt<AssetRepository>()),
  );
  getIt.registerLazySingleton<GetWithdrawRecordUsecase>(
    () => GetWithdrawRecordUsecase(getIt<EarnRepository>()),
  );
  getIt.registerLazySingleton<GetEarnRewardUsecase>(
    () => GetEarnRewardUsecase(getIt<EarnRepository>()),
  );
  getIt.registerFactory<ForgotPasswordViewModel>(
    () => ForgotPasswordViewModel(),
  );
  getIt.registerLazySingleton<ForgotPasswordRepository>(
    () => ForgotPasswordRepositoryImpl(getIt()),
  );
  getIt.registerLazySingleton(
    () => ForgotPasswordUsecase(getIt<ForgotPasswordRepository>()),
  );
  getIt.registerSingleton<GetRateUsecase>(
    GetRateUsecase(globalRepository: getIt<GlobalRepository>()),
  );
  getIt.registerLazySingleton<EarnRepository>(
    () => EarnRepositoryImpl(getIt()),
  );
  getIt.registerSingleton<GetEarnWalletUsecase>(
    GetEarnWalletUsecase(getIt<EarnRepository>()),
  );
  getIt.registerSingleton<ExecuteWithdrawEarnUseCase>(
    ExecuteWithdrawEarnUseCase(getIt<EarnRepository>()),
  );

  getIt.registerSingleton<GetEarnProductUsecase>(
    GetEarnProductUsecase(getIt<EarnRepository>()),
  );
  getIt.registerLazySingleton<AssetViewModel>(
    () => AssetViewModel(getIt<GlobalViewModel>()),
  );
  getIt.registerLazySingleton<AssetDetailViewModel>(
    () => AssetDetailViewModel(
      getIt<GetEarnWalletUsecase>(),
      getIt<GetEarnProductUsecase>(),
    ),
  );
  getIt.registerLazySingleton<AnnouncementUseCase>(
    () => AnnouncementUseCase(getIt<HomeReponsitory>()),
  );
  getIt.registerFactory(
    () => AnnouncementsViewModel(
      AnnouncementUseCase(getIt<HomeReponsitory>()),
      getIt<LocaleNotifier>(),
    ),
  );
  getIt.registerLazySingleton<AccountLogApiService>(
    () => AccountLogApiService(DioFactory.createDio(apiUrl, router: router)),
  );
  getIt.registerLazySingleton<AccountLogReponsitory>(
    () => AccountLogRepositoryImpl(getIt()),
  );
  getIt.registerLazySingleton<ChangePasswordRepository>(
    () => ChangePasswordRepositoryImpl(getIt()),
  );
  getIt.registerFactory(
    () => ChangePasswordViewModel(ChangePasswordUsecase(getIt())),
  );
  getIt.registerFactory<InviteFriendsViewModel>(() => InviteFriendsViewModel());
  getIt.registerLazySingleton<ReferralRepository>(
    () => ReferralRepositoryImpl(getIt()),
  );
  getIt.registerLazySingleton<GetReferallsUsecase>(
    () => GetReferallsUsecase(getIt<ReferralRepository>()),
  );
  getIt.registerLazySingleton<GetRankingUsecase>(
    () => GetRankingUsecase(getIt<ReferralRepository>()),
  );
  getIt.registerLazySingleton(
    () => ProfileViewModel(
      AccountLogUseCase(getIt()),
      getIt<GlobalViewModel>(),
      getIt<MyApiKeyUsecase>(),
    ),
  );

  getIt.registerLazySingleton<TwoFaRepository>(
    () => TwoFaRepositoryImpl(getIt()),
  );
  getIt.registerLazySingleton<TwoFaUseCase>(() => TwoFaUseCase(getIt()));
  getIt.registerFactory<RecordViewModel>(
    () => RecordViewModel(
      getIt<GetDepositRecordUsecase>(),
      getIt<GetWithdrawRecordsUsecase>(),
      getIt<GlobalViewModel>(),
    ),
  );
  getIt.registerFactory<DepositViewModel>(
    () => DepositViewModel(
      childCurrencyUsecase: GetChildCurrencyUsecase(getIt()),
      getDepositAddressUsecase: GetDepositAddressUsecase(getIt()),
    ),
  );

  getIt.registerFactory<WithdrawEarnViewmodel>(() => WithdrawEarnViewmodel());
  getIt.registerFactoryParam<WithdrawViewModel, String?, void>(
    (currency, _) => WithdrawViewModel(
      getIt<GlobalViewModel>(),
      SelectCoinWithdrawUseCase(getIt()),
      SelectNetworkWithdrawUseCase(getIt()),
      HistoryWithdrawUseCase(getIt()),
      AddBeneficiaryWithdrawUseCase(getIt()),
      ActiveBeneficiaryWithdrawUseCase(getIt()),
      DeleteBeneficiaryWithdrawUseCase(getIt()),
      ExecuteWithdrawUseCase(getIt()),
      currency,
    ),
  );
  getIt.registerFactory<AssetFeeViewModel>(
    () => AssetFeeViewModel(
      getIt<GlobalViewModel>(),
      getIt<GetFilterNetworkUseCase>(),
    ),
  );
  getIt.registerFactory<GetFilterNetworkUseCase>(
    () => GetFilterNetworkUseCase(getIt<AssetRepository>()),
  );
  getIt.registerLazySingleton<MyApiKeyRepository>(
    () => MyApiKeyRepositoryImpl(getIt<HomeApiService>()),
  );
  getIt.registerLazySingleton<MyApiKeyUsecase>(
    () => MyApiKeyUsecase(getIt<MyApiKeyRepository>()),
  );
  getIt.registerLazySingleton<GetStakeProductUsecase>(
    () => GetStakeProductUsecase(getIt<StakeRepository>()),
  );
  getIt.registerFactory<StakeViewModel>(
    () => StakeViewModel(
      getIt<GetStakeProductUsecase>(),
      GetStakeRecordsUseCase(getIt()),
      getIt<GlobalViewModel>(),
    ),
  );
}
