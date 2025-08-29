import 'package:notes_crm/core/db/database_helper.dart';
import 'package:notes_crm/core/network/api_helper.dart';
import 'package:notes_crm/models/customer_model.dart';

class CustomerRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final ApiHelper _apiHelper = ApiHelper();

  Future<List<CustomerModel>> getAllCustomers() async {
    try {
      final localCustomers = await _dbHelper.getCustomers();
      if (localCustomers.isEmpty) {
        final apiCustoners = await _apiHelper.fetchUsers();
        for (var customer in apiCustoners) {
          await _dbHelper.insertCustomer(customer);
        }
        final apiLocalCustomers = await _dbHelper.getCustomers();
        return apiLocalCustomers;
      } else {
        return localCustomers;
      }
    } catch (e) {
      throw Exception('Failed to load customers: $e');
    }
  }

  Future<CustomerModel?> getCustomerById(int id) async {
    return await _dbHelper.getCustomerById(id);
  }

  Future<int> addCustomer(CustomerModel customer) async {
    return await _dbHelper.insertCustomer(customer);
  }

  Future<int> updateCustomer(CustomerModel customer) async {
    return await _dbHelper.updateCoustomer(customer);
  }

  Future<int> deleteCustomer(int id) async {
    return await _dbHelper.deleteCustomer(id);
  }
}
