// ignore_for_file: public_member_api_docs, sort_constructors_first

class NoteModel {
  final int? id;
  final int customerId;
  final String title;
  final String description;
  final String createdAt;
  final String? customerName;

  NoteModel({
    required this.id,
    required this.customerId,
    required this.title,
    required this.description,
    required this.createdAt,
    this.customerName,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'id': id,
      'customer_id': customerId,
      'title': title,
      'description': description,
      'createdAt': createdAt, //.toIso8601String(),
    };

    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      id: map['id'] as int,
      customerId: map['customer_id'] as int,
      title: map['title'] as String,
      description: map['description'] as String,
      createdAt: map['createdAt'] as String,
      customerName: map['customerName'] as String?,
    );
  }
}
