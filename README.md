# GIF Search App

A Flutter mobile application for searching and browsing animated GIFs using the GIPHY API.

The application provides a responsive GIF gallery, automatic search, infinite scrolling, and a separate screen for viewing GIF details.

## Features

- **Trending GIFs** — Displays trending GIFs when the app launches or the search query is cleared.
- **Automatic search** — Performs a search 500 milliseconds after the user stops typing.
- **Infinite scrolling** — Automatically loads additional GIFs when scrolling through the results.
- **Responsive layout** — Supports both portrait and landscape orientations.
- **GIF gallery** — Displays results in a staggered grid with different image aspect ratios.
- **GIF details** — Opens a separate screen showing the selected GIF in its original resolution, along with its title.
- **Copy GIF link** — Allows users to copy a GIF URL to the clipboard.
- **Loading indicators** — Shows progress indicators during the initial load and pagination.
- **Error handling** — Handles API and network errors and provides retry options.
- **Empty states** — Displays a message when no GIFs are found.

## Technologies

- Flutter 3.47.6 (stable)
- Dart 3.13.5
- GIPHY API
- `http` — HTTP requests
- `flutter_staggered_grid_view` — Staggered GIF gallery

## Getting Started

### Prerequisites

- Flutter SDK installed and configured
- Android device, Android emulator, or Chrome
- GIPHY API key

You can obtain an API key from [GIPHY Developers](https://developers.giphy.com/).

A GIPHY API key is required to run the application. For security reasons,
API keys are not included in the repository. Please create a free API key
and pass it using `--dart-define`.

### Installation

Clone the repository:

```bash
git clone https://github.com/Artemov63/gif_search_app.git
```

Navigate to the project directory:

```bash
cd gif_search_app
```

Install dependencies:

```bash
flutter pub get
```

### Running the Application

Run on a connected Android device or emulator:

```bash
flutter run --dart-define=GIPHY_API_KEY=YOUR_API_KEY
```

Run in Chrome:

```bash
flutter run -d chrome --dart-define=GIPHY_API_KEY=YOUR_API_KEY
```

Replace `YOUR_API_KEY` with your GIPHY API key.

The key is passed through `--dart-define` rather than hardcoded in the Dart source files. Do not commit API keys to the repository.

## Project Structure

```text
lib/
├── main.dart
├── models/
│   └── gif_item.dart
├── services/
│   └── giphy_service.dart
├── screens/
│   ├── gif_search_screen.dart
│   └── gif_details_screen.dart
└── widgets/
    └── search_bar.dart

test/
└── giphy_service_test.dart
```

- **models** — Data models representing GIF information.
- **services** — GIPHY API integration and response parsing.
- **screens** — Main GIF gallery and GIF details screen.
- **widgets** — Reusable UI components.

## Testing

Run unit tests:

```bash
flutter test
```

Run static analysis:

```bash
flutter analyze
```

The project includes three unit tests covering:

- Successful API responses and GIF data parsing.
- HTTP error handling.
- Empty search results.

At the time of submission, all three unit tests pass and Flutter static analysis reports no issues.

## Error Handling

The application handles common error scenarios:

- Failed API requests.
- Network connection errors.
- Errors while loading additional results.
- Failed GIF image loading.
- Search queries returning no results.

Error messages are displayed in the UI. Users can retry failed initial requests and pagination requests without restarting the application.

## Testing and Limitations

- The application was developed on Windows.
- Android functionality was manually tested on a Samsung Galaxy S24 Ultra.
- Portrait and landscape layouts are supported.
- An iOS project is included, but iOS functionality has not been tested on a physical device or simulator.
- API requests are subject to GIPHY rate limits.
- State management is implemented using Flutter's built-in `StatefulWidget` and `setState`.
- Network errors are handled, but a dedicated network connectivity monitoring service is not implemented.
- Navigation is handled within the screen widgets rather than through a separate navigation coordinator.

## Attribution

Powered by GIPHY.

GIF content is retrieved through the [GIPHY API](https://developers.giphy.com/).