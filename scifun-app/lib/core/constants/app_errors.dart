class AppErrors {
  static const String failureLogin = 'Dang nhap that bai!';
  static const String getAuthFailure = 'Lay thong tin nguoi dung that bai!';
  static const String getNotificationsFailure =
      'Lay du lieu thong bao that bai!';
  static const String changePassFailure = 'Doi mat khau that bai!';
  static const String reviseInfoFailure = 'Chinh sua thong tin that bai!';
  static const String resetPassFailure = 'Khoi phuc mat khau that bai!';
  static const String failureSendEmail = 'Gui email that bai!';
  static const String commonError = 'Co loi xay ra!';
  static const String networkError =
      'Khong the ket noi may chu. Vui long thu lai.';
  static const String webCorsBlocked =
      "Web bi chan CORS. Chay 'dart run tool/cors_proxy.dart' va dat WEB_BASE_URL=http://127.0.0.1:8787/api/v1 trong .env.";
  static const String emptyData = 'Chua co';
}
