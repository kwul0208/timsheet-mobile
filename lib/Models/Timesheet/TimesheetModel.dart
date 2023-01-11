class TimesheetModel{
  final List timesheet;
  final int time_duration;
  final int oa_duration;

  TimesheetModel({required this.timesheet, required this.time_duration, required this.oa_duration});

  factory TimesheetModel.fromJson(dynamic json){
    return TimesheetModel(
      timesheet: json['timesheet'],
      time_duration: json['time_duration'],
      oa_duration: json['oa_duration'],
    );
  }

  static List<TimesheetModel> TimesheetModelFromSnapshot(List snapshot){
    return snapshot.map((e){
      return TimesheetModel.fromJson(e);
    }).toList();
  }

  @override
  String toString(){
    return '{timesheet: $timesheet, time_duration: $time_duration, oa_duration: $oa_duration}';
  }
  
}