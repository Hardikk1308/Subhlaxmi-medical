// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:myadsworld/core/extentions/text_style_extentions.dart';
// import 'package:myadsworld/core/style/app_colors.dart';
// import 'package:myadsworld/core/style/app_text_styles.dart';

// class FaqsWidget extends StatefulWidget {
//   final String question;
//   final String answer;
//   const FaqsWidget({super.key, required this.question, required this.answer});

//   @override
//   State<FaqsWidget> createState() => _FaqsWidgetState();
// }

// class _FaqsWidgetState extends State<FaqsWidget> {
//   bool isTrue = true;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       // height: 70.h,
//       margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//       width: double.infinity,
//       decoration: BoxDecoration(
//         color: Colours.white,
//         border: Border.all(color: Colours.neutralGray),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: InkWell(
//         onTap: () {
//           setState(() {
//             isTrue = !isTrue;
//           });
//         },
//         child: Center(
//           child: isTrue
//               ? ListTile(
//                   title: Text(
//                     maxLines: 2,
//                     widget.question,
//                     style: AppTextStyles.karala12w700,
//                   ),
//                   trailing: isTrue
//                       ? Icon(Icons.arrow_drop_down)
//                       : Icon(Icons.arrow_drop_up_outlined),
//                 )
//               : Column(
//                   children: [
//                     ListTile(
//                       title: Text(
//                         maxLines: 2,
//                         widget.question,
//                         style: AppTextStyles.karala12w700,
//                       ),
//                       trailing: isTrue
//                           ? Icon(Icons.arrow_drop_down)
//                           : Icon(Icons.arrow_drop_up_outlined),
//                     ),
//                     Divider(),
//                     Padding(
//                       padding: const EdgeInsets.only(
//                         left: 18.0,
//                         right: 18.0,
//                         bottom: 18.0,
//                       ),
//                       child: Text(
//                         textAlign: TextAlign.justify,
//                         widget.answer,
//                         style: AppTextStyles.karala12w500.dark,
//                       ),
//                     ),
//                   ],
//                 ),
//         ),
//       ),
//     );
//   }
// }
