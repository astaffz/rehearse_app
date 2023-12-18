import 'package:flutter/material.dart';

import 'styles.dart';

Widget RehearseAppLogo = Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    const Material(
      color: white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.all(Radius.circular(10)),
      ),
      child: Padding(
        padding: EdgeInsets.all(5.0),
        child: Icon(
          Icons.edit,
          color: icon,
        ),
      ),
    ),
    const SizedBox(
      width: 10,
    ),
    Text(
      'RehearseApp',
      style: heading1,
    )
  ],
);
