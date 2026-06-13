import 'package:alpha/core/base/base_view_model.dart';
import 'package:alpha/core/constants/app_string.dart';
import 'package:alpha/core/mixins/local_storage/local_storage_mixin.dart';
import 'package:alpha/core/utils/enums.dart';
import 'package:alpha/core/utils/format_usdt.dart';
import 'package:alpha/data/models/asset/Record/record_model.dart';
import 'package:alpha/domain/usecase/records/get_deposit_records_usecase.dart';
import 'package:alpha/domain/usecase/records/get_withdraw_records_usecase.dart';

import '../../../../core/constants/app_string_uri.dart';
import '../../global_view_model.dart';

class RecordViewModel extends BaseViewModel with LocalStorageMixin {
  final GetDepositRecordUsecase _getDepositRecordUsecase;
  final GetWithdrawRecordsUsecase _getWithdrawRecordsUsecase;
  final GlobalViewModel _globalViewModel;

  RecordViewModel(
    this._getDepositRecordUsecase,
    this._getWithdrawRecordsUsecase,
    this._globalViewModel,
  );

  List<RecordData> _depositRecords = [];
  List<RecordData> get depositRecords => _depositRecords;

  List<RecordData> _withdrawRecords = [];
  List<RecordData> get withdrawRecords => _withdrawRecords;

  RecordType _currentRecordType = RecordType.deposit;
  RecordType get currentRecordType => _currentRecordType;
  set currentRecordType(RecordType type) {
    _currentRecordType = type;
    notifyListeners();
  }

  final List<RecordData> _allDepositRecordData = [];
  final List<RecordData> _allWithdrawRecordData = [];
  List<RecordData> get allRecordData => _currentRecordType == RecordType.deposit
      ? _allDepositRecordData
      : _allWithdrawRecordData;

  int _currentPageDeposit = 1;
  int _currentPageWithdraw = 1;
  int get currentPage => _currentRecordType == RecordType.deposit
      ? _currentPageDeposit
      : _currentPageWithdraw;
  set currentPage(int page) {
    if (_currentRecordType == RecordType.deposit) {
      _currentPageDeposit = page;
    } else {
      _currentPageWithdraw = page;
    }
  }

  int _totalPagesDeposit = 1;
  int _totalPagesWithdraw = 1;
  int get totalPages => _currentRecordType == RecordType.deposit
      ? _totalPagesDeposit
      : _totalPagesWithdraw;
  set totalPages(int pages) {
    if (_currentRecordType == RecordType.deposit) {
      _totalPagesDeposit = pages;
    } else {
      _totalPagesWithdraw = pages;
    }
  }

  bool _isLoadingMoreDeposit = false;
  bool get isLoadingMoreDeposit => _isLoadingMoreDeposit;
  bool _isLoadingMoreWithdraw = false;
  bool get isLoadingMoreWithdraw => _isLoadingMoreWithdraw;
  bool get isLoadingMore => _currentRecordType == RecordType.deposit
      ? _isLoadingMoreDeposit
      : _isLoadingMoreWithdraw;
  set isLoadingMore(bool value) {
    if (_currentRecordType == RecordType.deposit) {
      _isLoadingMoreDeposit = value;
    } else {
      _isLoadingMoreWithdraw = value;
    }
  }

  final Set<int> _triggeredPagesDeposit = {};
  Set<int> get triggeredPagesDeposit => _triggeredPagesDeposit;
  final Set<int> _triggeredPagesWithdraw = {};
  Set<int> get triggeredPagesWithdraw => _triggeredPagesWithdraw;
  Set<int> get triggeredPages => _currentRecordType == RecordType.deposit
      ? _triggeredPagesDeposit
      : _triggeredPagesWithdraw;
  set triggeredPages(Set<int> pages) {
    if (_currentRecordType == RecordType.deposit) {
      _triggeredPagesDeposit.addAll(pages);
    } else {
      _triggeredPagesWithdraw.addAll(pages);
    }
  }

  String? selectedTypeDeposit;
  String? selectedTypeWithdraw;
  String? get selectedType => _currentRecordType == RecordType.deposit
      ? selectedTypeDeposit
      : selectedTypeWithdraw;
  set selectedType(String? type) {
    if (_currentRecordType == RecordType.deposit) {
      selectedTypeDeposit = type;
    } else {
      selectedTypeWithdraw = type;
    }
  }

  DateTime? fromDateDeposit;
  DateTime? fromDateWithdraw;
  DateTime? get fromDate => _currentRecordType == RecordType.deposit
      ? fromDateDeposit
      : fromDateWithdraw;
  set fromDate(DateTime? date) {
    if (_currentRecordType == RecordType.deposit) {
      fromDateDeposit = date;
    } else {
      fromDateWithdraw = date;
    }
  }

  DateTime? toDateDeposit;
  DateTime? toDateWithdraw;
  DateTime? get toDate =>
      _currentRecordType == RecordType.deposit ? toDateDeposit : toDateWithdraw;
  set toDate(DateTime? date) {
    if (_currentRecordType == RecordType.deposit) {
      toDateDeposit = date;
    } else {
      toDateWithdraw = date;
    }
  }

