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

### Persistence
This app uses Core Data to store persistant data. 
The data schema is designed as below
<center><img width="70%" src="https://user-images.githubusercontent.com/40845574/184281888-906c92ba-f015-4789-a7ab-b5e9a97b1bdb.png"></center> 

- **FetchInfo:** Store the previous time visited by user.
- **MovieItem:** Store each item of movie retrieved from iTunes API.  

### Timelines
I have done this project NOT in consecutive days due to current job's tasks.

However, the section below listed how I spend my most productive time for this project.

- **Aug 1st, 2022:** Received the Coding Challenge via Email.
- **Aug 3rd, 2022:** Read the project's requirements and init XCode project. Brainstorming. Add base files and directory tree **(1 hour of manday)**.
- **Aug 7th, 2022:** Finished half #1 feature (except for detail screen) **(1 manday)**.
- **Aug 8th, 2022:** Finished other half of #1 feature **(1 manday)**.
- **Aug 10th, 2022:** Add data change notify **(1 manday)**.
- **Aug 12th, 2022:** Add #2 feature and finalize the app **(1 manday)**.
- **Total effort:** 4 mandays and 1 hour.

### How to run the Application
1. Please kindly download/clone the repo. <br/>
2. Open the file ```MyMovie.xcodeproj``` with Xcode 13.1+. <br/>
3. After launching the project, please wait SPM fetching all the libraries. You can find the progess at the bottom left of Xcode's project navigator. 
4. Press Command + R or click the Play button to run the application. The default build configuration is "Staging", simulates the environment for developing. You can change it in the "Edit scheme" to either "Staging" or "Production".


### Screenshots
<p align="center">
    <img width="24%" src="https://user-images.githubusercontent.com/40845574/184281743-13e57f13-c6cc-4ad1-a62e-5f642e31a2cb.png">
    <img width="24%" src="https://user-images.githubusercontent.com/40845574/184284305-9943779c-9907-4b18-8412-afc09a6228c3.png">
    <img width="24%" src="https://user-images.githubusercontent.com/40845574/184281764-6f257b4a-5dbe-4180-8521-cbbb42954a96.png">
    <img width="24%" src="https://user-images.githubusercontent.com/40845574/184281765-11a79918-8dea-41c0-854b-7c5bf7fe4785.png">
</p>

<p align="center">
    <img width="24%" src="https://user-images.githubusercontent.com/40845574/184281760-6d76361e-deb3-4a8c-a957-a179419d520a.png">
    <img width="24%" src="https://user-images.githubusercontent.com/40845574/184281759-598dbc9c-df0f-4e3c-a282-64a17f6768ff.png">
    <img width="24%" src="https://user-images.githubusercontent.com/40845574/184281753-a4371144-0af7-4c13-9bf3-a225d15637d4.png">
    <img width="24%" src="https://user-images.githubusercontent.com/40845574/184283734-702ab53d-71bd-4f1f-8776-3d444236f67b.png">
</p>