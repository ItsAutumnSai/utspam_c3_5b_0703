import 'package:flutter/material.dart';
import 'package:utspam_c3_5b_0703/front_page.dart';
import 'model/Users.dart';

class DashboardPage extends StatefulWidget {
  final Users user;

  const DashboardPage({super.key, required this.user});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

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
      Center(),
      // History Page (Index 2)
      Center(),
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
