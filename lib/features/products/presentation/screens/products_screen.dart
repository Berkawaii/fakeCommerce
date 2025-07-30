import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:f_commerce/features/products/data/product_model.dart';
import 'package:f_commerce/features/products/data/product_providers.dart';
import 'package:f_commerce/features/products/presentation/screens/product_detail_screen.dart';
import 'package:f_commerce/core/theme/app_theme.dart';

class ProductsScreen extends ConsumerStatefulWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends ConsumerState<ProductsScreen> {
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(productCategoriesProvider);
    final productsAsync = _selectedCategory != null
        ? ref.watch(categoryProductsProvider(_selectedCategory!))
        : ref.watch(productListProvider);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            _buildHeader(),
            SizedBox(height: 20.h),
            _buildCategorySelector(categoriesAsync),
            SizedBox(height: 20.h),
            _buildProductList(productsAsync),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'F-Commerce',
          style: TextStyle(
            fontSize: 28.sp,
            fontWeight: FontWeight.bold,
            color: NeumorphicTheme.accentColor(context),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'Discover your style with neumorphic design',
          style: TextStyle(
            fontSize: 16.sp,
            color: NeumorphicTheme.defaultTextColor(context).withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildCategorySelector(AsyncValue<List<String>> categoriesAsync) {
    return categoriesAsync.when(
      data: (categories) => SizedBox(
        height: 50.h,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length + 1, // +1 for "All" category
          itemBuilder: (context, index) {
            final isAllCategory = index == 0;
            final category = isAllCategory ? 'All' : categories[index - 1];
            final isSelected = isAllCategory
                ? _selectedCategory == null
                : _selectedCategory == categories[index - 1];

            return Padding(
              padding: EdgeInsets.only(right: 12.w),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedCategory = isAllCategory ? null : category;
                  });
                },
                child: Neumorphic(
                  style: NeumorphicStyle(
                    depth: isSelected ? 4 : -2,
                    intensity: 0.8,
                    boxShape: NeumorphicBoxShape.roundRect(
                      BorderRadius.circular(25),
                    ),
                    color: isSelected
                        ? NeumorphicTheme.accentColor(context).withOpacity(0.1)
                        : NeumorphicTheme.baseColor(context),
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    alignment: Alignment.center,
                    child: Text(
                      _capitalizeFirstLetter(category),
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isSelected
                            ? NeumorphicTheme.accentColor(context)
                            : NeumorphicTheme.defaultTextColor(context),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      loading: () => const Center(child: NeumorphicProgressIndeterminate()),
      error: (error, stackTrace) => Center(
        child: Text(
          'Failed to load categories: ${error.toString()}',
          style: TextStyle(color: AppTheme.errorColor),
        ),
      ),
    );
  }

  Widget _buildProductList(AsyncValue<List<Product>> productsAsync) {
    return Expanded(
      child: productsAsync.when(
        data: (products) => GridView.builder(
          physics: const BouncingScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 16.w,
            mainAxisSpacing: 16.h,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            return _buildProductCard(products[index]);
          },
        ),
        loading: () => const Center(child: NeumorphicProgressIndeterminate()),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Failed to load products',
                style: TextStyle(color: AppTheme.errorColor, fontSize: 18.sp),
              ),
              SizedBox(height: 8.h),
              Text(
                error.toString(),
                style: TextStyle(fontSize: 14.sp),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.h),
              NeumorphicButton(
                style: NeumorphicStyle(
                  depth: 4,
                  boxShape: NeumorphicBoxShape.roundRect(
                    BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  if (_selectedCategory != null) {
                    ref.refresh(categoryProductsProvider(_selectedCategory!));
                  } else {
                    ref.refresh(productListProvider);
                  }
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: Neumorphic(
        style: NeumorphicStyle(
          depth: 4,
          intensity: 0.75,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(16)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image container
            Expanded(
              flex: 4,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.r),
                    topRight: Radius.circular(16.r),
                  ),
                  color: Colors.white,
                ),
                padding: EdgeInsets.all(12.r),
                child: CachedNetworkImage(
                  imageUrl: product.imageUrl,
                  fit: BoxFit.contain,
                  placeholder: (context, url) => const Center(
                    child: NeumorphicProgressIndeterminate(height: 4),
                  ),
                  errorWidget: (context, url, error) =>
                      const Center(child: Icon(Icons.error_outline)),
                ),
              ),
            ),
            // Product info
            Expanded(
              flex: 3,
              child: Padding(
                padding: EdgeInsets.all(12.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      product.category,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: NeumorphicTheme.defaultTextColor(
                          context,
                        ).withOpacity(0.6),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: NeumorphicTheme.accentColor(context),
                          ),
                        ),
                        if (product.rating != null)
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 16.sp,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                product.rating!.rate.toString(),
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}
