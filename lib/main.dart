import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:blur/blur.dart';

void main() {
  runApp(SpeedTestApp());
}

class SpeedTestApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SpeedTestScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SpeedTestScreen extends StatefulWidget {
  @override
  _SpeedTestScreenState createState() => _SpeedTestScreenState();
}

class _SpeedTestScreenState extends State<SpeedTestScreen> {
  double downloadSpeed = 0.0;
  double uploadSpeed = 0.0;
  int ping = 0;
  int jitter = 0;
  bool isTesting = false;
  bool showGraph = false;

  List<FlSpot> downloadData = [];
  List<FlSpot> uploadData = [];

  // Function to simulate test results
  Future<void> startSpeedTest() async {
    setState(() {
      isTesting = true;
      showGraph = false;
      downloadData = [];
      uploadData = [];
      downloadSpeed = 0.0;
      uploadSpeed = 0.0;
      ping = 0;
      jitter = 0;
    });

    await Future.delayed(Duration(seconds: 1), () {
      setState(() {
        ping = 4;
        jitter = 1;
        downloadSpeed = 275.2;
        uploadSpeed = 298.9;

        // Populate graph data
        for (int i = 0; i <= 10; i++) {
          downloadData.add(FlSpot(i.toDouble(), (i * 25).toDouble()));
          uploadData.add(FlSpot(i.toDouble(), (i * 22).toDouble()));
        }
      });
    });

    setState(() {
      isTesting = false;
      showGraph = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 231, 231),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(0, 8, 153, 141),
        elevation: 0,
        title: Text(
          'Internet Speed Test',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            showGraph ? buildGraph() : buildGlassGauge(),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildGlassMetricCard('Ping', '$ping ms'),
                SizedBox(width: 20),
                buildGlassMetricCard('Jitter', '$jitter ms'),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildGlassSpeedCard('Download', downloadSpeed),
                SizedBox(width: 20),
                buildGlassSpeedCard('Upload', uploadSpeed),
              ],
            ),
            SizedBox(height: 40),
            buildGlassStartButton(),
          ],
        ),
      ),
    );
  }

  Widget buildGlassGauge() {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(60),
        boxShadow: [
          BoxShadow(
              color: const Color.fromARGB(146, 101, 236, 119), blurRadius: 10)
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Blur(
              blur: 1,
              colorOpacity: 0.2,
              child: Container(
                color: Colors.white.withOpacity(0.05),
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              child: SfRadialGauge(
                axes: <RadialAxis>[
                  RadialAxis(
                    minimum: 0,
                    maximum: 500,
                    ranges: <GaugeRange>[
                      GaugeRange(
                          startValue: 0,
                          endValue: 100,
                          color: Colors.greenAccent),
                      GaugeRange(
                          startValue: 100,
                          endValue: 300,
                          color: Colors.orangeAccent),
                      GaugeRange(
                          startValue: 300,
                          endValue: 500,
                          color: Colors.redAccent),
                    ],
                    pointers: <GaugePointer>[
                      NeedlePointer(value: downloadSpeed),
                    ],
                    annotations: <GaugeAnnotation>[
                      GaugeAnnotation(
                        widget: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${downloadSpeed.toStringAsFixed(1)}',
                              style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Text('Mbps',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white)),
                          ],
                        ),
                        angle: 90,
                        positionFactor: 0.75,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildGraph() {
    return Container(
      height: 250,
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.blue.withOpacity(0.5), blurRadius: 20)
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Analytics',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(height: 10),
            ],
          ),
          LineChart(
            LineChartData(
              gridData: FlGridData(show: false),
              titlesData: FlTitlesData(show: false),
              borderData: FlBorderData(show: false),
              minX: 0,
              maxX: 10,
              minY: 0,
              maxY: 500,
              lineBarsData: [
                LineChartBarData(
                  spots: downloadData,
                  isCurved: true,
                  gradient:
                      LinearGradient(colors: [Colors.cyanAccent, Colors.blue]),
                  barWidth: 3,
                ),
                LineChartBarData(
                  spots: uploadData,
                  isCurved: true,
                  gradient: LinearGradient(
                      colors: [Colors.yellowAccent, Colors.orange]),
                  barWidth: 3,
                ),
              ],
            ),
          ),
          ...downloadData.map((spot) {
            return Positioned(
              left: spot.x * (MediaQuery.of(context).size.width / 10) - 20,
              bottom: spot.y / 500 * 250 + 20, // Adjust to position the text
              child: Text(
                '${spot.y.toStringAsFixed(1)} Mbps',
                style: TextStyle(color: Colors.cyanAccent, fontSize: 10),
              ),
            );
          }).toList(),
          ...uploadData.map((spot) {
            return Positioned(
              left: spot.x * (MediaQuery.of(context).size.width / 10) - 20,
              bottom: spot.y / 500 * 250 + 20, // Adjust to position the text
              child: Text(
                '${spot.y.toStringAsFixed(1)} Mbps',
                style: TextStyle(color: Colors.yellowAccent, fontSize: 10),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget buildGlassMetricCard(String title, String value) {
    return Container(
      width: 90,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
              color: const Color.fromARGB(160, 1, 192, 206), blurRadius: 10)
        ],
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, style: TextStyle(fontSize: 16, color: Colors.white)),
          SizedBox(height: 5),
          Text(value,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
        ],
      ),
    );
  }

  Widget buildGlassSpeedCard(String title, double speed) {
    return Container(
      width: 140,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
              color: const Color.fromARGB(220, 236, 232, 5), blurRadius: 15)
        ],
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, style: TextStyle(fontSize: 16, color: Colors.white)),
          SizedBox(height: 5),
          Text('${speed.toStringAsFixed(1)} Mbps',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
        ],
      ),
    );
  }

  Widget buildGlassStartButton() {
    return ElevatedButton(
      onPressed: isTesting ? null : startSpeedTest,
      child: Text(isTesting ? 'Testing...' : 'Start Test'),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: Colors.cyanAccent,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }
}
