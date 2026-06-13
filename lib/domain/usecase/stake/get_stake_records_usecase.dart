import 'package:alpha/data/models/stake/stake_record_model.dart';
import 'package:alpha/data/repositories/stake/stake_repository.dart';

class GetStakeRecordsUseCase {
  final StakeRepository _stakeRepository;

  GetStakeRecordsUseCase(this._stakeRepository);

  Future<List<StakeRecordModel>> call() async {
    return await _stakeRepository.getStakeRecords();
  }
}
