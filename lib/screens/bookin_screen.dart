import 'dart:developer';

import 'package:church_service/http/http_response/http_response.dart';
import 'package:church_service/models/Response.dart';
import 'package:church_service/screens/route_controller.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum Service { FIRST, SECOND, THIRD, FOURTH }

extension ServiceExtension on Service {
  String get _service {
    switch (this) {
      case Service.FIRST:
        return "1";
      case Service.SECOND:
        return "2";
      case Service.THIRD:
        return "3";
      case Service.FOURTH:
        return "4";
      default:
        return null;
    }
  }
}

class BookASeat extends StatefulWidget {
  BookASeat() : super();

  final String title = "BookASeat";

  @override
  BookASeatState createState() => BookASeatState();
}

class Company {
  int id;
  String name;

  Company(this.id, this.name);

  static List<Company> getCompanies() {
    return <Company>[
      Company(1, '1st Service'),
      Company(2, '2nd Service'),
      Company(3, '3rd service'),
      Company(4, '4th Service'),
      Company(5, '5th Service'),
    ];
  }
}

class BookASeatState extends State<BookASeat> implements HttpCallBack {
  //Service methode
  Service _serviceValue;

  //declare variables ........................
  String username;
  int seat;
  String service;
  int church = 1;

  //declare progress dialog
  ProgressDialog pr;

  //validate fields
  bool _validate = false;

  // declare Controllers....................
  TextEditingController _username = TextEditingController();
  TextEditingController _seat = TextEditingController();

  //declare global keys ........................
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  //Declare response
  HttpResponse _response;

  //initialize response
  BookASeatState() {
    _response = new HttpResponse(this);
  }


  //on book button clicked calls this
  void _submit() {
    var seats=int.parse(_seat.text);
    final form = _formKey.currentState;
    if (_validate == false) {
      setState(() {
        form.save();
        _response.doBook(service, seats, church);
      });
    }
  }

  logOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", null);
      preferences.commit();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => RouteController()),
      );
    });
  }

  //
  List<Company> _companies = Company.getCompanies();
  List<DropdownMenuItem<Company>> _dropdownMenuItems;
  Company _selectedCompany;

  @override
  void initState() {
    _dropdownMenuItems = buildDropdownMenuItems(_companies);
    _selectedCompany = _dropdownMenuItems[0].value;
    super.initState();
  }

  List<DropdownMenuItem<Company>> buildDropdownMenuItems(List companies) {
    List<DropdownMenuItem<Company>> items = List();
    for (Company company in companies) {
      items.add(
        DropdownMenuItem(
          value: company,
          child: Text(company.name),
        ),
      );
    }
    return items;
  }

  onChangeDropdownItem(Company selectedCompany) {
    setState(() {
      _selectedCompany = selectedCompany;
    });
  }

//declaring time and date pickers
  DateTime _date = new DateTime.now();
  TimeOfDay _time = new TimeOfDay.now();

  //Date setup
  // Future<Null> _selectDate(BuildContext context) async {
  //   final DateTime picked = await showDatePicker(
  //       context: context,
  //       initialDate: _date,
  //       firstDate: new DateTime(2019),
  //       lastDate: new DateTime(2030));

  //   if (picked != null && picked != _date) {
  //     print('Date selected: ${_date.toString()}');
  //     setState(() {
  //       _date = picked;
  //     });
  //   }
  // }

  // //Time setup
  // Future<Null> _selectTime(BuildContext context) async {
  //   final TimeOfDay picked =
  //       await showTimePicker(context: context, initialTime: _time);

  //   if (picked != null && picked != _time) {
  //     print('Time selected: ${_time.toString()}');
  //     setState(() {
  //       _time = picked;
  //     });
  //   }
  // }

  //show toast message
  void showToast(String message) {
    Fluttertoast.showToast(
        msg: '$message',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey[800],
        textColor: Colors.white);
  }

  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
