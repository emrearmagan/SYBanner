//
//  ExampleViewController.swift
//  NotiflyExample
//
//  Created by Emre Armagan on 07.04.22.
//

import Notifly
import UIKit

enum NotifcationExample: Int, CaseIterable {
    case simple
    case `default`
    case info
    case warning
    case success
    case stacked
    case dynamic
    case gradient
    case sticky
    case custom1
    case custom2
    case custom3
    case custom4
    case card1
    case card2

    var description: String {
        switch self {
            case .simple: return "Simple"
            case .default: return "Default"
            case .info: return "Info"
            case .warning: return "Warning"
            case .success: return "Success"
            case .stacked: return "Stacked"
            case .dynamic: return "Dynamic"
            case .gradient: return "Gradient"
            case .sticky: return "Sticky"
            case .custom1: return "Custom 1"
            case .custom2: return "Custom 2"
            case .custom3: return "Custom 3"
            case .custom4: return "Custom 4"
            case .card1: return "Card 1"
            case .card2: return "Card 2"
        }
    }
}

class ExampleViewController: UIViewController {
    // MARK: - Properties

    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private let max3BannersQueue = NotiflyQueue(maxNotificationsOnScreen: 3)
    private let defaultQueue = NotiflyQueue.default

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureButtons()
    }

    // MARK: - Methods

    private func setupUI() {
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
        stackView.distribution = .fill

        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -16),

            stackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -32)
        ])
    }

    private func configureButtons() {
        for type in NotifcationExample.allCases {
            let button = createButton(for: type)
            stackView.addArrangedSubview(button)
        }
    }

    private func createButton(for type: NotifcationExample) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(type.description, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.tag = type.rawValue
        button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        return button
    }

    // MARK: - Actions

    @objc private func didTapButton(_ sender: UIButton) {
        guard let type = NotifcationExample(rawValue: sender.tag) else { return }
        showExample(type)
    }

    private func showExample(_ example: NotifcationExample) {
        max3BannersQueue.dismissAll()

        switch example {
            case .simple:
                let banner = SimpleNotifly("Link copied", direction: .top)
                banner.present(queuePosition: .front)

            case .default:
                let banner = Notifly("Welcome to SYBanner!", subtitle: "{subtitle}", direction: .bottom)
                banner.configuration.titleFont = .systemFont(ofSize: 17, weight: .semibold)
                banner.present(queuePosition: .front)

            case .info:
                let banner = NotiflyFullWidth("Information",
                                                          subtitle: "This is an informational banner...",
                                                          configuration: .info(),
                                                          direction: .top)
                banner.present(queuePosition: .front)

            case .warning:
                let banner = NotiflyFullWidth("Warning message",
                                                          subtitle: "Proceeding further may lead to potential issues...",
                                                          configuration: .warning(),
                                                          direction: .top)
                banner.present(queuePosition: .front)

            case .success:
                let banner = NotiflyFullWidth("Successfully uploaded",
                                                          subtitle: "Your file has been successfully uploaded...",
                                                          configuration: .success(),
                                                          direction: .top)
                banner.present(queuePosition: .front)

            case .stacked:
                defaultQueue.dismissAll()

                let banners = [
                    NotiflyFullWidth(
                        "🚀 Blast Off!",
                        subtitle: "The rocket has launched successfully into orbit.",
                        queue: max3BannersQueue
                    ),
                    NotiflyFullWidth(
                        "🔥 Stay Alert!",
                        subtitle: "A wildfire warning has been issued for your area.",
                        queue: max3BannersQueue
                    ),
                    NotiflyFullWidth(
                        "✌️ Keep it Chill",
                        subtitle: "Take it easy and enjoy a peaceful moment.",
                        queue: max3BannersQueue
                    ),
                    NotiflyFullWidth(
                        "🎉 Overflow Banner",
                        subtitle: "This banner waits its turn to appear on the screen.",
                        queue: max3BannersQueue
                    )
                ]

                for banner in banners {
                    banner.direction = .top
                    banner.present()
                }

            case .dynamic:
                let banner1 = ReminderNotifaction(queue: max3BannersQueue)
                let banner2 = ReminderNotifaction(queue: max3BannersQueue)
                for banner in [banner1, banner2] {
                    banner.autoDismiss = false
                    banner.highlighter = nil
                    banner.didTap = {
                        if banner.isExpanded {
                            banner.dismiss()
                            return
                        }
                        banner.isExpanded = true
                    }
                    banner.present()
                }

            case .gradient:
                let topColor = UIColor(red: 0.55, green: 0.43, blue: 0.95, alpha: 1.0)
                let bottomColor = UIColor(red: 0.75, green: 0.64, blue: 1.0, alpha: 1.0)

                let configuration = Notifly.Configuration(backgroundColor: .gradient([topColor, bottomColor], .leftToRight))
                let banner = Notifly("Gradient Support", subtitle: "Add some cool gradient colors", configuration: configuration)
                banner.present(queuePosition: .front)

            case .sticky:
                let banner = NotiflyFullWidth("Welcome to SYBanner!",
                                                          subtitle: "{sticky}",
                                                          configuration:.init(backgroundColor: .default(.red), cornerRadius: .radius(0)),
                                                          direction: .bottom)
                banner.type = .stick
                banner.present(queuePosition: .front)

            case .custom1:
                let banner = Notifly("Game Mode", subtitle: "On", direction: .bottom, presenter: NotiflyBouncePresenter(animationDuration: 0.5))
                banner.configuration = Notifly.Configuration(icon: .init(image: .init(systemName: "gamecontroller.fill"), tintColor: .systemBlue))
                banner.configuration.imagePadding = 20
                banner.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 30)
                banner.present(queuePosition: .front)

            case .custom2:
                let banner = Notifly("Sending message....", direction: .bottom, presenter: NotiflyFadePresenter(animationDuration: 0.5))
                banner.configuration = Notifly.Configuration(icon: .init(image: .init(systemName: "paperplane.circle.fill"), tintColor: .white))
                banner.configuration.imagePadding = 10
                banner.layoutMargins = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 30)
                banner.present(queuePosition: .front)

            case .custom3:
                let banner = UndoNotifaction()
                banner.present(queuePosition: .front)

            case .custom4:
                let banner = ApprovalNotification()
                banner.present(queuePosition: .front)

            case .card1:
                let startButton = NotiflyCardButton(title: "Get started", font: .systemFont(ofSize: 14, weight: .semibold), style: .default)
                let skipButton = NotiflyCardButton(title: "Skip", font: .systemFont(ofSize: 14, weight: .semibold), style: .dismiss)
                let banner = NotiflyCard(title: "How to use", subtitle: "Simple download Notification banner and get started with your own notifcations", buttons: [skipButton, startButton])
                banner.backgroundColor = .notiflyDefaultColor
                banner.setNotificationOptions([
                    .titleColor(.white),
                    .subTitleColor(.white),
                    .showExitButton(true),
                    .customView(customViewGradient()),
                    .buttonAxis(.horizontal),
                    .titleFont(UIFont.systemFont(ofSize: 35, weight: .medium)),
                    .buttonsHeight(50)
                ])
                banner.present(queuePosition: .front)

            case .card2:
                let banner = NotiflyCard(title: "Welcome 👋", subtitle: "Sign in or create a new account with us.")
                banner.backgroundColor = .notiflyDefaultColor
                banner.addButton(NotiflyCardButton(title: "Sign in", font: .systemFont(ofSize: 16, weight: .semibold), style: .default) {
                    banner.dismiss()
                })
                banner.addButton(NotiflyCardButton(title: "Sign up", font: .systemFont(ofSize: 16, weight: .semibold), style: .dismiss) {
                    banner.dismiss()
                })

                banner.setNotificationOptions([
                    .showExitButton(false),
                    .titleFont(UIFont.systemFont(ofSize: 26, weight: .semibold)),
                    .buttonsHeight(50),
                    .buttonAxis(.vertical)
                ])
                banner.present(queuePosition: .front)
        }
    }
}

extension ExampleViewController {
    private func customViewGradient() -> UIView {
        let contentView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 300, height: 200)))
        contentView.layer.cornerRadius = 20
        contentView.layer.masksToBounds = true

        let colorTop = UIColor(red: 127/255.0, green: 0/255.0, blue: 255/255.0, alpha: 1.0).cgColor
        let colorMiddle = UIColor(red: 200/255.0, green: 80/255.0, blue: 192/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 255/255.0, green: 0/255.0, blue: 255/255.0, alpha: 1.0).cgColor

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorMiddle, colorBottom]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = CGRect(origin: .zero, size: CGSize(width: 400, height: 200))

        contentView.layer.insertSublayer(gradientLayer, at:0)

        return contentView
    }
}
