# No Spam Call

An iOS app to search and block spam phone numbers.

## Features

- Phone Number Search: Check Google search results for a phone number directly within the app
- Clipboard Search: Automatically search phone numbers copied to the clipboard
- Spam Registration: Register and block spam numbers in the app
- Spam List Management: View and delete registered spam numbers
- Multi-language Support: English and Korean languages supported

## Architecture

This project is implemented using the MVVM (Model-View-ViewModel) architecture.

### Structure

- **Models**: Data models
  - `SpamNumber`: Spam phone number model

- **Views**: UI components
  - `MainView`: Main screen
  - `SpamListView`: Spam number list screen
  - `WebView`: Web content display component

- **ViewModels**: Business logic
  - `MainViewModel`: Main screen view model
  - `SpamListViewModel`: Spam list view model

- **Services**: Data handling and external interactions
  - `SpamNumberService`: Spam number management service
  - `SearchService`: Search functionality service
  
- **Extensions**: Utility extensions
  - `StringExtensions`: Localization support for strings

- **Resources**: Localized resources
  - Localizable.strings: UI text translations
  - InfoPlist.strings: App name and metadata translations

## Requirements

- iOS 15.0+
- Xcode 14.0+
- Swift 5.8+

## Installation

1. Clone the repository
```
git clone https://github.com/yourusername/no-spam-call.git
```

2. Open the project in Xcode
```
open NoSpamCall.xcodeproj
```

3. Build and run the app

## Configuration

To use the CallKit extension functionality, the following settings are required:

1. App Groups configuration
2. CallDirectory extension activation

## Localization

The app supports the following languages:
- English (en)
- Korean (ko)

To add a new language:
1. Create a new folder in Resources with the language code (e.g., `fr.lproj`)
2. Copy the Localizable.strings and InfoPlist.strings files from an existing language
3. Translate the strings to the new language
4. Add the language to the project settings

## License

This project is licensed under the MIT License - see the LICENSE file for details. 