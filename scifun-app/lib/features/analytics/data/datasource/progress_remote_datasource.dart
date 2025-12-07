import 'package:sci_fun/core/constants/api_urls.dart';
import 'package:sci_fun/core/network/dio_client.dart';
import 'package:sci_fun/features/analytics/data/model/progress_model.dart';

abstract interface class ProgressRemoteDatasource {
  Future<ProgressModel> getProgress(String subjectId);
}

class ProgressRemoteDatasourceImpl implements ProgressRemoteDatasource {
  final DioClient dioClient;

  ProgressRemoteDatasourceImpl({required this.dioClient});

  @override
  Future<ProgressModel> getProgress(String subjectId) async {
    print("Fetching progress for subjectId: $subjectId");
    try {
      final res = await dioClient.get(
        url: "${SubmissionApiUrl.getUserProgress}/$subjectId",
      );
      print("Response status code: ${res.statusCode}");
      if (res.statusCode == 200) {
        final dynamic data = res.data['data'];
        print("Response data: $data");
        return ProgressModel.fromJson(data as Map<String, dynamic>);
      } else {
        throw Exception('Failed to load user progress');
      }
    } catch (e) {
      throw Exception('Failed to load user progress: $e');
    }
  }
}
