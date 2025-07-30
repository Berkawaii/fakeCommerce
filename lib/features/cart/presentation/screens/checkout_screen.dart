import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:f_commerce/core/theme/app_theme.dart';
import 'package:f_commerce/features/cart/data/cart_providers.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _zipController = TextEditingController();
  String _paymentMethod = 'credit_card';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _zipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartStateProvider);
    
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.h),
                  _buildHeader(context),
                  SizedBox(height: 32.h),
                  _buildOrderSummary(cartState),
                  SizedBox(height: 32.h),
                  _buildShippingForm(),
                  SizedBox(height: 32.h),
                  _buildPaymentMethod(),
                  SizedBox(height: 32.h),
                  _buildCheckoutButton(),
                  SizedBox(height: 32.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        NeumorphicButton(
          style: NeumorphicStyle(
            depth: 4,
            intensity: 0.6,
            boxShape: NeumorphicBoxShape.circle(),
          ),
          onPressed: () => Navigator.pop(context),
          padding: EdgeInsets.all(8.r),
          child: Icon(
            Icons.arrow_back,
            size: 20.sp,
          ),
        ),
        SizedBox(width: 16.w),
        Text(
          'Checkout',
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildOrderSummary(CartState cartState) {
    return Neumorphic(
      style: NeumorphicStyle(
        depth: 4,
        intensity: 0.7,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(16)),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Summary',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.h),
            _buildSummaryRow('Items', '${cartState.itemCount}'),
            SizedBox(height: 8.h),
            _buildSummaryRow('Subtotal', '\$${cartState.total.toStringAsFixed(2)}'),
            SizedBox(height: 8.h),
            _buildSummaryRow('Shipping', 'Free'),
            SizedBox(height: 8.h),
            const Divider(),
            SizedBox(height: 8.h),
            _buildSummaryRow(
              'Total',
              '\$${cartState.total.toStringAsFixed(2)}',
              isBold: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String title, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: isBold ? 18.sp : 16.sp,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isBold ? 18.sp : 16.sp,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildShippingForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Shipping Information',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16.h),
        _buildTextField(
          controller: _nameController,
          label: 'Full Name',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your name';
            }
            return null;
          },
        ),
        SizedBox(height: 16.h),
        _buildTextField(
          controller: _emailController,
          label: 'Email',
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
              return 'Please enter a valid email';
            }
            return null;
          },
        ),
        SizedBox(height: 16.h),
        _buildTextField(
          controller: _phoneController,
          label: 'Phone Number',
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your phone number';
            }
            return null;
          },
        ),
        SizedBox(height: 16.h),
        _buildTextField(
          controller: _addressController,
          label: 'Address',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your address';
            }
            return null;
          },
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: _buildTextField(
                controller: _cityController,
                label: 'City',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your city';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              flex: 2,
              child: _buildTextField(
                controller: _zipController,
                label: 'ZIP Code',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your ZIP code';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    return Neumorphic(
      style: NeumorphicStyle(
        depth: -3,
        intensity: 0.7,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            labelText: label,
            border: InputBorder.none,
            errorStyle: TextStyle(
              color: AppTheme.errorColor,
              fontSize: 12.sp,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethod() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Method',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16.h),
        _buildPaymentOption(
          title: 'Credit Card',
          value: 'credit_card',
          icon: Icons.credit_card,
        ),
        SizedBox(height: 12.h),
        _buildPaymentOption(
          title: 'PayPal',
          value: 'paypal',
          icon: Icons.paypal,
        ),
        SizedBox(height: 12.h),
        _buildPaymentOption(
          title: 'Cash on Delivery',
          value: 'cod',
          icon: Icons.money,
        ),
      ],
    );
  }

  Widget _buildPaymentOption({
    required String title,
    required String value,
    required IconData icon,
  }) {
    final isSelected = _paymentMethod == value;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _paymentMethod = value;
        });
      },
      child: Neumorphic(
        style: NeumorphicStyle(
          depth: isSelected ? 4 : 2,
          intensity: 0.7,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
          color: isSelected
              ? NeumorphicTheme.accentColor(context).withOpacity(0.1)
              : null,
        ),
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: Row(
            children: [
              Icon(
                icon,
                size: 24.sp,
                color: isSelected ? NeumorphicTheme.accentColor(context) : null,
              ),
              SizedBox(width: 16.w),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? NeumorphicTheme.accentColor(context) : null,
                ),
              ),
              const Spacer(),
              NeumorphicRadio(
                style: NeumorphicRadioStyle(
                  selectedDepth: -4,
                  unselectedDepth: 2,
                  boxShape: NeumorphicBoxShape.circle(),
                ),
                groupValue: _paymentMethod,
                value: value,
                onChanged: (String? value) {
                  if (value != null) {
                    setState(() {
                      _paymentMethod = value;
                    });
                  }
                },
                padding: EdgeInsets.all(2.r),
                child: Icon(
                  Icons.circle,
                  size: 16.sp,
                  color: isSelected ? NeumorphicTheme.accentColor(context) : Colors.transparent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCheckoutButton() {
    return NeumorphicButton(
      style: NeumorphicStyle(
        depth: 4,
        intensity: 0.8,
        color: NeumorphicTheme.accentColor(context),
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
      ),
      onPressed: _submitOrder,
      child: Container(
        height: 50.h,
        alignment: Alignment.center,
        width: double.infinity,
        child: Text(
          'Place Order',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _submitOrder() {
    if (_formKey.currentState?.validate() ?? false) {
      // In a real app, we would send the order to the server
      // For now, just show a success message and clear the cart
      
      // Clear the cart
      ref.read(cartStateProvider.notifier).clearCart();
      
      // Show success message and navigate back to home
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Order placed successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      
      // Pop twice to go back to home screen
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }
}
