class SharedNoteUsers {
  final String user, access;

  SharedNoteUsers({required this.user, required this.access});

  SharedNoteUsers.fromJson(Map<String, dynamic> jsonData)
      : user = jsonData['user'],
        access = jsonData['access'];

  Map<String, dynamic> toJson() => {
        'user': user,
        'access': access,
      };
}
