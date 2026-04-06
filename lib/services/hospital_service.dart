import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/hospital.dart';

class HospitalService {
  static Future<List<Hospital>> getHospitalsByPincode(String pincode) async {
    try {
      // 1. Geocode Pincode using Nominatim API
      final geoUrl = Uri.parse('https://nominatim.openstreetmap.org/search?postalcode=$pincode&country=india&format=json');
      final geoResponse = await http.get(geoUrl, headers: {'User-Agent': 'GramCareApp/1.0'});
      
      if (geoResponse.statusCode == 200) {
        final geoData = jsonDecode(geoResponse.body) as List;
        if (geoData.isNotEmpty) {
          final lat = double.parse(geoData[0]['lat']);
          final lon = double.parse(geoData[0]['lon']);
          
          // 2. Query Overpass API for Hospitals within 5km radius
          final overpassQuery = '[out:json];node(around:5000,$lat,$lon)["amenity"~"hospital|clinic"];out;';
          final overUrl = Uri.parse('https://overpass-api.de/api/interpreter');
          final overResponse = await http.post(overUrl, body: {'data': overpassQuery});
          
          if (overResponse.statusCode == 200) {
            final overData = jsonDecode(overResponse.body);
            final elements = overData['elements'] as List;
            
            List<Hospital> hospitals = [];
            for (var el in elements) {
              if (el['tags'] != null && el['tags']['name'] != null) {
                hospitals.add(
                  Hospital(
                    name: el['tags']['name'],
                    address: el['tags']['addr:full'] ?? el['tags']['addr:street'] ?? 'Local vicinity, $pincode',
                    phone: el['tags']['phone'] ?? '104 (General)',
                    lat: el['lat'],
                    lon: el['lon'],
                  ),
                );
              }
            }
            // Return populated list if found
            if (hospitals.isNotEmpty) return hospitals;
          }
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
