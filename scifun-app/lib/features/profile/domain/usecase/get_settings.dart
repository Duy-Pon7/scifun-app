import 'package:dartz/dartz.dart';
import 'package:thilop10_3004/common/entities/settings_entity.dart';
import 'package:thilop10_3004/core/error/failure.dart';
import 'package:thilop10_3004/core/utils/usecase.dart';
import 'package:thilop10_3004/features/profile/domain/entities/packages_entity.dart';
import 'package:thilop10_3004/features/profile/domain/repository/packages_repository.dart';
import 'package:thilop10_3004/features/profile/domain/repository/settings_repository.dart';

class GetSettings implements Usecase<List<SettingsEntity?>, NoParams> {
  final SettingsRepository settingsRepository;

  GetSettings({required this.settingsRepository});

  @override
  Future<Either<Failure, List<SettingsEntity?>>> call(NoParams param) async {
    return await settingsRepository.getSettings();
  }
}
