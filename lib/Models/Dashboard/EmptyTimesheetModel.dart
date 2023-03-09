class EmptyTimesheetModel{
  final String date;
  final String status;


  EmptyTimesheetModel({required this.date, required this.status});

  factory EmptyTimesheetModel.fromJson(dynamic json){
    return EmptyTimesheetModel(
      date: json['date'],
      status: json['status'],
    );
  }

  static List<EmptyTimesheetModel> EmptyTimesheetModelFromSnapshot(List snapshot){
    return snapshot.map((e){
      return EmptyTimesheetModel.fromJson(e);
    }).toList();
  }

  @override
  String toString(){
    return '{date: $date, status: $status}';
  }
  
}