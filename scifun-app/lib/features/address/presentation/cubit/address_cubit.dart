import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thilop10_3004/common/entities/address_entity.dart';
import 'package:thilop10_3004/features/address/domain/usecase/get_provinces.dart';
import 'package:thilop10_3004/features/address/domain/usecase/get_wards.dart';
import 'package:thilop10_3004/core/utils/usecase.dart';

/// --- STATE ---
sealed class AddressState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddressInitial extends AddressState {}

class AddressLoading extends AddressState {}

class AddressLoaded extends AddressState {
  final List<ProvinceEntity> provinces;
  final List<ProvinceEntity> wards;

  AddressLoaded(this.provinces, this.wards);

  @override
  List<Object?> get props => [provinces, wards];
}

class AddressError extends AddressState {
  final String message;

  AddressError(this.message);

  @override
  List<Object?> get props => [message];
}

/// --- CUBIT ---
class AddressCubit extends Cubit<AddressState> {
  final GetProvinces getAddress;
  final GetWards getWards;

  // Lưu trữ dữ liệu hiện tại
  List<ProvinceEntity> _provinces = [];
  List<ProvinceEntity> _wards = [];

  AddressCubit(this.getAddress, this.getWards) : super(AddressInitial());

  Future<void> fetchAddresss() async {
    if (isClosed) return;

    emit(AddressLoading());

    final result = await getAddress(NoParams());

    result.fold(
      (failure) => emit(AddressError(failure.message)),
      (provinces) {
        _provinces = provinces;
        emit(AddressLoaded(_provinces, _wards));
      },
    );
  }

  Future<void> fetchWards(int provinceId) async {
    if (isClosed) return;

    emit(AddressLoading());

    final result = await getWards(provinceId);

    result.fold(
      (failure) => emit(AddressError(failure.message)),
      (wards) {
        _wards = wards;
        emit(AddressLoaded(_provinces, _wards));
      },
    );
  }

  /// Getter để dùng bên ngoài
  List<ProvinceEntity> get provinces => _provinces;
  List<ProvinceEntity> get wards => _wards;
}
