import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Color(0xff11b719),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedCurrency, selectedType;
  final GlobalKey<FormState> _formKeyValue = new GlobalKey<FormState>();
  List<String> _accountType = <String>[
    'Savings',
    'Deposit',
    'Checking',
    'Brokerage'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(
                FontAwesomeIcons.bars,
                color: Colors.white,
              ),
              onPressed: () {}),
          title: Container(
            alignment: Alignment.center,
            child: Text("Account Details",
                style: TextStyle(
                  color: Colors.white,
                )),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                FontAwesomeIcons.coins,
                size: 20.0,
                color: Colors.white,
              ),
              onPressed: null,
            ),
          ],
        ),
        body: Form(
          key: _formKeyValue,
          autovalidate: true,
          child: new ListView(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            children: <Widget>[
              SizedBox(height: 20.0),
              new TextFormField(
                decoration: const InputDecoration(
                  icon: const Icon(
                    FontAwesomeIcons.phone,
                    color: Color(0xff11b719),
                  ),
                  hintText: 'Enter your Phone Details',
                  labelText: 'Phone',
                ),
                keyboardType: TextInputType.number
              ),
              new TextFormField(
                decoration: const InputDecoration(
                  icon: const Icon(
                    FontAwesomeIcons.userCircle,
                    color: Color(0xff11b719),
                  ),
                  hintText: 'Enter your Name',
                  labelText: 'Name',
                ),
              ),
              
              new TextFormField(
                decoration: const InputDecoration(
                  icon: const Icon(
                    FontAwesomeIcons.envelope,
                    color: Color(0xff11b719),
                  ),
                  hintText: 'Enter your Email Address',
                  labelText: 'Email',
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    FontAwesomeIcons.moneyBill,
                    size: 25.0,
                    color: Color(0xff11b719),
                  ),
                  SizedBox(width: 50.0),
                  DropdownButton(
                    items: _accountType
                        .map((value) => DropdownMenuItem(
                              child: Text(
                                value,
                                style: TextStyle(color: Color(0xff11b719)),
                              ),
                              value: value,
                            ))
                        .toList(),
                    onChanged: (selectedAccountType) {
                      print('$selectedAccountType');
                      setState(() {
                        selectedType = selectedAccountType;
                      });
                    },
                    value: selectedType,
                    isExpanded: false,
                    hint: Text(
                      'Choose Account Type',
                      style: TextStyle(color: Color(0xff11b719)),
                    ),
                  )
                ],
              ),
              SizedBox(height: 40.0),
              StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance.collection("currency").snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      const Text("Loading.....");
                    else {
                      List<DropdownMenuItem> currencyItems = [];
                      for (int i = 0; i < snapshot.data.documents.length; i++) {
                        DocumentSnapshot snap = snapshot.data.documents[i];
                        currencyItems.add(
                          DropdownMenuItem(
                            child: Text(
                              snap.documentID,
                              style: TextStyle(color: Color(0xff11b719)),
                            ),
                            value: "${snap.documentID}",
                          ),
                        );
                      }
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(FontAwesomeIcons.coins,
                              size: 25.0, color: Color(0xff11b719)),
                          SizedBox(width: 50.0),
                          DropdownButton(
                            items: currencyItems,
                            onChanged: (currencyValue) {
                              final snackBar = SnackBar(
                                content: Text(
                                  'Selected Currency value is $currencyValue',
                                  style: TextStyle(color: Color(0xff11b719)),
                                ),
                              );
                              Scaffold.of(context).showSnackBar(snackBar);
                              setState(() {
                                selectedCurrency = currencyValue;
                              });
                            },
                            value: selectedCurrency,
                            isExpanded: false,
                            hint: new Text(
                              "Choose Currency Type",
                              style: TextStyle(color: Color(0xff11b719)),
                            ),
                          ),
                        ],
                      );
                    }
                  }),
              SizedBox(
                height: 150.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  RaisedButton(
                      color: Color(0xff11b719),
                      textColor: Colors.white,
                      child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text("Submit", style: TextStyle(fontSize: 24.0)),
                            ],
                          )),
                      onPressed: () {},
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0))),
                ],
              ),
            ],
          ),
        ));
  }
}
