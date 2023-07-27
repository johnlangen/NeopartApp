import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'main_menu.dart';

class Parts {
  String location, m5PartNo, neoPartNo, description, binLocation, price;
  int quantity;

  Parts({
    required this.location,
    required this.m5PartNo,
    required this.neoPartNo,
    required this.description,
    required this.binLocation,
    required this.quantity,
    required this.price,
  });

  factory Parts.fromJson(Map<String, dynamic> json) {
    return Parts(
      location: json['location'],
      m5PartNo: json['m5_part_no'],
      neoPartNo: json['alt_part_no'],
      description: json['descrip'],
      binLocation: json['binloc1'],
      quantity: json['qtyavail'],
      price: json['price'].toString(),
    );
  }
}

class PartsLocatorPage extends StatefulWidget {
  @override
  _PartsLocatorPageState createState() => _PartsLocatorPageState();
}

class _PartsLocatorPageState extends State<PartsLocatorPage> {
  final TextEditingController _partNumberController = TextEditingController();
  final TextEditingController _keywordController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  final List<String> _locations = <String>['Fairfield', 'Reading'];
  List<Parts> _partsList = [];
  int _currentPartIndex = 0;

  Future<List<Parts>> fetchPart(
      String partNumber, String keyword, String location) async {
    final response = await http.get(
      Uri.parse(
          'http://localhost:3000/parts?partNumber=$partNumber&keyword=$keyword&location=$location'),
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((item) => Parts.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load part');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Parts Locator'),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth > 900) {
            // Use desktop layout if screen width is larger than 600 pixels
            return desktopView();
          } else {
            // Otherwise, use the mobile layout
            return mobileView(); // You can define a mobileView method with your current build implementation
          }
        },
      ),
    );
  }

  Widget desktopView() {
    return ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('Part Locator',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
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
              SizedBox(height: 10),
              SizedBox(
                width: 600,
                child: TextField(
                  controller: _keywordController,
                  decoration: InputDecoration(
                    labelText: 'Keyword',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                width: 600,
                child: Autocomplete<String>(
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text.isEmpty) {
                      return _locations;
                    }
                    return _locations.where((String option) {
                      return option
                          .toLowerCase()
                          .contains(textEditingValue.text.toLowerCase());
                    });
                  },
                  onSelected: (String selection) {
                    _locationController.text = selection;
                  },
                  optionsViewBuilder: (BuildContext context,
                      AutocompleteOnSelected<String> onSelected,
                      Iterable<String> options) {
                    return Align(
                      alignment: Alignment.topLeft,
                      child: Material(
                        elevation: 4.0,
                        child: Container(
                          height: 200.0,
                          child: ListView.builder(
                            itemCount: options.length,
                            itemBuilder: (BuildContext context, int index) {
                              final String option = options.elementAt(index);
                              return GestureDetector(
                                onTap: () {
                                  onSelected(option);
                                },
                                child: ListTile(
                                  title: Text(option),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                  fieldViewBuilder: (BuildContext context,
                      TextEditingController fieldTextController,
                      FocusNode focusNode,
                      VoidCallback onFieldSubmitted) {
                    fieldTextController.text = _locationController.text;
                    return TextField(
                      controller: fieldTextController,
                      focusNode: focusNode,
                      decoration: InputDecoration(
                        labelText: 'Location',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 10),
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
                    final partNumber = _partNumberController.text;
                    final keyword = _keywordController.text;
                    final location = _locationController.text;

                    if (partNumber.isNotEmpty ||
                        keyword.isNotEmpty ||
                        location.isNotEmpty) {
                      fetchPart(partNumber, keyword, location).then((partList) {
                        setState(() {
                          _partsList = partList;
                          _currentPartIndex = 0;
                        });
                      }).catchError((error) {
                        print(error);
                      });
                    }
                  },
                  child: Text('Search'),
                ),
              ),
              SizedBox(height: 10),
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
                    _partNumberController.clear();
                    _keywordController.clear();
                    _locationController.text = '';
                    setState(() {
                      _partsList = [];
                      _currentPartIndex = 0;
                    });
                  },
                  child: Text('Clear'),
                ),
              ),
              SizedBox(height: 20),
              DataTable(
                columns: const <DataColumn>[
                  DataColumn(
                    label: Text('Location'),
                  ),
                  DataColumn(
                    label: Text('M5 Part No'),
                  ),
                  DataColumn(
                    label: Text('Neopart No'),
                  ),
                  DataColumn(
                    label: Text('Description'),
                  ),
                  DataColumn(
                    label: Text('Bin Location'),
                  ),
                  DataColumn(
                    label: Text('Quantity Available'),
                  ),
                  DataColumn(
                    label: Text('Price'),
                  ),
                ],
                rows: _partsList
                    .map((part) => DataRow(
                          cells: <DataCell>[
                            DataCell(Text(part.location)),
                            DataCell(Text(part.m5PartNo)),
                            DataCell(Text(part.neoPartNo)),
                            DataCell(Text(part.description)),
                            DataCell(Text(part.binLocation)),
                            DataCell(Text('${part.quantity}')),
                            DataCell(Text(part.price)),
                          ],
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget mobileView() {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      double fontSize =
          MediaQuery.of(context).orientation == Orientation.landscape
              ? 14.0
              : 20.0;

      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('Part Locator',
                  style: TextStyle(
                      fontSize: fontSize, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),

              ConstrainedBox(
                constraints: BoxConstraints.tightFor(width: 200),
                child: TextField(
                  controller: _partNumberController,
                  decoration: InputDecoration(
                    labelText: 'Part Number',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
                  ),
                ),
              ),
              SizedBox(height: 10),
              ConstrainedBox(
                constraints: BoxConstraints.tightFor(width: 200),
                child: TextField(
                  controller: _keywordController,
                  decoration: InputDecoration(
                    labelText: 'Keyword',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Autocomplete<String>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text.isEmpty) {
                    return _locations;
                  }
                  return _locations.where((String option) {
                    return option
                        .toLowerCase()
                        .contains(textEditingValue.text.toLowerCase());
                  });
                },
                onSelected: (String selection) {
                  _locationController.text = selection;
                },
                optionsViewBuilder: (BuildContext context,
                    AutocompleteOnSelected<String> onSelected,
                    Iterable<String> options) {
                  return Align(
                    alignment: Alignment.topLeft,
                    child: Material(
                      elevation: 4.0,
                      child: Container(
                        height: 200.0,
                        child: ListView.builder(
                          itemCount: options.length,
                          itemBuilder: (BuildContext context, int index) {
                            final String option = options.elementAt(index);
                            return GestureDetector(
                              onTap: () {
                                onSelected(option);
                              },
                              child: ListTile(
                                title: Text(option),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
                fieldViewBuilder: (BuildContext context,
                    TextEditingController fieldTextController,
                    FocusNode focusNode,
                    VoidCallback onFieldSubmitted) {
                  fieldTextController.text = _locationController.text;
                  return ConstrainedBox(
                    constraints: BoxConstraints.tightFor(width: 200),
                    child: TextField(
                      controller: fieldTextController,
                      focusNode: focusNode,
                      decoration: InputDecoration(
                        labelText: 'Location',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 15.0),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 10),
              ButtonTheme(
                minWidth: 200.0,
                height: 50.0,
                buttonColor: Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: ElevatedButton(
                  onPressed: () {
                    final partNumber = _partNumberController.text;
                    final keyword = _keywordController.text;
                    final location = _locationController.text;

                    if (partNumber.isNotEmpty ||
                        keyword.isNotEmpty ||
                        location.isNotEmpty) {
                      fetchPart(partNumber, keyword, location).then((partList) {
                        setState(() {
                          _partsList = partList;
                          _currentPartIndex = 0;
                        });
                      }).catchError((error) {
                        print(error); // TODO: Handle errors
                      });
                    }
                  },
                  child: Text('Search'),
                ),
              ),
              SizedBox(height: 10),
              ButtonTheme(
                minWidth: 200.0,
                height: 50.0,
                buttonColor: Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: ElevatedButton(
                  onPressed: () {
                    _partNumberController.clear();
                    _keywordController.clear();
                    _locationController.text = '';
                    setState(() {
                      _partsList = [];
                      _currentPartIndex = 0;
                    });
                  },
                  child: Text('Clear'),
                ),
              ),
              SizedBox(height: 20),
              _partsList.isNotEmpty
                  ? Expanded(
                      child: Column(
                        children: [
                          Text(
                              'Location: ${_partsList[_currentPartIndex].location}',
                              style: TextStyle(fontSize: fontSize)),
                          Text(
                              'M5 Part No: ${_partsList[_currentPartIndex].m5PartNo}',
                              style: TextStyle(fontSize: fontSize)),
                          Text(
                              'Neopart No: ${_partsList[_currentPartIndex].neoPartNo}',
                              style: TextStyle(fontSize: fontSize)),
                          Text(
                              'Description: ${_partsList[_currentPartIndex].description}',
                              style: TextStyle(fontSize: fontSize)),
                          Text(
                              'Bin Location: ${_partsList[_currentPartIndex].binLocation}',
                              style: TextStyle(fontSize: fontSize)),
                          Text(
                              'Quantity Available: ${_partsList[_currentPartIndex].quantity}',
                              style: TextStyle(fontSize: fontSize)),
                          Text('Price: ${_partsList[_currentPartIndex].price}',
                              style: TextStyle(fontSize: fontSize)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: _currentPartIndex > 0
                                    ? () {
                                        setState(() {
                                          _currentPartIndex--;
                                        });
                                      }
                                    : null,
                                icon: Icon(Icons.arrow_back),
                              ),
                              IconButton(
                                onPressed:
                                    _currentPartIndex < _partsList.length - 1
                                        ? () {
                                            setState(() {
                                              _currentPartIndex++;
                                            });
                                          }
                                        : null,
                                icon: Icon(Icons.arrow_forward),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  : Container(), // If no parts are found
            ],
          ),
        ),
        drawer:
            MainMenu(), // Assuming you have a MainMenu widget for the drawer
      );
    });
  }
}
