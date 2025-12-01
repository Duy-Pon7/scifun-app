// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:sci_fun/common/cubit/paginator_cubit.dart';
// import 'package:sci_fun/common/widget/basic_appbar.dart';
// import 'package:sci_fun/common/widget/topic_item.dart';
// import 'package:sci_fun/core/di/injection.dart';
// import 'package:sci_fun/core/utils/theme/app_color.dart';
// import 'package:sci_fun/features/exam/presentation/page/test_subject_topic_quiz_list.dart';
// import 'package:sci_fun/features/home/domain/entity/lesson_category_entity.dart';
// import 'package:sci_fun/features/home/domain/usecase/get_lesson_category.dart';
// import 'package:sci_fun/features/home/presentation/cubit/lesson_cubit.dart';

// class TestSubjectTopic extends StatefulWidget {
//   final int subjectId;
//   final String title;
//   const TestSubjectTopic(
//       {super.key, required this.subjectId, required this.title});

//   @override
//   State<TestSubjectTopic> createState() => _TestSubjectTopicState();
// }

// class _TestSubjectTopicState extends State<TestSubjectTopic>
//     with AutomaticKeepAliveClientMixin {
//   late final PaginatorCubit<LessonCategoryEntity, GetLessonCateParam>
//       _lessonPaginator;
//   late final ScrollController _scrollCon;

//   @override
//   void initState() {
//     super.initState();

//     _lessonPaginator = PaginatorCubit<LessonCategoryEntity, GetLessonCateParam>(
//       usecase: sl<GetLessonCategory>(),
//     )..paginateData(param: GetLessonCateParam(subjectId: widget.subjectId));

//     _scrollCon = ScrollController()
//       ..addListener(() {
//         if (_scrollCon.position.pixels == _scrollCon.position.maxScrollExtent) {
//           _lessonPaginator.paginateData(
//               param: GetLessonCateParam(subjectId: widget.subjectId));
//         }
//       });
//   }

//   @override
//   void dispose() {
//     _lessonPaginator.close();
//     _scrollCon.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     super.build(context);

//     return MultiBlocProvider(
//       providers: [
//         BlocProvider<PaginatorCubit<LessonCategoryEntity, GetLessonCateParam>>(
//             create: (_) => _lessonPaginator),
//         BlocProvider(create: (_) => sl<LessonCubit>()),
//       ],
//       child: Scaffold(
//         appBar: BasicAppbar(
//           title: Text(
//             widget.title,
//             style: Theme.of(context).textTheme.titleMedium!.copyWith(
//                   fontSize: 17.sp,
//                   fontWeight: FontWeight.w600,
//                 ),
//           ),
//           centerTitle: true,
//           leading: IconButton(
//             icon: Icon(
//               Icons.arrow_back_ios_rounded,
//               color: AppColor.primary600,
//             ),
//             onPressed: () => Navigator.of(context).pop(),
//           ),
//         ),
//         body: Column(
//           children: [
//             Expanded(
//               child: BlocBuilder<
//                   PaginatorCubit<LessonCategoryEntity, GetLessonCateParam>,
//                   PaginatorState<LessonCategoryEntity>>(
//                 builder: (context, state) {
//                   if (state is PaginatorLoading<LessonCategoryEntity>) {
//                     return CustomizeLoader();
//                   }

//                   final items = context
//                       .read<
//                           PaginatorCubit<LessonCategoryEntity,
//                               GetLessonCateParam>>()
//                       .items;

//                   if (state is PaginatorFailed<LessonCategoryEntity> ||
//                       items.isEmpty) {
//                     return Center(
//                       child: Text(
//                         "Không có dữ liệu.",
//                         style: Theme.of(context).textTheme.bodyLarge,
//                       ),
//                     );
//                   }

//                   return Column(
//                     children: [
//                       Expanded(
//                         child: RefreshIndicator.adaptive(
//                           color: AppColor.inputIcon,
//                           onRefresh: () async => await context
//                               .read<
//                                   PaginatorCubit<LessonCategoryEntity,
//                                       GetLessonCateParam>>()
//                               .refreshData(
//                                 param: GetLessonCateParam(
//                                     subjectId: widget.subjectId),
//                               ),
//                           child: ListView.builder(
//                             controller: _scrollCon,
//                             physics: const BouncingScrollPhysics(
//                                 parent: AlwaysScrollableScrollPhysics()),
//                             itemCount: items.length,
//                             itemBuilder: (context, index) {
//                               final lessonCategory = items[index];
//                               return Padding(
//                                 padding: EdgeInsets.symmetric(
//                                     horizontal: 16.w, vertical: 8.h),
//                                 child: TopicItem(
//                                   title: lessonCategory.name ?? '',
//                                   onTap: () {
//                                     print(
//                                         "Lesson Category ID: ${lessonCategory.id}");
//                                     Navigator.of(context).push(
//                                       MaterialPageRoute(
//                                         builder: (_) =>
//                                             TestSubjectTopicQuizList(
//                                           lessonId: lessonCategory
//                                               .id!, // cần đảm bảo lessonCategory.id != null
//                                           lessonTitle:
//                                               lessonCategory.name ?? '',
//                                           titleSubject: widget.title,
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                       ),
//                       if (state is PaginatorLoadMore<LessonCategoryEntity>)
//                         CustomizeLoader(),
//                     ],
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   bool get wantKeepAlive => true;

//   void _onLoadMoreWhenTheContentUnOccupiesTheWholePage() {
//     if (_scrollCon.position.maxScrollExtent > 0) {
//       return;
//     }
//     if (_scrollCon.position.pixels == 0 &&
//         _lessonPaginator.state is PaginatorLoaded<LessonCategoryEntity> &&
//         !_lessonPaginator.isClosed) {
//       _lessonPaginator.paginateData();
//     }
//   }
// }

// class CustomizeLoader extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return const Center(
//       child: CircularProgressIndicator(),
//     );
//   }
// }

// class CustomizeTryAgain extends StatelessWidget {
//   final String? error;
//   final VoidCallback onPressed;

//   const CustomizeTryAgain({
//     Key? key,
//     this.error,
//     required this.onPressed,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           if (error != null) ...[
//             Text(error!, textAlign: TextAlign.center),
//             SizedBox(height: 10),
//           ],
//           ElevatedButton(
//             onPressed: onPressed,
//             child: Text("Thử lại"),
//           ),
//         ],
//       ),
//     );
//   }
// }
