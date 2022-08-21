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
    
    private let buttonSpacing: CGFloat = 20
    private let tableViewHeight: CGFloat = 250
  
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
    
    private let defaultBannerOptions: [String] = ["Text", "Info", "Warning", "Success", "Custom icon"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(transparentView)
        self.view.addSubview(tableView)
        tableView.isScrollEnabled = false
        tableView.layer.cornerRadius = 5
    }
    
    @IBAction func showSimpleBanner(_ sender: UIButton) {
        let banner = SYSimpleBanner("Link copied", backgroundColor: UIColor(named: "whiteLightBlack")!, direction: .top)
        banner.animationDurationDisappear = 0.1
        banner.appearanceDuration = 10
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            print("updating")
            banner.message = " alksjd askldj askldj askl"
        }
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
    
    @IBAction func showCustomBanner1(_ sender: UIButton) {
        let dismissButton =  SYCardBannerButton(title: "Dismiss", font: .systemFont(ofSize: 14, weight: .semibold), style: .dismiss, tintColor: .lightGray) {
            print("tapped dismiss")
        }
        
        let banner = SYCardBanner(title: "Large title", subtitle: "A smaller subtitle for additional information", buttons: [dismissButton])
        banner.backgroundColor = getTraitColor()
        banner.setBannerOptions([
            .showExitButton(false),
            .customView(customViewDefault())
        ])
        banner.dismissOnSwipe = false
        banner.show(queuePosition: .front)
    }
    
    @IBAction func showCustomBanner2(_ sender: UIButton) {
        let startButton =  SYCardBannerButton(title: "Get started", font: .systemFont(ofSize: 14, weight: .semibold), style: .default)
        let skipButton = SYCardBannerButton(title: "Skip", font: .systemFont(ofSize: 14, weight: .semibold), style: .dismiss)
        
        let banner = SYCardBanner(title: "How to use", subtitle: "Simple download Notification banner and get started with your own notifcations", buttons: [skipButton, startButton])
        banner.backgroundColor = getTraitColor()
        banner.setBannerOptions([
            .showExitButton(true),
            .customView(customViewGradient()),
            .buttonAxis(.horizontal),
            .titleFont(UIFont.systemFont(ofSize: 35, weight: .medium)),
            .buttonsHeight(50),
        ])
        banner.dismissOnSwipe = false
        banner.show(queuePosition: .front)
    }
    
    @IBAction func showCustomBanner3(_ sender: UIButton) {
        let banner = SYCardBanner(title: "Easy to use\n Banners", type: .float)
        banner.addButton(SYCardBannerButton(title: "Get started", font: .systemFont(ofSize: 18, weight: .semibold), cornerRadius: 15, style: .default, handler: {
            banner.dismissView()
        }))
        banner.backgroundColor = getTraitColor()
        banner.setBannerOptions([
            .showExitButton(true),
            .customView(customViewImage()),
            .buttonAxis(.horizontal),
            .titleFont(UIFont.systemFont(ofSize: 35, weight: .medium)),
            .titleColor(.gray),
            .buttonsHeight(50),
            .customViewInsets(.init(top: 20, left: 0, bottom: 40, right: 0)),
        ])
 
        banner.dismissOnSwipe = false
        banner.show(queuePosition: .front)
    }

    @IBAction func showCustomBanner4(_ sender: UIButton) {
        let banner = SYCardBanner(title: "Enter your name", subtitle: "Please enter your name and sign up with us today for great benefits. No Email required.", type: .float)
        
        banner.addButton(SYCardBannerButton(title: "Sign up", font: .systemFont(ofSize: 14, weight: .semibold), style: .default) {
            banner.dismissView()
        })
        banner.backgroundColor = getTraitColor()
        banner.setBannerOptions([
            .showExitButton(false),
            .customView(customViewTextField()),
            .titleFont(UIFont.systemFont(ofSize: 30, weight: .medium)),
            .subTitleFont(.systemFont(ofSize: 20)),
            .subTitleColor(.label),
            .titleColor(.gray),
            .buttonsHeight(50),
        ])
        banner.keyboardSpacing = 10
        banner.dismissOnSwipe = false
        banner.show(queuePosition: .front)
    }
    
    @IBAction func showCustomBanner5(_ sender: UIButton) {
        let banner = SYCardBanner(title: "Successfully downloaded", subtitle: "The requested video has been successfully downloaded. Watch it now or later in your gallery.", type: .float)
        
        banner.addButton(SYCardBannerButton(title: "Watch video", font: .systemFont(ofSize: 16, weight: .semibold), style: .default, tintColor: .systemGreen) {
            banner.dismissView()
        })
        
        banner.addButton(SYCardBannerButton(title: "Maybe later", font: .systemFont(ofSize: 12, weight: .semibold), style: .dismiss))
                      
        banner.backgroundColor = getTraitColor()
        banner.setBannerOptions([
            .showExitButton(false),
            .customView(customViewSuccess()),
            .titleFont(UIFont.systemFont(ofSize: 26, weight: .semibold)),
            .buttonsHeight(50),
            .buttonAxis(.vertical),
            .customViewInsets(.init(top: 30, left: 0, bottom: 30, right: 0)),
            .isDismissable(true),
        ])
        banner.contentInsets.bottom = 6
        banner.show(queuePosition: .front)
    }
    
    
    @IBAction func showCustomBanner6(_ sender: UIButton) {
        let banner = SYCardBanner(title: "Welcome 👋", subtitle: "Sign in or create a new account with us.", type: .float)
        
        banner.addButton(SYCardBannerButton(title: "Sign in", font: .systemFont(ofSize: 16, weight: .semibold), style: .default) {
            banner.dismissView()
        })
        
        banner.addButton(SYCardBannerButton(title: "Sign up", font: .systemFont(ofSize: 16, weight: .semibold), style: .dismiss) {
            banner.dismissView()
        })
             
        banner.backgroundColor = getTraitColor()
        banner.setBannerOptions([
            .showExitButton(false),
            .titleFont(UIFont.systemFont(ofSize: 26, weight: .semibold)),
            .buttonsHeight(50),
            .buttonAxis(.vertical),
            .isDismissable(false),
            //.customViewInsets(.init(top: 0, left: 0, bottom: 0, right: 0))
        ])
        banner.show(queuePosition: .front)
    }
}

