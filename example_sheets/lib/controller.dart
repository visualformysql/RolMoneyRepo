import 'dart:convert' as convert;
import 'package:example_sheets/models/feedback_form.dart';
import 'package:http/http.dart' as http;


class FormController {
  // Callback function to give response of status of current request.
  final void Function(String) callback;

  // Google App Script Web URL
  var URL = 'https://script.google.com/macros/s/AKfycbyc8jn74N107udevIJJl12e-XvNR-4UbbP98BPFkrXY6qL6lk1FmOcyVCHLFOVRIw1o/exec';

  static const STATUS_SUCCESS = "SUCCESS";

  FormController(this.callback);

  void submitForm(FeedbackForm feedbackForm) async {
    URL += feedbackForm.toParams();
    Uri uri = Uri.parse(URL);
    try {
      await http.get(
          uri).then(
              (response) {
            callback(convert.jsonDecode(response.body)['status']);
          });
    } catch (e) {
      print(e);
    }
  }
}