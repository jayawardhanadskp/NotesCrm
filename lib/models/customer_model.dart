// ignore_for_file: public_member_api_docs, sort_constructors_first

//   String customersTable = 'customers';
//   String notesTable = 'notes';
//   String colCustomerId = 'id';
//   String colCustomerName = 'name';
//   String colCustomerPhone = 'phone';
//   String colCustomerEmail = 'email';
//   String colCustomerCompany = 'company';
//   String colNoteId = 'id';
//   String colNoteCustomerId = 'customer_id';
//   String colNoteTitle = 'title';
//   String colNoteDescription = 'description';
//   String colNoteDate = 'date';

class CustomerModel {
  final int? id;
  final String name;
  final String phone;
  final String email;
  final String company;
  final String createdAt;

  CustomerModel({
    this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.company,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'name': name,
      'phone': phone,
      'email': email,
      'company': company,
      'createdAt': createdAt,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  factory CustomerModel.fromMap(Map<String, dynamic> map) {
    return CustomerModel(
      id: map['id'] as int,
      name: map['name'] as String,
      phone: map['phone'] as String,
      email: map['email'] as String,
      company: map['company'] as String,
      createdAt: map['createdAt'] as String,
    );
  }
}
