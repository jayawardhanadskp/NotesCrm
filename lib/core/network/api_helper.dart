/*{
    "id": 1,
    "name": "Leanne Graham",
    "username": "Bret",
    "email": "Sincere@april.biz",
    "address": {
      "street": "Kulas Light",
      "suite": "Apt. 556",
      "city": "Gwenborough",
      "zipcode": "92998-3874",
      "geo": {
        "lat": "-37.3159",
        "lng": "81.1496"
      }
    },
    "phone": "1-770-736-8031 x56442",
    "website": "hildegard.org",
    "company": {
      "name": "Romaguera-Crona",
      "catchPhrase": "Multi-layered client-server neural-net",
      "bs": "harness real-time e-markets"
    }
  } */
import 'package:dio/dio.dart';
import 'package:notes_crm/models/customer_model.dart';

class ApiHelper {
  final Dio _dio = Dio();
  final String url = 'https://jsonplaceholder.typicode.com/users';

  Future<List<CustomerModel>> fetchUsers() async {
    try {
      final response = await _dio.get(
        url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          receiveTimeout: const Duration(seconds: 15),
          sendTimeout: const Duration(seconds: 15),
        ),
      );

      if (response.statusCode == 200) {
        final List rawData = response.data;
        final List<CustomerModel> users = rawData.map((json) {
          return CustomerModel(
            id: json['id'],
            name: json['name'],
            phone: json['phone'],
            email: json['email'],
            company: json['company']['name'],
            createdAt: DateTime.now().toIso8601String(),
          );
        }).toList();
        return users;
      } else {
        throw Exception('Error getting data');
      }
    } catch (e) {
      rethrow;
    }
  }
}
