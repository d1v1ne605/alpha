import 'package:alpha/core/utils/enums.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/data/models/asset/Record/record_model.dart';
import 'package:alpha/data/models/earn/transaction_earn/withdraw_record/withdraw_record_earn.dart';
import 'package:flutter/material.dart';

import '../constants/app_storage_key.dart';

class RecordHelper {
  static String getCurrency(RecordData record, RecordType type) {
    if (type == RecordType.deposit) {
      return record.currency ?? '';
    } else if (type == RecordType.withdraw) {
      return record.withdrawCurrency?.id ?? '';
    }
    return '';
  }

  static String getFeeCurrency(RecordData record, RecordType type) {
    if (type == RecordType.deposit) {
      return record.currency ?? '';
    } else if (type == RecordType.withdraw) {
      return record.feeCurrency?.id ?? '';
    }
    return '';
  }

  static String getStatus(
    RecordData record,
    RecordType recordType,
    BuildContext context,
  ) {
    if (recordType == RecordType.deposit) {
      return getDepositStatus(record.state, context);
    } else if (recordType == RecordType.withdraw) {
      return getWithdrawStatus(record.status, context);
    }
    return '';
  }

  static String getStatusEarnWithdraw(
    WithdrawRecordData withdrawRecord,
    TransactionType transactionType,
    BuildContext context,
  ) {
    if (transactionType == TransactionType.withdraw_records) {
      return getWithdrawStatus(withdrawRecord.status, context);
    }
    return '';
  }

  static String getDepositStatus(String? state, BuildContext context) {
    switch (state?.toLowerCase()) {
      case AppStorageKey.accepted:
      case AppStorageKey.submitted:
        return context.appLocaleLanguage.waitConfirmation;
      case AppStorageKey.skipped:
      case AppStorageKey.processing:
      case AppStorageKey.collected:
        return context.appLocaleLanguage.succeeds;
      case AppStorageKey.canceled:
      case AppStorageKey.rejected:
        return context.appLocaleLanguage.rejectedBySystem;
      default:
        return context.appLocaleLanguage.waitForConfirmation;
    }
  }

  static String readableSocialLabel(String t, BuildContext context) {
    switch (t.toLowerCase()) {
      case AppStorageKey.twitterKey:
        return context.appLocaleLanguage.twitter;
      case AppStorageKey.telegramKey:
        return context.appLocaleLanguage.telegram;
      case AppStorageKey.discordKey:
        return context.appLocaleLanguage.discord;
      case AppStorageKey.facebookKey:
        return context.appLocaleLanguage.facebook;
      case AppStorageKey.redditKey:
        return context.appLocaleLanguage.reddit;
      default:
        if (t.isEmpty) return '';
        return t[0].toUpperCase() + t.substring(1);
    }
  }

  static String getWithdrawStatus(String? status, BuildContext context) {
    switch (status?.toLowerCase()) {
      case AppStorageKey.skipped:
        return context.appLocaleLanguage.waitApproveByAudit;
      case AppStorageKey.prepared:
      case AppStorageKey.submitted:
      case AppStorageKey.accepted:
        return context.appLocaleLanguage.waitWithdrawSubmit;
      case AppStorageKey.canceled:
        return context.appLocaleLanguage.cancelByUserRequest;
      case AppStorageKey.rejected:
      case AppStorageKey.failed:
      case AppStorageKey.errored:
        return context.appLocaleLanguage.blockchainError;
      case AppStorageKey.succeed:
        return context.appLocaleLanguage.succeeds;
      case AppStorageKey.completed:
        return context.appLocaleLanguage.completeds;
      case AppStorageKey.processing:
        return context.appLocaleLanguage.processings;
      case AppStorageKey.confirming:
        return context.appLocaleLanguage.waitForConfirmation;
      case AppStorageKey.denied:
        return context.appLocaleLanguage.denied;
      case AppStorageKey.processed:
        return context.appLocaleLanguage.processed;
      case AppStorageKey.pending:
        return context.appLocaleLanguage.pending;
      default:
        return context.appLocaleLanguage.waitForConfirmation;
    }
  }

  static DateTime getDateTime(RecordData record, RecordType type) {
    if (type == RecordType.deposit) {
      return record.created_at ?? DateTime.now();
    } else if (type == RecordType.withdraw) {
      return record.createdAt ?? DateTime.now();
    }
    return DateTime.now();
  }

  static double getAmount(RecordData record, RecordType type) {
    if (type == RecordType.deposit) {
      return double.parse(record.amount ?? "0.0");
    } else if (type == RecordType.withdraw) {
      return double.parse(record.withdrawAmount ?? "0.0");
    }
    return 0.0;
  }

  static String getTxId(RecordData record, RecordType type) {
    if (type == RecordType.deposit) {
      return record.txid;
    } else if (type == RecordType.withdraw) {
      return record.txid;
    }
    return '';
  }

  static String getTid(RecordData record, RecordType type) {
    if (type == RecordType.deposit) {
      return "";
    } else if (type == RecordType.withdraw) {
      return record.tid;
    }
    return '';
  }

  static String getAddress(RecordData record, RecordType type) {
    if (type == RecordType.deposit) {
      return "";
    } else if (type == RecordType.withdraw) {
      return record.rid ?? '';
    }
    return '';
  }

  static double getFee(RecordData record, RecordType type) {
    if (type == RecordType.deposit) {
      return 0.0;
    } else if (type == RecordType.withdraw) {
      return double.parse(record.feeAmount ?? "0.0");
    }
    return 0.0;
  }
}
