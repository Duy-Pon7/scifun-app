// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:sci_fun/features/auth/presentation/bloc/auth_bloc.dart';
// import 'package:sci_fun/features/auth/presentation/page/signin/signin_page.dart';
// import 'package:sci_fun/features/home/presentation/page/dashboard_page.dart';
// import 'package:sci_fun/features/profile/presentation/page/package/package_page.dart';

// class AuthRedirectPage extends StatefulWidget {
//   const AuthRedirectPage({super.key});

//   @override
//   State<AuthRedirectPage> createState() => _AuthRedirectPageState();
// }

// class _AuthRedirectPageState extends State<AuthRedirectPage> {
//   @override
//   void initState() {
//     super.initState();
//     context.read<AuthBloc>().add(AuthGetSession());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<AuthBloc, AuthState>(
//       builder: (context, state) {
//         if (state is AuthUserSuccess) {
//           final user = state.user;
//           final now = DateTime.now();

//           Future.microtask(() {
//             if (package == null ||
//                 package.endDate == null ||
//                 package.endDate!.isBefore(now)) {
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => PackagePage(
//                     flagpop: false,
//                     fullname: user?.fullname ?? "Khách",
//                     remainingPackage: getRemainingDays(package?.endDate),
//                   ),
//                 ),
//               );
//             } else {
//               Navigator.pushReplacement(
//                 context,
//                 DashboardPage.route(),
//               );
//             }
//           });

//           return const Scaffold(body: SizedBox.shrink());
//         }

//         if (state is AuthFailure) {
//           Future.microtask(() {
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (_) => const SigninPage()),
//             );
//           });
//           return const SizedBox.shrink();
//         }

//         return const Scaffold(
//           body: Center(child: CircularProgressIndicator()),
//         );
//       },
//     );
//   }

//   String getRemainingDays(DateTime? endDate) {
//     if (endDate == null) return "0 ngày";
//     final now = DateTime.now();
//     final difference = endDate.difference(now).inDays;
//     return difference <= 0 ? "Hết hạn" : "$difference ngày";
//   }
// }
