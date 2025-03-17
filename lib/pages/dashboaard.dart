import 'package:costtracker/widgets/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
        backgroundColor: FColors.primaryNavy,
        foregroundColor: FColors.pureWhite,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hello, User!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: FColors.primaryNavy,
              ),
            ),
            SizedBox(height: 5),
            Text(
              "Here is your financial summary",
              style: TextStyle(fontSize: 16, color: FColors.darkGrey),
            ),
            SizedBox(height: 20),
            _buildSummarySection(),
            SizedBox(height: 20),
            _buildGraphSection(),
            SizedBox(height: 20),
            _buildQuickActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildSummarySection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildSummaryCard(
          "Income",
          "\$5,000",
          FColors.secondary,
          Icons.arrow_upward,
        ),
        _buildSummaryCard(
          "Expenses",
          "\$3,200",
          FColors.secondaryRed,
          Icons.arrow_downward,
        ),
        _buildSummaryCard(
          "Budget",
          "\$1,800",
          FColors.primaryOrange,
          Icons.account_balance_wallet,
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
    String title,
    String amount,
    Color color,
    IconData icon,
  ) {
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: color,
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(icon, color: FColors.pureWhite, size: 30),
              SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: FColors.pureWhite,
                ),
              ),
              SizedBox(height: 5),
              Text(
                amount,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: FColors.pureWhite,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGraphSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Spending Trends",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: FColors.dark,
          ),
        ),
        SizedBox(height: 10),
        Container(
          height: 200,
          decoration: BoxDecoration(
            color: FColors.offBlue,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.all(16),
          child: LineChart(
            LineChartData(
              gridData: FlGridData(show: false),
              titlesData: FlTitlesData(show: false),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: [
                    FlSpot(0, 2),
                    FlSpot(1, 3),
                    FlSpot(2, 5),
                    FlSpot(3, 4),
                    FlSpot(4, 6),
                  ],
                  isCurved: true,
                  color: FColors.primary,
                  dotData: FlDotData(show: false),
                  belowBarData: BarAreaData(show: true, color: FColors.primary),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionButton(Icons.add, "Add Income", FColors.secondary),
        _buildActionButton(Icons.remove, "Add Expense", FColors.secondaryRed),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, String label, Color color) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: Icon(icon, color: FColors.pureWhite),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: FColors.pureWhite,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 3,
      ),
    );
  }
}
