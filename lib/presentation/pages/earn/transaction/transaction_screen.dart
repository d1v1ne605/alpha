import 'package:alpha/core/base/base_view.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/enums.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/widgets/app_header.dart';
import 'package:alpha/core/widgets/banners/custom_tab_bar.dart';
import 'package:alpha/injection/injector.dart';
import 'package:alpha/presentation/pages/earn/transaction/transaction_body.dart';
import 'package:alpha/presentation/view_models/earn/earn_view_model.dart';
import 'package:flutter/material.dart';

class TransactionScreen extends StatefulWidget {
  final TransactionType type;

  const TransactionScreen({Key? key, required this.type}) : super(key: key);

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    tabs = [
      Tab(
        child: Text(
          context.appLocaleLanguage.rewards,
          style: AppTextStyles.title2.copyWith(fontWeight: FontWeight.w500),
        ),
      ),
      Tab(
        child: Text(
          context.appLocaleLanguage.withdrawRecords,
          style: AppTextStyles.title2.copyWith(fontWeight: FontWeight.w500),
        ),
      ),
    ];
  }

  late final TabController _tabController = TabController(
    length: tabs.length,
    vsync: this,
    initialIndex: widget.type == TransactionType.reward ? 0 : 1,
  );

  late List<Tab> tabs;

  @override
  Widget build(BuildContext context) {
    return BaseView(
      viewModelBuilder: () => getIt<EarnViewModel>(),
      useSelector: true,
      autoDispose: false,
      builder: (context, vm, child) {
        return Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppHeader(textTitle: context.appLocaleLanguage.transactions),
              Expanded(
                child: Column(
                  children: [
                    CustomTabBar(controller: _tabController, tabs: tabs),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: const [
                          TransactionBody(recordType: TransactionType.reward),
                          TransactionBody(
                            recordType: TransactionType.withdraw_records,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
