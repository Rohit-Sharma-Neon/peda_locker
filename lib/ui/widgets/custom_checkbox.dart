import 'package:flutter/material.dart';

import '../../utils/sizes.dart';

class CustomCheckBox extends StatelessWidget {
  final String title;
  bool boolValue;
  CustomCheckBox({Key? key, required this.title, this.boolValue = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
        return InkWell(
          onTap: (){
            setState((){
              boolValue = !boolValue;
            });
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Transform.scale(
                scale: 1.5,
                child: Checkbox(value: boolValue, onChanged: (value){
                  setState((){
                    boolValue = value!;
                  });
                },visualDensity: const VisualDensity(horizontal: -4),activeColor: Colors.grey,),
              ),
              const SizedBox(width: 6,),
              Text(title,style: const TextStyle(fontSize: ts18,fontWeight: FontWeight.w500),),
            ],
          ),
        );
      },
    );
  }
}
