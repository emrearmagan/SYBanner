//
//  ViewController.swift
//  SYBannerDemo
//
//  Created by Emre Armagan on 07.04.22.
//

import UIKit
import SYBanner

class ViewController: UIViewController {
    
    
    @IBOutlet weak var defaultBannerButton: UIButton!
    @IBOutlet weak var imageBannerButtonTopConstraint: NSLayoutConstraint!
    
    private let lightDark = UIColor.init(red: 28/255, green: 27/255, blue: 29/255, alpha: 1)
    private let buttonSpacing: CGFloat = 20
    private let tableViewHeight: CGFloat = 200
  
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
        
    private lazy var transparentView: UIView = {
        let view = UIView()
        view.frame =  UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.frame ?? self.view.frame
       
        view.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissTransparentView))
        view.addGestureRecognizer(tapGesture)
        view.alpha = 0
        
        
        return view
    }()
    
    private let defaultBannerOptions: [String] = ["Info", "Warning", "Success", "Custom icon"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(transparentView)
        self.view.addSubview(tableView)
        tableView.isScrollEnabled = false
        tableView.layer.cornerRadius = 5
    }
    
    @IBAction func showSimpleBanner(_ sender: UIButton) {
        let banner = SYSimpleBanner("Link copied", backgroundColor: UIColor(named: "whiteLightBlack") ?? .darkGray, textColor: .label, direction: .top)
        banner.animationDurationDisappear = 0.1
        banner.show(queuePosition: .front)
    }
    
    @IBAction func showDefaultBanner(_ sender: UIButton) {
        tableView.frame = CGRect(x: self.defaultBannerButton.frame.origin.x, y: self.defaultBannerButton.frame.origin.y + self.defaultBannerButton.frame.height, width: self.defaultBannerButton.frame.width, height: 0)
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0.5
            self.imageBannerButtonTopConstraint.constant = self.buttonSpacing + self.tableViewHeight
            self.tableView.frame = CGRect(x: self.defaultBannerButton.frame.origin.x, y: self.defaultBannerButton.frame.origin.y + self.defaultBannerButton.frame.height, width: self.defaultBannerButton.frame.width, height: self.tableViewHeight)
        }, completion: nil)
    }
    
    @IBAction func imageBanner(_ sender: UIButton) {
        let banner = SYImageBanner("Large Title", "Some useful info about the image comes here", image: UIImage(named: "NotifcationBanner")!, type: .info, backgroundColor: lightDark.withAlphaComponent(0.95))
        banner.animationDurationDisappear = 0.1
        banner.show()
    }
    
    @IBAction func showCustomBanner1(_ sender: UIButton) {
        /*let dismissButton =  SYBannerButton(title: "Dismiss", font: .systemFont(ofSize: 14, weight: .semibold), style: .dismiss, tintColor: .lightGray) {
            print("tapped dismiss")
        }
        
        let banner = SYBanner(title: "Large title", subtitle: "A smaller subtitle for additional information", backgroundColor: lightDark, buttons: [dismissButton])
        
        banner.setBannerOptions([
            .showExitButton(true),
            .customView(customView1())
        ])
        banner.isDismissable = false
        banner.show(queuePosition: .front)*/
    }
    
    @IBAction func showCustomBanner2(_ sender: UIButton) {
        /*let startButton =  SYBannerButton(title: "Get started", font: .systemFont(ofSize: 14, weight: .semibold), style: .default)
        let skipButton = SYBannerButton(title: "Skip", font: .systemFont(ofSize: 14, weight: .semibold), style: .dismiss)
        
        let banner = SYBanner(title: "How to use", subtitle: "Simple download Notification banner and get started with your own notifcations", backgroundColor: lightDark, buttons: [skipButton, startButton])
        
        banner.setBannerOptions([
            .showExitButton(false),
            .customView(customView2()),
            .buttonAxis(.horizontal),
            .titleFont(UIFont.systemFont(ofSize: 35, weight: .medium)),
            .buttonsHeight(50),
        ])
        banner.isDismissable = false
        banner.show(queuePosition: .front)*/
    }

    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    @objc private func dismissTransparentView() {
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0
            self.imageBannerButtonTopConstraint.constant = self.buttonSpacing
            self.tableView.frame = CGRect(x: self.defaultBannerButton.frame.origin.x, y: self.defaultBannerButton.frame.origin.y + self.defaultBannerButton.frame.height, width: self.defaultBannerButton.frame.width, height: 0)
        }, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        defaultBannerOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.textLabel?.text = defaultBannerOptions[indexPath.row]
        cell.backgroundColor = UIColor(named: "whiteLightBlack")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isSelected = false
        var banner: SYDefaultBanner?
        if indexPath.row == 0 {
            //Info banner
            banner = SYDefaultBanner("Some useful info", type: .info)
            banner?.messageColor = .white
        } else if indexPath.row == 1 {
            //Warning banner
            banner = SYDefaultBanner("Warning message", type: .warning)
            banner?.messageColor = .white
        } else if indexPath.row == 2 {
            //Success banner
            banner = SYDefaultBanner("Successfully uploaded", type: .success)
            banner?.messageColor = .white
        } else if indexPath.row == 3 {
            //Custom banner
            let image = UIImage(named: "AppIcon60x60")
            let darkColor = UIColor.init(red: 28/255, green: 27/255, blue: 29/255, alpha: 1)
            banner = SYDefaultBanner("This is a custom banner with an icon. Try it out yourself 🔥", icon: image, backgroundColor: darkColor , direction: .top)
            banner?.imageView.layer.masksToBounds = false
            banner?.imageView.layer.cornerRadius = 20
            banner?.imageView.clipsToBounds = true
            banner?.iconSize = CGSize(width: 80, height: 80)
            banner?.messageFont = .systemFont(ofSize: 18, weight: .semibold)
            banner?.messageInsets.left = 20
            banner?.imagePadding = 20
            banner?.messageColor = .white
            banner?.layer.cornerRadius = 20
            banner?.didTap = {
                let banner = SYSimpleBanner("Yay you tapped me!", backgroundColor: darkColor, textColor: .white, direction: .bottom)
                banner.animationDurationDisappear = 0.1
                banner.show(queuePosition: .front)
            }
        }
        
        banner?.animationDurationDisappear = 0.1
        banner?.show(queuePosition: .front)
    }

}

extension ViewController {
    
    private func customView1() -> UIView {
        let contentView = UIView(frame: .zero)
        contentView.frame.size.height = 200
        contentView.layer.cornerRadius = 20
        contentView.layer.masksToBounds = true
        
        let label = UILabel()
        label.text = "Content"
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
        
        contentView.backgroundColor = .systemGray2
        return contentView
    }
    
    private func customView2() -> UIView {
        let contentView = UIView(frame: .zero)
        contentView.frame.size.height = 200
        contentView.layer.cornerRadius = 20
        contentView.layer.masksToBounds = true
        
        let colorTop =  UIColor(red: 127/255.0, green: 0/255.0, blue: 255/255.0, alpha: 1.0).cgColor
        let colorMiddle = UIColor(red: 200/255.0, green: 80/255.0, blue: 192/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 255/255.0, green: 0/255.0, blue: 255/255.0, alpha: 1.0).cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorMiddle, colorBottom]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = CGRect(origin: .zero, size: CGSize(width: 500, height: 200))
        
        contentView.layer.insertSublayer(gradientLayer, at:0)
        
        return contentView
    }
}


