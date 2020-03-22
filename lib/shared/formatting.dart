import 'package:flutter/material.dart';


const enabled =  OutlineInputBorder(
  borderSide: BorderSide(color: Colors.black, width: 2),
);

const focused =  OutlineInputBorder(
  borderSide: BorderSide(color: Colors.blue, width: 2),
);

const textInputFormatting = InputDecoration(
  fillColor: Colors.white,
  filled : true,
  errorBorder: enabled,
  focusedErrorBorder:focused,
  enabledBorder: enabled,
  focusedBorder: focused,
);