import 'package:equatable/equatable.dart';
import '../../models/item_model.dart';

abstract class ItemEvent extends Equatable {
  const ItemEvent();

  @override
  List<Object?> get props => [];
}

class FetchItemsEvent extends ItemEvent {
  const FetchItemsEvent();
}

class AddItemEvent extends ItemEvent {
  final ItemModel item;
  const AddItemEvent(this.item);

  @override
  List<Object?> get props => [item];
}

class UpdateItemEvent extends ItemEvent {
  final ItemModel item;
  const UpdateItemEvent(this.item);

  @override
  List<Object?> get props => [item];
}

class DeleteItemEvent extends ItemEvent {
  final String id;
  const DeleteItemEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class SearchItemsEvent extends ItemEvent {
  final String query;
  const SearchItemsEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class FilterItemsEvent extends ItemEvent {
  final String? status;
  final String? category;

  const FilterItemsEvent({this.status, this.category});

  @override
  List<Object?> get props => [status, category];
}

class ClearFiltersEvent extends ItemEvent {
  const ClearFiltersEvent();
}
