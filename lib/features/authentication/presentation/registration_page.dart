import 'package:delivera_flutter/features/authentication/data/auth_repository.dart';
import 'package:delivera_flutter/features/authentication/logic/auth_provider.dart';
import 'package:delivera_flutter/features/authentication/logic/register_request.dart';
import 'package:delivera_flutter/features/authentication/logic/user_model.dart';
import 'package:delivera_flutter/features/utils/regex_store.dart';
import 'package:delivera_flutter/features/utils/string_casing_extension.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegistrationPage extends ConsumerStatefulWidget {
  const RegistrationPage({super.key, required this.onBack});
  final Function onBack;

  @override
  ConsumerState<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends ConsumerState<RegistrationPage> {
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
  final _organizationRegistrationNumberController = TextEditingController();

  bool _obscureText = true;
  OrganizationRole? _organizationRole;
  bool _submitting = false;

  void _selectDate(BuildContext context) async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 100, now.month, now.day);
    final lastDate = DateTime(now.year - 18, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: lastDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (picked != null) {
      setState(() => _dateOfBirth = picked);
    }
  }

  Future<void> _register() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _submitting = true);

      final result = await ref
          .read(authRepositoryProvider)
          .register(
            RegisterRequest(
              email: _emailController.text.trim(),
              username: _usernameController.text.trim(),
              phoneNumber: _phoneNumberController.text.trim(),
              firstName: _firstNameController.text.trim(),
              lastName: _lastNameController.text.trim(),
              password: _passwordController.text.trim(),
              nationalId: _nationalIdController.text.trim(),
              dateOfBirth: _dateOfBirth!,
              organizationRole: _organizationRole,
              organizationShortCode: _organizationIdController.text.trim(),
              organizationRegistrationNumber:
                  _organizationRegistrationNumberController.text.trim(),
            ),
          );
      if (result == true) {
        print("whats the result $result");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Registration successful! Please login!")),
        );
        widget.onBack.call();
      } else {
        SnackBar(content: Text("Registration error! $result"));
      }

      setState(() => _submitting = false);
    }
  }

  InputDecoration _fieldDecoration(String label) =>
      InputDecoration(labelText: label);

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
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children:
                        [
                              // Email
                              TextFormField(
                                decoration: _fieldDecoration("Email"),
                                controller: _emailController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Email is required";
                                  }
                                  if (!Utils().emailRegex.hasMatch(value)) {
                                    return "Enter a valid email";
                                  }
                                  return null;
                                },
                              ),

                              // Username
                              TextFormField(
                                decoration: _fieldDecoration("Username"),
                                controller: _usernameController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Username is required";
                                  }
                                  if (value.length < 3) {
                                    return "Username must be at least 3 characters";
                                  }
                                  return null;
                                },
                              ),

                              // Password
                              TextFormField(
                                decoration: _fieldDecoration("Password")
                                    .copyWith(
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(
                                            () => _obscureText = !_obscureText,
                                          );
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
                                    return "Password must be at least 8 characters";
                                  }
                                  if (!Utils().passwordRegex.hasMatch(value)) {
                                    return "Must contain upper, lower, number, and special char";
                                  }
                                  return null;
                                },
                              ),

                              // Phone
                              TextFormField(
                                decoration: _fieldDecoration("Phone"),
                                controller: _phoneNumberController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Phone number is required";
                                  }
                                  if (!Utils().internationalPhoneRegex.hasMatch(
                                    value,
                                  )) {
                                    return "Enter a valid phone number";
                                  }
                                  return null;
                                },
                              ),

                              // First Name
                              TextFormField(
                                decoration: _fieldDecoration("First Name"),
                                controller: _firstNameController,
                                validator: (value) =>
                                    value == null || value.isEmpty
                                    ? "First Name is required"
                                    : null,
                              ),

                              // Last Name
                              TextFormField(
                                decoration: _fieldDecoration("Last Name"),
                                controller: _lastNameController,
                                validator: (value) =>
                                    value == null || value.isEmpty
                                    ? "Last Name is required"
                                    : null,
                              ),

                              // National ID
                              TextFormField(
                                decoration: _fieldDecoration("National ID"),
                                controller: _nationalIdController,
                                validator: (value) =>
                                    value == null || value.isEmpty
                                    ? "National ID is required"
                                    : null,
                              ),

                              // Date of Birth (styled like a textfield)
                              GestureDetector(
                                onTap: () => _selectDate(context),
                                child: AbsorbPointer(
                                  child: TextFormField(
                                    decoration: _fieldDecoration(
                                      "Date of Birth",
                                    ),
                                    controller: TextEditingController(
                                      text: _dateOfBirth == null
                                          ? ""
                                          : _dateOfBirth!
                                                .toIso8601String()
                                                .substring(0, 10),
                                    ),
                                    validator: (_) => _dateOfBirth == null
                                        ? "Date of Birth is required"
                                        : null,
                                  ),
                                ),
                              ),

                              // Organization Role (dropdown styled like textfield)
                              DropdownButtonFormField<OrganizationRole>(
                                decoration: _fieldDecoration("Role"),
                                value: _organizationRole,
                                items: OrganizationRole.values
                                    .map(
                                      (role) => DropdownMenuItem(
                                        value: role,
                                        child: Text(
                                          role.name.capitalizeFirst(),
                                        ),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  setState(() => _organizationRole = value);
                                },
                                validator: (value) => value == null
                                    ? "Please select your role"
                                    : null,
                              ),

                              // Organization ID
                              _organizationRole != OrganizationRole.owner
                                  ? TextFormField(
                                      decoration: _fieldDecoration(
                                        "Organization ID",
                                      ),
                                      controller: _organizationIdController,
                                      validator: (value) =>
                                          value == null || value.isEmpty
                                          ? "Organization ID is required"
                                          : null,
                                    )
                                  : TextFormField(
                                      decoration: _fieldDecoration(
                                        "Organization Registration Number is required",
                                      ),
                                      controller:
                                          _organizationRegistrationNumberController,
                                      validator: (value) =>
                                          value == null || value.isEmpty
                                          ? "Organization Registration No. is required"
                                          : null,
                                    ),
                            ]
                            .map(
                              (w) => Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: w,
                              ),
                            )
                            .toList(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _submitting ? null : _register,
              child: _submitting
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text("Register"),
            ),
          ],
        ),
      ),
    );
  }
}
