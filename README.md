# Flex Market

## About The Project

This project is a market application with a specific focus on the sale of clothing. The application aims to provide an intuitive and efficient platform for users to browse, select, and purchase a variety of clothing items.

#### Key features of the application include:

- **Product Browsing:** Users can effortlessly navigate through a comprehensive list of clothing items, each with detailed descriptions, images, and pricing information.
- **User Authentication:** The application includes secure user authentication, ensuring a safe and personalized shopping experience.
- **Shopping Cart Functionality:** Users can add items to a shopping cart, review their selections, and make modifications as needed before proceeding to checkout.
- **Order Management:** The app allows users to place orders, track the status of their purchases, and view past order history.
- **Admin Functionalities:** The app allows the admins to manage the app items by adding and editing them and they can also manage the orders status.

As a scholarly project, the application is not only a practical tool but also serves to demonstrate various technologies and programming concepts in a real-world scenario. The project is designed to showcase skills in mobile application development, user interface design, state management, and integration with external libraries and APIs.

## Built With

This project is developed using a variety of powerful and efficient technologies and libraries. Below is an overview of the major components:

**Flutter:** The primary framework used for creating the UI and logic of the application. Flutter is a popular UI toolkit by Google for building natively compiled applications in our case for mobile and web devices, from a single codebase.

**Firebase Core (firebase_core):** This package is used to initialize Firebase in the Flutter project. Firebase provides a suite of cloud services like authentication, databases, analytics, etc.

**Firebase Crashlytics (firebase_crashlytics):**: Provides real-time crash reporting and analytics, helping in monitoring and fixing stability issues.

**Auth0 Flutter (auth0_flutter):** Auth0 is used for implementing robust and secure user authentication and authorization. It simplifies managing user identity and access controls.

**Flutter Dotenv (flutter_dotenv):** This package is utilized for loading environment variables, which helps in managing different configurations for development and production environments, such as API keys and endpoints.

**Google Fonts (google_fonts):** This library allows the application to easily utilize a variety of fonts offered by Google Fonts. It's used to enhance the UI's typography.

**HTTP (http):** The HTTP package is used for making network requests to REST APIs. It's crucial for fetching, sending, and updating data over the network.

**Flutter SVG (flutter_svg):** This package provides SVG rendering support, allowing the application to use scalable vector graphics for icons and other graphical elements.

**Provider (provider):** A popular state management solution in Flutter used to efficiently manage the state of the application. It helps in making the app more reactive and managing data flow.

**Camera (camera):** Provides access to the device's cameras, enabling photo and video capturing within the app.

**Image Picker (image_picker):** Allows users to pick images from their device gallery or take new pictures with the camera.

**Nested (nested):** Facilitates building more complex and nested widget trees, enhancing the organizational structure of the UI components. In our case it is used to implement the MultiProvider.

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
flutter run -d chrome --web-port 3000


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
├── models/                         # Models used to handle data
│   └── ...
├── components/                     # Custom reusable components
│   └── ...
├── providers/                      # App data state management and API calls
│   └── ...
├── utils/                          # Contains utility classes
│   ├── constants.dart              # Global constants used across the app
│   ├── enums.dart                  # Enums and their conversion functions
│   ├── messenger.dart              # Utils to give feedback to user
│   └── utils.dart                  # Various functions used across the app
assets/
└── ...                             # Assets like images and SVG files
.env                                # Environment variables
```

**State Management Approach:**

The project uses the Provider package for state management, following a simple yet effective approach to managing the application's state.
The providers used to manage state across the app and provide data are in `lib/providers`. They act as a central place for the app's state and logic, ensuring a clean separation between the presentation and the data management with the corresponding API calls. They ensure a good propagation of the information across the widgets depending on it.

**Architectural Pattern:**

The project loosely follows the MVVM (Model-View-ViewModel) architectural pattern.

- Models: Represented by classes like Product in product.dart, encapsulating the data structure.
- Views: UI pages in `pages/` and widgets in `components/` that render the UI.
- ViewModel: The providers in `lib/providers` serves as the ViewModel, handling the business logic and state management, independent of the UI.

**Database Schema:**

- **flex-market-cart**  
  PK: userId

```ts
export enum ItemSize {
  XS = "XS",
  S = "S",
  M = "M",
  L = "L",
  XL = "XL",
  XXL = "XXL",
}

