import '../../../data/models/banner_models/banner_model.dart';
import 'package:alpha/data/repositories/home/home_reponsitory.dart';

class HomeBannerUseCase {
  final HomeReponsitory repository;
  HomeBannerUseCase(this.repository);
  Future<List<BannerModel>> call() {
    return repository.fetchBanners(limit: 5);
  }
}