//      customBody: LinearProgressIndicator(
//        valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
//        backgroundColor: Colors.white,
//      ),
    );

    pr.style(
      message: 'Loading',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
    );
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(8, 1, 1, 1),
          child: Image.asset(
            'asset/img/dcu-logo.png',
            fit: BoxFit.contain,
            height: 25,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
            onPressed: () => logOut(),
          ),
        ],
        title: Center(child: Text('Book A Seat')),
        backgroundColor: Colors.purple[500],
      ),
      body: Container(
        decoration: new BoxDecoration(
          boxShadow: [
            new BoxShadow(
              color: Color(0xffeeeeee),
              blurRadius: 1.0,
              offset: new Offset(1.0, 1.0),
            ),
          ],
          borderRadius: new BorderRadius.circular(16.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Container(
              child: ListView(
                children: <Widget>[
                  Container(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 10, 5),
                                child: Text(
                                  "Please select your preffered service, the number of seats you want to book and pick a service date, for ease Booking of seat(s) in the specified sunday service",
                                  style: TextStyle(
                                      color: Color(0xff616161), fontSize: 14.0),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 10, 5),
                                child: Text(
                                  "Please Enter Your full Name",
                                  style: TextStyle(
                                      color: Color(0xff616161), fontSize: 16.0),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 5, 10, 10),
                                child: TextFormField(
                                  onSaved: (val) => username = val,
                                  keyboardType: TextInputType.text,
                                  controller: _username,
                                  decoration: new InputDecoration(
                                    labelText: "full name",
                                    fillColor: Colors.white,
                                    border: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(5.0),
                                      borderSide: new BorderSide(),
                                    ),
                                    //fillColor: Colors.green
                                  ),
                                  validator: (val) {
                                    if (val.length == 0) {
                                      return "Name cannot be empty";
                                    } else {
                                      return null;
                                    }
                                  },
                                  style: new TextStyle(
                                    fontFamily: "Poppins",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 10, 5),
                                child: Text(
                                  "Select Service",
                                  style: TextStyle(
                                      color: Color(0xff616161), fontSize: 16.0),
                                ),
                              ),
                              RadioListTile(
                                title: const Text('1st Service'),
                                value: Service.FIRST,
                                groupValue: _serviceValue,
                                onChanged: (Service value) {
                                  setState(() {
                                    _serviceValue = value;
                                    Service data=value;
                                    service=data._service;

                                  });
                                },
                              ),
                              RadioListTile(
                                title: const Text('2nd Service'),
                                value: Service.SECOND,
                                groupValue: _serviceValue,
                                onChanged: (Service value) {
                                  setState(() {
                                    _serviceValue = value;
                                    Service data=value;
                                    service=data._service;
                                  });
                                },
                              ),
                              RadioListTile(
                                title: const Text('3rd Service'),
                                value: Service.THIRD,
                                groupValue: _serviceValue,
                                onChanged: (Service value) {
                                  setState(() {
                                    _serviceValue = value;
                                    Service data=value;
                                    service=data._service;
                                  });
                                },
                              ),
                              RadioListTile(
                                title: const Text('4th Service'),
                                value: Service.FOURTH,
                                groupValue: _serviceValue,
                                onChanged: (Service value) {
                                  setState(() {
                                    _serviceValue = value;
                                    Service data=value;
                                    service=data._service;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 10, 5),
                                child: Text(
                                  "Type Number of Seats",
                                  style: TextStyle(
                                      color: Color(0xff616161), fontSize: 16.0),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 5, 10, 10),
                                child: TextFormField(
                                  onSaved: (val) => seat,
                                  keyboardType: TextInputType.number,
                                  controller: _seat,
                                  decoration: new InputDecoration(
                                    labelText: "seats",
                                    fillColor: Colors.white,
                                    border: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(5.0),
                                      borderSide: new BorderSide(),
                                    ),
                                    //fillColor: Colors.green
                                  ),
                                  validator: (val) {
                                    if (val.length == 0) {
                                      return "Seats cannot be empty";
                                    } else {
                                      return null;
                                    }
                                  },
                                  style: new TextStyle(
                                    fontFamily: "Poppins",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: RaisedButton(
                              onPressed: () {

                               setState(() {

                                 if(_username.text.isEmpty&&_seat.text.isEmpty){
                                   _validate=true;
                                   showToast("Fields required");
                                 }else if(_username.text.isNotEmpty&&_seat.text.isEmpty){
                                   _validate=true;
                                   showToast("Number of seats required");


                                 }else if(_username.text.isEmpty&&_seat.text.isNotEmpty){

                                   _validate=true;
                                   showToast("Username required");
                                 }else if(_username.text.isNotEmpty&&_seat.text.isNotEmpty){

                                   pr.show();
                                    _validate = false;
                                    _submit();

                                 }
                               });


                              },
                              child: Text('Submit'),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: RaisedButton(
                              onPressed: () {},
                              child: Text('Cancel'),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void onError(String error) {
    // TODO: implement onError

    pr.hide();
    log('Booking error: $error');
  }

  @override
  void onSuccess(Response response) {
    // TODO: implement onSuccess
    if (response != null) {
      if (response.error == false) {
        pr.hide();
        String message = response.message;
        showToast("$message");
       // Navigator.pushNamed(context, 'BookASeat');
      }else if(response.error==true){
        pr.hide();
        String message = response.message;
        showToast("$message");
      }
    }else{
      pr.hide();
      showToast("failed");
    }
  }
  }

