import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class BudgetReportsScreen extends StatefulWidget {
  const BudgetReportsScreen({super.key});

  @override
  BudgetReportsScreenState createState() => BudgetReportsScreenState();
}

class BudgetReportsScreenState extends State<BudgetReportsScreen> {
  double monthlyBudget = 1000.0;
  double currentSpending = 750.0; // Example current spending
  double previousMonthSpending = 800.0; // Example previous month spending
  double foodSpending = 300.0;
  double entertainmentSpending = 200.0;
  double utilitiesSpending = 250.0;

  @override
  Widget build(BuildContext context) {
    double budgetPercentage = (currentSpending / monthlyBudget) * 100;
    Color progressColor = Colors.green;
    if (budgetPercentage > 80) {
      progressColor = Colors.orange;
    }
    if (budgetPercentage > 95) {
      progressColor = Colors.red;
    }

    var data = [
      SpendingCategory('Food', foodSpending, Colors.blue),
      SpendingCategory('Entertainment', entertainmentSpending, Colors.green),
      SpendingCategory('Utilities', utilitiesSpending, Colors.orange),
      SpendingCategory(
        'Other',
        currentSpending -
            foodSpending -
            entertainmentSpending -
            utilitiesSpending,
        Colors.grey,
      ),
    ];

    var series = [
      charts.Series(
        id: 'Spending',
        domainFn: (SpendingCategory spending, _) => spending.category,
        measureFn: (SpendingCategory spending, _) => spending.amount,
        colorFn:
            (SpendingCategory spending, _) =>
                charts.ColorUtil.fromDartColor(spending.color),
        data: data,
        labelAccessorFn:
            (SpendingCategory row, _) => '${row.category}: \$${row.amount}',
      ),
    ];

    var barData = [
      SpendingMonth('Current Month', currentSpending, Colors.blue),
      SpendingMonth('Previous Month', previousMonthSpending, Colors.orange),
    ];

    var barSeries = [
      charts.Series(
        id: 'Monthly Spending',
        domainFn: (SpendingMonth month, _) => month.month,
        measureFn: (SpendingMonth month, _) => month.amount,
        colorFn:
            (SpendingMonth month, _) =>
                charts.ColorUtil.fromDartColor(month.color),
        data: barData,
        labelAccessorFn: (SpendingMonth row, _) => '\$${row.amount}',
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: Text('Budget & Reports')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Monthly Budget',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Row(
              children: <Widget>[
                Text('\$${monthlyBudget.toStringAsFixed(2)}'),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    _showBudgetDialog(context);
                  },
                  child: Text('Set Budget'),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Spending Progress',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            LinearProgressIndicator(
              value: budgetPercentage / 100,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
            ),
            SizedBox(height: 8),
            Text(
              '${budgetPercentage.toStringAsFixed(1)}% of budget used (\$${currentSpending.toStringAsFixed(2)} / \$${monthlyBudget.toStringAsFixed(2)})',
            ),
            SizedBox(height: 24),
            Text(
              'Spending Breakdown',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: charts.PieChart(
                series,
                animate: true,
                defaultRenderer: charts.ArcRendererConfig(
                  arcRendererDecorators: [charts.ArcLabelDecorator()],
                ),
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Monthly Spending Comparison',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: charts.BarChart(
                barSeries,
                animate: true,
                barRendererDecorator: charts.BarLabelDecorator<String>(),
                domainAxis: charts.OrdinalAxisSpec(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showBudgetDialog(BuildContext context) async {
    double newBudget = monthlyBudget;
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Set Monthly Budget'),
          content: TextField(
            keyboardType: TextInputType.number,
            onChanged: (value) {
              newBudget = double.tryParse(value) ?? monthlyBudget;
            },
            decoration: InputDecoration(hintText: 'Enter budget amount'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Set'),
              onPressed: () {
                setState(() {
                  monthlyBudget = newBudget;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class SpendingCategory {
  final String category;
  final double amount;
  final Color color;

  SpendingCategory(this.category, this.amount, this.color);
}

class SpendingMonth {
  final String month;
  final double amount;
  final Color color;

  SpendingMonth(this.month, this.amount, this.color);
}
