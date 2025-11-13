class ResponseModel<Type> {
  final int? status;
  final String? message;
  final Type? data;

  ResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ResponseModel.fromJson(
    Map<String, dynamic> json,
    Type Function(Object? objectData) func,
  ) =>
      ResponseModel(
        status: json['status'],
        message: json['message'],
        data: json['data'] == null ? null : func(json['data']),
      );
}
