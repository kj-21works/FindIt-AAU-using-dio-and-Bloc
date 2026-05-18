import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/item_repository.dart';
import '../../models/item_model.dart';
import 'item_event.dart';
import 'item_state.dart';

class ItemBloc extends Bloc<ItemEvent, ItemState> {
  final ItemRepository _repository;

  ItemBloc({required ItemRepository repository})
      : _repository = repository,
        super(const ItemInitial()) {
    on<FetchItemsEvent>(_onFetchItems);
    on<AddItemEvent>(_onAddItem);
    on<UpdateItemEvent>(_onUpdateItem);
    on<DeleteItemEvent>(_onDeleteItem);
    on<SearchItemsEvent>(_onSearchItems);
    on<FilterItemsEvent>(_onFilterItems);
    on<ClearFiltersEvent>(_onClearFilters);
  }

  List<ItemModel> _applyFilters(
    List<ItemModel> items, {
    String query = '',
    String? statusFilter,
    String? categoryFilter,
  }) {
    return items.where((item) {
      final matchesQuery = query.isEmpty ||
          item.title.toLowerCase().contains(query.toLowerCase()) ||
          item.location.toLowerCase().contains(query.toLowerCase()) ||
          item.category.toLowerCase().contains(query.toLowerCase());

      final matchesStatus =
          statusFilter == null || item.status == statusFilter;

      final matchesCategory =
          categoryFilter == null || item.category == categoryFilter;

      return matchesQuery && matchesStatus && matchesCategory;
    }).toList();
  }

  Future<void> _onFetchItems(
      FetchItemsEvent event, Emitter<ItemState> emit) async {
    emit(const ItemLoading());
    try {
      final items = await _repository.fetchItems();
      emit(ItemLoaded(items: items, filteredItems: items));
    } catch (e) {
      emit(ItemError(message: e.toString()));
    }
  }

  Future<void> _onAddItem(AddItemEvent event, Emitter<ItemState> emit) async {
    final currentState = state;
    List<ItemModel> existingItems = [];
    if (currentState is ItemLoaded) {
      existingItems = currentState.items;
    }

    emit(const ItemSubmitting());
    try {
      final newItem = await _repository.addItem(event.item);
      final updatedItems = [newItem, ...existingItems];
      emit(ItemSuccess(
        message: 'Item reported successfully!',
        items: updatedItems,
      ));
    } catch (e) {
      emit(ItemOperationError(
        message: e.toString(),
        items: existingItems,
      ));
    }
  }

  Future<void> _onUpdateItem(
      UpdateItemEvent event, Emitter<ItemState> emit) async {
    final currentState = state;
    List<ItemModel> existingItems = [];
    if (currentState is ItemLoaded) {
      existingItems = currentState.items;
    }

    emit(const ItemSubmitting());
    try {
      final updatedItem = await _repository.updateItem(event.item);
      final updatedItems = existingItems
          .map((item) => item.id == updatedItem.id ? updatedItem : item)
          .toList();
      emit(ItemSuccess(
        message: 'Item updated successfully!',
        items: updatedItems,
      ));
    } catch (e) {
      emit(ItemOperationError(
        message: e.toString(),
        items: existingItems,
      ));
    }
  }

  Future<void> _onDeleteItem(
      DeleteItemEvent event, Emitter<ItemState> emit) async {
    final currentState = state;
    if (currentState is! ItemLoaded) return;

    final existingItems = currentState.items;
    final optimisticItems =
        existingItems.where((item) => item.id != event.id).toList();

    // Optimistic update
    emit(currentState.copyWith(
      items: optimisticItems,
      filteredItems: _applyFilters(
        optimisticItems,
        query: currentState.searchQuery,
        statusFilter: currentState.activeStatusFilter,
        categoryFilter: currentState.activeCategoryFilter,
      ),
    ));

    try {
      await _repository.deleteItem(event.id);
      emit(ItemSuccess(
        message: 'Item removed successfully!',
        items: optimisticItems,
      ));
    } catch (e) {
      // Rollback on failure
      emit(ItemOperationError(
        message: e.toString(),
        items: existingItems,
      ));
    }
  }

  void _onSearchItems(SearchItemsEvent event, Emitter<ItemState> emit) {
    final currentState = state;
    if (currentState is! ItemLoaded) return;

    final filtered = _applyFilters(
      currentState.items,
      query: event.query,
      statusFilter: currentState.activeStatusFilter,
      categoryFilter: currentState.activeCategoryFilter,
    );

    emit(currentState.copyWith(
      filteredItems: filtered,
      searchQuery: event.query,
    ));
  }

  void _onFilterItems(FilterItemsEvent event, Emitter<ItemState> emit) {
    final currentState = state;
    if (currentState is! ItemLoaded) return;

    final filtered = _applyFilters(
      currentState.items,
      query: currentState.searchQuery,
      statusFilter: event.status,
      categoryFilter: event.category,
    );

    emit(currentState.copyWith(
      filteredItems: filtered,
      activeStatusFilter: event.status,
      activeCategoryFilter: event.category,
      clearStatusFilter: event.status == null,
      clearCategoryFilter: event.category == null,
    ));
  }

  void _onClearFilters(ClearFiltersEvent event, Emitter<ItemState> emit) {
    final currentState = state;
    if (currentState is! ItemLoaded) return;

    emit(ItemLoaded(
      items: currentState.items,
      filteredItems: currentState.items,
      searchQuery: '',
    ));
  }
}
