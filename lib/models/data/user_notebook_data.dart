class UserNotebookData {
  UserNotebookData({
    required this.notebookID,
    required this.notebookTitle,
    required this.dateCreated,
    required this.lastModified,
    required this.lastModifiedTime,
    required this.status,
  });

  final String notebookID,
      notebookTitle,
      dateCreated,
      lastModified,
      lastModifiedTime,
      status;

  UserNotebookData.fromJson(Map<String, dynamic> jsonData)
      : notebookID = jsonData['id'],
        notebookTitle = jsonData['title'],
        dateCreated = jsonData['date_created'],
        lastModified = jsonData['last_modified'],
        lastModifiedTime = jsonData['last_modified_time'],
        status = jsonData['status'];

  Map<String, dynamic> toJson() => {
        'id': notebookID,
        'title': notebookTitle,
        'date_created': dateCreated,
        'last_modified': lastModified,
        'last_modified_time': lastModifiedTime,
        'status': status,
      };
}
