import 'package:dartz/dartz.dart';
import 'package:sci_fun/common/entities/settings_entity.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/core/utils/usecase.dart';
import 'package:sci_fun/features/profile/domain/entities/packages_entity.dart';
import 'package:sci_fun/features/profile/domain/repository/packages_repository.dart';
import 'package:sci_fun/features/profile/domain/repository/settings_repository.dart';

class GetSettings implements Usecase<List<SettingsEntity?>, NoParams> {
  final SettingsRepository settingsRepository;

  GetSettings({required this.settingsRepository});

  @override
  Future<Either<Failure, List<SettingsEntity?>>> call(NoParams param) async {
    return await settingsRepository.getSettings();
  }
}
