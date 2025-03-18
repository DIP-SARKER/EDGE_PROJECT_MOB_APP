import 'package:flutter/material.dart';

class BudgetReportsScreen extends StatefulWidget {
  const BudgetReportsScreen({super.key});

  @override
  BudgetReportsScreenState createState() => BudgetReportsScreenState();
}

class BudgetReportsScreenState extends State<BudgetReportsScreen> {
  double monthlyBudget = 1000.0;
  double currentSpending = 750.0;
  double previousMonthSpending = 800.0;
  double foodSpending = 300.0;
  double entertainmentSpending = 200.0;
  double utilitiesSpending = 250.0;

  @override
  Widget build(BuildContext context) {
    double budgetPercentage = (currentSpending / monthlyBudget) * 100;
    Color progressColor =
        budgetPercentage > 95
            ? Colors.red
            : (budgetPercentage > 80 ? Colors.orange : Colors.green);

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
            _buildSpendingBreakdown(),
            SizedBox(height: 24),
            Text(
              'Monthly Spending Comparison',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            _buildMonthlyComparison(),
          ],
        ),
      ),
    );
  }

  Widget _buildSpendingBreakdown() {
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

    return Column(
      children:
          data.map((category) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: [
                  Container(width: 20, height: 20, color: category.color),
                  SizedBox(width: 8),
                  Text(
                    '${category.category}: \$${category.amount.toStringAsFixed(2)}',
                  ),
                ],
              ),
            );
          }).toList(),
    );
  }

  Widget _buildMonthlyComparison() {
    return Column(
      children: [
        _buildBar('Current Month', currentSpending, Colors.blue),
        _buildBar('Previous Month', previousMonthSpending, Colors.orange),
      ],
    );
  }

  Widget _buildBar(String label, double value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 4),
        Container(
          width: double.infinity,
          height: 20,
          color: Colors.grey[300],
          child: FractionallySizedBox(
            widthFactor: value / monthlyBudget,
            alignment: Alignment.centerLeft,
            child: Container(color: color),
          ),
        ),
        SizedBox(height: 8),
      ],
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
