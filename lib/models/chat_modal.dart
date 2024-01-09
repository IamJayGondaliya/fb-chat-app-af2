class ChatModal {
  String msg, type;
  DateTime time;

  ChatModal(
    this.msg,
    this.time,
    this.type,
  );

  factory ChatModal.fromMap({required Map data}) => ChatModal(
        data['msg'],
        DateTime.fromMillisecondsSinceEpoch(int.parse(data['time'])),
        data['type'],
      );

  Map<String, dynamic> get toMap => {
        'msg': msg,
        'time': time.millisecondsSinceEpoch.toString(),
        'type': type,
      };
}
