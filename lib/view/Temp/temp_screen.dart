// import'package:flutter/material.dart';
// import 'package:untitled2/screens/Account/select_time_slot_screen.dart';
// import 'package:untitled2/screens/Wakeup/welcome_screen.dart';
// import 'package:untitled2/screens/selection.dart';
// import '../../Services/auth_services.dart';
// import '../Account/signup_screen.dart';

// class TempScreen extends StatefulWidget {
//   const TempScreen({Key? key}) : super(key: key);

//   @override
//   _TempScreenState createState() => _TempScreenState();
// }

// class _TempScreenState extends State<TempScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: FutureBuilder(
//         future: AuthServices.getCurrentUser(),
//         builder: (context,AsyncSnapshot<dynamic> snapshot){
//           var user = AuthServices.auth.currentUser;
//           if (snapshot.hasError || snapshot.data == null) {
//             return const SelectTimeSlotScreen();
//           } else {
//             AuthServices.setCurrentUserToMap(user!.uid);
//             return const SelectTimeSlotScreen();
//           }
//         },
//       ),
//     );
//   }
// }