extension ViewController {
    func getTraitColor() -> UIColor {
        return UIColor { (traits) -> UIColor in
            return traits.userInterfaceStyle == .light ? .white : UIColor.init(red: 28/255, green: 27/255, blue: 29/255, alpha: 1)
        }
    }
    
    @objc private func dismissTransparentView() {
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0
            self.imageBannerButtonTopConstraint.constant = self.buttonSpacing
            self.tableView.frame = CGRect(x: self.defaultBannerButton.frame.origin.x, y: self.defaultBannerButton.frame.origin.y + self.defaultBannerButton.frame.height, width: self.defaultBannerButton.frame.width, height: 0)
        }, completion: nil)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
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
            banner = SYDefaultBanner("A Banner with just a text", direction: .top, style: .none)
            banner?.backgroundColor = getTraitColor()
        }
        
        else if indexPath.row == 1 {
            //Info banner
            banner = SYDefaultBanner("Some useful info", direction: .top, style: .info)
            banner?.messageColor = .white
        } else if indexPath.row == 2 {
            //Warning banner
            banner = SYDefaultBanner("Warning message", style: .warning)
            banner?.messageColor = .white
        } else if indexPath.row == 3 {
            //Success banner
            banner = SYDefaultBanner("Successfully uploaded", style: .success)
            banner?.messageColor = .white
        } else if indexPath.row == 4 {
            //Custom banner
            let image = UIImage(named: "AppIcon60x60")
            banner = SYDefaultBanner("This is a custom banner with an icon. Try it out yourself 🔥", icon: image, backgroundColor: UIColor.init(red: 28/255, green: 27/255, blue: 29/255, alpha: 1) , direction: .top)
            banner?.messageColor = .white
            banner?.imageView.layer.masksToBounds = false
            banner?.imageView.layer.cornerRadius = 20
            banner?.imageView.clipsToBounds = true
            banner?.iconSize = CGSize(width: 80, height: 80)
            banner?.messageFont = .systemFont(ofSize: 16, weight: .semibold)
            banner?.messageInsets.left = 20
            banner?.layer.cornerRadius = 20
            banner?.didTap = {
                let banner = SYSimpleBanner("Yay you tapped me!", backgroundColor: self.getTraitColor(), direction: .bottom)
                banner.animationDurationDisappear = 0.1
                banner.show(queuePosition: .front)
            }
        }
        
        banner?.animationDurationDisappear = 0.1
        banner?.show(queuePosition: .front)
    }

}

//MARK: - Custom views
extension ViewController: UITextFieldDelegate {
    private func customViewDefault() -> UIView {
        let contentView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 300, height: 200)))
        contentView.layer.cornerRadius = 20
        contentView.layer.masksToBounds = true
        
        let label = UILabel()
        label.text = "Content"
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
        
        contentView.backgroundColor = .systemGray2
        return contentView
    }
    
    private func customViewGradient() -> UIView {
        let contentView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 300, height: 200)))
        contentView.layer.cornerRadius = 20
        contentView.layer.masksToBounds = true
        
        let colorTop =  UIColor(red: 127/255.0, green: 0/255.0, blue: 255/255.0, alpha: 1.0).cgColor
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
    
    private func customViewImage() -> UIView {
        let contentView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 150, height: 150)))
        
        contentView.layer.cornerRadius = 20
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = .init(red: 117/255, green: 85/255, blue: 202/255, alpha: 0.5)
        
        let label = UILabel()
        label.text = "👻"
        label.font = .systemFont(ofSize: 80, weight: .semibold)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
        
        return contentView
    }

    private func customViewSuccess() -> UIView {
        let contentView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 150, height: 150)))

        let imageView = UIImageView(image: UIImage(systemName: "checkmark.circle.fill"))
        imageView.tintColor = .systemGreen
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: contentView.frame.width),
            imageView.heightAnchor.constraint(equalToConstant: contentView.frame.height),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
        
        return contentView
    }
    
    private func customViewTextField() -> UIView {
        let contentView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 300, height: 50)))
  
        let txtField = UITextField()
        txtField.placeholder = "Enter your name"
        txtField.layer.borderWidth = 1.0
        txtField.layer.cornerRadius = 5
        txtField.font = .systemFont(ofSize: 16, weight: .semibold)
        
        txtField.delegate = self

        txtField.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(txtField)
        NSLayoutConstraint.activate([
            txtField.widthAnchor.constraint(equalToConstant: 300),
            txtField.heightAnchor.constraint(equalToConstant: 50),
            txtField.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            txtField.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
        
        return contentView
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}


