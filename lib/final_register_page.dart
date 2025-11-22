import 'package:flutter/material.dart';
import 'db/users_dao.dart';
import 'login_page.dart';

class FinalRegisterPage extends StatefulWidget {
  final String name;
  final String nik;
  final String email;
  final String phone;
  final String address;

  const FinalRegisterPage({
    super.key,
    required this.name,
    required this.nik,
    required this.email,
    required this.phone,
    required this.address,
  });

  @override
  State<FinalRegisterPage> createState() => _FinalRegisterPageState();
}

class _FinalRegisterPageState extends State<FinalRegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final UsersDao _usersDao = UsersDao();

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      final username = _usernameController.text;
      final password = _passwordController.text;

      // Check if user exists
      final existingUser = await _usersDao.getUserByUsername(username);
      if (existingUser != null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('User already exists with the same username'),
            ),
          );
        }
        return;
      }

      // Register user
      await _usersDao.registerUser(
        username: username,
        password: password,
        name: widget.name,
        nik: widget.nik,
        email: widget.email,
        phone: widget.phone,
        address: widget.address,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Register success, now please login')),
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
          (route) => route.isFirst,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(title: Text("One last thing")),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Create your account", style: TextStyle(fontSize: 30)),
                SizedBox(height: screenHeight * 0.02),
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your username.';
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your password.";
                    } else if (value.length < 8) {
                      return "Please enter a minimum of 8 characters.";
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                SizedBox(height: screenHeight * 0.05),
                SizedBox(
                  width: screenWidth,
                  child: ElevatedButton(
                    onPressed: _register,
                    child: Text(
                      "Register",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
