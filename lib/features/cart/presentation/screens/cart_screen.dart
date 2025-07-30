import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:f_commerce/features/cart/data/cart_providers.dart';
import 'package:f_commerce/features/cart/data/cart_model.dart';
import 'package:f_commerce/core/theme/app_theme.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartStateProvider);
    
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            _buildHeader(),
            SizedBox(height: 24.h),
            if (cartState.isLoading)
              const Expanded(
                child: Center(
                  child: NeumorphicProgressIndeterminate(),
                ),
              )
            else if (cartState.items.isEmpty)
              Expanded(
                child: _buildEmptyCart(),
              )
            else
              Expanded(
                child: _buildCartItems(context, ref, cartState),
              ),
            if (cartState.items.isNotEmpty)
              _buildCheckoutSection(context, ref, cartState),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Text(
      'Shopping Cart',
      style: TextStyle(
        fontSize: 28.sp,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.shopping_cart_outlined,
            size: 80,
            color: Colors.grey,
          ),
          SizedBox(height: 16.h),
          Text(
            'Your cart is empty',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Browse products and add items to your cart',
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCartItems(BuildContext context, WidgetRef ref, CartState cartState) {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemCount: cartState.items.length,
      separatorBuilder: (context, index) => SizedBox(height: 16.h),
      itemBuilder: (context, index) {
        final item = cartState.items[index];
        return _buildCartItem(context, ref, item);
      },
    );
  }

  Widget _buildCartItem(BuildContext context, WidgetRef ref, CartItem item) {
    return Neumorphic(
      style: NeumorphicStyle(
        depth: 4,
        intensity: 0.7,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(16)),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.r),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Product image
            Container(
              width: 80.w,
              height: 80.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: item.imageUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: CachedNetworkImage(
                        imageUrl: item.imageUrl!,
                        fit: BoxFit.contain,
                        placeholder: (context, url) => const Center(
                          child: NeumorphicProgressIndeterminate(
                            height: 2,
                          ),
                        ),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),
                    )
                  : const Icon(Icons.image_not_supported),
            ),
            SizedBox(width: 16.w),
            // Product info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title ?? 'Product #${item.productId}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  if (item.price != null)
                    Text(
                      '\$${item.price!.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: NeumorphicTheme.accentColor(context),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            // Quantity control
            Column(
              children: [
                Row(
                  children: [
                    NeumorphicButton(
                      style: NeumorphicStyle(
                        depth: 4,
                        boxShape: NeumorphicBoxShape.circle(),
                        color: NeumorphicTheme.baseColor(context),
                        intensity: 0.6,
                      ),
                      onPressed: () {
                        if (item.quantity > 1) {
                          _updateQuantity(ref, item.productId, item.quantity - 1);
                        }
                      },
                      padding: EdgeInsets.all(8.r),
                      child: Icon(
                        Icons.remove,
                        size: 16.sp,
                        color: item.quantity > 1
                            ? NeumorphicTheme.defaultTextColor(context)
                            : Colors.grey,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      item.quantity.toString(),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    NeumorphicButton(
                      style: NeumorphicStyle(
                        depth: 4,
                        boxShape: NeumorphicBoxShape.circle(),
                        color: NeumorphicTheme.baseColor(context),
                        intensity: 0.6,
                      ),
                      onPressed: () {
                        _updateQuantity(ref, item.productId, item.quantity + 1);
                      },
                      padding: EdgeInsets.all(8.r),
                      child: Icon(
                        Icons.add,
                        size: 16.sp,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                NeumorphicButton(
                  style: NeumorphicStyle(
                    depth: 2,
                    boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(8)),
                    color: AppTheme.errorColor.withOpacity(0.1),
                    intensity: 0.6,
                  ),
                  onPressed: () => _removeItem(ref, item.productId),
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                  child: Text(
                    'Remove',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppTheme.errorColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckoutSection(BuildContext context, WidgetRef ref, CartState cartState) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Column(
        children: [
          // Order summary
          Neumorphic(
            style: NeumorphicStyle(
              depth: -3,
              intensity: 0.7,
              boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(16)),
            ),
            child: Padding(
              padding: EdgeInsets.all(16.r),
              child: Column(
                children: [
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
          ),
          SizedBox(height: 16.h),
          // Checkout button
          NeumorphicButton(
            style: NeumorphicStyle(
              depth: 4,
              intensity: 0.8,
              color: NeumorphicTheme.accentColor(context),
              boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
            ),
            onPressed: () => _proceedToCheckout(context, ref, cartState),
            child: Container(
              height: 50.h,
              alignment: Alignment.center,
              width: double.infinity,
              child: Text(
                'Proceed to Checkout',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
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

  void _updateQuantity(WidgetRef ref, int productId, int quantity) {
    ref.read(cartStateProvider.notifier).updateQuantity(productId, quantity);
  }

  void _removeItem(WidgetRef ref, int productId) {
    ref.read(cartStateProvider.notifier).removeItem(productId);
  }

  void _proceedToCheckout(BuildContext context, WidgetRef ref, CartState cartState) {
    // In a real app, we'd check authentication first
    // For now, just navigate to checkout
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Checkout'),
        content: Text('Thank you for your order!\nTotal: \$${cartState.total.toStringAsFixed(2)}'),
        actions: [
          TextButton(
            onPressed: () {
              // Clear cart
              ref.read(cartStateProvider.notifier).clearCart();
              Navigator.pop(context);
            },
            child: Text('Complete'),
          ),
        ],
      ),
    );
  }
}
