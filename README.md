## Notifly
</div>

![Commit](https://img.shields.io/github/last-commit/emrearmagan/Notifly)
![Platform](https://img.shields.io/badge/platform-ios-lightgray.svg)
![Swift 5.0](https://img.shields.io/badge/Swift-5.0-orange.svg)
![iOS 13.0+](https://img.shields.io/badge/iOS-13.0%2B-blue.svg)
![MIT](https://img.shields.io/github/license/mashape/apistatus.svg)

----
**`A Minimalistic and Customizable Notification Library for iOS`**

Notifly is a simple notification library for iOS. It supports various notification types with customization options, making it easy to integrate

[📖 Documentation](https://emrearmagan.github.io/Notifly/)

<div align="center">
<img src="./Example/Notifly/Supporting Files/Preview/Overview.png" width= 100%>
</div>

> **⚠️ Important**  
> The current version is still in development. There can and will be breaking changes in version updates until version 1.0.


## Features
- **Multiple Notification Types**: Simple, Default, Card, FullWidth, and more.
- **Predefined Configurations**: Use built-in styles like `info`, `success`, and `warning`.
- **Queueing and Stacking**: Automatically manage multiple notifications without overlaps.
- **Custom Animations**: Built-in presenters like `Fade`, `Slide`, and `Bounce`, or create your own.
- **Interactive Elements**: Add buttons, custom views, or dynamic actions.
- **Customizable**: Tailor colors, fonts, icons, layouts, and corner radii.
- **Delegate Support**: Receive lifecycle callbacks for precise control.


### Quick start

##### Notifly:
<img src="./Example/NotiflyS/upporting Files/Preview/Default.gif" width= 30%>

```swift
let notification = Notifly("A Notification with just a text", subtitle: "{subtitle}", direction: .top)
notification.present()
```

##### Simple

<img src="./Example/Notifly/Supporting Files/Preview/Simple.gif" width= 30%>

```swift
let notification = SimpleNotifly("Link copied", direction: .top)
notification.present()
```

##### Card Notification
<img src="./Example/Notifly/Supporting Files/Preview/CardView.png" width= 30%>

The `NotiflyCard` provides a customizable and visually appealing card-style notification that can include titles, subtitles, buttons, and custom views. It is designed to offer a clean and engaging way to present information or actions to users. However, it's important to note that this is still a notification and can be dismissed by the user at any time. Your app should not depend on the `NotiflyCardNotification` for critical actions or information. If you need to present a modal page where the user cannot leave, please check out [ModalKit](https://github.com/emrearmagan/ModalKit) which may be more suited.

> **⚠️ Experimental**  
> The `NotiflyCardNotification` is currently experimental and should not be used in production. Feel free to contribute and help improve this feature!

```swift
let notification = NotiflyCard(title: "How to use", subtitle: "Simply download the notification banner and get started with your own notifications.")
notification.addButton(.init(title: "Skip ", style: .dismiss)
notification.addButton(.init(title: "Get started", style: .default, handler: {
    // Do something on button press
}))

// See Notification options for more
notification.setNotificationOptions([
  .showExitButton(true),
  .customView(yourCustomView()),
])

notification.dismissOnSwipe = false
notification.show()
```

##### Custom Notification
The `NotiflyBase` allows you to create completely customized notifications by overriding its properties and methods. With full control over the UI and behavior, you can design notifications tailored to your needs.

```swift
class MyCustomNotification: NotiflyBase {
    override init(direction: NotiflyDirection, queue: NotiflyQueue = .default, on parent: UIViewController? = nil) {
        super.init(direction: direction, queue: queue, on: parent)
        setupUI()
    }

    func setupUI() {
         // Create the notification's appearance
    }
}

let notification = MyCustomNotification(direction: .top)
notification.present()
```

### Configuration
Notifly provides a simple way to customize its appearance and behavior using Configuration. Each configuration allows you to define styles for text, background, icons, alignments, and more. You can either use the default configuration or create custom ones.


<div align="center">
<img src="./Example/Notifly/Supporting Files/Preview/Info.gif" width= 33%>
<img src="./Example/Notifly/Supporting Files/Preview/Success.gif" width= 33%>
<img src="./Example/Notifly/Supporting Files/Preview/Warning.gif" width= 33%>
</div>


###### Custom Configuration
To create a custom configuration, initialize an instance of Notifly.Configuration with your desired parameters. For example:
```swift
let customConfig = Notifly.Configuration(
    titleColor: .white,
    titleFont: .systemFont(ofSize: 18, weight: .semibold),
    subtitleColor: .gray,
    subtitleFont: .systemFont(ofSize: 14, weight: .regular),
    backgroundColor: .default(.blue),
    icon: .init(image: UIImage(systemName: "bell.fill"), tintColor: .white),
    cornerRadius: .rounded,
    textAlignment: .leading,
    contentAlignment: .center,
    imagePadding: 10,
    titleSubtitleSpacing: 4
)

let notification = Notifly(
    "Custom Notification",
    subtitle: "This notification uses a custom configuration.",
    configuration: customConfig,
    direction: .top
)
notification.present()
```

---

### Installation

##### Swift Package Manager
To integrate `Notifly` into your project using Swift Package Manager, add the following to your Package.swift file:
```swift
dependencies: [
    .package(url: "https://github.com/emrearmagan/Notifly.git")
]
``` 

##### CocoaPods
You can use CocoaPods to install Notifly by adding it to your Podfile

> **⚠️ Caution**  
> CocoaPods support dropped with version 0.1.0 Prior to that, support will be minimal. Using SPM is highly recommended.

##### Installing Notifly manually
1. Download Notifly.zip from the last release and extract its content in your project's folder.
2. From the Xcode project, choose Add Files to ... from the File menu and add the extracted files.

---
