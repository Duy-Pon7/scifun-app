// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:sci_fun/common/cubit/paginator_cubit.dart';
// import 'package:sci_fun/common/widget/basic_appbar.dart';
// import 'package:sci_fun/common/widget/topic_item.dart';
// import 'package:sci_fun/core/di/injection.dart';
// import 'package:sci_fun/core/utils/theme/app_color.dart';
// import 'package:sci_fun/features/exam/data/model/examset_model.dart';
// import 'package:sci_fun/features/exam/domain/usecase/get_examset.dart';
// import 'package:sci_fun/features/exam/presentation/cubit/examset_cubit.dart';
// import 'package:sci_fun/features/exam/presentation/cubit/examset_paginator_cubit.dart';
// import 'package:sci_fun/features/exam/presentation/page/subject_grade_page.dart';
// import 'package:sci_fun/features/subject/presentation/cubit/subject_cubit.dart';

// class ExamsetPage extends StatefulWidget {
//   const ExamsetPage({super.key});

//   @override
//   State<ExamsetPage> createState() => _ExamsetPageState();
// }

// class _ExamsetPageState extends State<ExamsetPage>
//     with AutomaticKeepAliveClientMixin {
//   late final PaginatorCubit<ExamsetModel, dynamic> _notiPaginator;
//   late final ScrollController _scrollCon;

//   @override
//   void initState() {
//     _notiPaginator = PaginatorCubit<ExamsetModel, dynamic>(
//       usecase: sl<GetExamset>(),
//     )..paginateData();

//     // Listen scroll action
//     _scrollCon = ScrollController()
//       ..addListener(() {
//         if (_scrollCon.position.pixels == _scrollCon.position.maxScrollExtent) {
//           _notiPaginator.paginateData();
//         }
//       });
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _notiPaginator.close();
//     _scrollCon.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     super.build(context);

//     return MultiBlocProvider(
//       providers: [
//         BlocProvider(create: (context) => _notiPaginator),
//         BlocProvider(create: (context) => sl<ExamsetPaginatorCubit>()),
//         BlocProvider(create: (context) => sl<ExamsetCubit>()),
//       ],
//       child: Scaffold(
//         appBar: BasicAppbar(
//           title: Text(
//             "Danh sách đề thi",
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
//             // Unread notifcations quantity
//             // UnreadQuantity(),

//             // Examset list
//             Expanded(
//               child: // ✅ BlocBuilder
//                   BlocBuilder<PaginatorCubit<ExamsetModel, dynamic>,
//                       PaginatorState<ExamsetModel>>(
//                 builder: (context, state) {
//                   print(state);

//                   if (state is PaginatorLoading<ExamsetModel>) {
//                     return CustomizeLoader();
//                   }

//                   final items = context
//                       .read<PaginatorCubit<ExamsetModel, dynamic>>()
//                       .items;

//                   if (state is PaginatorFailed<ExamsetModel> || items.isEmpty) {
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
//                               .read<PaginatorCubit<ExamsetModel, dynamic>>()
//                               .refreshData(),
//                           child: ListView.builder(
//                             controller: _scrollCon,
//                             physics: const BouncingScrollPhysics(
//                                 parent: AlwaysScrollableScrollPhysics()),
//                             itemCount: items.length,
//                             itemBuilder: (context, index) {
//                               final examset = items[index];
//                               return Padding(
//                                 padding: EdgeInsets.symmetric(
//                                     horizontal: 16.w, vertical: 8.h),
//                                 child: TopicItem(
//                                   title: examset.title,
//                                   onTap: () {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) => BlocProvider(
//                                           create: (_) =>
//                                               sl<SubjectCubit>()..getSubjects(),
//                                           child: SubjectGradePage(
//                                               examId: examset.id),
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
//                       if (state is PaginatorLoadMore<ExamsetModel>)
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

// // When the content unoccupies the whole page
//   void _onLoadMoreWhenTheContentUnOccupiesTheWholePage() {
//     if (_scrollCon.position.maxScrollExtent > 0) {
//       return;
//     }
//     if (_scrollCon.position.pixels == 0 &&
//         _notiPaginator.state is PaginatorLoaded<ExamsetModel> &&
//         !_notiPaginator.isClosed) {
//       _notiPaginator.paginateData();
//     }
//   }
// }

// // class UnreadQuantity extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Padding(
// //       padding: EdgeInsets.symmetric(vertical: 8),
// //       child: Text("Bạn có 3 thông báo chưa đọc"),
// //     );
// //   }
// // }

// class CustomizeLoader extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
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
