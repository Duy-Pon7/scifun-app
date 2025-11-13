import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sci_fun/common/entities/settings_entity.dart';
import 'package:sci_fun/core/utils/usecase.dart';
import 'package:sci_fun/features/profile/domain/usecase/get_settings.dart';

sealed class SettingsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SettingsInitial extends SettingsState {}

class SettingsLoading extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final List<SettingsEntity> newsList;
  SettingsLoaded(this.newsList);

  @override
  List<Object?> get props => [newsList];
}

class SettingsDetailLoaded extends SettingsState {
  final SettingsEntity newsDetail;

  SettingsDetailLoaded(this.newsDetail);

  @override
  List<Object?> get props => [newsDetail];
}

class SettingsError extends SettingsState {
  final String message;

  SettingsError(this.message);

  @override
  List<Object?> get props => [message];
}

class SettingsCubit extends Cubit<SettingsState> {
  final GetSettings getAllSettings;

  SettingsCubit(this.getAllSettings) : super(SettingsInitial());

  Future<void> getSettings() async {
    emit(SettingsLoading());
    try {
      final res = await getAllSettings.call(NoParams());
      res.fold(
        (failure) => emit(SettingsError(failure.message)),
        (data) =>
            emit(SettingsLoaded(data.whereType<SettingsEntity>().toList())),
      );
    } catch (e) {
      emit(SettingsError(e.toString()));
    }
  }
}
