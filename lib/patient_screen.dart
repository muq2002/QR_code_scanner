import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PatientScreen extends StatelessWidget {
  final String patientId;

  PatientScreen({required this.patientId});

  Future<Map<String, dynamic>> fetchPatientData(BuildContext context) async {
    // Retrieve the URL argument from the route settings
    final String? url = ModalRoute.of(context)?.settings.arguments as String?;
    if (url == null) {
      throw Exception('URL not provided');
    }
    print(url);
    final urlBase = getBaseUrl(url);

    final response = await http.get(Uri.parse(url));


    // Check for a successful response
    if (response.statusCode == 200) {
      // Parse the JSON data from the response
      final data = jsonDecode(response.body);
      final patientID = data["ID"].toString();

      final diagnosisResponse = await http.get(
          Uri.parse('$urlBase/api/diagnosis/$patientID')
      );

      print('$urlBase/api/diagnosis/$patientID');

      //Check for a successful response
      if (diagnosisResponse.statusCode == 200) {
        final diagnosisData = jsonDecode(diagnosisResponse.body);
        data['comments'] = diagnosisData[0]["Comments"].toString();
        print(diagnosisData);
      } else {
        throw Exception('Failed to load diagnosis data');
      }

      // Add the URL for the X-ray image to the data
      data['xrayUrl'] = '$urlBase/api/upload/$patientID';
      print(data);
      return data;
    } else {
      // Handle the error case if the HTTP request failed
      throw Exception('Failed to load patient data');
    }
  }
  String getBaseUrl(String url) {
    Uri uri = Uri.parse(url);
    String baseUrl = '${uri.scheme}://${uri.host}:${uri.port}';
    return baseUrl;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Details'),
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchPatientData(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading indicator while waiting for data
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Display an error message if something went wrong
            return Center(child: Text('Failed to load patient data'));
          } else {
            // Display the patient data
            final patient = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('UUID: ${patient['UUID']}'),
                  Text('Name: ${patient['Name']}'),
                  Text('Age: ${patient['Age']}'),
                  Text('Gender: ${patient['Gender']}'),
                  Text('Comments: ${patient['comments']}'),
                  SizedBox(height: 16),
                  Text('X-ray Image:'),
                  Image.network(patient['xrayUrl']),

                ],
              ),
            );
          }
        },
      ),
    );
  }
}
