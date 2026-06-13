import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/utils/enums.dart';
import 'package:alpha/presentation/pages/earn/transaction/transaction_item.dart';
import 'package:alpha/presentation/view_models/earn/earn_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class TransactionList<T> extends StatefulWidget {
  final TransactionType type;
  final List<T> records;

  const TransactionList({super.key, required this.type, required this.records});

  @override
  State<TransactionList<T>> createState() => _TransactionListState<T>();
}

class _TransactionListState<T> extends State<TransactionList<T>> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoadingMore = widget.type == TransactionType.reward
        ? context.select((EarnViewModel vm) => vm.isLoadingMoreRewards)
        : context.select((EarnViewModel vm) => vm.isLoadingMoreWithdraw);
    final triggeredPages = widget.type == TransactionType.reward
        ? context.select((EarnViewModel vm) => vm.triggeredPagesRewards)
        : context.select((EarnViewModel vm) => vm.triggeredPagesWithdraw);
    final loadMore = widget.type == TransactionType.reward
        ? context.select((EarnViewModel vm) => vm.loadMoreRewards)
        : context.select((EarnViewModel vm) => vm.loadMoreWithdrawRecords);

    return RefreshIndicator(
      onRefresh: () async {
        if (widget.type == TransactionType.reward) {
          await context.read<EarnViewModel>().refreshRewards();
        } else {
          await context.read<EarnViewModel>().refreshWithdrawRecords();
        }
      },
      child: ListView.separated(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        separatorBuilder: (context, index) =>
            SizedBox(height: AppSize.size15.h),
        itemCount: widget.records.length + (isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          const limit = 10;
          final currentPageOfItem = (index ~/ limit) + 1;
          final positionInPage = index % limit;
          if (positionInPage == limit - 3 &&
              !isLoadingMore &&
              !triggeredPages.contains(currentPageOfItem)) {
            triggeredPages.add(currentPageOfItem);
            loadMore();
          }
          if (index >= widget.records.length) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ),
            );
          }
          final record = widget.records[index];
          return TransactionItem(record: record, type: widget.type);
        },
      ),
    );
  }
}
