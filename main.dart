import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(SafeWalkApp());

class SafeWalkApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
      title: 'Safe Walkers',
      theme: ThemeData(primarySwatch: Colors.teal),
      debugShowCheckedModeBanner: false,
      home: LoginPage());
}

// -------- LOGIN PAGE --------
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _locationEnabled = true;

  Future<void> _requestLocation() async {
    final permission = await Permission.location.request();
    if (permission.isGranted) {
      try {
        Position pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        setState(() => _locationEnabled = true);
        print('Location: ${pos.latitude}, ${pos.longitude}');
      } catch (_) {
        setState(() => _locationEnabled = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to get location')));
      }
    } else if (permission.isPermanentlyDenied) {
      await openAppSettings();
      setState(() => _locationEnabled = false);
    } else {
      setState(() => _locationEnabled = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location permission is required')),
      );
    }
  }

  void _login() {
    if (_nameController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        !_locationEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields and enable location')),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProfilePage(
          name: _nameController.text,
          phone: _phoneController.text,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _requestLocation();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Center(
              child: Text(
            "Safe Walk",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          )),
          backgroundColor: const Color.fromARGB(255, 60, 59, 59),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  "lib/images/HD-wallpaper-zebra-crossing-lights-patterns-symbols-thumbnail.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          // child: Center(child: FlutterLogo(size: 200)),
          //   Padding(
          padding: EdgeInsets.all(30),

          child: Column(
            children: [
              SizedBox(height: 40),
              Text(
                'Welcome to Safe Walk',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 250, 250, 250)),
              ),
              SizedBox(height: 30),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Your Name',
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  hintStyle: TextStyle(color: Colors.white),
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 4, color: Colors.white),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 4, color: Colors.white),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Row(
                children: [
                  Icon(
                    _locationEnabled ? Icons.check_circle : Icons.location_off,
                    color: _locationEnabled ? Colors.green : Colors.red,
                  ),
                  SizedBox(width: 10),
                  Text(
                    _locationEnabled ? 'Location Enabled' : 'Location Disabled',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Spacer(),
              ElevatedButton(
                onPressed: _login,
                child: Text('Login'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  backgroundColor: const Color.fromARGB(255, 104, 219, 208),
                  textStyle: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}

// -------- PROFILE PAGE --------
class ProfilePage extends StatelessWidget {
  final String name;
  final String phone;
  ProfilePage({required this.name, required this.phone});

  @override
  Widget build(BuildContext context) => Scaffold(
        // appBar: AppBar(title: Text('Profile')),
        appBar: AppBar(
          title: Center(
              child: Text(
            "Profile",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          )),
          backgroundColor: const Color.fromARGB(255, 60, 59, 59),
        ),
        body: Container(
          // Padding(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  "lib/images/HD-wallpaper-zebra-crossing-lights-patterns-symbols-thumbnail.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome, $name',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(height: 10),
              Text('Phone: $phone',
                  style: TextStyle(fontSize: 18, color: Colors.white)),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => SafeWalkingRoutesPage()),
                ),
                child: Text('Safe Walking Routes'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  textStyle:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => NearbySkywalkersPage()),
                ),
                child: Text('Nearby Skywalkers'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  textStyle:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EmergencyCellPage(name: name, phone: phone),
                  ),
                ),
                child: Text('Emergency Cell'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  textStyle:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      );
}

// -------- SAFE WALKING ROUTES PAGE --------
class SafeWalkingRoutesPage extends StatefulWidget {
  @override
  _SafeWalkingRoutesPageState createState() => _SafeWalkingRoutesPageState();
}

class _SafeWalkingRoutesPageState extends State<SafeWalkingRoutesPage> {
  final _startController = TextEditingController();
  final _destController = TextEditingController();

  void _showRoute() {
    final start = _startController.text.trim();
    final dest = _destController.text.trim();
    if (start.isEmpty || dest.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter start and destination')),
      );
      return;
    }
    final url = Uri.encodeFull(
      'https://www.google.com/maps/dir/?api=1&origin=$start&destination=$dest&travelmode=walking',
    );
    launchUrl(Uri.parse(url));
  }

  @override
  void dispose() {
    _startController.dispose();
    _destController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        // appBar: AppBar(title: Text('Safe Walking Routes')),
        appBar: AppBar(
          title: Center(
              child: Text(
            "Safe Walking Routes",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          )),
          backgroundColor: const Color.fromARGB(255, 60, 59, 59),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  "lib/images/HD-wallpaper-zebra-crossing-lights-patterns-symbols-thumbnail.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          padding: EdgeInsets.all(30),
          child: Column(
            children: [
              TextField(
                controller: _startController,
                decoration: InputDecoration(
                  // labelText: 'Start Point',
                  // border: OutlineInputBorder(),
                  labelText: 'Start Point',
                  labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 4, color: Colors.white),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _destController,
                decoration: InputDecoration(
                  // labelText: 'Destination',
                  // border: OutlineInputBorder(),
                  labelText: 'Destination',
                  labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 4, color: Colors.white),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
              Spacer(),
              ElevatedButton(
                onPressed: _showRoute,
                child: Text('Show Route'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      );
}

// -------- NEARBY SKYWALKERS PAGE --------
// -------- NEARBY SKYWALKERS PAGE WITH DESTINATION LABEL --------
class NearbySkywalkersPage extends StatelessWidget {
  final String destination = "Guttahalli Bus Stop";

  final List<Map<String, dynamic>> skywalkers = [
    {"name": "guttahali bus stop", "distance": "50m"},
    {"name": "Palace Ground", "distance": "550m"},
    {"name": "Mekhri Circle", "distance": "1,5km"},
    {"name": "Hebbal", "distance": "2km"},
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
        // appBar: AppBar(title: Text('Nearby Skywalkers')),
        appBar: AppBar(
          title: Center(
              child: Text(
            "Nearby Skywalkers",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          )),
          backgroundColor: const Color.fromARGB(255, 60, 59, 59),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  "lib/images/HD-wallpaper-zebra-crossing-lights-patterns-symbols-thumbnail.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Destination Info
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.teal.shade50,
                  border: Border.all(color: Colors.teal),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(Icons.location_pin, color: Colors.teal),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Your Destination: $destination',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromARGB(255, 6, 173, 145),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              // List of Skywalkers
              Expanded(
                child: ListView.separated(
                  itemCount: skywalkers.length,
                  separatorBuilder: (_, __) => Divider(),
                  itemBuilder: (context, index) {
                    final skywalker = skywalkers[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.teal,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      title: Text(
                        skywalker['name'],
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ),
                      subtitle: Text(
                        'Distance: ${skywalker['distance']}',
                      ),
                      textColor: Colors.white,
                      trailing: Icon(Icons.chat, color: Colors.teal),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
}

// -------- EMERGENCY CELL PAGE WITH SOS --------
class EmergencyCellPage extends StatefulWidget {
  final String name;
  final String phone;

  EmergencyCellPage({required this.name, required this.phone});

  @override
  _EmergencyCellPageState createState() => _EmergencyCellPageState();
}

class _EmergencyCellPageState extends State<EmergencyCellPage> {
  final _contact1Controller = TextEditingController();
  final _contact2Controller = TextEditingController();

  final String policeNumber = '100';
  final String ambulanceNumber = '102';
  String _location = 'Getting location...';

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    final permission = await Permission.location.request();
    if (permission.isGranted) {
      Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(
        () => _location =
            'https://maps.google.com/?q=${pos.latitude},${pos.longitude}',
      );
    } else {
      setState(() => _location = 'Location permission denied');
    }
  }

  Future<void> _sendSOS() async {
    final contacts = [
      _contact1Controller.text.trim(),
      _contact2Controller.text.trim(),
      policeNumber,
      ambulanceNumber,
    ];

    final message = Uri.encodeComponent(
      "🚨 SOS Alert from ${widget.name} (${widget.phone})\nLocation: $_location",
    );

    bool atLeastOneSent = false;

    for (var number in contacts) {
      if (number.isNotEmpty) {
        final Uri smsUri = Uri.parse('sms:$number?body=$message');
        if (await canLaunchUrl(smsUri)) {
          await launchUrl(smsUri);
          atLeastOneSent = true;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not open SMS for $number')),
          );
        }
      }
    }

    if (atLeastOneSent) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '✅ SOS alert sent to emergency contacts.',
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _callEmergencyNumber(String number) async {
    final Uri telUri = Uri.parse('tel:$number');
    if (await canLaunchUrl(telUri)) {
      await launchUrl(telUri);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not call $number')));
    }
  }

  @override
  void dispose() {
    _contact1Controller.dispose();
    _contact2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        // appBar: AppBar(title: Text('Emergency Cell')),
        appBar: AppBar(
          title: Center(
              child: Text(
            "Emergency Cell",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          )),
          backgroundColor: const Color.fromARGB(255, 60, 59, 59),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  "lib/images/HD-wallpaper-zebra-crossing-lights-patterns-symbols-thumbnail.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          padding: EdgeInsets.all(30),
          child: Column(
            children: [
              TextField(
                controller: _contact1Controller,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  // labelText: 'Emergency Contact 1',
                  // border: OutlineInputBorder(),
                  labelText: 'Emergency Contact 1',
                  labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 4, color: Colors.white),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: _contact2Controller,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  // labelText: 'Emergency Contact 2',
                  // border: OutlineInputBorder(),
                  labelText: 'Emergency Contact 2',
                  labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 4, color: Colors.white),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Location:\n$_location',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16,
                    color: const Color.fromARGB(255, 252, 252, 252)),
              ),
              SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: _sendSOS,
                icon: Icon(Icons.warning),
                label: Text('SEND SOS to All'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: Size(double.infinity, 50),
                  textStyle:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _callEmergencyNumber(policeNumber),
                      icon: Icon(Icons.local_police),
                      label: Text('Call Police'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        minimumSize: Size(double.infinity, 50),
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _callEmergencyNumber(ambulanceNumber),
                      icon: Icon(Icons.local_hospital),
                      label: Text('Call Ambulance'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        minimumSize: Size(double.infinity, 50),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}
