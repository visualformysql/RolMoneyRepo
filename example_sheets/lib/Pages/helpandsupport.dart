import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:image_picker/image_picker.dart';

class helpandsupport extends StatefulWidget {
  const helpandsupport(String s, {Key? key}) : super(key: key);

  @override
  _helpandsupportState createState() => _helpandsupportState();
}

class _helpandsupportState extends State<helpandsupport> {

  List<String> attachments = [];
  bool isHTML = false;

  final _recipientController = TextEditingController(
    text: 'example@example.com',
  );

  final _subjectController = TextEditingController(text: 'The subject');

  final _bodyController = TextEditingController(
    text: 'Mail body.',
  );

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> send() async {
    final Email email = Email(
      body: _bodyController.text,
      subject: _subjectController.text,
      recipients: [_recipientController.text],
      attachmentPaths: attachments,
      isHTML: isHTML,
    );

    String platformResponse;

    try {
      await FlutterEmailSender.send(email);
      platformResponse = 'success';
    } catch (error) {
      platformResponse = error.toString();
    }

    if (!mounted) return;

    _scaffoldKey.currentState!.showSnackBar(SnackBar(
      content: Text(platformResponse),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          FocusScope.of(context).requestFocus(FocusNode());
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
    child:MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.blue),
      home: Scaffold(
        resizeToAvoidBottomInset : false,
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('Plugin example app'),
          actions: <Widget>[
            IconButton(
              onPressed: send,
              icon: const Icon(Icons.send),
            )
          ],
        ),

        body:
            SingleChildScrollView(
              reverse:false,
              padding: const EdgeInsets.symmetric(vertical: 40,horizontal:20),
    child:Container(
      padding: EdgeInsets.only(bottom: bottom),
              child:Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    enabled: false,
                    controller: _recipientController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Recipient',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _subjectController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Subject',
                    ),
                  ),
                ),
                ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxHeight: 300,
                    ),
                child: Padding(
                   padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _bodyController,
                    maxLines: null,
                    expands:true,
                    textAlignVertical: TextAlignVertical.top,
                    decoration:  const InputDecoration(
                        labelText: 'Body', border: OutlineInputBorder()),
                  ),
                 ),
                ),
                CheckboxListTile(
                  contentPadding:
                  const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
                  title: const Text('HTML'),
                  onChanged: (bool? value) {
                    setState(() {
                      isHTML = value!;
                    });
                  },
                  value: isHTML,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    children: <Widget>[
                      for (var i = 0; i < attachments.length; i++)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Flexible(
                                flex: 0,
                               child:
                                Container(
                                  margin: const EdgeInsets.all(10),
                                  width: 100,
                                  height: 100,
                                  child: Image.file(File(attachments[i]),
                                      fit: BoxFit.cover),
                                ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.remove_circle),
                              onPressed: () => {_removeAttachment(i)},
                            )
                          ],
                        ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon: const Icon(Icons.attach_file),
                          onPressed: _openImagePicker,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    ),
    ),
            ),
    ),
      );
  }

  Future _openImagePicker() async {
    final pick = await ImagePicker().getImage(source: ImageSource.gallery);
    if (pick != null) {
      setState(() {
        attachments.add(pick.path);
      });
    }
  }

  void _removeAttachment(int index) {
    setState(() {
      attachments.removeAt(index);
    });
  }
}
