# Token-Tracker-Improved
## Token Tracker App Explained and How to Run on a Computer
I will give a detailed explanation on how this app runs with its different files and how to run this app on your computer.

## Overview:
Token tracker is an app that presents to the user their current speed through their iPhone’s speedometer and the speed limit of the road they are driving on through Overpass API. The user will first signup/login in the app. The authentication for the user login and sign up is done through Google Firebase, and the database to store user information such as their name and email is stored on Google Firestore Database. So far, the app has been implanted so the signup/login, detecting their speed limit, and parsing overpass API to determine the road’s speed limit has been implemented. In the future, we hope we can implement blockchain into the app so the user’s driving data can be stored in a secure way. Currently, the app doesn’t store the user’s driving data. 

## CocaPods:
The app uses pods, which are 3rd party libraries. The app uses 
```
pod 'Firebase/Core'
pod 'Firebase/Auth'
pod 'Firebase/Firestore'
```
Firebase/Core allows the app to access Google Firebase servers. Firebase/Auth allows the app to access the authentication aspect of Firebase which allows users to sign up, login, and reset their password. Firebase/Firestore is the database which the app stores the user’s email and name.

## .xcodeproj vs .xcworkspace
There are two main files extensions for the main project: .xcodeproj and .xcworkspace. The extension .xcodeproj is the app before pods were installed, and .xcworkspace is the app after the pods were installed. USE .XCWORKSPACE WHEN RUNNING THE APP. .XCODEPROJ IS THE OUTDATED FILE.

## Files:
There are two types of files in the app: storyboards and viewControllerSwiftFiles. Storyboards are files where you can design the app, while the viewControllerSwiftFiles is where all the code is. Each storyboard contains view controllers, which are app screens (this is where you can add labels, buttons, and etc to each app screen). Each view controller has a viewControllerSwiftFile so you can program the view controller to do stuff such as expanding an image when you click on it.

In the “TokenTrackerImproved” folder, all the files of the app is contained.

## Configure Folder:
The Configure folder contains all the files that allows the app to boot up. 

## Log In & Sign In Folder:
This folder houses all the files that allow the user to sign up/login. There is a Main.storyboard where the sign up/login design is created. Main.storyboard is the first storyboard the user will see. There are 5 view controllers in the storyboard, and as a result, there are 5 viewControllerSwiftFiles. FirstViewController is just a white screen in the storyboard, and the swift file checks if the user is currently signed in. If the user is signed in, it will take the user to the HomeViewController, which is in the storyboard Home. If the user is not signed in, the user will be taken to the TitleScreenViewController. TitleScreenViewController displays two options: sign up or login. If the user clicks on sign up, they will be presented with the SignUpViewController, where they can sign up. If the user click on login, they will be presented with the LoginViewController. If the user forgot their password, the user can click on the forgot password button in the LoginViewController. This will cause the PasswordViewController screen to appear, where they can reset their password. 

Note : All these view controllers I talked about except for the FirstViewController are connected to each other by a Navigation Controller. The navigation controller allows the screens to be connected so when the user clicks on the back button, the previous screen will show.

## Utilities Swift File:
This file is a generic file where I stored common functions such as creating boarders on buttons, removing error labels, displaying error labels, and etc.

## Home Storyboard and Home ViewControllerSwiftFile:
The home storyboard is where the Home view controller is located. The Home view controller displays the user’s speed and the speed limit of the street. The HomeViewController is the swift code that does the backend for the view controller such as parsing API’s to determine the speed limit of the road. 

## View Controllers Structure
Each view controller will contain "override func viewDidLoad()" This is the main function of each viewControllerSwiftFile. From this function, all other functions will be called.
```
override func viewDidLoad() {
  print("Hello world!")
  testInternetConnection()
}
```
View controllers will often have "@IBOutlet var" These @IBOutlet var connect the objects of the view controller from the storyboard to it's viewControllerSwiftFile. For example, we can use @IBOutlet var to connect a label on the view controller to its viewControllerSwiftFile so we can programatiicaly change the label's color when the user enters their password wrong. 
```
@IBOutlet var errorLabel: UILabel!
```
"@IBAction func" are functions that run when a button is clicked on the view controller.
```
@IBAction func logOutClicked(_ sender: Any) {
  handleSignOut()
}
```
***Note: for each viewControllerSwiftFile, there are in-line comments to explain what each line of code does.***

***In HomeViewController, there are detailed comments about the code. Read through HomeViewController before trying to read and understand other files because once you read HomeViewController, it will be much easier to understand other files.***

## Assets.xcassets folder:
This folder contains all the images for the app. 

# How to Run this App:
To run this app, you need a Mac application called Xcode. Xcode is an application to create iOS, Mac OS, Watch OS, and TV OS apps.

1. Download this source code
2. unzip "Pods.zip"
3. Open the file “TokenTrackerImproved.xcworkspace” which should open in Xcode
4. On the top left of Xcode, press the play button icon. This will build the app and run the app on Xcode App Simulator. 

For more information on this app, feel free to contact me (Enoch Johnson) at enochdavidj@gmail.com
