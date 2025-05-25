import 'package:flutter/cupertino.dart';
import 'package:learning_platform/screens/Holiday_screen/holiday_screen.dart';
import 'package:learning_platform/screens/ResetPassword_screen/resetPassword_screen.dart';
import 'package:learning_platform/screens/Timetable_Screen/timetable_screen.dart';
import 'package:learning_platform/screens/attendance_screen/attendance_screen.dart';
import 'package:learning_platform/screens/choose_your_role_screen/choose_role_page.dart';
import 'package:learning_platform/screens/class_attendance_screen/mark_attendance_screen.dart';
import 'package:learning_platform/screens/datesheet_screen/datesheet_screen.dart';
import 'package:learning_platform/screens/fee_screen/fee_screen.dart';
import 'package:learning_platform/screens/forgetpassword_screen/email_verification_screen.dart';
import 'package:learning_platform/screens/forgetpassword_screen/new_password_screen.dart';
import 'package:learning_platform/screens/forgetpassword_screen/otp_verification_page.dart';
import 'package:learning_platform/screens/home_screen/home_screen.dart';
import 'package:learning_platform/screens/login_screen/login_screen.dart';
import 'package:learning_platform/screens/my_profile/my_profile.dart';
import 'package:learning_platform/screens/notes_screen/notes_screen.dart';
import 'package:learning_platform/screens/result_screen/result_screen.dart';
import 'package:learning_platform/screens/splash_screen/splash_screen.dart';
import 'package:learning_platform/screens/teacher_profile_screen/teacher_profile_screen.dart';

Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName : (context) => const SplashScreen(),
  LoginScreen.routeName : (context) => const LoginScreen(),
  HomeScreen.routeName : (context) => const HomeScreen(),
  MyProfileScreen.routeName : (context) => const MyProfileScreen(),
  FeeScreen.routeName : (context) => const FeeScreen(),
  ResultScreen.routeName : (context) => const ResultScreen(),
  DateSheetScreen.routeName : (context) => const DateSheetScreen(),
  TimeTableScreen.routeName : (context) => const TimeTableScreen(),
  MarkAttendanceScreen.routeName : (context) => const MarkAttendanceScreen(),
  HolidayScreen.routeName : (context) => const HolidayScreen(),
  ResetPasswordPage.routeName : (context) => const ResetPasswordPage(),
  EmailVerificationPage.routeName : (context) => const EmailVerificationPage(),
  OTPVerificationPage.routeName : (context) => const OTPVerificationPage(),
  CreateNewPasswordScreen.routeName : (context) => const CreateNewPasswordScreen(),
  ChooseRoleScreen.routeName : (context) => const ChooseRoleScreen(),
  TeacherProfileScreen.routeName : (context) => const TeacherProfileScreen(),
  AttendanceScreen.routeName : (context) => const AttendanceScreen(),
  NotesScreen.routeName : (context) => const NotesScreen(),
};