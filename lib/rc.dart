// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

/// Encapsulates a single row/column coordinate.
class RC {
  final int row;
  final int col;

  RC(this.row, this.col);

  RC get zero => RC(0, 0);

  const RC.zero()
      : row = 0,
        col = 0;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'row': row,
      'col': col,
    };
  }

  String toJson() => json.encode(toMap());

  factory RC.fromMap(Map<String, dynamic> map) {
    return RC(
      map['row'] as int,
      map['col'] as int,
    );
  }

  factory RC.fromJson(String source) =>
      RC.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RC &&
          runtimeType == other.runtimeType &&
          row == other.row &&
          col == other.col;

  @override
  int get hashCode => row.hashCode ^ col.hashCode;

  @override
  String toString() {
    return 'RC{row: $row, col: $col}';
  }
}
