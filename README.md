# Daily Quote App

A clean, minimalist mobile app that delivers daily inspiration through curated quotes. Built with Flutter and powered by the Quotable API.

### App Designs/Screenshots

![Daily Quote App Screenshot](https://github.com/GunvantGMC/quoteapp/blob/main/assets/images/Quote%20App%20Designs.png?raw=true)

**Web App Link** : https://quoteapp.gunvantgmc.in

> For better experience open link in mobile view

## Features

- **Daily Random Quotes**: Fresh inspirational quotes from the Quotable API
- **Favorites System**: Save your favorite quotes with persistent storage
- **Streak Counter**: Track your daily engagement with local storage
- **Share Functionality**: Share quotes through system share sheet
- **Dark Theme**: Beautiful dark green gradient design
- **Smooth UX**: Scrollable content and responsive layout

## Setup Instructions

### Prerequisites

- Flutter SDK (3.0 or higher)
- Dart SDK
- Android Studio / VS Code
- Android/iOS device or simulator

### Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/gunvantgmc/quoteapp
   cd daily-quote-app
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Build for Release

**Android APK:**

```bash
flutter build apk --release
```

**iOS (requires macOS):**

```bash
flutter build ios --release
```

## My Development Approach

This project started with a clear requirement gathering phase where I mapped out the core functionality needed for a daily quote app. Here's how I approached the development:

1. **Requirements Analysis**: Broke down the task into core features (quote display, favorites, sharing, persistence)

2. **Wireframing & Visualization**: Used Stitch to generate initial wireframes and visualize the user flow before coding

3. **UI Implementation**: Designed the interface using Stitch for clean, modern aesthetics with the dark green gradient theme

4. **AI-Assisted Development**: Leveraged Rocket platform for rapid app generation and iterative improvements

5. **Iterative Refinement**: Made continuous fixes and enhancements using a combination of AI tools and traditional development resources

6. **Testing & Polish**: Ensured smooth functionality across different screen sizes and quote lengths

The key was starting with a solid foundation and then using AI tools to accelerate development while maintaining code quality.

## AI Tools & Resources Used

- **Rocket Platform**: Primary tool for Flutter app generation and code modifications
- **ChatGPT**: Used for resolving functional doubts, generating good prompts, and problem-solving
- **Stitch**: For UI design and wireframing
- **Traditional Resources**: Google, Stack Overflow for specific technical challenges

## Design Process

The app design was created using **Stitch** for UI generation and wireframing. The design focuses on:

- Minimalist dark theme with green accents
- Clear typography for quote readability
- Intuitive action buttons (favorite, next, share)
- Visual streak counter for user engagement
  > Minor design adjustments were made during final implementation to improve usability and layout consistency. As a result, small differences may exist between initial designs and the final app.

**Home (Daily Quote):** **_Screen 1_**

- Daily streak counter at the top
- Large, readable quote display with decorative quotation marks
- Author attribution in green accent color
- Three action buttons: Favorite, Next Quote, and Share

**Favorite Quote:** **_Screen 2_**

- Lists all saved favorite quotes
- Each quote shows text and author
- Options to _Share_ or _Delete_ a quote
- Scrollable list with simple layout

**Quote Detail View:** **_Screen 3_**

- Displays the selected quote in full
- Shows author name clearly
- Focused UI for distraction-free reading

## API Integration

This app integrates with the [Quotable API](https://api.quotable.io) for fetching random quotes:

- **Quotable Endpoint**: `http://api.quotable.io/quotes/random`
- **Vercel Endpoint**: `https://quotableioapiexpress-js-proxy.vercel.app/api/quote`
- **Authentication**: No authentication required
- **Response**: Returns quote content, author, and metadata

## Technical Architecture

### State Management

- Provider pattern for state management
- SharedPreferences for local data persistence

### Key Packages

- **dio**: HTTP client for API requests
- **shared_preferences**: Local storage for favorites and streak data
- **share_plus**: Native share functionality
- **flutter_svg**: SVG image rendering
- **google_fonts**: Custom typography (Inter font)

### Project Structure

```
lib/
├── main.dart                          # App entry point
├── presentation/                      # UI layer
│   ├── home_screen/                   # Home screen with quote display
│   │   ├── home_screen.dart
│   │   ├── home_screen_initial_page.dart
│   │   └── widgets/                   # Home screen widgets
│   │       ├── quote_card_widget.dart
│   │       └── action_button_widget.dart
│   └── favorites_screen/              # Favorites screen
│       ├── favorites_screen.dart
│       └── widgets/                   # Favorites widgets
│           ├── favorite_quote_card_widget.dart
│           └── empty_favorites_widget.dart
├── services/                          # Business logic
│   ├── quote_service.dart             # API integration
│   ├── favorites_service.dart         # Favorites management
│   └── streak_service.dart            # Streak tracking
├── theme/                             # App theming
│   └── app_theme.dart
├── widgets/                           # Reusable widgets
│   ├── custom_bottom_bar.dart
│   ├── custom_error_widget.dart
│   ├── custom_icon_widget.dart
│   └── custom_image_widget.dart
├── routes/                            # Navigation
│   └── app_routes.dart
└── core/                              # Core utilities
    └── app_export.dart
```

## Key Features Implementation

### 1. Daily Streak Counter

- Uses SharedPreferences to track last visit date
- Calculates consecutive days of app usage
- Resets if user misses a day
- Displays with flame icon for visual appeal

### 2. Favorites System

- Persistent storage using SharedPreferences
- Add/remove quotes with heart icon toggle
- Dedicated favorites screen with all saved quotes
- Empty state when no favorites exist

### 3. Quote Display

- Scrollable quote content to handle long quotes
- Flexible author name display to prevent overflow
- Decorative quotation marks for visual appeal
- Responsive layout for different screen sizes

### 4. Share Functionality

- Native share sheet integration
- Shares quote text with author attribution
- Works across all platforms (iOS, Android, Web)

## Challenges & Solutions

### Challenge 1: Long Quote Overflow

**Problem**: Long quotes were overlapping with action buttons
**Solution**: Wrapped quote content in SingleChildScrollView to make it scrollable

### Challenge 2: Author Name Overflow

**Problem**: Long author names were causing text overflow
**Solution**: Used Flexible widget with TextOverflow.ellipsis and maxLines to wrap text properly

### Challenge 3: Static Streak Counter

**Problem**: Streak counter was showing hardcoded value
**Solution**: Implemented StreakService with SharedPreferences to track actual daily visits and calculate consecutive streaks

### Challenge 4: HTTP/HTTPS API Compatibility For Flutter Web

**Problem**: The original quotable API used HTTP-only endpoints. After hosting the Flutter web app on HTTPS, the browser blocked mixed content (HTTPS page trying to fetch HTTP resources), causing the API to fail.
**Solution**: Implemented a wrapper API using Vercel serverless functions that:

1. Acts as a proxy between the Flutter web app and the HTTP API
2. Accepts HTTPS requests from the Flutter app
3. Fetches data from the HTTP API on the server side
4. Returns the data over HTTPS to the client

This approach made the app fully functional for HTTPS traffic while maintaining compatibility with the existing API.

## Future Enhancements

- [ ] Add quote categories/tags filtering
- [ ] Add daily notifications with quotes
- [ ] Create custom quote collections
- [ ] Add social sharing with custom quote images
- [ ] Include quote of the day widget

## Contributing

Contributions are welcome! If you'd like to improve the app:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is open source and available under the [MIT License](LICENSE).

## Author

**Gunvant Chandratre** - [github.com/GunvantGMC](https://github.com/GunvantGMC)[GunvantGMC](https://gunvantgmc.in)

Feel free to reach out for questions, suggestions, or collaboration opportunities!

## Acknowledgments

- [Quotable API](https://quotable.io) for providing the quote data
- [Stitch](https://stitch.tech) for design and wireframing tools
- [Rocket Platform](https://rocket.dev) for AI-assisted Flutter development
- The Flutter community for excellent packages and resources

---

**Built with ❤️ using Flutter and AI-assisted development**
