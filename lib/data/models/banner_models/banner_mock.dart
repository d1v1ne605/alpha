import 'package:alpha/data/models/banner_models/banner_model.dart';
import 'package:alpha/data/models/banner_models/translation_model.dart';

class BannerMock {
  static final List<BannerModel> banners = [
    BannerModel(
      id: 1,
      state: 'active',
      priority: 1,
      photoUrl:
          'https://cafefcdn.com/thumb_w/640/203337114487263232/2025/9/1/avatar1756740999684-17567410003291749502635.jpg',
      thumbnailUrl:
          'https://cafefcdn.com/thumb_w/640/203337114487263232/2025/9/1/avatar1756740999684-17567410003291749502635.jpg',
      tags: ['promo', 'home'],
      category: 'homepage',
      showBanner: true,
      createdAt: DateTime.parse('2026-06-01T10:00:00Z'),
      updatedAt: DateTime.parse('2026-06-10T10:00:00Z'),
      publishedAt: DateTime.parse('2026-06-11T10:00:00Z'),
      translations: [
        TranslationModel(
          id: 101,
          language: 'vi',
          headline: 'Featured Promotion',
          description: 'Special offer for new users.',
          body: 'Get up to 50% off for a limited time.',
          articleId: 1,
        ),
        TranslationModel(
          id: 102,
          language: 'en',
          headline: 'Featured Promotion',
          description: 'Special offer for new users.',
          body: 'Get up to 50% off for a limited time.',
          articleId: 1,
        ),
      ],
      headline: 'Featured Promotion',
      description: 'Special offer for new users.',
      body: 'Get up to 50% off for a limited time.',
    ),
    BannerModel(
      id: 2,
      state: 'active',
      priority: 2,
      photoUrl:
          'https://dntt.mediacdn.vn/197608888129458176/2026/6/1/6eb1185eabeb4d3ba366bea0ee789be2-17803093736522104051776.jpg',
      thumbnailUrl:
          'https://dntt.mediacdn.vn/197608888129458176/2026/6/1/6eb1185eabeb4d3ba366bea0ee789be2-17803093736522104051776.jpg',
      tags: ['event', 'trading'],
      category: 'trading',
      showBanner: true,
      createdAt: DateTime.parse('2026-06-02T10:00:00Z'),
      updatedAt: DateTime.parse('2026-06-12T10:00:00Z'),
      publishedAt: DateTime.parse('2026-06-12T12:00:00Z'),
      translations: [
        TranslationModel(
          id: 201,
          language: 'vi',
          headline: 'New Trading Event',
          description: 'Join the event and earn rewards.',
          body: 'Start trading now to receive exciting gifts.',
          articleId: 2,
        ),
      ],
      headline: 'New Trading Event',
      description: 'Join the event and earn rewards.',
      body: 'Start trading now to receive exciting gifts.',
    ),
  ];
}
