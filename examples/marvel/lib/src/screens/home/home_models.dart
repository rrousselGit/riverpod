import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_models.freezed.dart';

const kCharactersPageLimit = 50;

@freezed
class CharacterPagination with _$CharacterPagination {
  factory CharacterPagination({
    required int page,
    String? name,
  }) = _CharacterPagination;
}

class AbortedException implements Exception {}

@freezed
class CharacterOffset with _$CharacterOffset {
  factory CharacterOffset({
    required int offset,
    @Default('') String name,
  }) = _CharacterOffset;
}
