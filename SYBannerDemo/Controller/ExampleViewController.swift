//
//  ExampleViewController.swift
//  SYBannerDemo
//
//  Created by Emre Armagan on 07.04.22.
//

import SYBanner
import UIKit

enum BannerExample: Int, CaseIterable {
    case simple
    case `default`
    case info
    case warning
    case success
    case stacked
    case dynamic
    case gradient
    case custom1
    case custom2
    case custom3
    case custom4

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
            case .custom1: return "Custom 1"
            case .custom2: return "Custom 2"
            case .custom3: return "Custom 3"
            case .custom4: return "Custom 4"
        }
    }
}

class ExampleViewController: UIViewController {
    // MARK: - Properties

    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private let max3BannersQueue = SYBannerQueue(maxBannersOnScreen: 3)
    private let defaultQueue = SYBannerQueue.default

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
        for type in BannerExample.allCases {
            let button = createButton(for: type)
            stackView.addArrangedSubview(button)
        }
    }

    private func createButton(for type: BannerExample) -> UIButton {
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
        guard let type = BannerExample(rawValue: sender.tag) else { return }
        showExample(type)
    }

    private func showExample(_ example: BannerExample) {
        max3BannersQueue.dismissAll()

        switch example {
            case .simple:
                let banner = SYSimpleBanner("Link copied", direction: .top)
                banner.present(queuePosition: .front)

            case .default:
                let banner = SYBanner("Welcome to SYBanner!", subtitle: "{subtitle}", direction: .bottom)
                banner.configuration.titleFont = .systemFont(ofSize: 17, weight: .semibold)
                banner.present(queuePosition: .front)

            case .info:
                let banner = SYFullWidthBanner("Information",
                                               subtitle: "This is an informational banner...",
                                               configuration: .info(),
                                               direction: .top)
                banner.present(queuePosition: .front)

            case .warning:
                let banner = SYFullWidthBanner("Warning message",
                                               subtitle: "Proceeding further may lead to potential issues...",
                                               configuration: .warning(),
                                               direction: .top)
                banner.present(queuePosition: .front)

            case .success:
                let banner = SYFullWidthBanner("Successfully uploaded",
                                               subtitle: "Your file has been successfully uploaded...",
                                               configuration: .success(),
                                               direction: .top)
                banner.present(queuePosition: .front)

            case .stacked:
                defaultQueue.dismissAll()

                let banners = [
                    SYFullWidthBanner(
                        "🚀 Blast Off!",
                        subtitle: "The rocket has launched successfully into orbit.",
                        queue: max3BannersQueue
                    ),
                    SYFullWidthBanner(
                        "🔥 Stay Alert!",
                        subtitle: "A wildfire warning has been issued for your area.",
                        queue: max3BannersQueue
                    ),
                    SYFullWidthBanner(
                        "✌️ Keep it Chill",
                        subtitle: "Take it easy and enjoy a peaceful moment.",
                        queue: max3BannersQueue
                    ),
                    SYFullWidthBanner(
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
                let banner1 = ReminderBanner(queue: max3BannersQueue)
                let banner2 = ReminderBanner(queue: max3BannersQueue)
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

                let configuration = SYBanner.Configuration(backgroundColor: .gradient([topColor, bottomColor], .leftToRight))
                let banner = SYBanner("Gradient Support", subtitle: "Add some cool gradient colors", configuration: configuration)
                banner.present()

            case .custom1:
                let banner = SYBanner("Game Mode", subtitle: "On", direction: .bottom, presenter: SYBouncePresenter(animationDuration: 0.5))
                banner.configuration = SYBanner.Configuration(icon: .init(image: .init(systemName: "gamecontroller.fill"), tintColor: .systemBlue))
                banner.configuration.imagePadding = 20
                banner.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 30)
                banner.present(queuePosition: .front)

            case .custom2:
                let banner = SYBanner("Sending message....", direction: .bottom, presenter: SYFadePresenter(animationDuration: 0.5))
                banner.configuration = SYBanner.Configuration(icon: .init(image: .init(systemName: "paperplane.circle.fill"), tintColor: .white))
                banner.configuration.imagePadding = 10
                banner.layoutMargins = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 30)
                banner.present(queuePosition: .front)

            case .custom3:
                let banner = UndoBanner()
                banner.present(queuePosition: .front)

            case .custom4:
                let banner = ApprovalBanner()
                banner.present(queuePosition: .front)
        }
    }
}
