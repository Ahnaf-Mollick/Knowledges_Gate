import 'package:get/get.dart';
import 'package:knowledges_gate/screens/QuestionScreen.dart';
import 'package:knowledges_gate/screens/LoginScreen.dart';
import 'package:knowledges_gate/screens/SignUpScreen.dart';
import 'package:knowledges_gate/screens/ResultScreen.dart';

class Routes {
  static const String LOGINROUTE = '/login';
  static const String SIGNUPROUTE = '/signup';
  static const String QUESTIONROUTE = '/question';
  static const String RESULTROUTE = '/result';

  static List<GetPage> routes = [
    GetPage(name: LOGINROUTE, page: () => LoginScreen()),
    GetPage(name: SIGNUPROUTE, page: () => SignUpScreen()),
    GetPage(name: QUESTIONROUTE, page: () => QuestionScreen()),
    GetPage(name: RESULTROUTE, page: () => ResultScreen()),
  ];
}
