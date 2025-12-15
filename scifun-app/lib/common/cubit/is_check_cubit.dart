// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:math/features/activities/repositories/activities_repository.dart';

// class IsCheckCubit extends Cubit<bool> {
//   final ActivitiesRepository activitiesRepository;

//   IsCheckCubit({required this.activitiesRepository}) : super(false);

//   Future<void> checkProgress({required String progressId}) async {
//     try {
//       final res = await activitiesRepository.postActivities(
//         progressId: progressId,
//       );
//       res.fold(
//         (failure) {
//           emit(false);
//         },
//         (data) {
//           emit(data.isCheck ?? false);
//         },
//       );
//     } catch (_) {
//       emit(false);
//     }
//   }
// }
