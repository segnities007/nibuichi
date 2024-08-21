import 'package:flutter/material.dart';



ButtonStyle buttonStyle({double n = 1, double height = 20, double width = 10}){
    return ElevatedButton.styleFrom(
        fixedSize: Size(height*n, width*n),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
        )
    );
}


