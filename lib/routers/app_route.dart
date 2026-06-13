import 'package:alpha/core/base/base_view_model.dart';
import 'package:alpha/core/utils/enums.dart';
import 'package:alpha/data/models/asset/asset_detail_model.dart';
import 'package:alpha/data/models/auth/register_body_request_model.dart';
import 'package:alpha/data/models/home_market/coin_model/coin_detail_model.dart';
import 'package:alpha/data/models/home_market/coin_model/coin_model.dart';
import 'package:alpha/data/models/my_api_key/api_key_model.dart';
import 'package:alpha/presentation/pages/asset_fee/asset_fee_screen.dart';
import 'package:alpha/presentation/pages/assets/asset_detail_screen.dart';
import 'package:alpha/presentation/pages/assets/deposit/deposit_screen.dart';
import 'package:alpha/presentation/pages/assets/record/record_screen.dart';
import 'package:alpha/presentation/pages/auth/choose-language/choose_language_screen.dart';
import 'package:alpha/presentation/pages/auth/forgot_password/forgot_password_screen.dart';
import 'package:alpha/presentation/pages/auth/login/login_screen.dart';
import 'package:alpha/presentation/pages/auth/register/register_screen.dart';
import 'package:alpha/presentation/pages/auth/reset_password/reset_password.dart';
import 'package:alpha/presentation/pages/discover/crypto_list/coin_list_crypto_detail.dart';
import 'package:alpha/presentation/pages/discover/discover_screen.dart';
import 'package:alpha/presentation/pages/earn/earn_screen.dart';
import 'package:alpha/presentation/pages/earn/transaction/transaction_screen.dart';
import 'package:alpha/presentation/pages/earn/withdraw/withdraw_earn_screen.dart';
import 'package:alpha/presentation/pages/home/search_screen.dart';
import 'package:alpha/presentation/pages/invite_friends/invite_friend_screen.dart';
import 'package:alpha/presentation/pages/main/main_screen.dart';
import 'package:alpha/presentation/pages/profile/information/infomation_screen.dart';
import 'package:alpha/presentation/pages/profile/language/language_screen.dart';
import 'package:alpha/presentation/pages/profile/my_api_key/detail_api_key_screen.dart';
import 'package:alpha/presentation/pages/profile/my_api_key/my_api_key_screen.dart';
import 'package:alpha/presentation/pages/splash/splash_screen.dart';
import 'package:alpha/presentation/pages/stakes/stake/stake_screen.dart';
import 'package:alpha/presentation/pages/stakes/stake_record/stake_record_screen.dart';
import 'package:alpha/presentation/pages/trading/chart/order_portal/order_portal.dart';
import 'package:alpha/presentation/pages/trading/trading_screen.dart';
import 'package:alpha/routers/router_name.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/network/auth_change_notifier.dart';
import '../presentation/pages/announcements/announcement_detail_args.dart';
import '../presentation/pages/announcements/announcements_screen.dart';
import '../presentation/pages/announcements/article_detail_screen.dart';
import '../presentation/pages/assets/assets_screen.dart';
import '../presentation/pages/assets/withdraw/withdraw_screen.dart';
import '../presentation/pages/home/home_screen.dart';
import '../presentation/pages/profile/account_security/account_security_screen.dart';
import '../presentation/pages/profile/profile_screen.dart';

class AppRouter {
  final GoRouter router;

