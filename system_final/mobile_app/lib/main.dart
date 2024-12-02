import 'package:feedback_app/blocs/auth/auth_event.dart';
import 'package:feedback_app/screens/auth/admin/admin_review.dart';
import 'package:feedback_app/screens/auth/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/dashboard/dashboard_screen.dart';
import 'services/auth_service.dart';
import 'blocs/auth/auth_bloc.dart';
import 'blocs/auth/auth_state.dart';
import 'screens/auth/dashboard/admin_dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final authService = AuthService();
  final authBloc = AuthBloc(authService);

  // Check authentication status before running the app
  final userData = await authService.getCurrentUser();
  if (userData != null && 
      userData['user'] != null && 
      userData['user']['id'] != null) {
    authBloc.add(CheckAuthEvent());
  }

  runApp(MyApp(authBloc: authBloc));
}

class MyApp extends StatelessWidget {
  final AuthBloc authBloc;

  const MyApp({super.key, required this.authBloc});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: authBloc,
      child: const FeedbackApp(),
    );
  }
}

class FeedbackApp extends StatelessWidget {
  const FeedbackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Feedback Management',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
        ),
        useMaterial3: true,
      ),
      home: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (state is AuthAuthenticated) {
            return const DashboardScreen();
          }
          return const LoginScreen();
        },
      ),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/dashboard': (context) => const DashboardScreen(),
          '/admin/reviews': (context) => const AdminReviewsScreen(),
    
        '/admin/dashboard': (context) => const AdminDashboardScreen(),
      },
    );
  }
}
