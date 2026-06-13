import 'package:alpha/data/models/banner_models/banner_model.dart';
import 'package:alpha/data/repositories/home/home_reponsitory.dart';

class AnnouncementUseCase {
  final HomeReponsitory repository;
  AnnouncementUseCase(this.repository);
  Future<List<BannerModel>> call() {
    return repository.fetchAnnouncements();
  }
}
