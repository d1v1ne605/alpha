import 'package:alpha/core/base/base_view.dart';
import 'package:alpha/core/constants/app_svg.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/widgets/custom_navbottom_bar.dart';
import 'package:alpha/data/models/navbar/nav_item.dart';
import 'package:alpha/injection/injector.dart';
import 'package:alpha/presentation/view_models/main/main_view_model.dart';
import 'package:alpha/routers/router_name.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainScreen extends StatefulWidget {
  final Widget child;

  const MainScreen({super.key, required this.child});

  static List<NavItem> navItems(BuildContext context) => [
    NavItem(
      icon: AppSvg.home,
      label: context.appLocaleLanguage.home,
      route: RouterPath.home,
    ),
    NavItem(
      icon: AppSvg.scan,
      label: context.appLocaleLanguage.discover,
      route: RouterPath.discover,
    ),
    NavItem(
      icon: AppSvg.chart,
      label: context.appLocaleLanguage.trade,
      route: RouterPath.trade,
      isCenter: true,
    ),
    NavItem(
      icon: AppSvg.earn_assets,
      label: context.appLocaleLanguage.earn,
      route: RouterPath.earn,
    ),
    NavItem(
      icon: AppSvg.assets,
      label: context.appLocaleLanguage.assets,
      route: RouterPath.assets,
    ),
  ];

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final String location = GoRouterState.of(context).uri.toString();
    final int currentIndex = _getCurrentTabIndex(location, context);
    return BaseView<MainViewModel>(
      autoDispose: false,
      onModelReady: (vm) async {
        await vm.initDefaultCoin();
      },
      viewModelBuilder: () => getIt<MainViewModel>(),
      builder: (context, vm, _) {
        return Scaffold(
          body: Column(children: [Expanded(child: widget.child)]),
          bottomNavigationBar: CustomNavBar(
            items: MainScreen.navItems(context),
            currentIndex: currentIndex,
            onTap: (index) {
              context.go(MainScreen.navItems(context)[index].route);
            },
          ),
        );
      },
    );
  }

  int _getCurrentTabIndex(String location, BuildContext context) {
    final navItems = MainScreen.navItems(context);
    int exactMatch = navItems.indexWhere((item) => item.route == location);
    if (exactMatch != -1) return exactMatch;
    for (int i = 0; i < navItems.length; i++) {
      if (location.startsWith(navItems[i].route)) {
        return i;
      }
    }
    return 0;
  }

  @override
  bool get wantKeepAlive => true;
}
