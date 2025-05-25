import 'package:flutter/material.dart';
import 'package:learning_platform/constants.dart';
import 'package:learning_platform/components/custom_buttons.dart';
import 'package:learning_platform/screens/forgetpassword_screen/email_verification_screen.dart';
import 'package:learning_platform/screens/home_screen/home_screen.dart';
import 'package:learning_platform/screens/teacher_profile_screen/teacher_profile_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

late bool _passwordVisible;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key});

  static String routeName = 'LoginScreen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _passwordVisible = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: kOtherColor,
          onPressed: () => Navigator.pop(context, false),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          body: ListView(
            children: <Widget>[
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 2.8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/splash.png',
                      height: 150.0,
                      width: 150.0,
                    ),
                    const SizedBox(
                      height: kDefaultPadding / 2,
                    ),
                    Text(
                      'Sign in as ${userRole.getRole}',
                      style: const TextStyle(
                        color: kTextWhiteColor,
                        fontWeight: FontWeight.normal,
                        fontSize: 35.0,
                      ),
                    ),
                    const SizedBox(
                      height: kDefaultPadding / 6,
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(kDefaultPadding * 3),
                    topRight: Radius.circular(kDefaultPadding * 3),
                  ),
                  color: kOtherColor,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(kDefaultPadding),
                  child: Column(
                    children: [
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            sizedBox,
                            buildEmailField(),
                            sizedBox,
                            buildPasswordField(),
                            sizedBox,
                            DefaultButton(
                              onPress: () async {
                                if (_formKey.currentState!.validate()) {
                                  _performLogin(context);
                                }
                              },
                              title: 'SIGN IN',
                              iconData: Icons.arrow_forward_outlined,
                            ),
                            sizedBox,
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, EmailVerificationPage.routeName);
                              },
                              child: const Align(
                                alignment: Alignment.bottomRight,
                                child: Text(
                                  'Forget password?',
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    color: kPrimaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField buildEmailField() {
    return TextFormField(
      controller: _emailController,
      textAlign: TextAlign.start,
      keyboardType: TextInputType.emailAddress,
      style: Theme.of(context)
          .textTheme
          .titleSmall!
          .copyWith(color: kTextBlackColor),
      decoration: const InputDecoration(
        labelText: 'Mobile Number/Email',
        floatingLabelBehavior: FloatingLabelBehavior.always,
        isDense: true,
      ),
      validator: (value) {
        RegExp regExp = RegExp(emailPattern);
        if (value == null || value.isEmpty) {
          return 'Please Enter Some Text';
        }
        else if (!regExp.hasMatch(value)) {
          return 'Please Enter a valid Email Address';
        }
      },
    );
  }

  TextFormField buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _passwordVisible,
      textAlign: TextAlign.start,
      keyboardType: TextInputType.visiblePassword,
      style: Theme.of(context)
          .textTheme
          .titleSmall!
          .copyWith(color: kTextBlackColor),
      decoration: InputDecoration(
        labelText: 'Password',
        floatingLabelBehavior: FloatingLabelBehavior.always,
        isDense: true,
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _passwordVisible = !_passwordVisible;
            });
          },
          icon: Icon(
            _passwordVisible ? Icons.visibility : Icons.visibility_off,
          ),
        ),
      ),
      validator: (value) {
        if (value!.length < 6) {
          return 'Must be more than 6 characters';
        }
      },
    );
  }

  void _performLogin(BuildContext context) async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    try {
      final response = await http.post(
        Uri.parse('${baseURL}login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final accessToken = json.decode(response.body)['access_token'];
        accessVerificationToken = accessToken;
        if (userRole.getRole == "Teacher") {
          Navigator.pushNamedAndRemoveUntil(
              context, TeacherProfileScreen.routeName, (route) => false);
        }
        else {
          Navigator.pushNamedAndRemoveUntil(
              context, HomeScreen.routeName, (route) => false);
        }
      }
      else {
        _showErrorSnackBar(context, 'Invalid Credentials');
      }
    }
    catch (e) {
      _showErrorSnackBar(context, 'No Internet Connection');
    }
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}
