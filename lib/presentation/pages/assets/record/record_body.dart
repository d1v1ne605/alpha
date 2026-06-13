import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/utils/enums.dart';
import 'package:alpha/core/widgets/custom_no_data.dart';
import 'package:alpha/data/models/asset/Record/record_model.dart';
import 'package:alpha/presentation/pages/assets/record/record_filter_type.dart';
import 'package:alpha/presentation/pages/assets/record/record_list.dart';
import 'package:alpha/presentation/view_models/asset/record/record_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class RecordBody extends StatefulWidget {
  final RecordType recordType;
  const RecordBody({super.key, required this.recordType});

  @override
  State<RecordBody> createState() => _RecordBodyState();
}

class _RecordBodyState extends State<RecordBody>
    with AutomaticKeepAliveClientMixin {
  RecordViewModel? _recordViewModel;
  RecordViewModel get vm {
    return _recordViewModel ??= context.read<RecordViewModel>();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    vm.currentRecordType = widget.recordType;
    vm.init(widget.recordType);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: AppSize.size15.h,
        horizontal: AppSize.size20.w,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RecordFilterType(vm: vm),
          SizedBox(height: AppSize.size15.h),
          Selector<
            RecordViewModel,
            ({
              bool isBusy,
              List<RecordData> depositRecords,
              List<RecordData> withdrawRecords,
            })
          >(
            selector: (_, viewModel) => (
              isBusy: viewModel.isBusy,
              depositRecords: viewModel.depositRecords,
              withdrawRecords: viewModel.withdrawRecords,
            ),
            builder: (context, data, child) {
              return Expanded(
                child: data.isBusy
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      )
                    : widget.recordType == RecordType.deposit &&
                          data.depositRecords.isEmpty
                    ? const CustomNoData()
                    : widget.recordType == RecordType.withdraw &&
                          data.withdrawRecords.isEmpty
                    ? const CustomNoData()
                    : RecordList(
                        type: widget.recordType,
                        records: widget.recordType == RecordType.deposit
                            ? data.depositRecords
                            : data.withdrawRecords,
                      ),
              );
            },
          ),
        ],
      ),
    );
  }
}
