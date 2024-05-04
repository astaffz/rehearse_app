import 'package:flutter/material.dart';

import 'styles.dart';

Widget RehearseAppLogo = Hero(
    tag: 'app.logo',
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'RehearseApp',
          style: heading1.copyWith(fontSize: 40, color: forestGreen),
        )
      ],
    ));
