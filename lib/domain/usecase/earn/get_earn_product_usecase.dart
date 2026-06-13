import 'package:alpha/data/models/earn/product/product_earn_model.dart';
import 'package:alpha/data/repositories/earn/earn_repository.dart';

class GetEarnProductUsecase {
  EarnRepository _earnRepository;

  GetEarnProductUsecase(this._earnRepository);

  Future<ProductEarnResponse> call() async {
    return await _earnRepository.getEarnProducts();
  }
}
