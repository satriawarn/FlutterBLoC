import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_state_bloc/bloc/auth_bloc.dart';
import 'package:flutter_state_bloc/presentation/dashboard.dart';
import 'package:flutter_state_bloc/presentation/sign_up.dart';
import 'package:flutter_state_bloc/utils/snack_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../utils/next_screen.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final RoundedLoadingButtonController googleController =
      RoundedLoadingButtonController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SignIn"),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            // Navigating to the dashboard screen if the user is authenticated
            nextScreenReplace(context, const Dashboard());
          }
          if (state is AuthError) {
            // Showing the error message if the user has entered invalid credentials
            openSnackBar(context, state.error, Colors.red);
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            // if (state is Loading) {
            //   // Showing the loading indicator while the user is signing in
            //   return const Center(
            //     child: CircularProgressIndicator(),
            //   );
            // }
            if (state is UnAuthenticated) {
              // Showing the sign in form if the user is not authenticated
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: SingleChildScrollView(
                    reverse: true,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Sign In",
                          style: TextStyle(
                            fontSize: 38,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        Center(
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  controller: _emailController,
                                  decoration: const InputDecoration(
                                    hintText: "Email",
                                    border: OutlineInputBorder(),
                                  ),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    return value != null &&
                                            !EmailValidator.validate(value)
                                        ? 'Enter a valid email'
                                        : null;
                                  },
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  obscureText: true,
                                  keyboardType: TextInputType.text,
                                  controller: _passwordController,
                                  decoration: const InputDecoration(
                                    hintText: "Password",
                                    border: OutlineInputBorder(),
                                  ),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    return value != null && value.length < 6
                                        ? "Enter min. 6 characters"
                                        : null;
                                  },
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                RoundedLoadingButton(
                                  controller: googleController,
                                  successColor: Colors.blue,
                                  width:
                                      MediaQuery.of(context).size.width * 0.80,
                                  elevation: 0,
                                  borderRadius: 25,
                                  onPressed: () {
                                    _authenticateWithEmailAndPassword(context);
                                  },
                                  color: Colors.blue,
                                  child: Wrap(
                                    children: const [
                                      Icon(
                                        FontAwesomeIcons.fire,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 15),
                                      Text(
                                        "Sign In",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // IconButton(
                        //   onPressed: () {
                        //     _authenticateWithGoogle(context);
                        //   },
                        //   icon: Image.network(
                        //     "https://upload.wikimedia.org/wikipedia/commons/thumb/5/53/Google_%22G%22_Logo.svg/1200px-Google_%22G%22_Logo.svg.png",
                        //     height: 30,
                        //     width: 30,
                        //   ),
                        // ),
                        const SizedBox(height: 20.0),
                        RoundedLoadingButton(
                          controller: googleController,
                          successColor: Colors.red,
                          width: MediaQuery.of(context).size.width * 0.80,
                          elevation: 0,
                          borderRadius: 25,
                          onPressed: () {
                            _authenticateWithGoogle(context);
                          },
                          color: Colors.red,
                          child: Wrap(
                            children: const [
                              Icon(
                                FontAwesomeIcons.google,
                                size: 20,
                                color: Colors.white,
                              ),
                              SizedBox(width: 15),
                              Text(
                                "Sign in with Google",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        const Text("Don't have an account?"),
                        OutlinedButton(
                          onPressed: () {
                            nextScreenReplace(context, const SignUp());
                          },
                          child: const Text("Sign Up"),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }

  void _authenticateWithEmailAndPassword(context) {
    if (_formKey.currentState!.validate()) {
      BlocProvider.of<AuthBloc>(context).add(
        SignInRequested(_emailController.text, _passwordController.text),
      );
    }
  }

  void _authenticateWithGoogle(context) {
    BlocProvider.of<AuthBloc>(context).add(
      GoogleSignInRequested(),
    );
  }
}
