class DetailWFHModel{
  final int? id;
  final String ? date;
  final String ? condition;
  final int ? status_id;
  final Map ? approved_by;
  final String ? approved_date;
  final Map ? rejected_by;
  final String ? rejected_date;
  final String ? duration;
  final String ? start_hour;
  final String ? finish_hour;
  final String ? description;
  final List ? request_link;
  final Map ? status;

  


  DetailWFHModel({this.id, this.date, this.condition, this.status_id, this.approved_by, this.approved_date, this.rejected_by, this.rejected_date, this.duration, this.start_hour, this.finish_hour, this.description, this.request_link, this.status});

  factory DetailWFHModel.fromJson(dynamic json){
    return DetailWFHModel(
      id: json['id'],
      date: json['date'],
      condition: json['condition'],
      status_id: json['status_id'],
      approved_by: json['approved_by'],
      approved_date: json['approved_date'],
      rejected_by: json['rejected_by'],
      rejected_date: json['rejected_date'],
      duration: json['duration'],
      start_hour: json['start_hour'],
      finish_hour: json['finish_hour'],
      description: json['description'],
      request_link: json['request_link'],
      status: json['status']
    );
  }

  static List<DetailWFHModel> DetailWFHModelFromSnapshot(List snapshot){
    return snapshot.map((e){
      return DetailWFHModel.fromJson(e);
    }).toList();
  }

  @override
  String toString(){
    return '{id: $id, date: $date, status_id: $status_id, approved_by: $approved_by, approved_date: $approved_date, rejected_by: $rejected_by, rejected_date: $rejected_date, duration: $duration, start_hour: $start_hour, finish_hour: $finish_hour, description: $description, request_link: $request_link, status: $status}';
  }
  
}