# Hearthstone Cards App

The Hearthstone Cards App is an iOS application that allows users to view cards from the Hearthstone game, categorized by faction. Users can navigate between different factions and see a list of cards associated with each one.

This app was developed as a demo project to showcase how to consume a RESTful API, process the received data, and display it in a user-friendly interface.

## Features

- View Hearthstone cards by faction (Alliance, Horde, Neutral).
- Update the list of cards when selecting a different faction.
- View details of a card by clicking on it in the list.

## Requirements

- iOS device running iOS 13.0 or later.
- Internet connection to load cards from the API.

## How to Use

1. Clone or download the repository to your local machine.
2. Open the project in Xcode.
3. Run the app on a simulator or connected iOS device.

## Project Architecture

- **Hearthstone**: Contains all the source code of the app.
  - **Controllers**: Contains the view controller classes.
  - **Models**: Contains the data models used in the app.
  - **Views**: Contains custom view classes.
  - **Interactors**: Contains classes responsible for business logic and interaction with the API.
  - **Services**: Contains services responsible for making HTTP requests to the API.
  - **Utilities**: Contains utility and helper classes.
  - **Supporting Files**: Contains configuration files, such as the app information file and asset files.

## Technologies Used

- **Swift**: Programming language used to develop the app.
- **UIKit**: Framework used to build the user interface.
- **URLSession**: Framework used to make HTTP requests to the API.
- **JSONDecoder**: Used to decode the data received from the API into Swift objects.
- **Combine**: Framework used for handling asynchronous operations with data streams.
- **XCTest**: Framework used to write unit tests.

## Contributing

Contributions are welcome! If you'd like to contribute to this project, follow these steps:

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/MyFeature`)
3. Commit your changes (`git commit -am 'Add a new feature'`)
4. Push to the branch (`git push origin feature/MyFeature`)
5. Create a new Pull Request

## Author

This app was developed by Járede Lima.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.
