import 'package:flutter/material.dart';
import 'main_menu.dart';
import 'package:http/http.dart' as http;

class PartsSignOutPage extends StatefulWidget {
  @override
  _PartsSignOutPageState createState() => _PartsSignOutPageState();
}

class _PartsSignOutPageState extends State<PartsSignOutPage> {
  final TextEditingController _mechanicIdController = TextEditingController();
  final TextEditingController _busIdController = TextEditingController();
  final TextEditingController _workOrderIdController = TextEditingController();
  final TextEditingController _partNumberController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _supervisorInitialsController =
      TextEditingController();

  Future<void> signOutPart() async {
    final response = await http.post(
      Uri.parse('http://localhost:3000/part-sign-out'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'mechanicId': _mechanicIdController.text,
        'busId': _busIdController.text,
        'workOrder': _workOrderIdController.text,
        'partNumber': _partNumberController.text,
        'quantity': _quantityController.text,
        'supervisorInitials': _supervisorInitialsController.text,
        'dateTime': DateTime.now().toString(),
        // Add other properties as necessary
      },
    );

    if (response.statusCode == 200) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MainMenu(),
        ),
      );
    } else {
      // Handle the error
      print('Error signing out part: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Parts Sign Out'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('Parts Sign Out',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              SizedBox(
                width: 600,
                child: TextField(
                  controller: _mechanicIdController,
                  decoration: InputDecoration(
                    labelText: 'Mechanic ID',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: 600,
                child: TextField(
                  controller: _busIdController,
                  decoration: InputDecoration(
                    labelText: 'Bus ID',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: 600,
                child: TextField(
                  controller: _workOrderIdController,
                  decoration: InputDecoration(
                    labelText: 'Work Order #',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: 600,
                child: TextField(
                  controller: _partNumberController,
                  decoration: InputDecoration(
                    labelText: 'Part Number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: 600,
                child: TextField(
                  controller: _quantityController,
                  decoration: InputDecoration(
                    labelText: 'Quantity',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: 600,
                child: TextField(
                  controller: _supervisorInitialsController,
                  decoration: InputDecoration(
                    labelText: 'Supervisor Initials',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Note: Supervisor must initial if the part costs more than 500 dollars.',
                style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              ),
              SizedBox(height: 20),
              Container(
                width: 150,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    onPrimary: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: signOutPart,
                  child: Text('Enter'),
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: 150,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    onPrimary: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MainMenu(),
                      ),
                    );
                  },
                  child: Text('Main Menu'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
