# 08012022-gia-hoang-nguyen-ios
## MyMovie
A simple app that retrieves information of iTunes medias.

#### About the author:
My name is Gia Nguyen. If you have any question or further information, feel free to contact me by **nhgia.apcs(at)gmail.com** and/or [LinkedIn](https://www.linkedin.com/in/nhgia/).


### Prerequisite
- XCode 13.1+

### Techs that applied into the Application
- This application using the MVVM. <br/>
- Other design patterns: Singleton, Dependency Injection.
- UIKit and Storyboards
- Libraries and dependencies: Alamofire (for network tasks), Kingfisher (for image loading & caching), CoreData (for store data locally).
- Install via Swift Package Manager (SPM) (why not CocoaPods: SPM is less time-consuming in setting up new project).

### Source code structure, libraries, and frameworks
- The structure of the project can be listed as below:
```swift

├── MyMovie
│   ├── Config          // Any client configuration
│   │   ├── Info.plist
│   │   ├── Production.xcconfig // Server url, bundleID, app name, app version.
│   │   ├── Staging.xcconfig    // Same key but different values for staging app.
│   │   └── ConfigKey.swift     // get values from xcconfig.
│   ├── Infrastructure  // The base layer of app's methods
│   │   ├── Extension          // Extend types
│   │   ├── CoreData           // CoreData methods
│   │   ├── Network            // Handle network tasks
│   ├── ApplicationModules // Any feature will be implemented here
│   │   ├── Base       // Anything related to the core of the App
│   │   │   ├── AppDelegate
│   │   │   ├── IB             // Interface builder files 
│   │   │   └── ViewController // Shared ViewController
│   │   └── <Any module name>
│   │       ├── Model
│   │       ├── View
│   │       └── ViewModel
│   ├── Resources
│   │   ├── Assets                
│   │   │   └── Assets.xcassets      // Local images/assets
│   │   └── CoreData  
│   │       └── MyMovie.xcdatamodeld // CoreData schema
├── MyMovie.xcodeproj
└── MyMovieTests    // Contains unit tests for any modules

```

### Timelines
I have done this project NOT in consecutive days due to current job's tasks.

However, the section below listed how I spend my most productive time for this project.

- **Aug 1st, 2022:** Received the Coding Challenge via Email.
- **Aug 3rd, 2022:** Read the project's requirements and init XCode project. Brainstorming. Add base files and directory tree **(1 hour of manday)**.
- **Aug 7th, 2022:** Finished half #1 feature (except for detail screen) **(1 manday)**.
- **Aug 8th, 2022:** Finished other half of #1 feature **(1 manday)**.
- **Aug 10th, 2022:** Add data change notify **(1 manday)**.
- **Total effort:** 3 mandays and 1 hour.

### How to run the Application
1. Please kindly download/clone the repo. <br/>
2. Open the file ```MyMovie.xcodeproj``` with Xcode 13.1+. <br/>
3. After launching the project, please wait SPM fetching all the libraries. You can find the progess at the bottom left of Xcode's project navigator. 
4. Press Command + R or click the Play button to run the application. The default build configuration is "Staging", simulates the environment for developing. You can change it in the "Edit scheme" to either "Staging" or "Production".


### Screenshots
<p align="center">
    <img width="24%" src="">
    <img width="24%" src="">
    <img width="24%" src="">
    <img width="24%" src="">

</p>
