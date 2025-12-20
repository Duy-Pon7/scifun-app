import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sci_fun/features/profile/domain/usecase/get_info_user.dart';

class ProCubit extends Cubit<bool> {
  final GetInfoUser getInfoUser;

  ProCubit({required this.getInfoUser}) : super(false);

  Future<bool> isCheckPro({required String token}) async {
    try {
      final res = await getInfoUser.call(token: token);
      return await res.fold(
        (failure) {
          return false;
        },
        (data) {
          final isPro = data?.data!.subscription?.tier == "PRO";
          if (isPro) {
            emit(true);
          } else {
            emit(false);
          }
          return isPro;
        },
      );
    } catch (e) {
      return false;
    }
  }
}
