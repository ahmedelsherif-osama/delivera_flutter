import 'package:delivera_flutter/features/orgadmin_actions/data/orgadmin_repository.dart';
import 'package:delivera_flutter/features/orgadmin_actions/logic/order_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateOrder extends ConsumerStatefulWidget {
  const CreateOrder({super.key, required this.onBack});
  final Function onBack;
  @override
  ConsumerState<CreateOrder> createState() => _CreateOrderState();
}

class _CreateOrderState extends ConsumerState<CreateOrder> {
  //   {
  final _orderDetailsController = TextEditingController();

  Location? _pickUpLocation;

  Location? _dropOffLocation;

  final _formKey = GlobalKey<FormState>();

  bool _submitting = false;

  Future<void> _createOrder() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _submitting = true);
      final order = Order(
        id: "",
        organizationId: "",
        status: OrderStatus.created,
        pickUpLocation: _pickUpLocation!,
        dropOffLocation: _dropOffLocation!,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        orderDetails: _orderDetailsController.text,
        createdById: "",
      );
      final result = ref.read(orgAdminRepoProvider).createOrder(order);

      setState(() => _submitting = false);
    }
  }

  InputDecoration _fieldDecoration(String label) =>
      InputDecoration(labelText: label);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: 550,
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
                              Center(
                                child: Text(
                                  "Create Order",
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ),
                              SizedBox(height: 10),

                              // Email

                              // Password

                              // Phone
                              TextFormField(
                                decoration: _fieldDecoration("Order Details"),
                                controller: _orderDetailsController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Order details are required";
                                  }

                                  return null;
                                },
                              ),

                              // First Name

                              // National ID

                              // Date of Birth (styled like a textfield)

                              // Organization ID
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
              onPressed: _submitting ? null : _createOrder,
              child: _submitting
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text("Create"),
            ),
          ],
        ),
      ),
    );
  }
}
