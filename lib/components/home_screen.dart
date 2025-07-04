import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'tweets_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        elevation: 4,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _welcomeSection(),
              SizedBox(height: 10),
              _schedule(),
              _engagementSection(context),
              _chartSection(),
              _viewTweetsByDateSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _viewTweetsByDateSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(
          "View Tweets by Date",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime(2100),
            );

            if (pickedDate != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      TweetsListScreen(selectedDate: pickedDate),
                ),
              );
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xFFCFDBE8)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Select Date",
                  style: TextStyle(
                    color: Color(0xFF4A739C),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Icon(LucideIcons.calendar, size: 20, color: Color(0xFF4A739C)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Padding _chartSection() {
    return Padding(
      padding: const EdgeInsets.only(top: 32), // already has global 24 padding
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Daily Insights",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            "+15%",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Last 7 Days +15%",
            style: TextStyle(
              fontSize: 14,
              color: Colors.green,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: SizedBox(
              height: 120,
              width: double.infinity,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          const days = [
                            'Mon',
                            'Tue',
                            'Wed',
                            'Thu',
                            'Fri',
                            'Sat',
                            'Sun',
                          ];
                          if (value.toInt() < 0 || value.toInt() > 6)
                            return Container();
                          return Text(
                            days[value.toInt()],
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      isCurved: true,
                      color: Colors.blueAccent,
                      barWidth: 2,
                      isStrokeCapRound: true,
                      belowBarData: BarAreaData(show: false),
                      dotData: FlDotData(show: false),
                      spots: [
                        FlSpot(0, 3),
                        FlSpot(1, 4),
                        FlSpot(2, 3.5),
                        FlSpot(3, 4.2),
                        FlSpot(4, 2),
                        FlSpot(5, 4.5),
                        FlSpot(6, 4),
                      ],
                    ),
                  ],
                  minX: 0,
                  maxX: 6,
                  minY: 0,
                  maxY: 5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container _engagementSection(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Engagement Stats",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          SizedBox(height: 15),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.40,
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Color(0xFFCFDBE8)),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      "Likes\n120",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.40,
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Color(0xFFCFDBE8)),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      "Retweets\n85",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Color(0xFFCFDBE8)),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  "Comments\n42",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Column _schedule() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Scheduled Tweets",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 15),
        _scheduledTweetCard("Just posted a new blog post about", "10:00"),
        _scheduledTweetCard("Engaging with your audience is key", "12:00"),
        _scheduledTweetCard("Did you know that video content gets", "2:00"),
      ],
    );
  }

  Container _scheduledTweetCard(String label, String time) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      width: double.infinity,
      child: Row(
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: Color(0xFFE8EDF5),
              borderRadius: BorderRadius.circular(7.5),
            ),
            child: Center(child: Icon(LucideIcons.twitter)),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                ),
                Text(time, style: TextStyle(color: Color(0xFF4A739C))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  SizedBox _welcomeSection() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Welcome back, Alex",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Today",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Text("2/3 Tweets Posted"),
                  Text("Next tweet at 10:00 AM"),
                ],
              ),
              Image.asset(
                "assets/images/android_logo12.png",
                height: 100,
                width: 100,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
