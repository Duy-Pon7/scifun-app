class ServerException implements Exception{
  final String message;

  ServerException({this.message = 'Có lỗi xảy ra'});
}