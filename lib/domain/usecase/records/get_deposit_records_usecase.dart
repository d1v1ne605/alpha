import 'package:alpha/data/models/asset/Record/record_model.dart';
import 'package:alpha/data/repositories/asset/asset_repository.dart';

class GetDepositRecordUsecase {
  AssetRepository _assetRepository;
  GetDepositRecordUsecase(this._assetRepository);

  Future<RecordResponse> call({int page = 1, int limit = 25}) {
    return _assetRepository.getDepositRecordHistory(page: page, limit: limit);
  }
}
