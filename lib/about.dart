import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to The House Coffee Shop'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
                child: Image.asset(
                  'assets/logo.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                'Welcome to The House Coffee Shop, your one-stop destination for the perfect blend of coffee and vaping essentials. Located in the heart of Teboulba, Monastir, our unique establishment caters to coffee enthusiasts and vape aficionados alike.\n\nAt The House Coffee Shop, we pride ourselves on offering an exceptional range of premium coffee products that are meticulously selected from renowned coffee bean farms across the globe. Our expert baristas craft each cup with precision and care, ensuring you experience the finest flavors and aromas that coffee has to offer.\n\nBut that\'s not all—we go beyond just coffee. As a vape store, we provide a comprehensive selection of vaping products, catering to both wholesale and retail customers. Whether you\'re a vaping enthusiast or a newcomer exploring this dynamic world, our diverse range of vaping devices, e-liquids, and accessories will cater to your every need.\n\nOur commitment to customer satisfaction extends beyond the walls of our coffee shop and vape store. We offer convenient shipping options for those who prefer to enjoy our products from the comfort of their own homes. So, even if you can\'t visit us in person, you can still indulge in the delightful experience we have to offer.\n\nWe value the feedback and inquiries of our customers, and we\'re always here to assist you. Should you have any questions or require further information, please don\'t hesitate to reach out to us at 99275439. Our dedicated team is ready to provide you with prompt and friendly assistance.\n\nJoin us at The House Coffee Shop, where coffee and vaping come together in harmony. Experience the perfect balance of flavors and explore a world of caffeinated bliss and vaping delights. We look forward to serving you and creating unforgettable moments with every sip and vape.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.3,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(35.4853, 10.8890),
                  zoom: 16.0,
                ),
                markers: Set<Marker>.from([
                  Marker(
                    markerId: MarkerId('The House Coffee Shop'),
                    position: LatLng(35.4853, 10.8890),
                    infoWindow: InfoWindow(
                      title: 'The House Coffee Shop',
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}