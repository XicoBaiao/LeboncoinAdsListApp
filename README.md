# LeboncoinListOfAdsApp

A Swift-based classified ads app using **SwiftUI**, **UIKit**, and **MVVM**, fetching ads and categories from a public API.

---

## Features

- ✅ **List classified ads** with images, titles, prices, categories and creation dates
- ✅ **Filter ads by category** with a horizontal scrollable category selector  
- ✅ **View ad details** with full-screen images and descriptions  
- ✅ **Asynchronous image caching** for smooth scrolling  
- ✅ **Pull-to-refresh** functionality for fetching updated ads  
- ✅ **Error handling** with retry functionality  
- ✅ **Adaptive UI** for iPhones and iPads  

---

## Architecture

This app follows the **MVVM (Model-View-ViewModel)** pattern:

- **Model**: Defines `Ad` and `Category` data structures.
- **ViewModel**: Handles fetching, filtering, and storing ads.
- **View**: UIKit Collection Views to display categories and Ads List. SwiftUI views for displaying the Ad Detail UI.
- **Services**: `APIService.swift` manages network requests.

---

## Dependencies

| Library  | Usage  |
|----------|--------|
| **SwiftUI** | UI components for detail screens |
| **UIKit** | Collection views for listing ads and categories |
| **Combine** | Asynchronous data fetching |
| **NSCache** | Image caching |

---

### Prerequisites

- **Xcode 15+**
- **iOS 16+** target
- **Swift 5.9+**

###  Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/LeboncoinListOfAdsApp.git
   cd LeboncoinListOfAdsApp

2. **Open the project in Xcode**
   ```bash
   open LeboncoinListOfAdsApp.xcodeproj

3. **Run the app on iOS simulator or physical device**

### API Usage

- **Ads API:** https://raw.githubusercontent.com/leboncoin/paperclip/master/listing.json
- **Categories API:** https://raw.githubusercontent.com/leboncoin/paperclip/master/categories.json
- **Swagger:** https://raw.githubusercontent.com/leboncoin/paperclip/master/swagger.yaml

### Testing

To run Unit tests and UI tests:
```bash
⌘ + U
