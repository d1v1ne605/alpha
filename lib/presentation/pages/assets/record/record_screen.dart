import 'package:alpha/core/base/base_view.dart';
import 'package:alpha/core/utils/enums.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/widgets/banners/custom_tab_bar.dart';
import 'package:alpha/injection/injector.dart';
import 'package:alpha/presentation/pages/assets/record/record_body.dart';
import 'package:alpha/presentation/pages/assets/record/record_header.dart';
import 'package:alpha/presentation/view_models/asset/record/record_view_model.dart';
import 'package:flutter/material.dart';

class RecordScreen extends StatefulWidget {
  final RecordType type;

  const RecordScreen({Key? key, required this.type}) : super(key: key);

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    tabs = [
      Tab(text: context.appLocaleLanguage.assetsButtonDeposit),
      Tab(text: context.appLocaleLanguage.assetsButtonWithdraw),
    ];
  }

  late final TabController _tabController = TabController(
    length: tabs.length,
    vsync: this,
    initialIndex: widget.type == RecordType.deposit ? 0 : 1,
  );

  late List<Tab> tabs;

  @override
  Widget build(BuildContext context) {
    return BaseView(
      viewModelBuilder: () => getIt<RecordViewModel>(),
      useSelector: true,
      builder: (context, vm, child) {
        onTabChanged(vm);
        return Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RecordHeader(vm: vm),
              Expanded(
                child: Column(
                  children: [
                    CustomTabBar(controller: _tabController, tabs: tabs),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: const [
                          RecordBody(recordType: RecordType.deposit),
                          RecordBody(recordType: RecordType.withdraw),
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

  void onTabChanged(RecordViewModel vm) {
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        final newType = _tabController.index == 0
            ? RecordType.deposit
            : RecordType.withdraw;
        vm.currentRecordType = newType;
      }
    });
  }
}
