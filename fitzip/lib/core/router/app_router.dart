import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fitzip/features/auth/presentation/login_screen.dart';
import 'package:fitzip/features/auth/presentation/signup_screen.dart';
import 'package:fitzip/features/home/presentation/home_screen.dart';
import 'package:fitzip/features/bmi/presentation/bmi_input_screen.dart';
import 'package:fitzip/features/bmi/presentation/bmi_result_screen.dart';
import 'package:fitzip/features/analysis/presentation/camera_screen.dart';
import 'package:fitzip/features/analysis/presentation/analysis_result_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
    GoRoute(path: '/sign-up', builder: (_, __) => const SignUpScreen()),
    GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
    GoRoute(path: '/bmi', builder: (_, __) => const BmiInputScreen()),
    GoRoute(
      path: '/bmi/result',
      builder: (_, state) => BmiResultScreen(extra: state.extra as Map<String, dynamic>),
    ),
    GoRoute(path: '/analysis/camera', builder: (_, __) => const CameraScreen()),
    GoRoute(
      path: '/analysis/result/:id',
      builder: (_, state) => AnalysisResultScreen(analysisId: state.pathParameters['id']!),
    ),
  ],
);
