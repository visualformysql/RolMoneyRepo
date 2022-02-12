import 'package:example_sheets/Pages/helpandsupport.dart';
import 'package:flutter/material.dart';
import 'package:example_sheets/controller.dart';
import 'package:example_sheets/models/feedback_form.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,

      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();


  // TextField Controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobilenoController = TextEditingController();
  TextEditingController feedbackController = TextEditingController();

  void _submitForm() {

    if(_formKey.currentState!.validate()){
      FeedbackForm feedbackForm = FeedbackForm(
          nameController.text,
          emailController.text,
          mobilenoController.text,
          feedbackController.text
      );

      FormController formController = FormController((String response){
        print("Response: $response");
        if(response == FormController.STATUS_SUCCESS){
          //
          _showSnackbar("Feedback Submitted");
        } else {
          _showSnackbar("Error Occurred!");
        }
      });

      _showSnackbar("Submitting Feedback");

      // Submit 'feedbackForm' and save it in Google Sheet

      formController.submitForm(feedbackForm);
    }


  }

  // Method to show snackbar with 'message'.
  _showSnackbar(String message) {
    final snackBar = SnackBar(content: Text(message));
    _scaffoldKey.currentState!.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          FocusScope.of(context).requestFocus(new FocusNode());
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
    child:Scaffold(
      resizeToAvoidBottomInset : false,
      appBar: AppBar(
        title: const Text ("RolMoney") ,
            ),
      drawer: Drawer(
        child: ListView(
          children: <Widget> [
            const UserAccountsDrawerHeader(
              accountName: Text("Senior Ayush"),
              accountEmail: Text("Seniorayush@gmail.com"),
              currentAccountPicture: CircleAvatar(child: Text("S A"),backgroundColor:Colors.brown,
              ),
              otherAccountsPictures:<Widget>[CircleAvatar(backgroundColor:Colors.brown,child: Text("S V"),
              )
              ],
            ),
            const ListTile(
              title: Text("Page One"),
              trailing: Icon(Icons.arrow_upward),
            ),
            ListTile(
              title: const Text("Help & Support"),
              trailing: const Icon(Icons.help),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) =>
                    const helpandsupport("Help & support")));
              },
            ),
            const Divider(),
            ListTile(
              title: const Text("Close"),
              trailing: const Icon(Icons.close),
              onTap:() => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
      key:  _scaffoldKey,
      body:
          SingleChildScrollView(
              reverse: true,
            padding: const EdgeInsets.symmetric(vertical: 50,horizontal: 24),
            child: Center(
              child: Container(
          padding: EdgeInsets.only(bottom: bottom),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      controller: nameController,
                      validator: (value){
                        if(value!.isEmpty){
                          return "Enter Valid Name";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                          labelText: "Name"
                      ),
                    ),
                    TextFormField(
                      controller: emailController,
                      validator: (value){
                        if(value!.isEmpty){
                          return "Enter Valid Email";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                          labelText: "Email"
                      ),
                    ),
                    TextFormField(
                      controller: mobilenoController,
                      validator: (value){
                        if(value!.isEmpty){
                          return "Enter Valid Phone Number";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                          labelText: "Phone Number"
                      ),
                    ),
                    TextFormField(
                      scrollPadding:const EdgeInsets.all(20.0),
                      controller: feedbackController,
                      validator: (value){
                        if(value!.isEmpty){
                          return "Enter Valid Feedback";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                          labelText: "Feedback"
                      ),
                    ),

                    const SizedBox(   //Use of SizedBox
                      height: 30,
                    ),

                    Center(
                    child:RaisedButton(
                      color: Colors.teal,
                      textColor: Colors.white,
                      onPressed: _submitForm,
                      child: const Text('Submit Feedback'),
                    ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
          ),
      ),
    ),
    );
  }
}
