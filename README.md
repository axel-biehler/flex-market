# Flex Market

## About The Project

This project is a market application with a specific focus on the sale of clothing. The application aims to provide an intuitive and efficient platform for users to browse, select, and purchase a variety of clothing items.

#### Key features of the application include:

- **Product Browsing:** Users can effortlessly navigate through a comprehensive list of clothing items, each with detailed descriptions, images, and pricing information.
- **User Authentication:** The application includes secure user authentication, ensuring a safe and personalized shopping experience.
- **Shopping Cart Functionality:** Users can add items to a shopping cart, review their selections, and make modifications as needed before proceeding to checkout.
- **Order Management:** The app allows users to place orders, track the status of their purchases, and view past order history.

As a scholarly project, the application is not only a practical tool but also serves to demonstrate various technologies and programming concepts in a real-world scenario. The project is designed to showcase skills in mobile application development, user interface design, state management, and integration with external libraries and APIs.

## Built With

This project is developed using a variety of powerful and efficient technologies and libraries. Below is an overview of the major components:

**Flutter:** The primary framework used for creating the UI and logic of the application. Flutter is a popular UI toolkit by Google for building natively compiled applications in our case for mobile and web devices, from a single codebase.

**Firebase Core (firebase_core):** This package is used to initialize Firebase in the Flutter project. Firebase provides a suite of cloud services like authentication, databases, analytics, etc.

**Auth0 Flutter (auth0_flutter):** Auth0 is used for implementing robust and secure user authentication and authorization. It simplifies managing user identity and access controls.

**Flutter Dotenv (flutter_dotenv):** This package is utilized for loading environment variables, which helps in managing different configurations for development and production environments, such as API keys and endpoints.

**Google Fonts (google_fonts):** This library allows the application to easily utilize a variety of fonts offered by Google Fonts. It's used to enhance the UI's typography.

**HTTP (http):** The HTTP package is used for making network requests to REST APIs. It's crucial for fetching, sending, and updating data over the network.

**Flutter SVG (flutter_svg):** This package provides SVG rendering support, allowing the application to use scalable vector graphics for icons and other graphical elements.

**Provider (provider):** A popular state management solution in Flutter used to efficiently manage the state of the application. It helps in making the app more reactive and managing data flow.

These libraries and frameworks are chosen for their reliability, wide community support, and ability to make the development process more efficient and effective.

## Getting Started

### Prerequisites

**Install needed software:**

- Flutter
- Dart language
- Android studio with an emulator (recommended AVD: Pixel 7 pro with Android 13.0 Tiramisu Api level 33)

**Clone the repository and navigate to its directory:**

```bash
git clone git@github.com:biles2/flex-market.git && cd flex-market
```

**Install dependencies:**

```bash
flutter pub get
```

**Run the app:**

```bash
# run on chrome
flutter run -d chrome


# To run on android start your emulator and then find you device like this:
flutter devices
flutter run -d 'yourDeviceName'
```

### Architecture

The architecture of this project is carefully designed to ensure readability, maintainability, and scalability. Below is an overview of the key architectural aspects:

**File Structure:**

```bash
lib/
├── main.dart                       # App entry point
├── pages/                          # App pages
│   └── ...
├── components/                     # Custom reusable components
│   └── ...
├── utils/                          # Contains utility classes
│   ├── data_provider.dart          # Application state and business logic
│   ├── constants.dart              # Global constants used across the app
│   └── models/                     # Models used to handle data
│       └── ...
assets/
└── ...                             # Assets like images and SVG files
```

**State Management Approach:**

The project uses the Provider package for state management, following a simple yet effective approach to managing the application's state.
The DataProvider class in `utils/data_provider.dart` acts as a central place for the app's state and logic, ensuring a clean separation between the presentation and business logic.

**Architectural Pattern:**

The project loosely follows the MVVM (Model-View-ViewModel) architectural pattern.

- Models: Represented by classes like Product in product.dart, encapsulating the data structure.
- Views: UI pages in `pages/` and widgets in `components/` that render the UI.
- ViewModel: The `DataProvider` class serves as the ViewModel, handling the business logic and state management, independent of the UI.

**Database Schema:**

// TODO

Adoption of Flutter's native capabilities for cross-platform compatibility.
This architecture is designed to support the scalability of the application, with each component serving a distinct purpose, promoting clean code practices, and easing future enhancements.

### Deployment

// TODO
