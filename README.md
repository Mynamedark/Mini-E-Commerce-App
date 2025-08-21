# Mini E-Commerce App

A Flutter-based e-commerce application with Firebase backend support. The app supports product listing, cart management, nearby stores map, and localization (English & Hindi).

---

## **Table of Contents**

1. [Features](#features)
2. [Project Architecture](#project-architecture)
3. [Prerequisites](#prerequisites)
4. [Setup & Installation](#setup--installation)
5. [Running the App](#running-the-app)
6. [Localization](#localization)
7. [Firebase Integration](#firebase-integration)
8. [Design Decisions](#design-decisions)

---

## **Features**

- Browse products with search functionality
- View product details
- Add products to cart and manage cart items
- View nearby stores on a map using **Flutter Map**
- Multi-language support: English & Hindi
- Firebase backend for storing products, cart, and user info

---

## **Project Architecture**

The app follows a **MVVM-like architecture** using **Provider** for state management:

```
lib/
├── main.dart                 # App entry point
├── routes.dart               # Named route definitions
├── models/                   # Data models (Product, CartItem)
├── providers/                # State management (ProductProvider, CartProvider, LocaleProvider)
├── ui/
│   ├── pages/                # Screens (HomePage, ProductDetailPage, NearbyStoresMap)
│   └── widgets/              # Reusable widgets
├── l10n/                     # Localization files
│   ├── app_localizations.dart
│   ├── en.arb
│   └── hi.arb
└── services/                 # Firebase services (optional)
```

**State Management**

- `ProductProvider`: Manages product data and search filtering
- `CartProvider`: Manages cart items
- `LocaleProvider`: Manages app localization

**Localization**

- `.arb` files in `assets/i18n`
- Custom `AppLocalizations` class to fetch strings

**Maps**

- Nearby stores displayed using `flutter_map` with Geolocator

---

## **Prerequisites**

- Flutter SDK >= 3.0
- Android Studio / VS Code
- Firebase project with Realtime Database or Firestore
- Google Maps API key (optional if using `flutter_map`)

---

## **Setup & Installation**

1. Clone the repository:

```bash
git clone https://github.com/yourusername/mini- e-commerce_app.git
cd mini-e-commerce-app
```

2. Install dependencies:

```bash
flutter pub get
```

3. Add Firebase configuration:

- **Android**: Place `google-services.json` in `android/app/`
- **iOS**: Place `GoogleService-Info.plist` in `ios/Runner/`

4. Enable Firebase services (Firestore/Realtime DB) and add collections:

```
products/
cart/
users/
```

5. Set up **localization files** in `assets/i18n/`

- `en.arb`
- `hi.arb`

6. Update `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/i18n/
```

---

## **Running the App**

```bash
flutter run
```

- Make sure an emulator or physical device is connected.
- Supports hot reload/hot restart.

---

## **Localization**

**Languages Supported:**

- English (`en.arb`)
- Hindi (`hi.arb`)

**Usage in code:**

```dart
final t = AppLocalizations.of(context);
Text(t.t('home'));
```

**Language Switching:**

```dart
IconButton(
  icon: const Icon(Icons.language),
  onPressed: () {
    final provider = context.read<LocaleProvider>();
    if(provider.locale.languageCode == 'en') {
      provider.setLocale(const Locale('hi'));
    } else {
      provider.setLocale(const Locale('en'));
    }
  },
)
```

---

## **Firebase Integration**

- Products stored in Firestore: `products` collection
- Cart stored in `cart` collection per user
- Firebase Storage for product images or receipts

**Sample Firestore Document:**

```json
{
  "id": "p1",
  "title": "Product Name",
  "price": 12.99,
  "imageUrl": "https://link-to-image"
}
```

---

## **Design Decisions**

1. **State Management**: Provider is used for simplicity and reactivity.
2. 
3. **UI**: Material Design with customization and theme support.
4. **Maps**: Used `flutter_map` + `geolocator` for better flexibility and no Google API dependency.
5. **Localization**: `.arb` files allow adding more languages easily.
6. **Firebase**: Firestore chosen for easy real-time updates.
7. **Architecture**: MVVM-like separation for scalability and maintainability.

## **Screen shot **

https://github.com/Mynamedark/Mini-E-Commerce-App/blob/main/Screenshot_2025-08-21-21-52-49-26_e51cc5eacb31f807692e5d3df56ca25e.jpg
https://github.com/Mynamedark/Mini-E-Commerce-App/blob/main/Screenshot_2025-08-21-21-52-53-15_e51cc5eacb31f807692e5d3df56ca25e.jpg
https://github.com/Mynamedark/Mini-E-Commerce-App/blob/main/Screenshot_2025-08-21-21-53-11-26_e51cc5eacb31f807692e5d3df56ca25e.jpg
https://github.com/Mynamedark/Mini-E-Commerce-App/blob/main/Screenshot_2025-08-21-21-53-17-15_e51cc5eacb31f807692e5d3df56ca25e.jpg
https://github.com/Mynamedark/Mini-E-Commerce-App/blob/main/Screenshot_2025-08-21-21-53-20-86_e51cc5eacb31f807692e5d3df56ca25e.jpg
https://github.com/Mynamedark/Mini-E-Commerce-App/blob/main/Screenshot_2025-08-21-21-53-20-86_e51cc5eacb31f807692e5d3df56ca25e.jpg
https://github.com/Mynamedark/Mini-E-Commerce-App/blob/main/Screenshot_2025-08-21-21-53-53-52_e51cc5eacb31f807692e5d3df56ca25e.jpg
https://github.com/Mynamedark/Mini-E-Commerce-App/blob/main/Screenshot_2025-08-21-21-54-00-01_e51cc5eacb31f807692e5d3df56ca25e.jpg
https://github.com/Mynamedark/Mini-E-Commerce-App/blob/main/Screenshot_2025-08-21-21-54-14-19_e51cc5eacb31f807692e5d3df56ca25e.jpg
https://github.com/Mynamedark/Mini-E-Commerce-App/blob/main/Screenshot_2025-08-21-21-54-28-10.jpg
