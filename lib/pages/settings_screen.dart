import 'package:flutter/material.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contact Us",style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold,color: Colors.white),),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              "We’d love to hear from you!",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Email Card
            Card(
              color: Colors.blue.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.email, color: Colors.blue),
                title: const Text("Email"),
                subtitle: const Text("support@ShahzaibAhmad.com"),
                onTap: () {
                  // Later you can use url_launcher to open email
                },
              ),
            ),
            const SizedBox(height: 10),

            // Phone Card
            Card(
              color: Colors.blue.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.phone, color: Colors.blue),
                title: const Text("Phone"),
                subtitle: const Text("+92 307 4028172"),
                onTap: () {
                  // Later use url_launcher to dial
                },
              ),
            ),
            const SizedBox(height: 10),

            // Website Card
            Card(
              color: Colors.blue.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.web, color: Colors.blue),
                title: const Text("Website"),
                subtitle: const Text("www.waterintakego.com"),
                onTap: () {
                  // Open link with url_launcher
                },
              ),
            ),

            const SizedBox(height: 30),

            // Footer
            Center(
              child: Text(
                "© 2025 Water Intake Go\nDeveloped by Shahzaib Ahmad",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
