import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/data/models/asset/Record/record_model.dart';
import 'package:alpha/presentation/view_models/asset/record/record_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'record_item.dart';

class RecordList extends StatefulWidget {
  final dynamic type;
  final List<RecordData> records;

  const RecordList({super.key, required this.type, required this.records});

  @override
  State<RecordList> createState() => _RecordListState();
}

class _RecordListState extends State<RecordList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoadingMore = context.select(
      (RecordViewModel vm) => vm.isLoadingMore,
    );
    final triggeredPages = context.select(
      (RecordViewModel vm) => vm.triggeredPages,
    );
    final loadMore = context.select((RecordViewModel vm) => vm.loadMore);
    return ListView.separated(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      separatorBuilder: (context, index) => SizedBox(height: AppSize.size15.h),
      itemCount: widget.records.length + (isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        final limit =
            widget.type.toString().contains(context.appLocaleLanguage.deposits)
            ? 25
            : 20;
        final currentPageOfItem = (index ~/ limit) + 1;
        final positionInPage = index % limit;

        if (positionInPage == limit - 5 &&
            !isLoadingMore &&
            !triggeredPages.contains(currentPageOfItem)) {
          triggeredPages.add(currentPageOfItem);
          loadMore(widget.type);
        }
        final record = widget.records[index];
        return RecordItem(record: record, type: widget.type);
      },
    );
  }
}
