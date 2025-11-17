import 'package:freezed_annotation/freezed_annotation.dart';

import 'item_model.dart';

part 'item_list_model.freezed.dart';
part 'item_list_model.g.dart';

@freezed
class ItemListModel with _$ItemListModel {
  const factory ItemListModel({required List<ItemModel> items}) =
      _ItemListModel;

  factory ItemListModel.fromJson(Map<String, dynamic> json) =>
      _$ItemListModelFromJson(json);
}
