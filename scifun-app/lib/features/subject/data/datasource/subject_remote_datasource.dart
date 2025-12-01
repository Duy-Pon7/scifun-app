import 'package:sci_fun/core/constants/api_urls.dart';
import 'package:sci_fun/core/network/dio_client.dart';
import 'package:sci_fun/features/subject/data/model/subject_model.dart';

abstract interface class SubjectRemoteDatasource {
  Future<List<SubjectModel>> getAllSubjects(String? searchQuery);
}

class SubjectRemoteDatasourceImpl implements SubjectRemoteDatasource {
  final DioClient dioClient;

  SubjectRemoteDatasourceImpl({required this.dioClient});

  @override
  Future<List<SubjectModel>> getAllSubjects(
    String? searchQuery,
  ) async {
    try {
      final res = await dioClient.get(
          url:
              "${SubjectApiUrl.getSubjects}?page=1&limit=10&search=$searchQuery");
      if (res.statusCode == 200) {
        final List<dynamic> data = res.data['data']['subjects'];
        return data
            .map((subjectJson) =>
                SubjectModel.fromJson(subjectJson as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to load subjects');
      }
    } catch (e) {
      throw Exception('Failed to load subjects: $e');
    }
  }
}
