class WFHModel{
  final int ? id;
  final int ? employees_id;
  final String ? date;
  final String ? duration;
  final String ? start_hour;
  final String ? finish_hour;
  final String ? same_day;
  final String ? reason;
  final int ? is_overtime;
  final String ? description;
  final int ? status_id;
  final String ? approved_date;
  final String ? approved_note;
  final int ? approved_by;
  final String ? created_at;
  final String ? rejected_date;
  final String ? rejected_noted;
  final int ? rejected_by;
  final String ? verified_date;
  final String ? verified_noted;
  final int ? verified_by;
  final String ? cancel_date;
  final String ? cancel_noted;
  final int ? cancel_by;
  final String ? condition;
  


  WFHModel({this.id, this.employees_id, this.date, this.duration, this.start_hour, this.finish_hour, this.same_day, this.reason, this.is_overtime, this.description, this.status_id, this.approved_date, this.approved_note, this.approved_by, this.created_at, this.rejected_noted, this.rejected_date, this.rejected_by, this.verified_noted, this.verified_date, this.verified_by, this.cancel_date, this.cancel_noted, this.cancel_by, this.condition});

  factory WFHModel.fromJson(dynamic json){
    return WFHModel(
      id: json['id'],
      employees_id: json['employees_id'],
      date: json['date'] ,
      duration: json['duration'] ,
      start_hour: json['start_hour'] ,
      finish_hour: json['finish_hour'].toString() ,
      same_day: json['same_day'] ,
      reason: json['reason'] ,
      is_overtime: json['is_overtime'],
      description: json['description'] ,
      status_id: json['status_id'],
      approved_date: json['approved_date'] ,
      approved_note: json['approved_note'] ,
      approved_by: json['approved_by'] ,
      created_at: json['created_at'] ,
      rejected_date: json['rejected_date'] ,
      rejected_noted: json['rejected_noted'] ,
      rejected_by: json['rejected_by'] ,
      verified_date: json['verified_date'] ,
      verified_noted: json['verified_noted'] ,
      verified_by: json['verified_by'] ,
      cancel_date: json['cancel_date'] ,
      cancel_noted: json['cancel_noted'] ,
      cancel_by: json['cancel_by'] ,
      condition: json['condition']
    );
  }

  static List<WFHModel> WFHModelFromSnapshot(List snapshot){
    return snapshot.map((e){
      return WFHModel.fromJson(e);
    }).toList();
  }

  @override
  String toString(){
    return '{id: $id, employees_id, $employees_id, date: $date, duration: $duration, start_hour: $start_hour, finish_hour: $finish_hour, same_day: $same_day, reason: $reason, is_overtime: $is_overtime, description: $description, status_id: $status_id, approved_date: $approved_date, approved_note: $approved_note, approved_by: $approved_by, created_at: $created_at, rejected_date: $rejected_date, rejected_noted: $rejected_noted, rejected_by: $rejected_by, verified_date: $verified_date, verified_noted: $verified_noted, verified_by: $verified_by, cancel_date: $cancel_date, cancel_noted: $cancel_noted, cancel_by: $cancel_by, condition: $condition}';
  }
  
}