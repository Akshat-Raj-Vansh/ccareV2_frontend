import 'package:flutter/material.dart';

class MedicalReports extends StatefulWidget {
  const MedicalReports({ Key? key }) : super(key: key);

  @override
  _MedicalReportsState createState() => _MedicalReportsState();
}

class _MedicalReportsState extends State<MedicalReports> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        buildMainBody(),
                buildFloatingButton()
              ],
            );
          }
        
          buildFloatingButton()=>
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
        
              padding:EdgeInsets.all(30),
              child: FloatingActionButton(
                backgroundColor: Theme.of(context).primaryColor,
                onPressed: (){},
              child:Icon(Icons.add,color: Colors.white,)),),
            );
        
          buildMainBody() =>Center(child: Text("No Reports Added"),);
  
}