import 'package:alpha/data/models/asset/Record/record_model.dart';
import 'package:alpha/data/repositories/asset/asset_repository.dart';

class GetWithdrawRecordsUsecase {
  AssetRepository _assetRepository;
  GetWithdrawRecordsUsecase(this._assetRepository);

  Future<RecordResponse> call({int page = 1, int limit = 20}) {
    return _assetRepository.getWithdrawRecordHistory(page: page, limit: limit);
  }
}
