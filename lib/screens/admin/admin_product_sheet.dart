import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/product.dart';

/// Opens the "Add product" / "Edit product" bottom sheet.
///
/// The sheet only collects and validates the form. It never touches the data
/// itself: when the admin taps save, [onSaved] receives the finished product
/// and the original one (null when a new product is being added).
void showAdminProductSheet(
  BuildContext context, {
  Product? product,
  String? initialCategory,
  required void Function(Product updated, Product? original) onSaved,
}) {
  final isEditing = product != null;
  final nameController = TextEditingController(text: product?.name ?? '');
  final priceController = TextEditingController(
    text: product?.pricePerKg.toStringAsFixed(0) ?? '',
  );
  var category = product?.category ?? initialCategory ?? 'fish';
  var available = product?.isAvailable ?? true;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) => StatefulBuilder(
      builder: (innerContext, setSheetState) => Padding(
        padding: EdgeInsets.only(
          top: 36,
          bottom: MediaQuery.viewInsetsOf(innerContext).bottom,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 30,
                offset: const Offset(0, -10),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(22, 14, 22, 28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    isEditing ? 'Edit product' : 'Add product',
                    style: AppTextStyles.heading2,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Changes appear in the customer catalogue immediately.',
                    style: AppTextStyles.body,
                  ),
                  const SizedBox(height: 24),
                  const Text('Product name', style: AppTextStyles.bodyMedium),
                  const SizedBox(height: 8),
                  TextField(
                    controller: nameController,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      hintText: 'e.g. Vanjaram',
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text('Price per kg', style: AppTextStyles.bodyMedium),
                  const SizedBox(height: 8),
                  TextField(
                    controller: priceController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'e.g. 850',
                      prefixText: '₹  ',
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text('Category', style: AppTextStyles.bodyMedium),
                  const SizedBox(height: 8),
                  SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(
                        value: 'fish',
                        label: Text('Fish'),
                        icon: Icon(Icons.set_meal_rounded),
                      ),
                      ButtonSegment(
                        value: 'chicken',
                        label: Text('Chicken'),
                        icon: Icon(Icons.restaurant_rounded),
                      ),
                    ],
                    selected: {category},
                    onSelectionChanged: (value) =>
                        setSheetState(() => category = value.first),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surfaceSoft,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: SwitchListTile.adaptive(
                      title: const Text(
                        'Available today',
                        style: AppTextStyles.bodyMedium,
                      ),
                      subtitle: Text(
                        available
                            ? 'Visible to customers'
                            : 'Shown as out of stock',
                      ),
                      value: available,
                      onChanged: (value) =>
                          setSheetState(() => available = value),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      final name = nameController.text.trim();
                      final price = double.tryParse(
                        priceController.text.trim(),
                      );
                      if (name.isEmpty || price == null || price <= 0) {
                        ScaffoldMessenger.of(innerContext).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Enter a valid product name and price.',
                            ),
                          ),
                        );
                        return;
                      }
                      final original = product;
                      final updated = Product(
                        id: original?.id ??
                            'product_${DateTime.now().millisecondsSinceEpoch}',
                        name: name,
                        pricePerKg: price,
                        isAvailable: available,
                        category: category,
                        imageUrl:
                            original != null && original.category == category
                            ? original.imageUrl
                            : category == 'fish'
                            ? 'assets/images/vanjaram.jpg'
                            : 'assets/images/broiler_chicken.jpg',
                      );
                      onSaved(updated, original);
                      Navigator.pop(sheetContext);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isEditing ? 'Product updated' : 'Product added',
                          ),
                        ),
                      );
                    },
                    child: Text(isEditing ? 'Save changes' : 'Add product'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  ).whenComplete(() {
    nameController.dispose();
    priceController.dispose();
  });
}
