import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


// For formatting text inout fields
const enabled =  OutlineInputBorder(
  borderSide: BorderSide(color: Colors.blue, width: 2),
);

const focused =  OutlineInputBorder(
  borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2),
);

const textInputFormatting = InputDecoration(
  fillColor: Colors.white,
  filled : true,
  errorBorder: enabled,
  focusedErrorBorder:focused,
  enabledBorder: enabled,
  focusedBorder: focused,
);

const authInputFormatting = InputDecoration(
  fillColor: Colors.white,
  filled : true,
  border: InputBorder.none,
);


// For loading screen
class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SpinKitDoubleBounce(
          color: Colors.cyan,
          size: 50,
        ),
      ),
    );
  }
}

class LoadingData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SpinKitThreeBounce(
          color: Colors.cyan,
          size: 30,
        ),
      ),
    );
  }
}

class AuthLoading extends StatelessWidget {
  final double _height, _width;
  AuthLoading(this._height, this._width);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _width, vertical: _height),
      child: Center(
        child: SpinKitThreeBounce(
          color: Colors.cyan,
          size: 40,
        ),
      ),
    );
  }
}

