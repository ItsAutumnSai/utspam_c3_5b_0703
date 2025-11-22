import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:utspam_c3_5b_0703/model/Users.dart';

class RentDetailPage extends StatefulWidget {
  final Map<String, dynamic> rentData;
  final Users user;

  const RentDetailPage({super.key, required this.rentData, required this.user});

  @override
  State<RentDetailPage> createState() => _RentDetailPageState();
}

class _RentDetailPageState extends State<RentDetailPage> {
  late int _rentDuration;
  late double _totalPrice;
  late int _isRentActive;

  @override
  void initState() {
    super.initState();
    _rentDuration = widget.rentData['rentdurationdays'] as int;
    _isRentActive = widget.rentData['isRentActive'] as int;
    _calculateTotalPrice();
  }

  void _calculateTotalPrice() {
    final pricePerDay =
        double.tryParse(widget.rentData['carpriceperday'].toString()) ?? 0;
    _totalPrice = pricePerDay * _rentDuration;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final carName = widget.rentData['carname'] as String;
    final carType = widget.rentData['cartype'] ?? 'Unknown';
    final carImagePath = widget.rentData['carimagepath'];
    final rentDateStr = widget.rentData['rentdate'] as String;

    final rentDate = DateFormat('yyyy-MM-dd').parse(rentDateStr);
    final endDate = rentDate.add(Duration(days: _rentDuration));
    final now = DateTime.now();

    String statusText;
    Color statusColor;

    if (_isRentActive == 0) {
      statusText = "Cancelled";
      statusColor = Colors.red.shade800;
    } else if (now.isBefore(rentDate)) {
      statusText = "Inactive yet";
      statusColor = Colors.blueGrey;
    } else if (now.isAfter(endDate)) {
      statusText = "Finished";
      statusColor = Colors.blueGrey;
    } else {
      statusText = "Active";
      statusColor = Colors.lightGreen;
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Rent Details")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: screenWidth / 2,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  image: DecorationImage(
                    image: AssetImage(carImagePath),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 10,
                      left: 10,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            carName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(blurRadius: 10, color: Colors.black),
                              ],
                            ),
                          ),
                          Text(
                            carType,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              shadows: [
                                Shadow(blurRadius: 10, color: Colors.black),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),

              const Text(
                "Rent Information",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              _buildInfoRow(
                "Price per Day",
                "Rp ${widget.rentData['carpriceperday']}",
              ),
              _buildInfoRow("Start Date", rentDateStr),
              _buildInfoRow(
                "End Date",
                DateFormat('yyyy-MM-dd').format(endDate),
              ),
              _buildInfoRow("Duration", "$_rentDuration Days"),
              _buildInfoRow(
                "Total Price",
                "Rp ${_totalPrice.toStringAsFixed(0)}",
              ),

              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Status",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withAlpha(30),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: statusColor),
                    ),
                    child: Text(
                      statusText,
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(height: 30),

              const Text(
                "Renter Information",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              _buildInfoRow("Name", widget.user.name),
              _buildInfoRow("Phone", widget.user.phone),
              _buildInfoRow("Email", widget.user.email),

              const SizedBox(height: 30),

              if (_isRentActive == 1 &&
                  !now.isAfter(endDate)) // Only show if active and not finished
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: const Text("Cancel Rent"),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey.shade700,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: const Text("Edit Duration"),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16, color: Colors.grey)),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
