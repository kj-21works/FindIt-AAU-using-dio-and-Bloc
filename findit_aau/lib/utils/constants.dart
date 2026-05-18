class AppConstants {
  static const String baseUrl =
      'https://6a0b93ae5aa893e1015a57fd.mockapi.io/api/v1';

  static const int connectTimeout = 10000;
  static const int receiveTimeout = 15000;

  static const String statusLost = 'Lost';
  static const String statusFound = 'Found';

  static const List<String> categories = [
    'Electronics',
    'ID Cards',
    'Bags',
    'Books',
    'Clothing',
    'Accessories',
    'Other',
  ];

  static const List<String> locations = [
    'Main Library',
    'Student Union',
    'Science Faculty',
    'Engineering Block',
    'Cafeteria',
    'Administration',
    'Medical Faculty',
    'Law Faculty',
    'Business Faculty',
    'Sports Complex',
    'Dormitory A',
    'Dormitory B',
    'Gate 3',
    'Gate 6',
    'Other',
  ];

  static const String itemAddedSuccess = 'Item reported successfully!';
  static const String itemUpdatedSuccess = 'Item updated successfully!';
  static const String itemDeletedSuccess = 'Item removed successfully!';
  static const String networkError =
      'Network error. Please check your connection.';
  static const String timeoutError = 'Request timed out. Please try again.';
  static const String unknownError = 'Something went wrong. Please try again.';

  static const String placeholderImage =
      'https://via.placeholder.com/400x300/1B5E20/FFFFFF?text=FindIt+AAU';
}
