class AppConstants {
  // API
  static const String baseUrl = 'https://67f9eea1094de2fe6ea1f7f4.mockapi.io/api/v1';
  static const String itemsEndpoint = '/items';

  // Timeouts
  static const int connectTimeout = 10000;
  static const int receiveTimeout = 15000;

  // Item Status
  static const String statusLost = 'Lost';
  static const String statusFound = 'Found';

  // Categories
  static const List<String> categories = [
    'Electronics',
    'ID Cards',
    'Bags',
    'Books',
    'Clothing',
    'Accessories',
    'Other',
  ];

  // AAU Campus Locations
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

  // Snackbar messages
  static const String itemAddedSuccess = 'Item reported successfully!';
  static const String itemUpdatedSuccess = 'Item updated successfully!';
  static const String itemDeletedSuccess = 'Item removed successfully!';
  static const String networkError = 'Network error. Please check your connection.';
  static const String timeoutError = 'Request timed out. Please try again.';
  static const String unknownError = 'Something went wrong. Please try again.';

  // Placeholder image
  static const String placeholderImage =
      'https://via.placeholder.com/400x300/1B5E20/FFFFFF?text=FindIt+AAU';
}
