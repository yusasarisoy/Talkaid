<div align="center">
  <img width="100" height="100" alt="Talkaid" src="https://i.ibb.co/F8gvwDC/talkaid.png">
  </br>
  <h1><b>Talkaid</b></h1>
</div>

<div align="center">

![](https://img.shields.io/badge/Editor-Xcode-informational?style=flat&logo=xcode&logoColor=white&color=a874d1) ![](https://img.shields.io/badge/Language-Swift-informational?style=flat&logo=swift&logoColor=white&color=a874d1) ![](https://img.shields.io/badge/UI%20Framework-SwiftUI-informational?style=flat&logo=swift&logoColor=white&color=a874d1)

</div>

Talkaid is an interactive messaging iOS app that allows users to engage in conversations with an AI assistant. Users have the option to interact with the AI assistant through text input via the keyboard or by sending voice messages, facilitating seamless communication.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Usage](#usage)
- [Technical Details](#technical-details)
- [Architecture](#architecture)
- [Features](#features)
- [Unit Tests](#unit-tests)
- [Possible Improvements](#possible-improvements)

## Prerequisites

- iOS device or simulator running iOS 15.0 or later.
- Xcode 13.0 or later.

## Installation

1. Clone or download the repository.
2. Open the project in Xcode.
5. Connect your iOS device or choose a simulator.
6. Build and run the application.

## Usage

1. Launch the Talkaid on your iOS device or simulator.
2. The application will prompt for your permission to enable voice message functionality, granting you the capability to send audio messages to the AI assistant.
3. You are now fully equipped and prepared to utilize the application's extensive features and functionalities to meet your needs effectively. 

## Technical Details

- The app is written in Swift.
- [SwiftUI](https://developer.apple.com/xcode/swiftui/) was used as the UI framework to take advantage of declarative programming capabilities.
- The app follows the MVVM architectural pattern for better code organization and separation of concerns.
- The app uses networking capabilities to fetch data from the mock API.
- The responses from AI assistant are loaded asynchronously using.
- [SwiftLint](https://github.com/realm/SwiftLint) has used to enforce Swift style and conventions and keeping the codebase consistent.
- The **Network** layer handles communication with the data sources. It serves as an intermediary between the data consumer and the data sources, shielding the consumer from dealing with the intricacies of manipulating the data. This layer provides flexibility in changing data sources without impacting other components.

## Architecture

The Chat App follows the MVVM (Model-View-ViewModel) architecture to ensure a clear separation of concerns and maintainable codebase. The architecture is structured as follows:

- **View**: Responsible for displaying data and user interactions. Implemented using SwiftUI.
- **ViewModel**: Handles the business logic and state management of the app. Contains the necessary functions and properties to interact with the View and API Manager.
- **API Manager**: Handles the communication with the mocked API. It connects to the server through a REST API and simulates the responses. The Service class includes methods such as `sendMessage() async throws` to send a message to the server and receive a response.

## Features

- Seamless messaging experience: Users can send and receive messages in real-time.
- Message delay simulation: Upon sending a message, the app simulates a delay before displaying the received answer to mimic server processing.
- Animation feedback: During the message delay, a simple animation is shown to indicate that the app is processing the request.
- Dark mode support: The app's colors are carefully designed to ensure a professional look, even in dark mode.
- Voice mode entry: Users can send the voice messages, which are transcribed into text and added to the main text field. An animation reacts to the loudness of the microphone input.

## Unit Tests

The project includes a comprehensive suite of unit tests to ensure the quality and reliability of the code. Although not all functions are tested, the included tests cover critical functionalities, such as message sending, message delay simulation, and API response handling. The tests are written using [XCTest](https://developer.apple.com/documentation/xctest) framework and can be found in the dedicated test target.

## Possible Improvements

- Add an onboarding module after the app has multiple features. So that the user can easily understand about the capabilities of the app.
- Add language support to extend the reachability of the app worldwide.
- Add CI/CD tool(s) to automate release processes and regularly check the content of commits for a more concise codebase.
- Add a beautiful and pleasant animated splash screen to make the user's first impression and grab their attention.
- Extend the reach of the app by developing versions for other Apple platforms, such as iPad or macOS. This can help you reach a wider audience and ensure a consistent user experience across different Apple devices.
- Expand the app's test coverage by implementing integration tests, behavior driven tests, snapshot tests and UI tests beside unit tests. Continuously test the app for bugs, performance issues, and usability problems to ensure a high-quality user experience.
- Make UI/UX Enhancements continuously to improve the user interface and experience by incorporating modern design principles, animations, and intuitive interactions.
- Add accessibility support to ensure that people with visual impairments can use the app comfortably.
- Enhance error handling by providing meaningful error messages to users when network requests fail or other errors occur.
- Implement crash reporting tools such as Crashlytics to collect crash logs and error reports for easier debugging and issue resolution.
- Implement push notifications to enable proactive communication with users. This could involve sending relevant announcements, or reminders to keep users engaged with the app.
- Provide options for users to personalize their app experience, such as choosing themes, customizing layouts, or setting preferences.
- Add analytics tools to gather data on user behavior, usage patterns, and performance metrics. This can help make useful decisions for future improvements.
- Improve app security to protect user data and ensure secure communication with the backend services. Implement best practices like encryption, secure storage, and secure network connections.
