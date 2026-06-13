import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/presentation/pages/announcements/widgets/announcements_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';

import '../../../core/base/base_view.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_size.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/widgets/custom_header_search.dart';
import '../../view_models/announcements/announcements_viewmodel.dart';
import 'asset_screen.dart';
import 'events_screen.dart';
import 'update_screen.dart';
import 'whats_new_screen.dart';
import 'widgets/announcements_tab_bar.dart';

class AnnouncementsScreen extends StatefulWidget {
  const AnnouncementsScreen({super.key});

  @override
  State<AnnouncementsScreen> createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  Widget build(BuildContext context) {
    return BaseView<AnnouncementsViewModel>(
      viewModelBuilder: () => GetIt.I<AnnouncementsViewModel>(),
      onModelReady: (vm) {
        vm.fetchBanners();
        if (_tabController == null) {
          _tabController = TabController(
            length: vm.groupedSidebarTabs.length,
            vsync: this,
            initialIndex: vm.currentTabIndex,
          );
        }
        _tabController?.addListener(() {
          if (!_tabController!.indexIsChanging) {
            vm.changeTab(_tabController!.index);
          }
        });
      },
      builder: (context, vm, child) {
        if (vm.isBusy) {
          return const Center(child: CircularProgressIndicator());
        }
        if (vm.errorMessage != null) {
          return Center(
            child: Text(
              vm.errorMessage ?? context.appLocaleLanguage.errorMessage,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }
        return Scaffold(
          backgroundColor: AppColors.background,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnnouncementsAppBar(),
              CustomHeaderSearch(
                backgroundColor: AppColors.background,
                isChecked: false,
                titleWidget: Container(
                  width: double.infinity,
                  height: AppSize.size38.h,
                  decoration: BoxDecoration(
                    color: AppColors.iconSearch,
                    borderRadius: BorderRadius.circular(AppSize.size4.r),
                  ),
                  child: TextField(
                    autofocus: true,
                    textAlignVertical: TextAlignVertical.center,
                    style: TextStyle(fontSize: AppSize.size14.sp),
                    onChanged: vm.updateSearchQuery,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.search,
                        color: AppColors.grey,
                        size: AppSize.size20.sp,
                      ),
                      hintStyle: TextStyle(
                        color: AppColors.grey,
                        fontSize: AppSize.size12.sp,
                      ),
                      hintText: context.appLocaleLanguage.search,
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ),

              AnnouncementsTabBar(
                tabController: _tabController!,
                tabItems: vm.groupedSidebarTabs,
              ),
              const SizedBox(height: AppSpacing.space16),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: const [
                    WhatsNewScreen(),
                    AssetScreen(),
                    EventsScreen(),
                    UpdateScreen(),
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
    _tabController?.dispose();
    super.dispose();
  }
}
