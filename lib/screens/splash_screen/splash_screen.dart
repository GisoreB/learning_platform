import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learning_platform/constants.dart';
import 'package:learning_platform/screens/choose_your_role_screen/choose_role_page.dart';

class SplashScreen extends StatelessWidget {
  static String routeName = 'SplashScreen';

  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(
      const Duration(seconds: 5),
      () {
        Navigator.pushNamedAndRemoveUntil(
            context, ChooseRoleScreen.routeName, (route) => false);
      },
    );

    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'IIITA',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: kTextWhiteColor,
                        fontSize: 50.0,
                        fontStyle: FontStyle.italic,
                        letterSpacing: 3.0,
                      ),
                ),
                Text(
                  'IMS',
                  style: GoogleFonts.pattaya(
                    fontSize: 50.0,
                    fontStyle: FontStyle.italic,
                    color: kTextWhiteColor,
                    letterSpacing: 3.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            Image.asset(
              'assets/images/splash.png',
              height: 150.0,
              width: 150.0,
            ),
          ],
        ),
      ),
    );
  }
}