  bool fromDateError = false;
  bool toDateError = false;

  bool get canFilter {
    return !fromDateError && !toDateError && fromDate != null && toDate != null;
  }

  RecordData _mapIconUrl(RecordData record, RecordType type) {
    String? iconUrl;

    if (type == RecordType.deposit) {
      final currencyCode = record.currency?.toLowerCase();
      if (currencyCode != null) {
        final currencyModel = _globalViewModel.currencies[currencyCode];
        iconUrl = currencyModel?.icon_url ?? AppStringUri.alphaIconUrl;
      }
    } else {
      iconUrl = record.withdrawCurrency?.iconUrl;
    }

    return record.copyWith(iconUrl: iconUrl);
  }

  List<RecordData> _mapIconsForRecords(
    List<RecordData> records,
    RecordType type,
  ) {
    return records.map((record) => _mapIconUrl(record, type)).toList();
  }

  Future<void> loadRecords({
    required RecordType type,
    int? limit,
    bool isLoadMore = false,
    bool isRefresh = false,
  }) async {
    if (isLoadMore) {
      isLoadingMore = true;
    }
    if (!isLoadMore && !isRefresh) setBusy(true);
    try {
      final effectiveLimit = limit ?? (type == RecordType.deposit ? 25 : 20);

      final response = type == RecordType.deposit
          ? await _getDepositRecordUsecase(
              page: _currentPageDeposit,
              limit: effectiveLimit,
            )
          : await _getWithdrawRecordsUsecase(
              page: _currentPageWithdraw,
              limit: effectiveLimit,
            );

      final newRecords = _mapIconsForRecords(
        List<RecordData>.from(response.data ?? []),
        type,
      );

      if (isLoadMore) {
        if (type == RecordType.deposit) {
          _allDepositRecordData.addAll(newRecords);
        } else {
          _allWithdrawRecordData.addAll(newRecords);
        }
        _applyActiveFilters();
      } else {
        if (type == RecordType.deposit) {
          _allDepositRecordData.clear();
          _allDepositRecordData.addAll(newRecords);
          _depositRecords = List<RecordData>.from(_allDepositRecordData);
        } else {
          _allWithdrawRecordData.clear();
          _allWithdrawRecordData.addAll(newRecords);
          _withdrawRecords = List<RecordData>.from(_allWithdrawRecordData);
        }
        _applyActiveFilters();
      }
      currentPage = response.pagination?.page ?? 1;
      totalPages = response.pagination?.totalPages ?? 1;
    } catch (e) {
      setError('Error loading ${type.name} records::$e');
    } finally {
      if (isLoadMore) {
        isLoadingMore = false;
      }
      Future.microtask(() {
        setBusy(false);
      });
    }
  }

  void _applyActiveFilters() {
    List<RecordData> filteredList = List.from(allRecordData);
    if (fromDate != null || toDate != null) {
      filteredList = filteredList.where((e) {
        final date = e.createdAt ?? e.created_at;
        return date != null &&
            (fromDate == null ||
                FormatterUtils.isSameOrAfter(date, fromDate!)) &&
            (toDate == null || FormatterUtils.isSameOrBefore(date, toDate!));
      }).toList();
    }

    if (selectedType != null) {
      filteredList = filteredList.where((e) {
        String? recordStatus = _currentRecordType == RecordType.withdraw
            ? (e as dynamic).status as String?
            : (e as dynamic).state as String?;
        if (recordStatus == 'collected') {
          recordStatus = 'completed';
        }
        return recordStatus?.toLowerCase() == selectedType!.toLowerCase();
      }).toList();
    }

    currentRecordType == RecordType.deposit
        ? _depositRecords = List.from(filteredList)
        : _withdrawRecords = List.from(filteredList);
  }

  Future<void> loadMore(RecordType type) async {
    if (isLoadingMore || currentPage >= totalPages) return;
    currentPage++;
    await loadRecords(type: type, isLoadMore: true);
  }

  Future<void> refreshRecords(RecordType type) async {
    type == RecordType.deposit
        ? _triggeredPagesDeposit.clear()
        : _triggeredPagesWithdraw.clear();
    await loadRecords(type: type, isRefresh: true);
  }

  void init(RecordType type) {
    loadRecords(type: type);
  }

  void setDate(bool isFrom, DateTime date) {
    if (isFrom) {
      fromDate = date;
      if (toDate != null && fromDate!.isAfter(toDate!)) {
        fromDateError = true;
      } else {
        fromDateError = false;
        toDateError = false;
      }
    } else {
      toDate = date;
      if (fromDate != null && toDate!.isBefore(fromDate!)) {
        toDateError = true;
      } else {
        fromDateError = false;
        toDateError = false;
      }
    }
    notifyListeners();
  }

  void filterByDate() {
    _applyActiveFilters();
    notifyListeners();
  }

  void filterByType(String? status) {
    selectedType = status;
    _applyActiveFilters();
    notifyListeners();
  }

  void resetFilter() {
    toDate = null;
    fromDate = null;
    fromDateError = false;
    toDateError = false;
    _applyActiveFilters();
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
