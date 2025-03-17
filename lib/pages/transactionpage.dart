import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:tesseract_ocr/tesseract_ocr.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  AddTransactionScreenState createState() => AddTransactionScreenState();
}

class AddTransactionScreenState extends State<AddTransactionScreen> {
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();

  String _transactionType = 'Expense';
  String _category = 'Food';
  String _receiptPath = '';
  bool _isRecurring = false;
  String _recurringFrequency = 'Monthly';

  // Categories
  final List<String> _categories = [
    'Food',
    'Transport',
    'Bills',
    'Entertainment',
    'Shopping',
    'Health',
    'Other',
  ];

  // Recurring Frequencies
  final List<String> _frequencies = ['Daily', 'Weekly', 'Monthly', 'Custom'];

  // Image Picker instance
  final ImagePicker _picker = ImagePicker();

  // Method to pick receipt image
  Future<void> _pickReceipt() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _receiptPath = pickedFile.path;
      });

      // Call OCR to extract text from the image (Optional)
      //String extractedText = await TesseractOcr.extractText(_receiptPath);
    }
  }

  // Method to handle Save action
  void _saveTransaction() {
    if (_amountController.text.isEmpty) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Transaction')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Transaction Type Toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Radio<String>(
                    value: 'Expense',
                    groupValue: _transactionType,
                    onChanged: (value) {
                      setState(() {
                        _transactionType = value!;
                      });
                    },
                  ),
                  Text('Expense'),
                  Radio<String>(
                    value: 'Income',
                    groupValue: _transactionType,
                    onChanged: (value) {
                      setState(() {
                        _transactionType = value!;
                      });
                    },
                  ),
                  Text('Income'),
                ],
              ),

              // Category Selection
              DropdownButton<String>(
                value: _category,
                onChanged: (String? newValue) {
                  setState(() {
                    _category = newValue!;
                  });
                },
                items:
                    _categories.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
              ),

              // Amount Entry
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Amount',
                  prefixText: '\$',
                ),
              ),

              // Receipt Upload (with OCR scanning)
              SizedBox(height: 16.0),
              GestureDetector(
                onTap: _pickReceipt,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.camera_alt, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'Attach Receipt',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              if (_receiptPath.isNotEmpty) ...[
                SizedBox(height: 10),
                Text('Receipt Selected: $_receiptPath'),
              ],

              // Recurring Transaction Toggle
              SwitchListTile(
                title: Text('Recurring Transaction'),
                value: _isRecurring,
                onChanged: (bool value) {
                  setState(() {
                    _isRecurring = value;
                  });
                },
              ),

              // Recurring Frequency Selection
              if (_isRecurring) ...[
                DropdownButton<String>(
                  value: _recurringFrequency,
                  onChanged: (String? newValue) {
                    setState(() {
                      _recurringFrequency = newValue!;
                    });
                  },
                  items:
                      _frequencies.map<DropdownMenuItem<String>>((
                        String value,
                      ) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                ),
              ],

              // Notes/Description
              TextField(
                controller: _notesController,
                decoration: InputDecoration(labelText: 'Notes (optional)'),
                maxLines: 3,
              ),

              // Save and Cancel Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Cancel action
                    },
                    child: Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: _saveTransaction,
                    child: Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
