import 'dart:async';

import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/network/auth_change_notifier.dart';
import 'package:alpha/core/utils/lang/language.dart';
import 'package:alpha/data/services/local/hive_service.dart';
import 'package:alpha/injection/injector.dart';
import 'package:alpha/presentation/view_models/locale_langue/locale_language_view_model.dart';
import 'package:alpha/routers/app_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'core/utils/lang/config/app_locale_language.dart';

// Function to load environment configuration
Future<void> _loadEnvironmentConfig() async {
  try {
    // Try to load .env file first
    await dotenv.load(fileName: ".env");
  } catch (e) {
    // If .env file doesn't exist, the app will use EnvConfig as fallback
    print('Warning: .env file not found, using default configuration');
  }
}

void main() async {
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await _loadEnvironmentConfig();

    final appRouter = AppRouter(AuthChangeNotifier());

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: AppColors.background,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    setupDependencies(appRouter.router);
    await getIt<HiveService>().init();

    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => AuthChangeNotifier()),
          ChangeNotifierProvider.value(value: getIt<LocaleNotifier>()),
        ],
        child: ScreenUtilInit(
          designSize: const Size(428, 926),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return MyApp(router: appRouter.router);
          },
        ),
      ),
    );
  }, (error, stack) {});
}

class MyApp extends StatelessWidget {
  final GoRouter router;

  const MyApp({super.key, required this.router});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      supportedLocales: Language.all,
      locale: context.watch<LocaleNotifier>().locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'IBMPlexSans',
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.background,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: AppColors.textPrimary),
          bodyMedium: TextStyle(color: AppColors.textPrimary),
          bodySmall: TextStyle(color: AppColors.textPrimary),
        ),
      ),
      routerDelegate: router.routerDelegate,
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,
    );
  }
}
