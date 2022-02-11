# swile-test

### Installation instructions 🛠

I used Cocoapods without a Gemfile, only a pod install is needed:

Step 1: *git clone*
Step 2: *pod install*

### Application Architecture 🏛

##### App

In this folder you may find the AppDelegate and the AppCoordinator.
The AppCoordinator is the only Coordinator of the application since there is not many flow.
The Coordinator architecture is not really reflected on this Sample Project.

##### Commons / UICommons

In those folder you will find some helpers that are use through the app
Since Thos kind of folder tend to get quite big really fast I generally prefer putting all UI helpers separately.

##### Design

This is where the design system of the application is defined.
This part aim to be move in an external library or at least in a module.
This is why you can find many class/struct which are `public`

##### Features

A folder regrouping each Feature. In a bigger application it would be nice to regroup those features in separate modules.
This application contains only two features, the transactions list and the transaction details.

### External Libraries 📚

##### RxSwift

I chose RxSwift for the reactive part of the application because it is the one I'm moste used to.
I already tried a bit of Combine with a SwitUI test but I am more confortable with RxSwift at the moment.

##### SnapKit

When I arrived at BlaBlaCar I discovered SnapKit and the possibility to not used Storyboard, it was a revelation to me.
I really prefer to create UI using SnapKit, especially when the project get bigger and multiple people are working on it at the same time.

##### SwiftGen

I tried SwiftGen recently on another project and find it quite useful, at least for a small project, that why I reused it here.

##### SwiftLint

Clean code is quite important to me, that is why the first thing I add in a project is often SwiftLint.

### Time spent ⧗

- ~1h to read the subject, initialised the project and setup my environment
- ~2h to implement the basis of the Design System (Colors, Font) and create the first VM + VC with a header
- ~1h to implement the API Call
- ~3h to implement to create the Transaction Design and display the list with section headers
- ~1h to implement the testing of the `TransactionViewModel`
- ~1h to create the second VM + VC with the detailed header

### What I would like to do next 🤔

- Finish the Transaction Detail screen
- Implement the animation between the two screen (Maybe use Hero pod considering the time available)
- Add more testing. (`DateFormatter`, `TransactionsRepository`, ...)
- Add SnapshotTesting for Design Components
