import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:mobile_application_driveos/core/domain/event/domain_event.dart';
import 'package:mobile_application_driveos/core/domain/event/domain_event_bus.dart';
import 'package:mobile_application_driveos/core/storage/session_storage.dart';
import 'package:mobile_application_driveos/features/inventory/application/inventory_application.dart';
import 'package:mobile_application_driveos/features/inventory/domain/inventory_domain.dart';

/// Presentation ViewModel managing branch inventory products, category/stock
/// filters, and catalog creation.
class InventoryViewModel extends ChangeNotifier {
  final ManageInventoryProducts _manageProducts;
  final SessionStorage _sessionStorage;
  final DomainEventBus? _eventBus;
  StreamSubscription<ActiveBranchChangedEvent>? _branchSubscription;

  /// Creates an [InventoryViewModel].
  InventoryViewModel({
    required this._manageProducts,
    required this._sessionStorage,
    this._eventBus,
  }) {
    _branchSubscription =
        _eventBus?.on<ActiveBranchChangedEvent>().listen((_) => loadProducts());
  }

  /// Whether inventory items are currently loading.
  bool isLoading = false;

  /// Latest error message, if any.
  String? errorMessage;

  /// Whether only low-stock products should be fetched.
  bool lowStockOnly = false;

  /// Active category filter (`null` means all categories).
  String? selectedCategory;

  /// Search query filtering loaded products by name or SKU.
  String searchQuery = '';

  /// Raw products loaded for the active branch.
  List<InventoryProduct> products = const [];

  /// Active branch identifier from [SessionStorage].
  String get activeBranchId => _sessionStorage.activeBranchId ?? '';

  /// Products filtered locally by [searchQuery].
  List<InventoryProduct> get filteredProducts {
    final query = searchQuery.trim().toLowerCase();
    if (query.isEmpty) return products;
    return products
        .where(
          (p) =>
              p.name.toLowerCase().contains(query) ||
              p.sku.toLowerCase().contains(query),
        )
        .toList();
  }

  /// Updates [searchQuery] and notifies listeners.
  void setSearchQuery(String value) {
    searchQuery = value;
    notifyListeners();
  }

  /// Updates [lowStockOnly] and reloads products.
  Future<void> setLowStockOnly(bool value) {
    if (lowStockOnly == value) return Future.value();
    lowStockOnly = value;
    return loadProducts();
  }

  /// Updates [selectedCategory] and reloads products.
  Future<void> setCategory(String? category) {
    final normalized =
        (category == null || category == 'ALL') ? null : category;
    if (selectedCategory == normalized) return Future.value();
    selectedCategory = normalized;
    return loadProducts();
  }

  /// Fetches branch products from [ManageInventoryProducts].
  Future<void> loadProducts([String? branchId]) async {
    final targetBranch = branchId ?? activeBranchId;
    if (targetBranch.isEmpty) {
      products = const [];
      notifyListeners();
      return;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      products = await _manageProducts.listByBranch(
        branchId: targetBranch,
        category: selectedCategory,
        lowStockOnly: lowStockOnly ? true : null,
      );
      isLoading = false;
      notifyListeners();
    } catch (error) {
      errorMessage = error.toString().replaceFirst('Exception: ', '');
      isLoading = false;
      notifyListeners();
    }
  }

  /// Creates a new catalog product in the active branch.
  Future<bool> createProduct({
    required String category,
    required String name,
    required String sku,
    required double salePrice,
    required int minimumStock,
    String? description,
  }) async {
    if (activeBranchId.isEmpty) {
      errorMessage = 'Please select an active branch first.';
      notifyListeners();
      return false;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final created = await _manageProducts.create(
        branchId: activeBranchId,
        category: category,
        name: name,
        sku: sku,
        description: description,
        salePrice: salePrice,
        minimumStock: minimumStock,
      );
      products = [created, ...products];
      isLoading = false;
      notifyListeners();
      return true;
    } catch (error) {
      errorMessage = error.toString().replaceFirst('Exception: ', '');
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    _branchSubscription?.cancel();
    super.dispose();
  }
}
