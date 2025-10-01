import 'package:delivera_flutter/features/authentication/logic/user_model.dart';
import 'package:delivera_flutter/features/utils/regex_store.dart';
import 'package:delivera_flutter/features/utils/string_casing_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key, required this.onBack});
  final Function onBack;

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _dateOfBirth;
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _nationalIdController = TextEditingController();
  final _organizationIdController = TextEditingController();

  final _passwordController = TextEditingController();
  bool _obscureText = true;
  OrganizationRole? _organizationRole;
  bool _submitting = false;

  void _selectDate(BuildContext context) async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 100, now.month, now.day);
    final lastDate = DateTime(now.year - 18, now.month, now.day);
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: lastDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (picked != null) {
      setState(() {
        _dateOfBirth = picked;
      });
    }
  }

  Future<bool> _register() async {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        widget.onBack.call();
      },
      child: SizedBox(
        height: 450,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(labelText: "Email"),
                          controller: _emailController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Email is required";
                            }
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: "Username"),
                          controller: _usernameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Username is required";
                            }
                          },
                        ),
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
                        TextFormField(
                          decoration: InputDecoration(labelText: "Phone"),
                          controller: _phoneNumberController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Phone number is required";
                            }
                          },
                        ),

                        TextFormField(
                          decoration: InputDecoration(labelText: "First Name"),
                          controller: _firstNameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "First Name is required";
                            }
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: "Last Name"),
                          controller: _lastNameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Last Name is required";
                            }
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: "National ID"),
                          controller: _nationalIdController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "National ID is required";
                            }
                          },
                        ),
                        Row(
                          children: [
                            Text("Date of birth: "),
                            TextButton(
                              onPressed: () {
                                _selectDate(context);
                              },
                              child: Text(
                                _dateOfBirth == null
                                    ? "Select date"
                                    : _dateOfBirth!.toIso8601String().substring(
                                        0,
                                        10,
                                      ),
                              ),
                            ),
                          ],
                        ),
                        DropdownButton(
                          hint: Text("What's your role?"),
                          value: _organizationRole,
                          items: OrganizationRole.values
                              .map(
                                (role) => DropdownMenuItem(
                                  value: role,
                                  child: Text((role.name).capitalizeFirst()),
                                ),
                              )
                              .toList(),

                          onChanged: (value) {
                            setState(() {
                              _organizationRole = value;
                            });
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: "Organization ID",
                          ),
                          controller: _organizationIdController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Organization ID is required";
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                _submitting ? null : _register();
              },
              child: _submitting
                  ? Center(child: CircularProgressIndicator())
                  : Text("Register"),
            ),
          ],
        ),
      ),
    );
  }
}
