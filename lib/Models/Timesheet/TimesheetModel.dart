class TimesheetModel{
  final List timesheet;
  final int? working_time;
  final int? office_administration;
  final String? status;
  final String? locked_date;
  final String? unlocked_request_date;
  final String? unlocked_date;
  final String? relocked_date;
  final String? work_from;
  final int? over_time;
  final int? ishoma;
  final int? chargeable;
  final int? training;

  TimesheetModel({required this.timesheet, this.working_time, this.office_administration, this.status, this.locked_date, this.unlocked_request_date, this.unlocked_date,   this.relocked_date, this.work_from, this.over_time, this.ishoma, this.chargeable, this.training});

  factory TimesheetModel.fromJson(dynamic json){
    return TimesheetModel(
      timesheet: json['timesheet'],
      working_time: json['summary']['working_time'] ?? 0,
      office_administration: json['summary']['office_administration'] ?? 0,
      status: json['status'],
      locked_date: json['locked_date'],
      unlocked_request_date: json['unlocked_request_date'],
      unlocked_date: json['unlocked_date'],
      relocked_date: json['relocked_date'],
      work_from: json['work_from'],
      over_time: json['summary']['over_time'] ?? 0,
      ishoma: json['summary']['ishoma'] ?? 0,
      chargeable: json['summary']['chargeable'] ?? 0,
      training: json['summary']['training'] ?? 0,
    );
  }

  static List<TimesheetModel> TimesheetModelFromSnapshot(List ? snapshot){
    return snapshot!.map((e){
      return TimesheetModel.fromJson(e);
    }).toList();
  }

  @override
  String toString(){
    return '{timesheet: $timesheet, working_time: $working_time, office_administration: $office_administration, status: $status, loacked_date: $locked_date, unlocked_request_date; $unlocked_request_date, unlocked_date: $unlocked_date, relocked_date: $relocked_date, work_from: $work_from, over_time: $over_time, ishoma: $ishoma, chargeable: $chargeable, training: $training}';
  }
  
}