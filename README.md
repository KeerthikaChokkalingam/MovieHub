# MovieHub 🍿

An iOS application built with UIKit, MVVM, TMDB API, CoreData, and CocoaPods. The app allows users to browse movies, view details, watch trailers, and manage favorites. This project serves as an example for learning how to integrate and use the TMDB API.

---

## ✨ Features

* ✅ **Movie List Displays:** Currently trending/popular movies from TMDB. Shows title, rating, poster, and release date.
* ✅ **Movie Detail Page:** Banner + play button (using `youtube-ios-player-helper`)
* ✅ **Detail Scrolling:** Beautiful scrollable UI for title, genre, cast, languages, plot, and IMDB rating.
* ✅ **CoreData Integration:** Autolayout is adaptive (using `UILayoutConstraint`).
* ✅ **Search:** Live search using the TMDB Search API (Debounced for improved performance).
* ✅ **Favorites:** Save and remove favorites using CoreData Persistent storage (favorites list displayed in a separate screen).
* ✅ **Project Structure:** Clear separation of concerns: `MovieHub/ — Models/ — ViewModels/ — Views/ — networking/ — CoreData/ — Extensions/`

---

## ⚙️ Setup Instructions

Follow these steps to get the project running locally:

1.  **Clone the project:**
    ```bash
    git clone [https://github.com/yourname/MovieHub.git](https://github.com/yourname/MovieHub.git) cd MovieHub
    ```
2.  **Install CocoaPods:** Install [CocoaPods](https://cocoapods.org/) if you haven't already.
3.  **Install Pods:**
    ```bash
    pod install
    ```
4.  **Open the Workspace:** Open the generated `MovieHub.xcworkspace` file.
5.  **Get a TMDB API Key:** Go to [https://www.themoviedb.org](https://www.themoviedb.org) and create an account to generate an API key.
6.  **Add API Key to Project:** Inside your project, add the TMDB Swift struct (using a static let):
    ```swift
    static let apikey = "YOUR_API_KEY"
    ```
7.  **Run:** Build & Run the project on a selected iOS Simulator or device.

---

## ℹ️ Technical Notes and Limitations

* **Dependencies:** Uses CocoaPods for `youtube-ios-player-helper` (for embedding YouTube trailer inside the banner). CoreData is used to store and retrieve favorite movies.
* **Assumptions:** User must have internet connection to fetch movie details and trailers. All trailer requests assume TMDB always provides a valid YouTube video key.
* **Design Target:** UI is designed for iPhone screen sizes only (not optimized for iPad).
* **Known Limitations:** Offline mode is not fully implemented (only basic connectivity check). No pagination implemented for the movie list. No dark mode styling yet. API key is stored in plain text (not secure).
