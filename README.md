# F-Commerce

A modern Flutter e-commerce app built with Neumorphic design principles. This app showcases a monochromatic, muted color scheme with soft shadows and highlights to create a sleek, tactile user experience.

![F-Commerce App](https://via.placeholder.com/800x400?text=F-Commerce+App)

## Features

- **Monochromatic Neumorphic UI Design**: Soft shadows and highlights with muted colors
- **Product Browsing & Filtering**: Browse products with category filters
- **Product Details**: View detailed product information with images
- **Shopping Cart**: Add/remove items with quantity control
- **Checkout Flow**: Simple order confirmation process
- **User Profile**: User information and settings
- **Dark/Light Theme Toggle**: Switch between light and dark neumorphic themes
- **Responsive Design**: Works on various screen sizes

## App Architecture

This project follows a feature-based architecture pattern with clean separation of concerns:

- **Core**: Base components, services, utilities, and theme
- **Features**: Organized by domain (products, cart, auth)
  - **Data**: Models, repositories, providers
  - **Presentation**: Screens and widgets

## Tech Stack

- **State Management**: [flutter_riverpod](https://pub.dev/packages/flutter_riverpod)
- **UI Design**: [flutter_neumorphic_plus](https://pub.dev/packages/flutter_neumorphic_plus)
- **API Integration**: [dio](https://pub.dev/packages/dio) for network requests
- **Responsive UI**: [flutter_screenutil](https://pub.dev/packages/flutter_screenutil)
- **Image Handling**: [cached_network_image](https://pub.dev/packages/cached_network_image)
- **Local Storage**: [hive_flutter](https://pub.dev/packages/hive_flutter)

## Screenshots

<table>
  <tr>
    <td align="center"><img src="https://via.placeholder.com/200x400?text=Home+Screen" width="200" alt="Home Screen"/></td>
    <td align="center"><img src="https://via.placeholder.com/200x400?text=Product+Details" width="200" alt="Product Details"/></td>
    <td align="center"><img src="https://via.placeholder.com/200x400?text=Cart" width="200" alt="Cart Screen"/></td>
    <td align="center"><img src="https://via.placeholder.com/200x400?text=Profile" width="200" alt="Profile Screen"/></td>
  </tr>
  <tr>
    <td align="center">Home</td>
    <td align="center">Product Details</td>
    <td align="center">Cart</td>
    <td align="center">Profile</td>
  </tr>
</table>

## Getting Started

### Prerequisites

- Flutter SDK (2.5.0 or higher)
- Dart SDK (2.14.0 or higher)
- An IDE (VS Code, Android Studio, etc.)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/Berkawaii/fakeCommerce.git
cd fakeCommerce
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## Project Structure

```
lib/
├── core/
│   ├── api/
│   ├── providers/
│   ├── storage/
│   └── theme/
└── features/
    ├── products/
    │   ├── data/
    │   └── presentation/
    ├── cart/
    │   ├── data/
    │   └── presentation/
    └── auth/
        ├── data/
        └── presentation/
```

## API Integration

This app uses [FakeStoreAPI](https://fakestoreapi.com) for product data, cart functionality, and user authentication.
