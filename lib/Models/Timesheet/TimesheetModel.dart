class TimesheetModel{
  final List timesheet;
  final int time_duration;
  final int oa_duration;
  final String? status;
  final String? locked_date;
  final String? unlocked_request_date;
  final String? unlocked_date;
  final String? relocked_date;
  final String? work_from;

  TimesheetModel({required this.timesheet, required this.time_duration, required this.oa_duration, this.status, this.locked_date, this.unlocked_request_date, this.unlocked_date,   this.relocked_date, this.work_from});

  factory TimesheetModel.fromJson(dynamic json){
    return TimesheetModel(
      timesheet: json['timesheet'],
      time_duration: json['summary']['working_time'],
      oa_duration: json['summary']['oa'],
      status: json['status'],
      locked_date: json['locked_date'],
      unlocked_request_date: json['unlocked_request_date'],
      unlocked_date: json['unlocked_date'],
      relocked_date: json['relocked_date'],
      work_from: json['work_from'],
    );
  }

  static List<TimesheetModel> TimesheetModelFromSnapshot(List snapshot){
    return snapshot.map((e){
      return TimesheetModel.fromJson(e);
    }).toList();
  }

  @override
  String toString(){
    return '{timesheet: $timesheet, time_duration: $time_duration, oa_duration: $oa_duration, status: $status, loacked_date: $locked_date, unlocked_request_date; $unlocked_request_date, unlocked_date: $unlocked_date, relocked_date: $relocked_date, work_from: $work_from}';
  }
  
}