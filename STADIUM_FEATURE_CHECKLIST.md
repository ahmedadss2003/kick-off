# 🏟️ STADIUM FEATURE - QUICK START CHECKLIST

## Before You Run the App

- [ ] Update API URL in `lib/features/stadiums/data/datasources/stadium_remote_data_source.dart`
  ```dart
  final String baseUrl = "https://your-api.com"; // Change this
  ```

- [ ] Update endpoint path if needed (currently `/stadiums`)
  ```dart
  final response = await dio.get('$baseUrl/stadiums'); // Update if needed
  ```

- [ ] Run `flutter pub get` to install dependencies

- [ ] Hot restart your app: `flutter run`

## Testing the Feature

### Step 1: Add Navigation Button
Add this somewhere in your app (e.g., in home screen):

```dart
ElevatedButton(
  onPressed: () {
    Navigator.pushNamed(context, Routes.stadiums);
  },
  child: const Text('View Stadiums'),
)
```

### Step 2: Import Routes
```dart
import 'package:kickoff/core/routes_manager/routes.dart';
```

### Step 3: Test the Navigation
Click the button and you should see:
1. Loading state with skeleton cards
2. Stadium list when data loads
3. Pull-to-refresh functionality
4. Bottom sheet when tapping a card

## Feature Checklist

### Data Layer ✅
- [x] Stadium models created
- [x] API data source implemented
- [x] Repository pattern applied
- [x] JSON serialization/deserialization

### Business Logic Layer ✅
- [x] BLoC created
- [x] Events defined
- [x] States defined
- [x] Error handling

### Presentation Layer ✅
- [x] Main screen UI
- [x] Stadium card widget
- [x] Loading state widget
- [x] Empty state widget
- [x] Bottom sheet for details
- [x] Error state with retry

### Navigation ✅
- [x] Route added to routes.dart
- [x] Route generator updated
- [x] BLoC provider integrated

### Dependencies ✅
- [x] equatable added to pubspec.yaml
- [x] flutter_bloc (already present)
- [x] dio (already present)

## File Locations Quick Reference

```
✅ Models:       lib/features/stadiums/data/models/stadium_model.dart
✅ API Service:  lib/features/stadiums/data/datasources/stadium_remote_data_source.dart
✅ Repository:   lib/features/stadiums/data/repositories/stadium_repository.dart
✅ BLoC:         lib/features/stadiums/presentation/bloc/stadium_bloc.dart
✅ UI Screen:    lib/features/stadiums/presentation/pages/stadiums_screen.dart
✅ Routes:       lib/core/routes_manager/routes.dart
✅ Route Gen:    lib/core/routes_manager/routes_generators.dart
⚙️  Config:       pubspec.yaml
```

## Commands to Run

```bash
# Get dependencies
flutter pub get

# Run the app
flutter run

# Run with specific device
flutter run -d [device_id]

# Clean and rebuild
flutter clean
flutter pub get
flutter run
```

## Expected Output

When you navigate to the stadiums screen, you should see:

1. **AppBar** with "Available Stadiums" title
2. **Stadium Cards** with:
   - Stadium name and price
   - Description
   - Size, address
   - Opening and closing times
   - "View Details" button
3. **Pull to Refresh** support
4. **Bottom Sheet** with complete details when tapping a card

## API Response Expected

Your API should respond with:
```json
{
  "success": true,
  "code": 200,
  "message": "Fields retrieved successfully",
  "data": [...]
}
```

## Troubleshooting

### Build Fails
```bash
flutter clean
flutter pub get
flutter run
```

### API Not Responding
1. Check API URL is correct
2. Check internet connection
3. Verify API endpoint path
4. Check API is returning correct JSON format

### States Not Updating
1. Check BLoC provider is active
2. Verify event is being triggered
3. Check initState calls GetStadiumsEvent

## Performance Tips

- Data is cached in memory by BLoC
- Consider adding pagination for large datasets
- Pull-to-refresh works out of the box
- Images could be cached with cached_network_image (future enhancement)

## Security Checklist

- [x] Error messages don't expose sensitive info
- [x] API errors handled gracefully
- [x] Input validation present
- [x] No hardcoded sensitive data

## Next Steps

After setup works:
1. Test with real API
2. Add unit tests
3. Add widget tests
4. Add integration tests
5. Customize UI colors if needed
6. Add features like favorites, booking, etc.

---

**All Systems Go!** ✅ Ready to use once API URL is configured.
