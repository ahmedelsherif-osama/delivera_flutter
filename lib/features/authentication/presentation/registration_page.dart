import 'package:delivera_flutter/features/authentication/logic/user_model.dart';
import 'package:delivera_flutter/features/utils/regex_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

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
    return Scaffold(
      body: Expanded(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 50),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 0, right: 50),
                  child: SvgPicture.asset("assets/delivera_logo.svg"),
                ),
                Padding(
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
                        //                     {
                        // "email": "rider4@example.com",
                        // "username": "rider4",
                        // "phoneNumber": "1234567822",
                        // "firstName": "Test",
                        // "lastName": "User",
                        // "password": "changemE@123",
                        // "globalRole": "orguser",
                        // "nationalId": "123456333",
                        // "dateOfBirth": "2005-05-12",
                        // "organizationRole":"rider",
                        // "organizationId":"AD8EA38C-36C2-48E9-B6D8-558EC4D9EE8B"
                        // }
                        //
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
                          value: _organizationRole,
                          items: OrganizationRole.values
                              .map(
                                (role) => DropdownMenuItem(
                                  child: Text(role.toString().toLowerCase()),
                                  value: role,
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
