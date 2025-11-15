# MovieHub
iOS app for learning TMDb API
🎬 MovieHub — iOS App
An iOS application built with UIKit, MVVM, TMDb API, CoreData, and CocoaPods.
The app allows users to browse movies, view details, watch trailers, and manage favorites.
📌 Features
✅ Movie List
Displays currently trending/popular movies from TMDb.
Shows title, rating, poster, and release date.
✅ Movie Detail Page
Banner + play button
Inline YouTube trailer player (using youtube-ios-player-helper)
Title, genres, cast, languages, plot, IMDb rating
Beautiful scrollable UI
Favorite (❤️) toggle with CoreData
Autolayout & adaptive UI
✅ Search
Live search using TMDb Search API
Debounced for improved performance
✅ Favorites
Save & remove favorites using CoreData
Persistent storage
Favorites list displayed in a separate screen
📦 Project Structure
MovieHub/
│
├── Models/
├── ViewModels/
├── Views/
├── Networking/
├── CoreData/
├── Extensions/
└── Resources/
⚙️ Setup Instructions
1️⃣ Clone the project
git clone https://github.com/yourname/MovieHub.git
cd MovieHub
2️⃣ Install CocoaPods dependencies
You must install the YouTube helper pod:
Podfile
pod 'youtube-ios-player-helper'
Now install:
pod install
Open the workspace:
open MovieHub.xcworkspace
🔑 TMDb API Setup
Go to https://www.themoviedb.org
Create an account
Generate an API key
Add it inside your project:
TMDB.swift
struct TMDB {
    static let apiKey = "YOUR_API_KEY"
}
▶️ Build & Run
Open MovieHub.xcworkspace
Select a simulator
Press ⌘ + R to run
🗂️ Dependencies Used
CocoaPods
youtube-ios-player-helper
→ Used for embedding YouTube trailer inside the banner.
CoreData
Used to store and retrieve favorite movies.
🧪 Assumptions
User must have internet connection to fetch movie details and trailers.
All trailer requests assume TMDb always provides a valid YouTube video key.
UI is designed to work for iPhone screen sizes only (not optimized for iPad).
🚧 Known Limitations
Offline mode is not fully implemented (only basic connectivity check).
No pagination implemented for movie list.
No dark mode styling yet.
API key is stored in plain text (not secure).
