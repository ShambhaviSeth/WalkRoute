# WalkRoute - Smart Walking Route Generator

WalkRoute is an iOS app that helps you explore your neighborhood or a new city with randomly generated walking routes based on your selected duration. Designed for ease of use, customization, and exploration, WalkRoute provides scenic and efficient loop routes with real-time tracking and dark mode support.

---

## Features

- **Smart Route Generation**
  - Input a duration (5–60 minutes)
  - Generates non-repetitive loop routes starting and ending at your current location

- **Google Maps Integration**
  - Smooth map rendering with turn-by-turn geometry
  - Automatically switches to dark map style in dark mode

- **Walk History Tracking**
  - Saves distance, duration, and start location of previous walks
  - Includes a clean UI to browse past walks

- **Live Location Tracking**
  - Follows your movement in real time on the route
  - Recenter button to snap back to your current location

- **Dark Mode Friendly**
  - UI components and map style fully adapt to system theme

---

## 🔧 Setup Instructions

1. **Clone the Repository**

```bash
git clone https://github.com/yourusername/walkroute.git
```

2. **Install Dependencies**

Ensure CocoaPods is installed:
```bash
sudo gem install cocoapods
```
Then:
```bash
cd walkroute
pod install
open WalkRoute.xcworkspace
```

3. **Google Maps Setup**
- Get your API key from the [Google Cloud Console](https://console.cloud.google.com/)
- Enable the **Directions API** and **Maps SDK for iOS**
- Replace `Constants.googleMapsAPIKey` in your app with your key

4. **Add the Dark Map Style**
- Include the `dark-map-style.json` file in your Xcode project
- Make sure it’s part of the app target


---
## Features Preview

| Light Theme | Dark Theme |
| :---------: | :--------: |
| <img src="https://github.com/user-attachments/assets/8241ae7c-b1cb-4a30-a2c5-f79f99d1c3f0" width="350" alt="Light-mode screenshot"/> | <img src="https://github.com/user-attachments/assets/64ca9b17-1603-4b5a-82e9-b15ef7b1919f" width="350" alt="Dark-mode screenshot"/> |
<img src="https://github.com/user-attachments/assets/515df0cf-b18c-4c97-ad28-42a0f0eb243f" width="350" alt="Light-mode screenshot"/> | <img src="https://github.com/user-attachments/assets/b623ba62-313b-42fb-b2e3-9111fbed2b44" width="350" alt="Dark-mode screenshot"/> |




