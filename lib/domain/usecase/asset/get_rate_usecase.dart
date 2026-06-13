import 'package:alpha/core/constants/app_storage_key.dart';
import 'package:alpha/data/repositories/global/global_repository.dart';

class GetRateUsecase {
  final GlobalRepository globalRepository;

  GetRateUsecase({required this.globalRepository});

  Future<double> call() async {
    final globalData = await globalRepository.getGlobalData();
    final currency = globalData[AppStorageKey.currencies];
    final usdtAsset = currency.firstWhere(
      (c) => c.id == AppStorageKey.usdt.toLowerCase(),
      orElse: () => throw Exception('Currency not found'),
    );
    return double.parse(usdtAsset.price);
  }
}
