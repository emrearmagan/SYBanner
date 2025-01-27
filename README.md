## Notifly
</div>

![Commit](https://img.shields.io/github/last-commit/emrearmagan/Notifly)
![Platform](https://img.shields.io/badge/platform-ios-lightgray.svg)
![Swift 5.0](https://img.shields.io/badge/Swift-5.0-orange.svg)
![iOS 13.0+](https://img.shields.io/badge/iOS-13.0%2B-blue.svg)
![MIT](https://img.shields.io/github/license/mashape/apistatus.svg)

----
**`A Minimalistic and Customizable Notification Library for iOS`**

Notifly is a lightweight notification library for iOS. It provides multiple notifications types and customization options, making it straightforward to integrate and adapt to your requirements.

[📖 Documentation](https://emrearmagan.github.io/Notifly/)

<div align="center">
<img src="./Example/NotiflyExample/Supporting Files/Preview/Overview.png" width= 100%>
</div>

> **⚠️ Important**  
> The current version is still in development. There can and will be breaking changes in version updates until version 1.0.


## Features
- **Multiple Banner Types**: Simple, Default, Card, FullWidth, and more.
- **Predefined Configurations**: Use built-in styles like `info`, `success`, and `warning`.
- **Queueing and Stacking**: Automatically manage multiple banners without overlaps.
- **Custom Animations**: Built-in presenters like `Fade`, `Slide`, and `Bounce`, or create your own.
- **Interactive Elements**: Add buttons, custom views, or dynamic actions.
- **Customizable**: Tailor colors, fonts, icons, layouts, and corner radii.
- **Delegate Support**: Receive lifecycle callbacks for precise control.


### Quick start

##### Simple Notification

<img src="./Example/NotiflyExample/Supporting Files/Preview/Simple.gif" width= 30%>

```swift
let banner = SimpleNotifly("Link copied", direction: .top)
banner.present()
```

##### Default Notification:
<img src="./Example/NotiflyExample/Supporting Files/Preview/Default.gif" width= 30%>

```swift
let banner = Notifly("A Banner with just a text", subtitle: "{subtitle}", direction: .top)
banner.present()
```

##### Card Notification
<img src="./Example/NotiflyExample/Supporting Files/Preview/CardView.png" width= 30%>

The `CardNotifly` provides a customizable and visually appealing card-style banner that can include titles, subtitles, buttons, and custom views. It is designed to offer a clean and engaging way to present information or actions to users. However, it's important to note that this is still a banner and can be dismissed by the user at any time. Your app should not depend on the `CardNotifly` for critical actions or information. If you need to present a modal page where the user cannot leave, please check out [ModalKit](https://github.com/emrearmagan/ModalKit) which may be more suited.

> **⚠️ Experimental**  
> The `CardNotifly` is currently experimental and should not be used in production. Feel free to contribute and help improve this feature!

```swift
let banner = CardNotifly(title: "How to use", subtitle: "Simply download the notification banner and get started with your own notifications.")
banner.addButton(CardNotiflyButton(title: "Skip ", style: .dismiss))
banner.addButton(CardNotiflyButton(title: "Get started", style: .default, handler: {
    // Do something on button press
}))

// See Banner options for more
banner.setBannerOptions([
  .showExitButton(true),
  .customView(yourCustomView()),
])

banner.dismissOnSwipe = false
banner.show()
```

##### Custom Notification
The `BaseNotifly` allows you to create completely customized banners by overriding its properties and methods. With full control over the UI and behavior, you can design banners tailored to your needs.

```swift
class MyCustomBanner: BaseNotifly {
    override init(direction: NotiflyDirection, queue: NotiflyQueue = .default, on parent: UIViewController? = nil) {
        super.init(direction: direction, queue: queue, on: parent)
        setupUI()
    }

    func setupUI() {
         // Create the banner's appearance
    }
}

let banner = MyCustomBanner(direction: .top)
banner.present()
```

### Configuration
Notifly provides a simple way to customize its appearance and behavior using Configuration. Each configuration allows you to define styles for text, background, icons, alignments, and more. You can either use the default configuration or create custom ones.

<div align="center">
<img src="./Example/NotiflyExample/Supporting Files/Preview/Info.gif" width= 33%>
<img src="./Example/NotiflyExample/Supporting Files/Preview/Success.gif" width= 33%>
<img src="./Example/NotiflyExample/Supporting Files/Preview/Warning.gif" width= 33%>
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

let banner = Notifly(
    "Custom Banner",
    subtitle: "This banner uses a custom configuration.",
    configuration: customConfig,
    direction: .top
)
banner.present()
```


###### Predefined Configurations
Notifly includes predefined configurations for common scenarios: Info, Success, and Warning. These configurations are ready to use and include preset styles for text, icons, and background colors.
```swift
let infoBanner = Notifly(
    "Information",
    subtitle: "This is an informational banner.",
    configuration: .info()
)
banner.present()
```


### Queue
The NotiflyQueue system provides queue management to handle multiple banners. It ensures that banners are displayed sequentially, limits the number of banners visible at a time, and automatically adjusts the position of banners when others are dismissed.

<div align="center">
<img src="./Example/NotiflyExample/Supporting Files/Preview/Stacking.gif" width= 40%>
<img src="./Example/NotiflyExample/Supporting Files/Preview/Dynamic.gif" width= 40%>
</div>

- **Stacking**: Manage multiple banners and define how many can appear simultaneously.
- **Dynamic Animations**: Automatically animates banners to adjust their positions when one is dismissed.
- **Queue Positioning**: Decide whether to add a banner at the front or back of the queue.
- **Customizable Limit**: Set the maximum number of visible banners.
- **Automatic and Manual Dismissal**: Remove banners programmatically or let them dismiss themselves after a delay.


By default each banner is placed at the end of the queue. If you want to display the banner immediately, place it at the front of the queue.
```swift
let queue = NotiflyQueue.default
let banner1 = Notifly("Banner 1", direction: .top, queue: queue)
let banner2 = Notifly("Banner 2", direction: .top, queue: queue)
let banner3 = Notifly("Banner 3", direction: .top, queue: queue)

queue.addBanner(banner1, queuePosition: .back) // Add at the back of the queue
queue.addBanner(banner2, queuePosition: .front) // Add at the front of the queue
banner.present(queuePosition: .back)  // Add at the back of the queue

```

By default each banner will be dismissed after a time. If you want to disable that, set `autoDismiss` to `false` and dismiss manually:
```swift
banner.autoDismiss = false

// .. some long task
banner.dismiss()
```

### Presenter
The NotiflyPresenter protocol and its various implementations define how banners are presented and dismissed with animations. Presenters control the lifecycle of banners and provide the flexibility to customize their animations for a wide range of use cases.
<div align="center">
<img src="./Example/NotiflyExample/Supporting Files/Preview/Bounce.gif" width= 40%>
<img src="./Example/NotiflyExample/Supporting Files/Preview/Fade.gif" width= 40%>
</div>

##### Using a Presenter
Each banner has a presenter property that determines its animation behavior. For instance, you can use the `NotiflyDefaultPresenter` for basic animations or swap it for a more dynamic presenter like `NotiflyBouncePresenter`.

| Presenter | Demo |
| -------- | ---- |
| *Default* | <img src="./Example/NotiflyExample/Supporting Files/Preview/Presenter_Default.gif" width="200" align="center"> |
| *Fade* | <img src="./Example/NotiflyExample/Supporting Files/Preview/Presenter_Fade.gif" width="200" align="center"> |
| *Scale* | <img src="./Example/NotiflyExample/Supporting Files/Preview/Presenter_Scale.gif" width="200" align="center"> |
| *Bounce* | <img src="./Example/NotiflyExample/Supporting Files/Preview/Presenter_Bounce.gif" width="200" align="center"> |

```swift
let banner = SimpleNotifly("Dynamic Banner", presenter: NotiflyBouncePresenter(animationDuration: 0.4))
banner.present()
```

##### Creating a Presenter
You can create your own presenters by conforming to the `NotiflyPresenter` protocol or the `NotiflyDefaultPresenter`. For instance, here's an example of a custom slide-in animation:
```swift
class CustomSlidePresenter: NotiflyDefaultPresenter {
    override public func presentationAnimator(_ banner: NotiflyBaseBanner, in superview: UIView) -> UIViewPropertyAnimator {
        let animator = UIViewPropertyAnimator(duration: animationDuration, curve: .easeInOut)

        animator.addAnimations {
            banner.frame = self.finalFrame(for: banner, in: superview)
        }

        return animator
    }

    override public func dismissAnimator(_ banner: NotiflyBaseBanner, in superview: UIView) -> UIViewPropertyAnimator {
        let animator = UIViewPropertyAnimator(duration: animationDuration, curve: .easeInOut)

        animator.addAnimations {
            banner.frame = self.initialFrame(for: banner, in: superview)
        }

        return animator
    }
}
```

### Highlighter
Highlighters define the visual feedback when users interact with a banner, such as touch events like taps or drags. They are used to provide animations that emphasize the interaction, such as scaling or alpha changes.
`Notifly` includes the `NotiflyHighlighter` protocol, which allows developers to define custom highlighter behavior. It also provides a default implementation, NotiflyDefaultHighlighter, for standard highlighting effects.

<img src="./Example/NotiflyExample/Supporting Files/Preview/Highlighter.gif" width= 40%>

##### Using a Highlighter
You can assign a highlighter to a banner by setting its highlighter property. By default, banners use NotiflyDefaultHighlighter.
```swift
let banner = NotiflySimpleBanner("Dynamic Banner")
banner.highlighter = NotiflyDefaultHighlighter(animationScale: 0.9, animationDuration: 0.2)
banner.present()
```

##### Creating a Highlighter
You can implement the `NotiflyHighlighter` protocol to define custom behavior. For example, you might want to add a rotation effect along with scaling:
```swift
class CustomHighlighter: NotiflyHighlighter {
    private let rotationAngle: CGFloat = .pi / 12
    private let animationDuration: TimeInterval = 0.3

    func highlight(_ button: NotiflyBaseBanner, at location: CGPoint) {
        UIView.animate(withDuration: animationDuration) {
            button.transform = CGAffineTransform(scaleX: 0.9, y: 0.9).rotated(by: self.rotationAngle)
        }
    }

    func stopHighlight(_ button: NotiflyBaseBanner) {
        UIView.animate(withDuration: animationDuration) {
            button.transform = .identity
        }
    }

    func locationMoved(_ button: NotiflyBaseBanner, to location: CGPoint) {
        // Optional: Track touch location and adjust highlighting
    }
}
```

### Feedback
The feedback system in Notifly is designed to provide haptic or visual cues when a banner is displayed.
Notifly includes the NotiflyFeedback protocol, which allows you to define custom feedback behavior. It also provides default implementations for common feedback types, such as haptic feedback.
You can assign feedback to a banner by setting its feedback property. By default, banners use .impact(style: .light).
```swift
let banner = Notifly("Success!")
banner.feedback = .notification(type: .success)
banner.present()
````

##### Custom Feedback
To define custom feedback behavior, implement the NotiflyFeedback protocol. For example, you could play a sound effect or perform a visual animation:
```swift
class SoundFeedback: NotiflyFeedback {
    func generate() {
        // Play a sound or perform custom feedback
        AudioServicesPlaySystemSound(1057) // Example: system sound
    }
}

let banner = Notifly("Success!")
banner.feedback = SoundFeedback()
banner.present()
```

### Delegate and User Interaction in Notifly
Notifly provides a simple way for handling banner events through the NotiflyDelegate protocol and direct closures for user interaction, such as taps or swipes.

##### Delegate
The NotiflyDelegate protocol allows you to respond to key lifecycle events of the banner, such as when it appears, disappears, or is dismissed.

```swift
class MyViewController: UIViewController, NotiflyDelegate {
  override func viewDidLoad() {
    let banner = Notifly("Link copied", direction: .top)
    banner.delegate = self
    banner.show()
  }

  // Banner delegate
  func notificationWillAppear(_ notification: NotiflyBase) {
    // Do something before the banner appears
  }

  func notificationDidAppear(_ notification: NotiflyBase) {
    // Do something when the banner appeared
  }
  func notificationWillDisappear(_ notification: NotiflyBase) {
    // Do something before the banner disappears
  }

  func notificationDidDisappear(_ notification: NotiflyBase) {
    // Do something after the banner disappeared
  }
}
```

##### User interaction
Notifly also provides closures for directly handling interactions, such as taps and swipes, without the need for a delegate. By default, these interactions dismiss the banner.
```swift
banner.onSwipe = { sender in
    // Do something on swipe
}

banner.didTap = {
    // Do something on tap
}
```

### Options

| Option Name                   | Description                                                                                   |
|-------------------------------|-----------------------------------------------------------------------------------------------|
| `feedback`                    | The haptic feedback to be triggered when the banner is presented (`NotiflyFeedback`, default `.impact(style: .light)`). |
| `highlighter`                 | The highlighter responsible for handling touch interactions (`NotiflyHighlighter?`, default `NotiflyDefaultHighlighter()`). |
| `autoDismiss`                 | Indicates whether the banner should automatically dismiss itself after a specified interval (`Bool`, default `false`). |
| `autoDismissInterval`         | The time interval after which the banner will automatically dismiss itself, if `autoDismiss` is enabled (`TimeInterval`, default `2` seconds). |
| `didTap`                      | Closure executed when the banner is tapped (Default dismisses the banner). |
| `onSwipe`                     | Closure executed when the banner is swiped (Default dismisses the banner. |
| `direction`                   | The direction from which the banner will appear (e.g., `.top` or `.bottom`) |
| `delegate`                    | Delegate to handle banner lifecycle events (`NotiflyDelegate?`, default `nil`). |
| `presentationState`           | The current state of the banner during its lifecycle (`NotiflyState`, for example `.presenting` or `presented`). |
| `bannerType`                  | The type of the banner (e.g., stick or float) (`NotiflyType`, default `.float`). |
| `parentViewController`        | The parent view controller on which the banner is displayed (`UIViewController?`, default `nil`). |
| `hasBeenSeen`                 | Indicates whether the banner has been shown at least once (`Bool`, default `false`). |
| `notificationQueue`                 | The queue where the banner will be placed (`NotiflyQueue`, default `.default`). |



### Requirements
- Xcode 11
- iOS 13 or later
- Swift 5 or later


### Installation

##### Swift Package Manager
To integrate `Notifly` into your project using Swift Package Manager, add the following to your Package.swift file:
```swift
dependencies: [
    .package(url: "https://github.com/emrearmagan/Notifly.git")
]
``` 

##### CocoaPods
> **⚠️ Caution**  
> CocoaPods support has been dropped with version 0.1.0 Prior to that, support will not be existing. Using SPM is highly recommended.

##### Installing Notifly manually
1. Download Notifly.zip from the last release and extract its content in your project's folder.
2. From the Xcode project, choose Add Files to ... from the File menu and add the extracted files.

### Contribute
Contributions are highly appreciated! To submit one:
1. Fork
2. Commit changes to a branch in your fork
3. Push your code and make a pull request
