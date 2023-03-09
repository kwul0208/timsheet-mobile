import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:timsheet_mobile/Config/Config.dart';
import 'package:timsheet_mobile/Models/Timesheet/mode/employees/EmployeesApi.dart';
import 'package:timsheet_mobile/Models/Timesheet/mode/employees/EmployeesModel.dart';
import 'package:timsheet_mobile/Provider/Timesheet/TimesheetState.dart';

class EmployeeList extends StatefulWidget {
  const EmployeeList({super.key});

  @override
  State<EmployeeList> createState() => _EmployeeListState();
}

class _EmployeeListState extends State<EmployeeList> {

  // employee
  List<EmployeesModel>? _allUsers;
  // This list holds the data for the list view
  List<EmployeesModel> _foundUsers = [];
   // list employees
  EmployeesModel? selectedUser;
  List<EmployeesModel> ? _employees;
  Future<dynamic>? _futureEmployees;



  @override
  void initState(){
    super.initState();
    _futureEmployees = getEmployees();
  }

  // Employees search
  void _runFilter(String enteredKeyword) {
    List<EmployeesModel>? results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = _employees;
    } else {
      results = _employees!
          .where((user) =>
              user.fullname.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    print('objectxx');
          print(_employees);
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      _foundUsers = results!;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back, size: 30, color: Colors.black,)),
        title: TextFormField(
          onChanged: (value) => _runFilter(value),
          decoration: const InputDecoration(
            isDense: true, 
            contentPadding: EdgeInsets.fromLTRB(20, 20, 20, 0),
            hintText: 'Search',
            // prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(
                borderRadius:BorderRadius.all(Radius.circular(10.0)),
              ),
          ),
        ),
      ),
      body: FutureBuilder(
        future: _futureEmployees,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Consumer<TimesheetState>(
              builder: (context, data, _){
                return _foundUsers.isNotEmpty
                  ? ListView.builder(
                      itemCount: _foundUsers.length,
                      itemBuilder: (context, index) => Card(
                        // key: ValueKey(_foundUsers[index].id),
                        // elevation: 1,
                        // margin: const EdgeInsets.symmetric(vertical: 10),
                        child: Consumer<TimesheetState>(
                          builder: (context, data, _) {
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(_foundUsers[index].url_photo!),
                                backgroundColor: Colors.grey,
                              ),
                              title: Text(_foundUsers[index].fullname),
                              trailing: data.indexSelectedEmployee == _foundUsers[index].id ? Icon(Icons.check, color: Config().primary,) : SizedBox(),
                              onTap: (){
                                // employeeIdMode = _foundUsers[index].id;
                                Provider.of<TimesheetState>(context, listen: false).changeemployeeName(_foundUsers[index].fullname);
                                Provider.of<TimesheetState>(context, listen: false).changeIndexSelectedEmployee(_foundUsers[index].id);
                                Navigator.pop(context);
                              },
                            );
                          }
                        ),
                      ),
                    )
                  : const Text(
                      'No results found',
                      style: TextStyle(fontSize: 24),
                    );
              }
            );
          }else{
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        }
      ),
    );
  }

  getEmployees()async{
    _employees = await EmployeesApi.getEmployees(context);
    _foundUsers = _employees!;
    print(_foundUsers);
    Provider.of<TimesheetState>(context, listen: false).changeRefresh();
    // selectedUser=_employees![0];
  }
}