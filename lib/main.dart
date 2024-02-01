import 'package:flutter/material.dart';

void main() {
  final ThemeData theme = ThemeData();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Simple Interest Calculator App",
    home: SIForm(),
    theme: ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.indigo,
      colorScheme:
          ThemeData.dark().colorScheme.copyWith(secondary: Colors.indigoAccent),
    ),
  ));
}

class SIForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SIFormState();
  }
}

class _SIFormState extends State<SIForm> {

  var _formKey = GlobalKey<FormState>();

  var _currencies = ['Rupees', 'Dollars', 'Pounds', 'Dinars'];
  final _minimumPadding = 5.0;

  var _currentItemSelected = 'Rupees';

  TextEditingController principalContoller = TextEditingController();
  TextEditingController roiContoller = TextEditingController();
  TextEditingController termContoller = TextEditingController();

  var displayResult = '';

  @override
  Widget build(BuildContext context) {
    TextStyle? textStyle = Theme.of(context).textTheme.headline6;

    return Scaffold(
      //resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Simple Interest Calculator"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
            padding: EdgeInsets.all(_minimumPadding * 2),
            child: ListView(
              children: <Widget>[
                getImageAsset(),
                Padding(
                    padding: EdgeInsets.only(
                        top: _minimumPadding, bottom: _minimumPadding),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      style: textStyle,
                      controller: principalContoller,
                      validator: (String? value){
                        if ( value!.isEmpty ){
                          return 'Please enter principal amount';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid value';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          labelText: 'Principal',
                          hintText: "Enter Principal e.g.12000",
                          labelStyle: textStyle,
                          errorStyle: TextStyle(
                            color: Colors.yellowAccent,
                            fontSize: 15.0,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          )),
                    )),
                Padding(
                  padding: EdgeInsets.only(
                      top: _minimumPadding, bottom: _minimumPadding),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    style: textStyle,
                    controller: roiContoller,
                    validator: (String? value){
                      if ( value!.isEmpty ){
                        return 'Please enter rate of interest';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid value';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        labelText: 'Interest Rate',
                        hintText: "In percent",
                        labelStyle: textStyle,
                        errorStyle: TextStyle(
                          color: Colors.yellowAccent,
                          fontSize: 15.0,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        )),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: _minimumPadding, bottom: _minimumPadding),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: TextFormField(
                        keyboardType: TextInputType.number,
                        style: textStyle,
                        controller: termContoller,
                            validator: (String? value){
                              if ( value!.isEmpty ) {
                                return 'Please enter term';
                              }
                              if (double.tryParse(value) == null) {
                                return 'Please enter a valid value';
                              }
                              return null;
                            },
                        decoration: InputDecoration(
                            labelText: 'Term',
                            hintText: "Time in years",
                            labelStyle: textStyle,
                            errorStyle: TextStyle(
                              color: Colors.yellowAccent,
                              fontSize: 15.0,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            )),
                      )),
                      Container(
                        width: _minimumPadding * 5,
                      ),
                      Expanded(
                          child: DropdownButton<String>(
                        items: _currencies.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        value: _currentItemSelected,
                        onChanged: (newValueSelected) {
                          // your code to execute when a menu item is selected from dropdown
                          _onDropDownItemSelected(newValueSelected!);
                        },
                      ))
                    ],
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(
                        top: _minimumPadding, bottom: _minimumPadding),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Theme.of(context).primaryColorDark,
                              onPrimary: Theme.of(context).primaryColorLight,
                            ),
                            child: Text(
                              'Calculate',
                              textScaleFactor: 1.5,
                            ),
                            onPressed: () {
                              setState(() {
                                if (_formKey.currentState!.validate()) {
                                  this.displayResult = _calculateTotalReturns();
                                }
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: ElevatedButton(
                            child: Text(
                              'Reset',
                              textScaleFactor: 1.5,
                            ),
                            onPressed: () {
                              setState(() {
                                _reset();
                              });
                            },
                          ),
                        ),
                      ],
                    )),
                Padding(
                  padding: EdgeInsets.all(_minimumPadding * 2),
                  child: Text(
                    this.displayResult,
                    style: textStyle,
                  ),
                )
              ],
            )),
      ),
    );
  }

  Widget getImageAsset() {
    AssetImage assetImage = AssetImage('images/logo.png');
    Image image = Image(
      image: assetImage,
      width: 170.0,
      height: 170.0,
    );

    return Container(
      child: image,
      margin: EdgeInsets.all(_minimumPadding * 5),
    );
  }

  String _calculateTotalReturns() {
    double principal = double.parse(principalContoller.text);
    double roi = double.parse(roiContoller.text);
    double term = double.parse(termContoller.text);

    double totalAmountPayable = principal + (principal * roi * term) / 100;

    String result =
        "After $term years, your investesment will be worth $totalAmountPayable $_currentItemSelected ";
    return result;
  }

  void _onDropDownItemSelected(String newValueSelected) {
    setState(() {
      this._currentItemSelected = newValueSelected;
    });
  }

  void _reset() {
    principalContoller.text = "";
    roiContoller.text = "";
    termContoller.text = "";
    displayResult = "";
    _currentItemSelected = _currencies[0];
  }
}
