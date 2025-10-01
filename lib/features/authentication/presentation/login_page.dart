import 'package:delivera_flutter/features/authentication/logic/auth_provider.dart';
import 'package:delivera_flutter/features/authentication/presentation/registration_page.dart';
import 'package:delivera_flutter/features/utils/regex_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key, required this.changeAccountStatus});
  final Function changeAccountStatus;

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscureText = true;

  _login() async {
    if (_formKey.currentState!.validate()) {
      await ref
          .read(authProvider.notifier)
          .login(
            _usernameController.text.trim(),
            _passwordController.text.trim(),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: 25,
              left: 33,
              right: 33,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: "Username"),
                    controller: _usernameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Username is required";
                      }
                    },
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Password",
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText; // toggle
                          });
                        },
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                    ),
                    obscureText: _obscureText,
                    controller: _passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Password is required";
                      }
                      if (value.length < 8) {
                        return "Password must be at least 8 characters long";
                      }
                      if (!Utils().passwordRegex.hasMatch(value)) {
                        return "Must contain upper, lower, number, and special char";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 70),
                  ElevatedButton(
                    onPressed: () {
                      authState.isLoading ? null : _login();
                    },
                    child: authState.isLoading
                        ? Center(child: CircularProgressIndicator())
                        : Text("Login"),
                  ),
                  TextButton(
                    onPressed: () {
                      widget.changeAccountStatus.call();
                    },
                    child: Text("No account yet? Register now!"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
