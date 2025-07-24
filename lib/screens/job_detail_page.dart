import 'package:flutter/material.dart';
import '../models/job_model.dart';

class JobDetailPage extends StatelessWidget {
  final Job job;

  const JobDetailPage({Key? key, required this.job}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(job.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Job title
            Text(
              job.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Company & Location
            Row(
              children: [
                const Icon(Icons.business, size: 18),
                const SizedBox(width: 6),
                Text(job.company, style: TextStyle(fontSize: 16)),
                const SizedBox(width: 16),
                const Icon(Icons.location_on, size: 18),
                const SizedBox(width: 6),
                Text(job.location, style: TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 20),

            // Job Type & Salary
            Row(
              children: [

                Text(
                  job.salary,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Job Description
            const Text(
              "Job Description",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              job.description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

            // Apply Button
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.send),
                label: const Text("Apply Now"),
                onPressed: () {
                  // Add your apply logic or open a link
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
