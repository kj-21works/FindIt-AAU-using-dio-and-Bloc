import 'package:equatable/equatable.dart';
import '../../models/item_model.dart';

abstract class ItemState extends Equatable {
  const ItemState();

  @override
  List<Object?> get props => [];
}

class ItemInitial extends ItemState {
  const ItemInitial();
}

class ItemLoading extends ItemState {
  const ItemLoading();
}

class ItemLoaded extends ItemState {
  final List<ItemModel> items;
  final List<ItemModel> filteredItems;
  final String searchQuery;
  final String? activeStatusFilter;
  final String? activeCategoryFilter;

  const ItemLoaded({
    required this.items,
    required this.filteredItems,
    this.searchQuery = '',
    this.activeStatusFilter,
    this.activeCategoryFilter,
  });

  ItemLoaded copyWith({
    List<ItemModel>? items,
    List<ItemModel>? filteredItems,
    String? searchQuery,
    String? activeStatusFilter,
    String? activeCategoryFilter,
    bool clearStatusFilter = false,
    bool clearCategoryFilter = false,
  }) {
    return ItemLoaded(
      items: items ?? this.items,
      filteredItems: filteredItems ?? this.filteredItems,
      searchQuery: searchQuery ?? this.searchQuery,
      activeStatusFilter:
          clearStatusFilter ? null : (activeStatusFilter ?? this.activeStatusFilter),
      activeCategoryFilter: clearCategoryFilter
          ? null
          : (activeCategoryFilter ?? this.activeCategoryFilter),
    );
  }

  @override
  List<Object?> get props => [
        items,
        filteredItems,
        searchQuery,
        activeStatusFilter,
        activeCategoryFilter,
      ];
}

class ItemSubmitting extends ItemState {
  const ItemSubmitting();
}

class ItemSuccess extends ItemState {
  final String message;
  final List<ItemModel> items;

  const ItemSuccess({required this.message, required this.items});

  @override
  List<Object?> get props => [message, items];
}

class ItemError extends ItemState {
  final String message;
  final List<ItemModel>? previousItems;

  const ItemError({required this.message, this.previousItems});

  @override
  List<Object?> get props => [message, previousItems];
}

class ItemOperationError extends ItemState {
  final String message;
  final List<ItemModel> items;

  const ItemOperationError({required this.message, required this.items});

  @override
  List<Object?> get props => [message, items];
}
