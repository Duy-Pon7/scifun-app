class AppErrors {
  static const String failureLogin = 'Đăng nhập thất bại!';
  static const String getAuthFailure = 'Lấy thông tin người dùng thất bại!';
  static const String getNotificationsFailure =
      'Lấy dữ liệu thông báo thất bại!';
  static const String changePassFailure = 'Đổi mật khẩu thất bại!';
  static const String reviseInfoFailure = 'Chỉnh sửa thông tin thất bại!';
  static const String resetPassFailure = 'Khôi phục mật khẩu thất bại!';
  static const String failureSendEmail = 'Gửi email thất bại!';
  static const String commonError = 'Có lỗi xảy ra!';
  static const String networkError =
      'Không thể kết nối máy chủ. Vui lòng thử lại.';
  static const String webCorsBlocked =
      "Web bị chặn CORS. Chạy tool/run_web_with_proxy.ps1 và đặt WEB_BASE_URL=http://192.168.11.61/api/v1 trong .env.";
  static const String emptyData = 'Chưa có';
}
