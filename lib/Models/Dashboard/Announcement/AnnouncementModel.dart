class AnnouncementModel{
  final int ? id;
  final String ? date;
  final String ? sender;
  final String ? message;
  final String ? url_photo;


  AnnouncementModel({this.id ,this.date, this.sender, this.message, this.url_photo});

  factory AnnouncementModel.fromJson(dynamic json){
    return AnnouncementModel(
      id: json['id'],
      date: json['date'],
      sender: json['sender'],
      message: json['message'],
      url_photo: json['url_photo']
    );
  }

  static List<AnnouncementModel> AnnouncementModelFromSnapshot(List snapshot){
    return snapshot.map((e){
      return AnnouncementModel.fromJson(e);
    }).toList();
  }

  @override
  String toString(){
    return '{date: $date, date: $date, sender: $sender, message, $message, url_photo: $url_photo}';
  }
  
}