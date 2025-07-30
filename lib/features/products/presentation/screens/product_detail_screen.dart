import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:f_commerce/features/products/data/product_model.dart';
import 'package:f_commerce/features/cart/data/cart_providers.dart';
import 'package:f_commerce/core/storage/storage_service.dart';
import 'package:f_commerce/core/providers/providers.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final Product product;

  const ProductDetailScreen({Key? key, required this.product})
    : super(key: key);

  @override
  ConsumerState<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  int quantity = 1;
  bool isInWishlist = false;

  @override
  void initState() {
    super.initState();
    _checkWishlistStatus();
  }

  Future<void> _checkWishlistStatus() async {
    final storageService = ref.read(storageServiceProvider);
    setState(() {
      isInWishlist = storageService.isInWishlist(widget.product.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartStateProvider);

    return Scaffold(
      backgroundColor: NeumorphicTheme.baseColor(context),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProductImage(),
                      SizedBox(height: 20.h),
                      _buildProductInfo(),
                      SizedBox(height: 20.h),
                      _buildQuantitySelector(),
                      SizedBox(height: 20.h),
                      _buildDescription(),
                      SizedBox(
                        height: 100.h,
                      ), // Extra space for the bottom button
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildAddToCartButton(cartState),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          NeumorphicButton(
            style: NeumorphicStyle(
              depth: 4,
              boxShape: NeumorphicBoxShape.circle(),
            ),
            onPressed: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back,
              color: NeumorphicTheme.defaultTextColor(context),
              size: 24.sp,
            ),
          ),
          NeumorphicButton(
            style: NeumorphicStyle(
              depth: 4,
              boxShape: NeumorphicBoxShape.circle(),
            ),
            onPressed: _toggleWishlist,
            child: Icon(
              isInWishlist ? Icons.favorite : Icons.favorite_border,
              color: isInWishlist
                  ? Colors.red
                  : NeumorphicTheme.defaultTextColor(context),
              size: 24.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductImage() {
    return Container(
      height: 300.h,
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      child: Neumorphic(
        style: NeumorphicStyle(
          depth: 8,
          intensity: 0.65,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(20)),
        ),
        child: Padding(
          padding: EdgeInsets.all(25.r),
          child: CachedNetworkImage(
            imageUrl: widget.product.imageUrl,
            fit: BoxFit.contain,
            placeholder: (context, url) =>
                const Center(child: NeumorphicProgressIndeterminate()),
            errorWidget: (context, url, error) =>
                const Center(child: Icon(Icons.error_outline)),
          ),
        ),
      ),
    );
  }

  Widget _buildProductInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                widget.product.title,
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: NeumorphicTheme.defaultTextColor(context),
                ),
              ),
            ),
            SizedBox(width: 16.w),
            Text(
              '\$${widget.product.price.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: NeumorphicTheme.accentColor(context),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        _buildCategoryAndRating(),
      ],
    );
  }

  Widget _buildCategoryAndRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Neumorphic(
          style: NeumorphicStyle(
            depth: 2,
            intensity: 0.7,
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(30)),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Text(
              widget.product.category,
              style: TextStyle(
                fontSize: 14.sp,
                color: NeumorphicTheme.defaultTextColor(context),
              ),
            ),
          ),
        ),
        if (widget.product.rating != null)
          Row(
            children: [
              Icon(Icons.star, color: Colors.amber, size: 20.sp),
              SizedBox(width: 4.w),
              Text(
                '${widget.product.rating!.rate} (${widget.product.rating!.count})',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildQuantitySelector() {
    return Row(
      children: [
        Text(
          'Quantity:',
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500),
        ),
        SizedBox(width: 16.w),
        NeumorphicButton(
          style: NeumorphicStyle(
            depth: 4,
            boxShape: NeumorphicBoxShape.circle(),
          ),
          onPressed: () {
            if (quantity > 1) {
              setState(() {
                quantity--;
              });
            }
          },
          child: Icon(
            Icons.remove,
            size: 20.sp,
            color: quantity > 1
                ? NeumorphicTheme.defaultTextColor(context)
                : NeumorphicTheme.defaultTextColor(context).withOpacity(0.3),
          ),
        ),
        SizedBox(width: 16.w),
        Text(
          quantity.toString(),
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(width: 16.w),
        NeumorphicButton(
          style: NeumorphicStyle(
            depth: 4,
            boxShape: NeumorphicBoxShape.circle(),
          ),
          onPressed: () {
            setState(() {
              quantity++;
            });
          },
          child: Icon(
            Icons.add,
            size: 20.sp,
            color: NeumorphicTheme.defaultTextColor(context),
          ),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12.h),
        Neumorphic(
          style: NeumorphicStyle(
            depth: -3,
            intensity: 0.7,
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Text(
              widget.product.description,
              style: TextStyle(
                fontSize: 16.sp,
                height: 1.5,
                color: NeumorphicTheme.defaultTextColor(
                  context,
                ).withOpacity(0.8),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddToCartButton(CartState cartState) {
    final totalPrice = widget.product.price * quantity;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: NeumorphicTheme.baseColor(context),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, -5),
            blurRadius: 10,
          ),
        ],
      ),
      child: NeumorphicButton(
        style: NeumorphicStyle(
          depth: 4,
          intensity: 0.8,
          color: NeumorphicTheme.accentColor(context),
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
        ),
        onPressed: cartState.isLoading ? null : _addToCart,
        child: Container(
          height: 56.h,
          alignment: Alignment.center,
          child: cartState.isLoading
              ? const NeumorphicProgressIndeterminate(height: 5)
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_cart, color: Colors.white, size: 24.sp),
                    SizedBox(width: 12.w),
                    Text(
                      'Add to Cart - \$${totalPrice.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  void _toggleWishlist() async {
    final storageService = ref.read(storageServiceProvider);
    await storageService.toggleWishlistItem(widget.product.id);
    setState(() {
      isInWishlist = !isInWishlist;
    });

    // Show snackbar
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isInWishlist
              ? 'Added to your wishlist'
              : 'Removed from your wishlist',
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _addToCart() async {
    final cartNotifier = ref.read(cartStateProvider.notifier);
    await cartNotifier.addToCart(widget.product, quantity);

    // Show snackbar
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Added to your cart'),
        duration: Duration(seconds: 1),
      ),
    );
  }
}
