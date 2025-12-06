import 'package:sci_fun/core/services/share_prefs_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IsAuthorizedCubit extends Cubit<bool> {
  final SharePrefsService _sharePrefsService;

  IsAuthorizedCubit({required SharePrefsService sharePrefsService})
      : _sharePrefsService = sharePrefsService,
        super(false);

  void isAuthorized() {
    final token =
        _sharePrefsService.getAuthToken(); // dùng đúng key 'auth_token'
    emit(token != null);
  }

  void getIdData() {
    final userData =
        _sharePrefsService.getUserData(); // dùng đúng key 'user_data'
    emit(userData != null);
  }

  void logout() async {
    await _sharePrefsService.clear();
    emit(false); // đảm bảo tự quay lại login luôn
  }
}
