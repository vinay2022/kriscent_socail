import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kriscent_socail/view/utils/extensions/app_extensions.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key, required this.onPressed, required this.text,  this.isLoading});
  final void Function()? onPressed;
  final bool? isLoading;
  final String text;
  @override
  Widget build(BuildContext context) {
    if(isLoading == true){
      return const Center(child: CupertinoActivityIndicator());
    }
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SizedBox(
        height: 50,
        width: double.infinity,
        child: ElevatedButton(onPressed: onPressed,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent,shape: 5.shapeBorderRadius),
          child: Text(text, style: TextStyle(color: Colors.white),),),
      ),
    );
  }
}
