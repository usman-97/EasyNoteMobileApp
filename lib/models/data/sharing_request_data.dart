class SharingRequestData {
  SharingRequestData({
    required this.sender,
    required this.senderName,
    required this.recipient,
    required this.note,
    required this.noteTitle,
    required this.access,
    required this.status,
  });

  final String sender, senderName, recipient, note, noteTitle, access, status;

  SharingRequestData.fromJson(Map<String, dynamic> jsonData)
      : sender = jsonData['sender'],
        senderName = jsonData['sender_name'],
        recipient = jsonData['recipient'],
        note = jsonData['note'],
        noteTitle = jsonData['note_title'],
        access = jsonData['access'],
        status = jsonData['status'];

  Map<String, dynamic> toJson() => {
        'sender': sender,
        'sender_name': senderName,
        'recipient': recipient,
        'note': note,
        'note_title': noteTitle,
        'access': access,
        'status': status,
      };
}
