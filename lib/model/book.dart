import 'package:json_annotation/json_annotation.dart';

part 'book.g.dart';

@JsonSerializable()
class Book {
  String author, id, site, title;

  String get key => [this.site, this.author, this.title, this.id].join('_');

  Book(
    this.author,
    this.id,
    this.site,
    this.title,
  );

  factory Book.fromJson(Map<String, dynamic> json) => _$BookFromJson(json);

  Map<String, dynamic> toJson() => _$BookToJson(this);
}
