import 'package:flutter/material.dart';
import 'package:utspam_c3_5b_0703/front_page.dart';
import 'model/Users.dart';
import 'model/Cars.dart';
import 'db/cars_dao.dart';
import 'rent_page.dart';
import 'db/renthistory_dao.dart';
import 'package:intl/intl.dart';

class DashboardPage extends StatefulWidget {
  final Users user;
  const DashboardPage({super.key, required this.user});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 1;
  final CarsDao _carsDao = CarsDao();
  final RentHistoryDao _rentHistoryDao = RentHistoryDao();
  final PageController _pageController = PageController(initialPage: 1000);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  TableRow _buildTableRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            value,
            style: TextStyle(fontSize: 16, color: Colors.blueGrey.shade700),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgetOptions = <Widget>[
      // Profile Page (Index 0)
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Account Information",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Table(
              border: TableBorder.all(color: Colors.grey),
              columnWidths: const {
                0: IntrinsicColumnWidth(),
                1: FlexColumnWidth(),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                _buildTableRow("Name", widget.user.name),
                _buildTableRow("Username", widget.user.username),
                _buildTableRow("NIK", widget.user.nik),
                _buildTableRow("Email", widget.user.email),
                _buildTableRow("Phone", widget.user.phone),
                _buildTableRow("Address", widget.user.address),
              ],
            ),
          ],
        ),
      ),
      // Explore Page (Index 1)
      FutureBuilder<List<Cars>>(
        future: _carsDao.getAllCars(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No cars available"));
          }

          final cars = snapshot.data!.where((c) => c.isAvailable).toList();

          if (cars.isEmpty) {
            return const Center(child: Text("No cars to display"));
          }

          return Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                itemBuilder: (context, index) {
                  final car = cars[index % cars.length];
                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 15.0,
                      vertical: 25,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      image: DecorationImage(
                        image: AssetImage(car.carImagePath),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          bottom: 20,
                          left: 20,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                car.carName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(blurRadius: 10, color: Colors.black),
                                  ],
                                ),
                              ),
                              Text(
                                car.carType,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  shadows: [
                                    Shadow(blurRadius: 10, color: Colors.black),
                                  ],
                                ),
                              ),
                              Text(
                                "Rp ${car.carPricePerDay}/day",
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
                        Positioned(
                          bottom: 20,
                          right: 20,
                          child: FloatingActionButton.extended(
                            backgroundColor: Colors.white,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      RentPage(car: car, user: widget.user),
                                ),
                              );
                            },
                            label: Text(
                              "Rent",
                              style: TextStyle(color: Colors.blueGrey.shade700),
                            ),
                            icon: Icon(
                              Icons.car_rental,
                              color: Colors.blueGrey.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              Positioned(
                left: 5,
                top: 0,
                bottom: 0,
                child: Center(
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      size: 30,
                      color: Colors.white,
                      shadows: [
                        Shadow(blurRadius: 20, color: Colors.black),
                        Shadow(blurRadius: 20, color: Colors.black),
                      ],
                    ),
                    onPressed: () {
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                right: 5,
                top: 0,
                bottom: 0,
                child: Center(
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_forward_ios,
                      size: 30,
                      color: Colors.white,
                      shadows: [
                        Shadow(blurRadius: 20, color: Colors.black),
                        Shadow(blurRadius: 20, color: Colors.black),
                      ],
                    ),
                    onPressed: () {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
      // History Page (Index 2)
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Recent Transactions",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _rentHistoryDao.getRentHistoryWithCars(widget.user.id!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No rent history found"));
                  }

                  final history = snapshot.data!;

                  return ListView.builder(
                    itemCount: history.length,
                    itemBuilder: (context, index) {
                      final item = history[index];
                      final carName = item['carname'] as String;
                      final rentDateStr = item['rentdate'] as String;
                      final rentDuration = item['rentdurationdays'] as int;
                      final pricePerDayStr = item['carpriceperday'] as String;
                      final isRentActive = item['isRentActive'] as int;
                      final pricePerDay = double.tryParse(pricePerDayStr) ?? 0;
                      final totalPrice = pricePerDay * rentDuration;

                      final rentDate = DateFormat(
                        'yyyy-MM-dd',
                      ).parse(rentDateStr);
                      final endDate = rentDate.add(
                        Duration(days: rentDuration),
                      );
                      final now = DateTime.now();

                      String statusText;
                      Color statusColor;

                      if (isRentActive == 0) {
                        statusText = "Cancelled";
                        statusColor = Colors.red;
                      } else if (now.isAfter(endDate)) {
                        statusText = "Finished";
                        statusColor = Colors.green;
                      } else {
                        statusText = "Active";
                        statusColor = Colors.blue;
                      }

                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    carName,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: statusColor.withOpacity(0.1),
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
                              const SizedBox(height: 8),
                              Text("Date: $rentDateStr"),
                              const SizedBox(height: 4),
                              Text(
                                "Total Price: Rp ${totalPrice.toStringAsFixed(0)}",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.blueGrey.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Welcome, ${widget.user.name}!",
          style: TextStyle(fontSize: 24),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => FrontPage()),
              );
            },
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 32,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: 'Rent History',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueGrey.shade700,
        onTap: _onItemTapped,
      ),
    );
  }
}
