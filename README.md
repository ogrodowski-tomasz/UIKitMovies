# UIKitMovies

A modern iOS movie discovery application built with UIKit, implementing the MVVM-C (Model-View-ViewModel-Coordinator) architecture pattern. This project serves as a reference implementation for building the same application with different tech stacks and architectures.

## 🎯 Project Purpose

This project was created as part of a comparative study to build the same movie discovery application using different technology stacks and architectural patterns. The UIKitMovies app demonstrates how to implement clean architecture principles in a traditional UIKit-based iOS application.

## 🏗️ Architecture: MVVM-C

The application follows the **MVVM-C (Model-View-ViewModel-Coordinator)** architecture pattern:

### Components:

- **Model**: Data models and API response structures (`MovieApiModel`, `MovieDetailsApiModel`, etc.)
- **View**: UIKit view controllers and custom cells (`MovieListViewController`, `MovieDetailsViewController`)
- **ViewModel**: Business logic and data binding (`MovieListViewModel`, `MovieDetailsViewModel`)
- **Coordinator**: Navigation flow management (`AppCoordinator`, `MovieListCoordinator`, `MovieDetailsCoordinator`)

### Key Architecture Benefits:
- **Separation of Concerns**: Clear boundaries between presentation, business logic, and navigation
- **Testability**: Objects are easily testable with dependency injection
- **Reusability**: Coordinators manage navigation flow independently
- **Maintainability**: Each layer has a single responsibility

## 🛠️ Tech Stack

### Core Technologies:
- **iOS 18+** - Target platform
- **UIKit** - User interface framework
- **Swift** - Programming language

### Dependencies:
- **Moya (15.0.3)** - Network abstraction layer built on Alamofire
- **RxSwift (6.9.0)** - Reactive programming framework
- **ReactiveSwift (6.7.0)** - Alternative reactive framework
- **Alamofire (5.10.2)** - HTTP networking library
- **Kingfisher (8.5.0)** - Image downloading and caching
- **SnapKit (5.7.1)** - Auto Layout DSL

### Key Features:
- **Reactive Programming**: RxSwift for data binding and asynchronous operations
- **Dependency Injection**: Protocol-based network layer for testability
- **Image Caching**: Kingfisher for efficient image loading and caching
- **Programmatic UI**: SnapKit for clean Auto Layout code
- **Network Abstraction**: Moya for type-safe API calls

## 📱 Features

- **Movie Discovery**: Browse popular, now playing, and top-rated movies
- **Movie Details**: View detailed information about selected movies
- **Favorites Management**: Save and manage favorite movies
- **Responsive UI**: Adaptive layouts for different screen sizes
- **Image Loading**: Optimized image loading with caching

## 🏛️ Project Structure

```
UIKitMovies/
├── Models/                 # Data models and API structures
├── Network/              # Network layer with Moya
│   ├── Movies/           # Movie-specific endpoints
│   └── Genres/           # Genre-related endpoints
├── Presentation/         # MVVM-C implementation
│   ├── Main/             # App coordinator and tab bar
│   ├── MovieList/        # Movie list feature
│   ├── MovieDetails/     # Movie details feature
│   └── FavoritesList/    # Favorites management
├── Extensions/           # Swift extensions
└── Stubs/               # Mock data for development
```

## 🚀 Getting Started

### Prerequisites:
- Xcode 12.0+
- iOS 18.4+
- Swift 5.0+

### Installation:
1. Clone the repository
2. Open `UIKitMovies.xcodeproj` in Xcode
3. Build and run the project

### API Configuration:
The app uses The Movie Database (TMDb) API. 

## 🔧 Possible Improvements

### Architecture Enhancements:
1. **Dependency Injection Container**: Implement a proper DI container (e.g., Swinject) for better dependency management
2. **Repository Pattern**: Add a repository layer between ViewModels and Network layer
3. **Use Cases/Interactors**: Extract business logic into dedicated use case classes
4. **Error Handling**: Implement comprehensive error handling with user-friendly messages
5. **Loading States**: Add proper loading and error states throughout the app

### Code Quality:
1. **Unit Tests**: Add comprehensive unit tests for ViewModels and business logic
2. **Linting**: Add SwiftLint for consistent code style
3. **Documentation**: Add comprehensive code documentation and API documentation

### Performance:
1. **Image Optimization**: Implement progressive image loading and placeholder images
2. **Memory Management**: Add proper memory management for large image collections
3. **Background Processing**: Add background refresh capabilities
4. **Pagination**: Implement infinite scrolling for large movie lists

### User Experience:
1. **Search Functionality**: Add movie search with real-time suggestions
2. **Filtering & Sorting**: Implement filtering by genre, year, rating
3. **Offline Support**: Add offline capabilities with Core Data
4. **Accessibility**: Improve accessibility support for VoiceOver and other assistive technologies
5. **Dark Mode**: Enhanced dark mode support with dynamic colors

### Technical Debt:
1. **Async/Await**: Migrate from RxSwift to modern async/await patterns
2. **SwiftUI Integration**: Gradually introduce SwiftUI components where appropriate
3. **Combine Framework**: Consider migrating to Combine for reactive programming
4. **Modularization**: Split the app into feature modules for better maintainability

## 📄 License

This project is for educational and comparison purposes. Please ensure you have proper API keys and follow the terms of service for any third-party APIs used.

## 🤝 Contributing

This project is part of a comparative study. Feel free to suggest improvements or report issues for educational purposes.

---

*This project demonstrates clean architecture principles in iOS development using UIKit and serves as a reference for building similar applications with different technology stacks.*
