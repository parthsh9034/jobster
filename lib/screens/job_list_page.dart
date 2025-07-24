import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/job_model.dart';
import 'job_detail_page.dart';
import 'favorite_jobs_page.dart';

class JobListPage extends StatefulWidget {
  @override
  _JobListPageState createState() => _JobListPageState();
}

class _JobListPageState extends State<JobListPage> {
  List<Job> jobs = [];
  List<Job> filteredJobs = [];
  Set<int> favoriteIndices = {};
  int? tappedIndex;
  String selectedLocation = 'All';

  @override
  void initState() {
    super.initState();
    loadJobs();
  }

  Future<void> loadJobs() async {
    try {
      final String response = await DefaultAssetBundle.of(context).loadString('assets/data/dummy_data.json');
      final List<dynamic> data = json.decode(response);

      setState(() {
        jobs = data.map((json) => Job.fromJson(json)).toList();
        filteredJobs = jobs;
      });
    } catch (e) {
      print('Error loading jobs: $e');
    }
  }

  void toggleFavorite(int index) {
    setState(() {
      if (favoriteIndices.contains(index)) {
        favoriteIndices.remove(index);
      } else {
        favoriteIndices.add(index);
      }
    });
  }

  void filterJobsByLocation(String location) {
    setState(() {
      selectedLocation = location;
      filteredJobs = (location == 'All')
          ? jobs
          : jobs.where((job) => job.location == location).toList();
    });
  }

  void showFilterDialog() {
    final locations = ['All', ...{...jobs.map((j) => j.location)}];
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: locations.map((loc) {
            return ListTile(
              title: Text(loc),
              leading: selectedLocation == loc
                  ? const Icon(Icons.check_circle, color: Colors.blue)
                  : const Icon(Icons.circle_outlined),
              onTap: () {
                Navigator.pop(context);
                filterJobsByLocation(loc);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jobster'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: showFilterDialog,
          ),
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              final favoriteJobs = favoriteIndices.map((index) => jobs[index]).toList();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FavoriteJobsPage(favoriteJobs: favoriteJobs),
                ),
              );
            },
          ),
        ],
      ),
      body: filteredJobs.isEmpty
          ? const Center(child: Text('No jobs found for this filter.'))
          : ListView.builder(
        itemCount: filteredJobs.length,
        itemBuilder: (context, index) {
          final job = filteredJobs[index];
          final actualIndex = jobs.indexOf(job);
          final isFavorite = favoriteIndices.contains(actualIndex);
          final isTapped = tappedIndex == actualIndex;

          return InkWell(
            onTap: () {
              setState(() => tappedIndex = actualIndex);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => JobDetailPage(job: job),
                ),
              );
            },
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => toggleFavorite(actualIndex),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.grey,
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            job.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  offset: Offset(1.5, 1.5),
                                  blurRadius: 3.0,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.business, size: 16, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(
                                job.company,
                                style: const TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                              const SizedBox(width: 12),
                              const Icon(Icons.location_on, size: 16, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(
                                job.location,
                                style: const TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    AnimatedRotation(
                      turns: isTapped ? 0.25 : 0,
                      duration: const Duration(milliseconds: 400),
                      child: const Icon(Icons.arrow_forward_ios, size: 20, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
