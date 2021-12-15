import 'package:ccarev2_frontend/main/domain/edetails.dart';
import 'package:ccarev2_frontend/state_management/main/main_cubit.dart';
import 'package:ccarev2_frontend/user/domain/hub_doc_info.dart';
import 'package:flutter/material.dart';

class PatientList extends StatelessWidget {
  final List<PatientDetails> patients;
  final MainCubit cubit;

  const PatientList(this.patients, this.cubit);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: patients.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () => cubit.fetchEmergencyDetails(patients[index].id),
            child: ListTile(
                leading: Icon(Icons.person),
                trailing: Text(
                  patients[index].name,
                  style: TextStyle(color: Colors.green, fontSize: 15),
                ),
                title: Text(patients[index].name)),
          );
        });
  }
}