  AppRouter(AuthChangeNotifier authNotifier)
    : router = GoRouter(
        navigatorKey: BaseViewModel.navigatorKey,
        initialLocation: RouterPath.splash,
        debugLogDiagnostics: true,
        routes: [
          GoRoute(
            path: RouterPath.splash,
            name: RouterName.splash,
            builder: (context, state) => const SplashScreen(),
          ),
          GoRoute(
            path: RouterPath.login,
            name: RouterName.login,
            builder: (context, state) =>
                LoginScreen(emailFromRegister: state.extra as String?),
          ),
          GoRoute(
            path: RouterPath.register,
            name: RouterName.register,
            builder: (context, state) {
              return const RegisterScreen();
            },
          ),
          GoRoute(
            path: RouterPath.forgotPassword,
            name: RouterName.forgotPassword,
            builder: (context, state) {
              return const ForgotPasswordPage();
            },
          ),
          GoRoute(
            path: RouterPath.resetPassword,
            name: RouterName.resetPassword,
            builder: (context, state) {
              return const ResetPasswordPage();
            },
          ),
          GoRoute(
            path: RouterPath.chooseLanguage,
            name: RouterName.chooseLanguage,
            builder: (context, state) {
              final extra = state.extra;
              final requestBody = extra is Map<String, dynamic>
                  ? RegisterBodyRequest.fromJson(extra)
                  : extra as RegisterBodyRequest;
              return ChooseLanguageScreen(bodyFromRegister: requestBody);
            },
          ),
          GoRoute(
            path: RouterPath.search,
            builder: (context, state) => const SearchScreen(),
          ),
          GoRoute(
            path: RouterPath.cryptoDetail,
            name: RouterName.cryptoDetail,
            builder: (context, state) {
              final coin = state.extra as CoinDetailModel?;
              return CoinListCryptoDetail(coin: coin);
            },
          ),
          GoRoute(
            path: RouterPath.language,
            name: RouterName.language,
            builder: (context, state) => LanguageScreen(),
          ),
          ShellRoute(
            routes: [
              GoRoute(
                path: RouterPath.home,
                name: RouterName.home,
                builder: (context, state) => HomeScreen(),
              ),
              GoRoute(
                path: RouterPath.discover,
                name: RouterName.discover,
                builder: (context, state) => const DiscoverScreen(),
              ),
              GoRoute(
                path: RouterPath.trade,
                name: RouterName.trade,
                builder: (context, state) {
                  final extra = state.extra;
                  final coin = extra is Map<String, dynamic>
                      ? CoinModel.fromJson(extra)
                      : extra as CoinModel?;
                  return TradingScreen(
                    coin: coin,
                    isChangeCoin: coin != null,
                    key: ValueKey('trade_${coin?.id}'),
                  );
                },
              ),
              GoRoute(
                path: RouterPath.earn,
                name: RouterName.earn,
                builder: (context, state) => const EarnScreen(),
              ),
              GoRoute(
                path: RouterPath.assets,
                name: RouterName.assets,
                builder: (context, state) => const AssetsScreen(),
                routes: [
                  GoRoute(
                    path: RouterPath.assetDetail,
                    name: RouterName.assetDetail,
                    builder: (context, state) => AssetDetailScreen(
                      assetData: state.extra as AssetDetailModel,
                    ),
                  ),
                ],
              ),
            ],
            builder: (context, state, child) => MainScreen(child: child),
          ),
          GoRoute(
            path: RouterPath.announcements,
            name: RouterName.announcements,
            builder: (context, state) => const AnnouncementsScreen(),
          ),
          GoRoute(
            path: RouterPath.articleDetail,
            name: RouterName.articleDetail,
            builder: (context, state) {
              final args = state.extra as AnnouncementDetailArgs;
              return ArticleDetailScreen(
                item: args.item,
                tabTitle: args.tabTitle,
                subTabTitle: args.subTabTitle,
              );
            },
          ),
          GoRoute(
            path: RouterPath.profile,
            name: RouterName.profile,
            builder: (context, state) {
              return const ProfileScreen();
            },
          ),
          GoRoute(
            path: RouterPath.accountSecurity,
            name: RouterName.accountSecurity,
            builder: (context, state) {
              return const AccountSecurityScreen();
            },
          ),
          GoRoute(
            path: RouterPath.inviteFriend,
            name: RouterName.inviteFriend,
            builder: (context, state) {
              return const InviteFriendsScreen();
            },
          ),
          GoRoute(
            path: RouterPath.infomation,
            name: RouterName.infomation,
            builder: (context, state) {
              return const InformationScreen();
            },
          ),
          GoRoute(
            path: RouterPath.record,
            name: RouterName.record,
            builder: (context, state) {
              return RecordScreen(type: state.extra as RecordType);
            },
          ),
          GoRoute(
            path: RouterPath.deposit,
            builder: (context, state) {
              return DepositScreen(currency: state.extra as String?);
            },
          ),
          GoRoute(
            path: RouterPath.withdraw,
            name: RouterName.withdraw,
            builder: (context, state) {
              return WithdrawScreen(currency: state.extra as String?);
            },
          ),
          GoRoute(
            path: RouterPath.withdraw_earn,
            name: RouterName.withdraw_earn,
            builder: (context, state) {
              return WithDrawEarnScreen(currency: state.extra as String?);
            },
          ),
          GoRoute(
            path: RouterPath.transaction,
            name: RouterName.transaction,
            builder: (context, state) {
              return TransactionScreen(type: state.extra as TransactionType);
            },
          ),
          GoRoute(
            path: RouterPath.orderPortal,
            name: RouterName.orderPortal,
            builder: (context, state) {
              return OrderPortal();
            },
          ),
          GoRoute(
            path: RouterPath.assetFee,
            name: RouterName.assetFee,
            builder: (context, state) {
              return AssetFeeScreen();
            },
          ),
          GoRoute(
            path: RouterPath.myApiKey,
            name: RouterName.myApiKey,
            builder: (context, state) {
              return MyApiKeyScreen();
            },
          ),
          GoRoute(
            path: RouterPath.detailApiKey,
            name: RouterName.detailApiKey,
            builder: (context, state) {
              final apiKey = state.extra as ApiKeyModel;
              return DetailApiKeyScreen(apiKey: apiKey);
            },
          ),
          GoRoute(
            path: RouterPath.stake,
            name: RouterName.stake,
            builder: (context, state) {
              return StakeScreen();
            },
          ),
          GoRoute(
            path: RouterPath.stakeRecord,
            name: RouterName.stakeRecord,
            builder: (context, state) {
              return StakeRecordScreen();
            },
          ),
        ],
        redirect: (context, state) async {
          final matchedLocation = state.matchedLocation;
          final isAuthenticated = await authNotifier.checkLogin;
          final loggingIn = matchedLocation == RouterPath.login;
          final registering = matchedLocation == RouterPath.register;
          final atChooseLanguage = matchedLocation == RouterPath.chooseLanguage;
          final atForgotPassword = matchedLocation == RouterPath.forgotPassword;
          final atSplash = matchedLocation == RouterPath.splash;
          if (AppRouter.getScreenAccessPublic(matchedLocation)) return null;
          if (isAuthenticated) {
            return (loggingIn || registering) ? RouterPath.home : null;
          }
          return (loggingIn ||
                  registering ||
                  atChooseLanguage ||
                  atForgotPassword ||
                  atSplash)
              ? null
              : RouterPath.login;
        },
        refreshListenable: authNotifier,
      ) {}

  static bool getScreenAccessPublic(String matchedLocation) {
    const Set<String> publicRoutes = {
      RouterPath.home,
      RouterPath.trade,
      RouterPath.discover,
      RouterPath.search,
      RouterPath.announcements,
    };
    return publicRoutes.contains(matchedLocation);
  }
}
