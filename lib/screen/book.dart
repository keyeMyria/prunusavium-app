import 'package:flutter/material.dart';
import 'package:prunusavium/model/book.dart';

class BookPage extends StatefulWidget {
  final Book book;

  const BookPage(this.book);

  _BookPageState createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('${widget.book.title}'),
    );
  }
}
