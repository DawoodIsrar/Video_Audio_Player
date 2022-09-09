import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class POnline extends StatefulWidget {
  const POnline({Key? key}) : super(key: key);

  @override
  State<POnline> createState() => _POnlineState();
}

class _POnlineState extends State<POnline> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        backgroundColor: Colors.lightBlue[300],
        title: Text(
          'Bitlogicx Player',
        ),
      ),
    );
  }
}