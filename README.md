## SYBanner
</div>

![Commit](https://img.shields.io/github/last-commit/emrearmagan/SYBanner)
![Platform](https://img.shields.io/badge/platform-ios-lightgray.svg)
![Swift 5.0](https://img.shields.io/badge/Swift-5.0-orange.svg)
![iOS 13.0+](https://img.shields.io/badge/iOS-13.0%2B-blue.svg)
![MIT](https://img.shields.io/github/license/mashape/apistatus.svg)

----
**`A Minimalistic and Customizable Banner Library for iOS`**

SYBanner is a simple and clean banner library for iOS. It supports various banner types with flexible customization options, making it easy to integrate and tailor to your app's needs.

<div align="center">
<img src="./SYBannerDemo/SupportFiles/Preview/Overview.png" width= 100%>
</div>


## Features
- **Multiple Banner Types**: Simple, Default, Card, FullWidth, and more.
- **Predefined Configurations**: Use built-in styles like `info`, `success`, and `warning`.
- **Queueing and Stacking**: Automatically manage multiple banners without overlaps.
- **Custom Animations**: Built-in presenters like `Fade`, `Slide`, and `Bounce`, or create your own.
- **Interactive Elements**: Add buttons, custom views, or dynamic actions.
- **Customizable**: Tailor colors, fonts, icons, layouts, and corner radii.
- **Delegate Support**: Receive lifecycle callbacks for precise control.


### Quick start

##### SYSimpleBanner

<img src="./SYBannerDemo/SupportFiles/Preview/Simple.gif" width= 23%>

```swift
let banner = SYBanner("Link copied", direction: .top)
banner.present()
```

##### SYBanner:
<img src="./SYBannerDemo/SupportFiles/Preview/Default.gif" width= 23%>

```swift
let banner = SYDefaultBanner("A Banner with just a text", subtitle: "{subtitle}", direction: .top)
banner.present()
```

##### SYCardBanner
<img src="./SYBannerDemo/SupportFiles/Preview/gradient.gif" width= 23%>

```swift
let banner = SYCardBanner(title: "How to use", subtitle: "Simply download the notification banner and get started with your own notifications.")
banner.addButton(SYCardBannerButton(title: "Skip ", style: .dismiss)
banner.addButton(SYCardBannerButton(title: "Get started", style: .default, handler: {
    // Do something on button press
}))

// See Banner options for more
banner.setBannerOptions([
  .showExitButton(true),
  .customView(yourCustomView()),
  .buttonAxis(.horizontal),
  .titleFont(UIFont.systemFont(ofSize: 35, weight: .medium)),
  .titleColor(.gray),
  .buttonsHeight(50),
  .customViewInsets(.init(top: 20, left: 0, bottom: 40, right: 0)),
])

banner.dismissOnSwipe = false
banner.show()
```


### Configuration
SYBanner provides a flexible and centralized way to customize its appearance and behavior using Configuration. Each configuration allows you to define styles for text, background, icons, alignments, and more. You can either use the default configuration or create custom ones.


<div align="center">
<img src="./SYBannerDemo/SupportFiles/Preview/Info.gif" width= 30%>
<img src="./SYBannerDemo/SupportFiles/Preview/Success.gif" width= 30%>
<img src="./SYBannerDemo/SupportFiles/Preview/Warning.gif" width= 30%>
</div>


###### Custom Configuration
To create a custom configuration, initialize an instance of SYBanner.Configuration with your desired parameters. For example:
```swift
let customConfig = SYBanner.Configuration(
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

let banner = SYBanner(
    "Custom Banner",
    subtitle: "This banner uses a custom configuration.",
    configuration: customConfig,
    direction: .top
)
banner.present()
```


###### Predefined Configurations
SYBanner includes predefined configurations for common scenarios: Info, Success, and Warning. These configurations are ready to use and include preset styles for text, icons, and background colors.
```swift
let infoBanner = SYBanner(
    "Information",
    subtitle: "This is an informational banner.",
    configuration: .info()
)
banner.present()
```


### Queue
The SYBannerQueue system provides queue management to handle multiple banners. It ensures that banners are displayed sequentially, limits the number of banners visible at a time, and automatically adjusts the position of banners when others are dismissed.

<div align="center">
<img src="./SYBannerDemo/SupportFiles/Preview/Stacking.gif" width= 40%>
<img src="./SYBannerDemo/SupportFiles/Preview/Dynamic.gif" width= 40%>
</div>

- **Stacking**: Manage multiple banners and define how many can appear simultaneously.
- **Dynamic Animations**: Automatically animates banners to adjust their positions when one is dismissed.
- **Queue Positioning**: Decide whether to add a banner at the front or back of the queue.
- **Customizable Limit**: Set the maximum number of visible banners.
- **Automatic and Manual Dismissal**: Remove banners programmatically or let them dismiss themselves after a delay.


By default each banner is placed at the at the end of the queue. If your want to display the banner immediately place it at the front of the queue.
```swift
let queue = SYBannerQueue.default
let banner1 = SYBanner("Banner 1", direction: .top, queue: queue)
let banner2 = SYBanner("Banner 2", direction: .top, queue: queue)
let banner3 = SYBanner("Banner 3", direction: .top, queue: queue)

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
The SYBannerPresenter protocol and its various implementations define how banners are presented and dismissed with animations. Presenters control the lifecycle of banners and provide the flexibility to customize their animations for a wide range of use cases.
<div align="center">
<img src="./SYBannerDemo/SupportFiles/Preview/Bounce.gif" width= 40%>
<img src="./SYBannerDemo/SupportFiles/Preview/Fade.gif" width= 40%>
</div>

##### Using a Presenter
Each banner has a presenter property that determines its animation behavior. For instance, you can use the `SYDefaultPresenter` for basic animations or swap it for a more dynamic presenter like `SYBouncePresenter`.


| Presenter | Demo |
| -------- | ---- |
| *Default* | <img src="./SYBannerDemo/SupportFiles/Preview/Presenter_Default.gif" width="200" align="center"> |
| *Fade* | <img src="./SYBannerDemo/SupportFiles/Preview/Presenter_Fade.gif" width="200" align="center"> |
| *Scale* | <img src="./SYBannerDemo/SupportFiles/Preview/Presenter_Scale.gif" width="200" align="center"> |
| *Bounce* | <img src="./SYBannerDemo/SupportFiles/Preview/Presenter_Bounce.gif" width="200" align="center"> |


```swift
let banner = SYSimpleBanner("Dynamic Banner", presenter: SYBouncePresenter(animationDuration: 0.4))
banner.present()

```

##### Creating a Presenter
You can create your own presenters by conforming to the `SYBannerPresenter` protocol or the `SYDefaultPresenter`. For instance, here's an example of a custom slide-in animation
```swift
class CustomSlidePresenter: SYDefaultPresenter {
    override public func presentationAnimator(_ banner: SYBaseBanner, in superview: UIView) -> UIViewPropertyAnimator {
        let animator = UIViewPropertyAnimator(duration: animationDuration, curve: .easeInOut)

        animator.addAnimations {
            banner.frame = self.finalFrame(for: banner, in: superview)
        }

        return animator
    }

    override public func dismissAnimator(_ banner: SYBaseBanner, in superview: UIView) -> UIViewPropertyAnimator {
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
`SYBanner` includes the `SYBannerHighlighter` protocol, which allows developers to define custom highlighter behavior. It also provides a default implementation, SYDefaultHighlighter, for standard highlighting effects.

<img src="./SYBannerDemo/SupportFiles/Preview/Highlighter.gif" width= 40%>

##### Using a Highlighter
You can assign a highlighter to a banner by setting its highlighter property. By default, banners use SYDefaultHighlighter.
```swift
let banner = SYSimpleBanner("Dynamic Banner")
banner.highlighter = SYDefaultHighlighter(animationScale: 0.9, animationDuration: 0.2)
banner.present()
```

##### Creating a Highlighter
You can implement the `SYBannerHighlighter` protocol to define custom behavior. For example, you might want to add a rotation effect along with scaling:
```swift
class CustomHighlighter: SYBannerHighlighter {
    private let rotationAngle: CGFloat = .pi / 12
    private let animationDuration: TimeInterval = 0.3

    func highlight(_ button: SYBaseBanner, at location: CGPoint) {
        UIView.animate(withDuration: animationDuration) {
            button.transform = CGAffineTransform(scaleX: 0.9, y: 0.9).rotated(by: self.rotationAngle)
        }
    }

    func stopHighlight(_ button: SYBaseBanner) {
        UIView.animate(withDuration: animationDuration) {
            button.transform = .identity
        }
    }

    func locationMoved(_ button: SYBaseBanner, to location: CGPoint) {
        // Optional: Track touch location and adjust highlighting
    }
}
```

### Feedback
The feedback system in SYBanner is designed to provide haptic or visual cues when a banner is displayed.
SYBanner includes the SYBannerFeedback protocol, which allows you to define custom feedback behavior. It also provides default implementations for common feedback types, such as haptic feedback.
You can assign feedback to a banner by setting its feedback property. By default, banners use .impact(style: .light).
```swift
let banner = SYSimpleBanner("Success!")
banner.feedback = .notification(type: .success)
banner.present()
````

##### Custom Feedback
To define custom feedback behavior, implement the SYBannerFeedback protocol. For example, you could play a sound effect or perform a visual animation:
```swift
class SoundFeedback: SYBannerFeedback {
    func generate() {
        // Play a sound or perform custom feedback
        AudioServicesPlaySystemSound(1057) // Example: system sound
    }
}

let banner = SYSimpleBanner("Success!")
banner.feedback = SoundFeedback()
banner.present()
```

### Delegate and User Interaction in SYBanner
SYBanner provides a simple way for handling banner events through the SYBannerDelegate protocol and direct closures for user interaction, such as taps or swipes.


##### Delegate
The SYBannerDelegate protocol allows you to respond to key lifecycle events of the banner, such as when it appears, disappears, or is dismissed.

```swift
class MyViewController: UIViewController, SYBannerDelegate {
  override func viewDidLoad() {
    let banner = SYSimpleBanner("Link copied", direction: .top)
    banner.delegate = self
    banner.show()
  }

  // Banner delegate
  func bannerWillAppear(_ banner: SYBaseBanner) {
    // Do something before the banner appears
  }

  func bannerDidAppear(_ banner: SYBaseBanner) {
    // Do something when the banner appeared
  }
  func bannerWillDisappear(_ banner: SYBaseBanner) {
    // Do something before the banner disappears
  }

  func bannerDidDisappear(_ banner: SYBaseBanner) {
    // Do something after the banner disappeared
  }
}
```

##### User interaction
SYBanner also provides closures for directly handling interactions, such as taps and swipes, without the need for a delegate. By default, these interactions dismiss the banner.
```swift
banner.onSwipe = { sender in
    // Do something on swipe
}

banner.didTap = {
    // Do something on tap
}
```

### Requirements
- Xcode 11
- iOS 13 or later
- Swift 5 or later


### Installation

##### Swift Package Manager
To integrate `SYBanner` into your project using Swift Package Manager, add the following to your Package.swift file:
```swift
dependencies: [
    .package(url: "https://github.com/emrearmagan/SYBanner.git")
]
``` 

##### CocoaPods
You can use CocoaPods to install SYBanner by adding it to your Podfile:

    pod 'SYBanner'

##### Installing SYBanner manually
1. Download SYBanner.zip from the last release and extract its content in your project's folder.
2. From the Xcode project, choose Add Files to ... from the File menu and add the extracted files.

### Contribute
Contributions are highly appreciated! To submit one:
1. Fork
2. Commit changes to a branch in your fork
3. Push your code and make a pull request
