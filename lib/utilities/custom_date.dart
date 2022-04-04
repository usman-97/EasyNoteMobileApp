class CustomDate {
  /// Get current data
  String getShortFormatDate() {
    DateTime now = DateTime.now().toLocal();
    String date = '${now.day}/${now.month}/${now.year}';

    return date;
  }
}
