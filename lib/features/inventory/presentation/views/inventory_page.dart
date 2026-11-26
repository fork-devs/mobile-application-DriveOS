import 'package:flutter/material.dart';
import 'package:mobile_application_driveos/core/di/dependency_injection.dart';
import 'package:mobile_application_driveos/core/localization/app_localizations.dart';
import 'package:mobile_application_driveos/core/theme/app_theme.dart';
import 'package:mobile_application_driveos/core/widgets/driveos_empty_state.dart';
import 'package:mobile_application_driveos/core/widgets/driveos_loading_helpers.dart';
import 'package:mobile_application_driveos/core/widgets/driveos_page_header.dart';
import 'package:mobile_application_driveos/core/widgets/driveos_pull_to_refresh.dart';
import 'package:mobile_application_driveos/core/widgets/driveos_skeleton.dart';
import 'package:mobile_application_driveos/features/auth/presentation/widgets/auth_scaffold.dart';
import 'package:mobile_application_driveos/features/inventory/domain/inventory_domain.dart';
import 'package:mobile_application_driveos/features/inventory/presentation/controllers/inventory_view_model.dart';

/// Workshop branch inventory catalog page with search, category chips,
/// low-stock filter, and product creation.
class InventoryPage extends StatefulWidget {
  /// Optional injected [InventoryViewModel] for testing.
  final InventoryViewModel? viewModel;

  /// Optional explicit branch identifier override.
  final String? branchId;

  /// Creates an [InventoryPage].
  const InventoryPage({
    super.key,
    this.viewModel,
    this.branchId,
  });

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  static const List<String> _categories = [
    'ALL',
    'LUBRICANTES',
    'FILTROS',
    'FRENOS',
    'SUSPENSION',
    'MOTOR',
  ];

  late final InventoryViewModel _viewModel;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _viewModel = widget.viewModel ?? getIt<InventoryViewModel>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel.loadProducts(widget.branchId);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _showCreateProductDialog() async {
    final nameController = TextEditingController();
    final skuController = TextEditingController();
    final categoryController = TextEditingController(text: 'LUBRICANTES');
    final priceController = TextEditingController();
    final minStockController = TextEditingController(text: '5');
    final formKey = GlobalKey<FormState>();

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(AppLocalizations.of(context).translate('new_product')),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: skuController,
                  decoration: const InputDecoration(labelText: 'SKU'),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: categoryController,
                  decoration: const InputDecoration(labelText: 'Category'),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Sale price'),
                  validator: (v) =>
                      double.tryParse(v ?? '') == null ? 'Invalid price' : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: minStockController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Minimum stock'),
                  validator: (v) =>
                      int.tryParse(v ?? '') == null ? 'Invalid number' : null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(AppLocalizations.of(context).translate('cancel')),
          ),
          FilledButton(
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;
              final ok = await _viewModel.createProduct(
                category: categoryController.text,
                name: nameController.text,
                sku: skuController.text,
                salePrice: double.parse(priceController.text),
                minimumStock: int.parse(minStockController.text),
              );
              if (ok && dialogContext.mounted) {
                Navigator.of(dialogContext).pop();
              }
            },
            child: Text(AppLocalizations.of(context).translate('save')),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        final vm = _viewModel;
        final items = vm.filteredProducts;

        return Scaffold(
          backgroundColor: DriveOSColors.warmNeutral,
          floatingActionButton: FloatingActionButton.extended(
            key: const Key('fab_new_product'),
            onPressed: _showCreateProductDialog,
            icon: const Icon(Icons.add_rounded),
            label: Text(loc.translate('new_product')),
          ),
          body: DriveOSCollapsibleHeaderBody(
            header: DriveOSPageHeader(
              title: loc.translate('inventory_title'),
              actions: [
                FilterChip(
                  label: Text(loc.translate('low_stock_only')),
                  selected: vm.lowStockOnly,
                  onSelected: vm.setLowStockOnly,
                ),
              ],
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: TextField(
                    key: const Key('inventory_search_input'),
                    controller: _searchController,
                    onChanged: vm.setSearchQuery,
                    decoration: authInputDecoration(
                      hintText: loc.translate('search_inventory_hint'),
                      prefixIcon: Icons.search_rounded,
                    ),
                  ),
                ),
                SizedBox(
                  height: 44,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final category = _categories[index];
                      final isSelected = (category == 'ALL' &&
                              vm.selectedCategory == null) ||
                          vm.selectedCategory == category;
                      return ChoiceChip(
                        label: Text(category),
                        selected: isSelected,
                        onSelected: (_) => vm.setCategory(category),
                      );
                    },
                  ),
                ),
                if (vm.errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                    child: AuthErrorBanner(message: vm.errorMessage!),
                  ),
                Expanded(
                  child: DriveOSContentTransition(
                    child: vm.isLoading && items.isEmpty
                        ? const DriveOSSkeletonCardList(
                            key: ValueKey('inventory_skeleton'),
                          )
                        : items.isEmpty
                            ? Center(
                                key: const ValueKey('inventory_empty'),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const DriveOSEmptyStateIcon(
                                      icon: Icons.inventory_2_outlined,
                                      color: DriveOSColors.primaryBlue,
                                    ),
                                    const SizedBox(height: 14),
                                    Text(
                                      loc.translate('no_products'),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: DriveOSColors.graphiteText,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : DriveOSPullToRefresh(
                                key: const ValueKey('inventory_list'),
                                onRefresh: () =>
                                    vm.loadProducts(widget.branchId),
                                child: ListView.separated(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  padding: const EdgeInsets.fromLTRB(
                                    16,
                                    12,
                                    16,
                                    110,
                                  ),
                                  itemCount: items.length,
                                  separatorBuilder: (_, _) =>
                                      const SizedBox(height: 12),
                                  itemBuilder: (context, index) =>
                                      _ProductCard(product: items[index]),
                                ),
                              ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product});

  final InventoryProduct product;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final stockColor = product.lowStockAlert
        ? DriveOSColors.severityCrimson
        : DriveOSColors.preventiveGreen;

    return Container(
      key: Key('product_card_${product.id}'),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: product.lowStockAlert
              ? DriveOSColors.severityCrimson.withValues(alpha: 0.45)
              : DriveOSColors.borderSlate,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w800,
                    color: DriveOSColors.graphiteText,
                  ),
                ),
              ),
              Text(
                'S/ ${product.salePrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  color: DriveOSColors.primaryBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${product.sku} · ${product.category}',
                style: TextStyle(
                  fontSize: 12.5,
                  color: DriveOSColors.graphiteText.withValues(alpha: 0.65),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: stockColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${loc.translate('in_stock_label')}: ${product.currentStock} '
                  '(${loc.translate('min_stock_label')}: ${product.minimumStock})',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: stockColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
