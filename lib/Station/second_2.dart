import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SecondTwo extends StatefulWidget {
  const SecondTwo({Key? key}) : super(key: key);

  @override
  State<SecondTwo> createState() => _SecondTwoState();
}

class _SecondTwoState extends State<SecondTwo> {
  var _contactNameController = TextEditingController();
  var _contactNumberController = TextEditingController();
  var _contactEmailController = TextEditingController();
  //
  // bool _validateName = false;
  bool _validateNumber = false;

  bool quota = false;

  bool free = true;

  _ValidateQuota() async {
    free
        ? setState(() {
            quota = true;
            // showDialog(
            //     context: context,
            //     builder: (parm) {
            //       return AlertDialog(
            //         title: Column(
            //           children: const [
            //             Text(
            //               'Avaliable limit',
            //               style:
            //                   TextStyle(color: Colors.blueGrey, fontSize: 18),
            //             ),
            //             SizedBox(
            //               height: 20,
            //             ),
            //             Text(
            //               '5 liters',
            //               style: TextStyle(color: Colors.green, fontSize: 18),
            //             ),
            //             // SizedBox(
            //             //   height: 20,
            //             // ),
            //             // TextButton(
            //             //   onPressed: () {
            //             //   },
            //             //   child: Text('5 liters',
            //             //       style:
            //             //       TextStyle(color: Colors.green, fontSize: 18)),
            //             // ),
            //           ],
            //         ),
            //       );
            //     });
          })
        : showDialog(
            context: context,
            builder: (parm) {
              return AlertDialog(
                title: Column(
                  children: const [
                    Text(
                      'No quota available',
                      style: TextStyle(color: Colors.blueGrey, fontSize: 18),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Icon(
                      Icons.cancel_outlined,
                      size: 70,
                      color: Colors.red,
                    )
                  ],
                ),
              );
            });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10.0,
              ),
              const Text(
                    "Fuel Station",
                    style: TextStyle(fontSize: 30),
                  ),
              const SizedBox(
                height: 10.0,
              ),
              // Stack(
              //   children: [
              //     // Center(
              //     //   child: Container(
              //     //     height: 160,
              //     //     width: 160,
              //     //     decoration: BoxDecoration(
              //     //       shape: BoxShape.circle,
              //     //       //border: Border.all(width: 2, color: Colors.blueGrey)
              //     //     ),
              //     //     child:
              //     //     // ClipRRect(
              //     //     //   borderRadius: BorderRadius.circular(100.0),
              //     //     //   child: _image != null
              //     //     //       ? Image.file(
              //     //     //     _image!,
              //     //     //     fit: BoxFit.cover,
              //     //     //   )
              //     //     //       :
              //     //       Center(
              //     //         child: CircleAvatar(
              //     //           backgroundColor: Colors.blueGrey,
              //     //           radius: 80,
              //     //           child: Icon(
              //     //             Icons.add_a_photo,
              //     //             size: 30,
              //     //             color: Colors.white,
              //     //           ),
              //     //         ),
              //     //       ),
              //     //
              //     //   ),
              //     // ),
              //     // Center(
              //     //   child: CircleAvatar(
              //     //     backgroundColor: Colors.black12,
              //     //     radius: 80,
              //     //     child: IconButton(
              //     //         icon: const Icon(
              //     //           Icons.add_a_photo,
              //     //           size: 30,
              //     //         ),
              //     //         color: Colors.white,
              //     //         onPressed: () {
              //     //           Widget optionOne = SimpleDialogOption(
              //     //             child: const Text('Take new photo'),
              //     //             onPressed: () {
              //     //               Navigator.pop(context);
              //     //               //_TakePhoto();
              //     //             },
              //     //           );
              //     //           Widget optionTwo = SimpleDialogOption(
              //     //             child: const Text('Choose new photo'),
              //     //             onPressed: () {
              //     //               Navigator.pop(context);
              //     //               //_ChoosePhoto();
              //     //             },
              //     //           );
              //     //           // set up the SimpleDialog
              //     //           SimpleDialog dialog = SimpleDialog(
              //     //             title: const Text('Change photo'),
              //     //             children: <Widget>[
              //     //               optionOne,
              //     //               optionTwo,
              //     //             ],
              //     //           );
              //     //
              //     //           // show the dialog
              //     //           showDialog(
              //     //             context: context,
              //     //             builder: (BuildContext context) {
              //     //               return dialog;
              //     //             },
              //     //           );
              //     //         }
              //     //     ),
              //     //   ),
              //     // ),
              //   ],
              // ),
              // const SizedBox(
              //   height: 40.0,
              // ),
              // Column(
              //   children: const [
              //     //Icon(Icons.person),
              //   ],
              // ),
              Row(
                children: [
                  Flexible(
                    child: TextField(
                      //autofocus: true,
                      controller: _contactNameController,
                      decoration: const InputDecoration(
                        //filled: true,
                        fillColor: const Color(0xFFFFFFFF),
                        isDense: true,
                        border: OutlineInputBorder(),
                        hintText: 'Enter Token Number',
                        labelText: 'Token Number',
                        //errorText: _validateName ? 'Name Can\'t Be Empty' : null,
                      ),
                      onSubmitted: (value) {
                        if (value.isNotEmpty) {
                          _ValidateQuota();
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 50,
                      width: 100,
                      child: TextButton(
                          style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.red,
                              textStyle: const TextStyle(fontSize: 15)),
                          onPressed: () {
                            _ValidateQuota();
                          },
                          child: const Text('Check')),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 100.0,
              ),

              quota ? Column(
                children: [
                  Text(
                    "Quota limit",
                    style: TextStyle(fontSize: 15),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    "5 litres",
                    style: TextStyle(fontSize: 40),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  Row(
                    children: [
                      Text(
                        "Vehicle number:",
                        style: TextStyle(fontSize: 15),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 40.0),
                        child: Text(
                          "ABC 001",
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    children: [
                      Text(
                        "Requested amount:",
                        style: TextStyle(fontSize: 15),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 18.0),
                        child: Text(
                          "2 litres",
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                  // TextField(
                  //     enabled: quota ? true : false,
                  //     controller: _contactNumberController,
                  //     decoration: InputDecoration(
                  //       //filled: true,
                  //       fillColor: const Color(0xFFFFFFFF),
                  //       isDense: true,
                  //       border: const OutlineInputBorder(),
                  //       hintText: 'Enter Token Number',
                  //       labelText: 'Token Number',
                  //       errorText: _validateNumber ? 'Number Can\'t Be Empty' : null,
                  //     )),
                  // SizedBox(
                  //   height: 18.0,
                  // ),
                  // TextField(
                  //     enabled: quota ? true : false,
                  //     controller: _contactEmailController,
                  //     keyboardType: TextInputType.number,
                  //     inputFormatters: <TextInputFormatter>[
                  //       FilteringTextInputFormatter.allow(RegExp(r'[.0-9]')),
                  //     ],
                  //     decoration: const InputDecoration(
                  //       //filled: true,
                  //       fillColor: const Color(0xFFFFFFFF),
                  //       isDense: true,
                  //       border: OutlineInputBorder(),
                  //       hintText: 'Enter fuel amount',
                  //       labelText: 'Fuel amount',
                  //     )),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextButton(
                            style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.blueGrey,
                                textStyle: const TextStyle(fontSize: 15)),
                            onPressed: () async {
                              setState(() {
                                // _contactNameController.text.isEmpty
                                //     ? _validateName = true
                                //     : _validateName = false;
                                _contactNumberController.text.isEmpty
                                    ? _validateNumber = true
                                    : _validateNumber = false;
                              });
                              if (
                              //_validateName == false &&
                              _validateNumber == false) {
                                //InsertContacts
                                // var _contact = Contact();
                                // _contact.name = _contactNameController.text;
                                // _contact.number = _contactNumberController.text;
                                // _contact.email = _contactEmailController.text;
                                // _contact.photo = ImagePath ?? "";
                                // print(_contact.name);
                                // print(_contact.number);
                                // print(_contact.email);
                                // print(_contact.photo);
                                // var result =
                                // await _contactCommunication.saveContact(_contact);
                                // Navigator.pop(context, result);
                              }
                            },
                            child: const Text('Submit')),
                      ),
                      // const SizedBox(
                      //   width: 10.0,
                      // ),
                      // Expanded(
                      //     child: TextButton(
                      //         style: TextButton.styleFrom(
                      //             foregroundColor: Colors.white,
                      //             backgroundColor: Colors.red,
                      //             textStyle: const TextStyle(fontSize: 15)),
                      //         onPressed: () {
                      //           _contactNameController.text = '';
                      //           _contactNumberController.text = '';
                      //           _contactEmailController.text = '';
                      //         },
                      //         child: const Text('Clear')))
                    ],
                  )
                ],
              ) : Container(),

            ],
          ),
        ),
      ),
    );
  }
}
