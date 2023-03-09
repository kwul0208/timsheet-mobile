class OTPlanModel{
  final String ? overtimeplan_id;
  final String ? overtimeplan_by_id;
  final String ? employees_name;
  final String ? description;
  final String ? status;
  final String ? timestart;
  final String ? timefinish;
  final String ? inputted_at;
  final String ? inputted_by;
  final String ? updated_at;


  OTPlanModel({this.overtimeplan_id, this.overtimeplan_by_id, this.employees_name, this.description, this.status, this.timestart, this.timefinish, this.inputted_at, this.inputted_by, this.updated_at});

  factory OTPlanModel.fromJson(dynamic json){
    return OTPlanModel(
      overtimeplan_id :json['overtimeplan_id'].toString(),
      overtimeplan_by_id:json['overtimeplan_by_id'].toString(),
      employees_name:json['employees_name'],
      description:json['description'],
      status:json['status'],
      timestart:json['timestart'],
      timefinish:json['timefinish'],
      inputted_at:json['inputted_at'],
      inputted_by:json['inputted_by'],
      updated_at:json['updated_at'],
    );
  }

  static List<OTPlanModel> OTPlanModelFromSnapshot(List ? snapshot){
    return snapshot!.map((e){
      return OTPlanModel.fromJson(e);
    }).toList();
  }

  @override
  String toString(){
    return '{overtimeplan_id: $overtimeplan_id, overtimeplan_by_id: $overtimeplan_by_id, employees_name: $employees_name, description: $description, status: $status, timestart: $timestart, timefinish: $timefinish, inputted_at: $inputted_at, inputted_by: $inputted_by, updated_at: $updated_at}';
  }
  
}