export interface CartItem {
  itemId: string;
  quantity: number;
  size: ItemSize;
}

export interface Cart {
  userId: string;
  items: CartItem[];
  totalAmount: number;
}
```

- **flex-market-favorites**  
  PK: userId

```ts
import { ItemSize } from "./Product";

export interface FavoriteItem {
  itemId: string;
  size: ItemSize;
}

export interface Favorite {
  userId: string;
  items: FavoriteItem[];
}
```

- **flex-market-orders**  
  PK: orderId

```ts
import { ItemSize } from "./Product";

export enum OrderStatus {
  PENDING = "PENDING",
  COMPLETED = "COMPLETED",
  CANCELLED = "CANCELLED",
  SENT = "SENT",
}

export interface Order {
  orderId: string;
  userId: string;
  items: OrderItem[];
  totalAmount: number;
  orderDate: Date;
  status: string;
  shippingAddress: string;
}

export interface OrderItem {
  itemId: string;
  quantity: number;
  size: ItemSize;
  price: number;
}
```

- **flex-market-products**  
  PK: id

```ts
export enum ItemSize {
  XS = "XS",
  S = "S",
  M = "M",
  L = "L",
  XL = "XL",
  XXL = "XXL",
}

export enum ItemGender {
  MEN = "MEN",
  WOMEN = "WOMEN",
  UNISEX = "UNISEX",
}

export enum Category {
  TOPS = "TOPS",
  BOTTOMS = "BOTTOMS",
  DRESSES = "DRESSES",
  OUTERWEAR = "OUTERWEAR",
  UNDERWEAR = "UNDERWEAR",
  FOOTWEAR = "FOOTWEAR",
  ACCESSORIES = "ACCESSORIES",
  ATHLETIC = "ATHLETIC",
  SLEEPWEAR = "SLEEPWEAR",
  SWIMWEAR = "SWIMWEAR",
}

export interface InputSearchProducts {
  gender?: ItemGender;
  category?: string[];
  name?: string;
}

export interface Product {
  id: string;
  name: string;
  description: string;
  price: number;
  specs: { [key: string]: string };
  stock: { [key: string]: number };
  imagesUrl: string[];
  gender: ItemGender;
  createdAt: string;
  category: Category;
  searchName: string;
}
```

- **profile**

```ts
interface Identity {
  connection: string;
  user_id: string;
  provider: string;
  isSocial: boolean;
  access_token?: string;
  access_token_secret?: string;
  refresh_token?: string;
  profileData: {
    email: string;
    email_verified: boolean;
    name: string;
    username: string;
    given_name: string;
    phone_number: string;
    phone_verified: boolean;
    family_name: string;
  };
}

export interface UserProfile {
  user_id: string;
  email: string;
  email_verified: boolean;
  username: string;
  phone_number: string;
  phone_verified: boolean;
  created_at: string | Date;
  updated_at: string | Date;
  identities: Identity[];
  app_metadata: any;
  user_metadata: any;
  picture: string;
  name: string;
  nickname: string;
  multifactor: string[];
  last_ip: string;
  last_login: string | Date;
  logins_count: number;
  blocked: boolean;
  given_name: string;
  family_name: string;
}
```

Adoption of Flutter's native capabilities for cross-platform compatibility.
This architecture is designed to support the scalability of the application, with each component serving a distinct purpose, promoting clean code practices, and easing future enhancements.

### Deployment

Codemagic automates the process of building and testing the app. For deployment, the Android version is distributed via Firebase App Distribution, while the web version is hosted as a static site on Amazon S3.
