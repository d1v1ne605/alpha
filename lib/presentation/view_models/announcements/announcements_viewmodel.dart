import 'dart:async';

import 'package:alpha/core/constants/app_local_key.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/data/models/banner_models/translation_model.dart';
import 'package:alpha/domain/usecase/home/announcement_usecase.dart';
import 'package:alpha/presentation/view_models/locale_langue/locale_language_view_model.dart';
import '../../../core/base/base_view_model.dart';
import '../../../core/constants/app_storage_key.dart';
import '../../../core/mixins/local_storage/local_storage_mixin.dart';
import '../../../data/models/banner_models/banner_model.dart';
import '../../../injection/injector.dart';

enum AnnouncementSidebarKey {
  all,
  newListings,
  eventNews,
  maintenanceNews,
  delistings,
  updates,
}

extension AnnouncementSidebarKeyExt on AnnouncementSidebarKey {
  String get value => switch (this) {
    AnnouncementSidebarKey.all => AppStorageKey.keyAll,
    AnnouncementSidebarKey.newListings => AppStorageKey.keyNewListings,
    AnnouncementSidebarKey.eventNews => AppStorageKey.keyEventNews,
    AnnouncementSidebarKey.maintenanceNews => AppStorageKey.keyMaintenanceNews,
    AnnouncementSidebarKey.delistings => AppStorageKey.keyDelistings,
    AnnouncementSidebarKey.updates => AppStorageKey.keyUpdates,
  };
}

class AnnouncementsViewModel extends BaseViewModel with LocalStorageMixin {
  final AnnouncementUseCase announcementUseCase;
  final LocaleNotifier localeNotifier;

  AnnouncementsViewModel(this.announcementUseCase, this.localeNotifier) {
    initLocalStorage(getIt());
  }

  List<Map<String, Object?>> get groupedSidebarTabs => [
    {
      'key': AnnouncementSidebarKey.all,
      'label': context?.appLocaleLanguage.whatsNew,
      'subTabs': [context?.appLocaleLanguage.trendingInfo],
    },
    {
      'key': AnnouncementSidebarKey.newListings,
      'label': context?.appLocaleLanguage.asset,
      'subTabs': [
        context?.appLocaleLanguage.newListings,
        context?.appLocaleLanguage.projectMaintenance,
        context?.appLocaleLanguage.delisting,
      ],
    },
    {
      'key': AnnouncementSidebarKey.eventNews,
      'label': context?.appLocaleLanguage.events,
      'subTabs': [context?.appLocaleLanguage.eventNews],
    },
    {
      'key': AnnouncementSidebarKey.updates,
      'label': context?.appLocaleLanguage.update,
      'subTabs': [context?.appLocaleLanguage.systemUpgrade],
    },
  ];

  int _currentTabIndex = 0;
  final Map<String, int> _currentSubTabIndexes = {};
  List<BannerModel> _allAnnouncements = [];
  final Map<String, List<BannerModel>> _categorizedData = {};
  Timer? _debounce;

  // ===== Getters =====
  int get currentTabIndex => _currentTabIndex;

  Map<String, dynamic> get currentTab => groupedSidebarTabs[_currentTabIndex];

  int get currentSubTabIndex => _currentSubTabIndexes[currentTabKey] ?? 0;

  List<String> get currentSubTabs =>
      (currentTab['subTabs'] as List<String?>?)?.whereType<String>().toList() ??
      [];

  String get currentTabKey =>
      (currentTab['key'] as AnnouncementSidebarKey).value;

  String? get currentSubTabTitle => (currentSubTabIndex < currentSubTabs.length)
      ? currentSubTabs[currentSubTabIndex]
      : null;

  String get breadcrumbPath {
    final tab = currentTab['label'] ?? '';
    final sub = currentSubTabTitle;
    return sub != null ? '$tab > $sub' : tab;
  }

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  List<BannerModel> get allAnnouncements => _allAnnouncements;

  List<BannerModel> get currentFilteredAnnouncements {
    final key = _getCategoryKey(currentSubTabTitle);
    List<BannerModel> data = key == AnnouncementSidebarKey.all.value
        ? _allAnnouncements
        : (_categorizedData[key] ?? []);
    return _filterBySearch(data);
  }

  void updateSearchQuery(String value) {
    final newQuery = value.trim().toLowerCase();

    if (newQuery == _searchQuery) return;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _searchQuery = newQuery;
      notifyListeners();
    });
  }

  List<BannerModel> _filterBySearch(List<BannerModel> data) {
    if (_searchQuery.isEmpty) return data;

    final langCode = localeNotifier.locale.languageCode;
    return data.where((item) {
      final translation = getTranslationForLang(item.translations, langCode);
      final headline = translation?.headline.toLowerCase() ?? '';
      return headline.contains(_searchQuery);
    }).toList();
  }

  Future<void> fetchBanners() async {
    setBusy(true);
    clearError();
    try {
      _allAnnouncements = await announcementUseCase();
      _categorizeData();
      notifyListeners();
    } catch (e) {
      _allAnnouncements = [];
      setError('Failed to load announcements: ${e.toString()}');
    } finally {
      setBusy(false);
    }
  }

  void _categorizeData() {
    _categorizedData.clear();
    for (var item in _allAnnouncements) {
      final key = _normalize(item.category ?? '');
      _categorizedData.putIfAbsent(key, () => []).add(item);
    }
  }

  void changeTab(int newIndex) {
    _currentTabIndex = newIndex;
    _currentSubTabIndexes.putIfAbsent(currentTabKey, () => 0);
    notifyListeners();
  }

  void changeSubTab(int index) {
    _currentSubTabIndexes[currentTabKey] = index;
    notifyListeners();
  }

  String _normalize(String input) =>
      input.trim().toLowerCase().replaceAll(' ', '_');

  String _getCategoryKey(String? label) {
    final map = {
      context?.appLocaleLanguage.trendingInfo.toLowerCase().trim():
          AnnouncementSidebarKey.all.value,
      context?.appLocaleLanguage.newListings.toLowerCase().trim():
          AnnouncementSidebarKey.newListings.value,
      context?.appLocaleLanguage.projectMaintenance.toLowerCase().trim():
          AnnouncementSidebarKey.maintenanceNews.value,
      context?.appLocaleLanguage.delisting.toLowerCase().trim():
          AnnouncementSidebarKey.delistings.value,
      context?.appLocaleLanguage.eventNews.toLowerCase().trim():
          AnnouncementSidebarKey.eventNews.value,
      context?.appLocaleLanguage.systemUpgrade.toLowerCase().trim():
          AnnouncementSidebarKey.updates.value,
    };
    return map[label?.toLowerCase().trim() ?? ''] ?? _normalize(label ?? '');
  }

  TranslationModel? getTranslationForLang(
    List<TranslationModel> translations,
    String langCode,
  ) {
    return translations.firstWhere(
      (t) => t.language == langCode,
      orElse: () => translations.first,
    );
  }

  TranslationModel? translation;

  Future<void> loadTranslation(BannerModel item) async {
    final savedLocaleCode = await loadFromHive<String>(
      key: AppLocalKey.selectedLocale,
      boxName: AppLocalKey.commonBox,
    );
    translation = getTranslationForLang(
      item.translations,
      savedLocaleCode ?? 'en',
    );
    notifyListeners();
  }
}
