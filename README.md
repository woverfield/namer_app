# namer_app

namer_app is a Flutter application designed to generate cool-sounding names like "newstay", "lightstream", "mainbrake", or "graypine". Users can easily generate names, favorite their preferred ones, manage their list of favorites, and compare them with other users. The backend is powered by Firebase, ensuring a seamless and reliable user experience.

## Features

- **Name Generation:** Generate unique and catchy names with a single tap.
- **Favorite Names:** Save your favorite generated names for easy access later.
- **Favorites Management:** View and manage your list of favorite names on a dedicated page.
- **Comparison with Others:** Compare your favorite names with those of other users, fostering a sense of community and engagement.

## Getting Started

### Prerequisites

- Flutter SDK: [Install Flutter](https://flutter.dev/docs/get-started/install)
- Firebase account: [Create Firebase account](https://firebase.google.com/)

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/yourusername/namer_app.git
   cd namer_app
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Set up Firebase:**
   - Create a new Firebase project in the [Firebase Console](https://console.firebase.google.com/).
   - Add your Android and iOS apps to the Firebase project.
   - Download the `google-services.json` file for Android and `GoogleService-Info.plist` file for iOS and place them in the respective directories.

4. **Run the app:**
   ```bash
   flutter run
   ```

## Usage

- **Generating Names:** Tap the "Generate" button on the home screen to create a new name.
- **Favoriting a Name:** Tap the heart icon next to a generated name to add it to your favorites.
- **Managing Favorites:** Navigate to the favorites page to view, edit, or remove your saved names.
- **Comparing Favorites:** Access the comparison feature to see how your favorites stack up against those of other users.

## Contributing

We welcome contributions to namer_app! To get started:

1. Fork the repository.
2. Create a new branch (`git checkout -b feature/your-feature-name`).
3. Make your changes.
4. Commit your changes (`git commit -m 'Add some feature'`).
5. Push to the branch (`git push origin feature/your-feature-name`).
6. Open a pull request.

## Acknowledgments

- [Flutter](https://flutter.dev/)
- [Firebase](https://firebase.google.com/)
