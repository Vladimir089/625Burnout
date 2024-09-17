//
//  SettingsViewController.swift
//  625Burnout
//
//  Created by Владимир Кацап on 17.09.2024.
//

import UIKit
import StoreKit
import WebKit
import Combine
import CombineCocoa

class SettingsViewController: UIViewController {
    
    var cancellables = [AnyCancellable]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        createInterface()
    }
    

    func createInterface() {
        let topLabel = UILabel()
        topLabel.text = "Settings"
        topLabel.textColor = .white
        topLabel.font = .systemFont(ofSize: 34, weight: .bold)
        view.addSubview(topLabel)
        topLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        let separatorView: UIView = {
            let view = UIView()
            view.backgroundColor = .white.withAlphaComponent(0.2)
            return view
        }()
        view.addSubview(separatorView)
        separatorView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.left.right.equalToSuperview()
            make.top.equalTo(topLabel.snp.bottom).inset(-10)
        }
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.clipsToBounds = true
        stackView.layer.cornerRadius = 20
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(separatorView.snp.bottom).inset(-20)
            make.height.equalTo(168)
        }
        
        let policyButton = createButton(image: .pol, text: "Usage Policy", isBotSeparator: true)
        stackView.addArrangedSubview(policyButton)
        policyButton.tapPublisher
            .sink { _ in
                self.policy()
            }
            .store(in: &cancellables)
        
        let shareButton = createButton(image: .shareBuy, text: "Share App", isBotSeparator: true)
        stackView.addArrangedSubview(shareButton)
        shareButton.tapPublisher
            .sink { _ in
                self.shareApps()
            }
            .store(in: &cancellables)
        
        let rateButton = createButton(image: .rate, text: "Rate Us", isBotSeparator: false)
        stackView.addArrangedSubview(rateButton)
        rateButton.tapPublisher
            .sink { _ in
                self.rateApps()
            }
            .store(in: &cancellables)
        
    }
    
    func rateApps() {
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        } else {
            if let url = URL(string: "id") {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        }
    }
    
    func shareApps() {
        let appURL = URL(string: "id")!
        let activityViewController = UIActivityViewController(activityItems: [appURL], applicationActivities: nil)
        
        // Настройка для показа в виде popover на iPad
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }

        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func policy() {
        let webVC = WebViewController()
        webVC.urlString = "pol"
        present(webVC, animated: true, completion: nil)
    }
    
    func createButton(image: UIImage, text: String, isBotSeparator: Bool) -> UIButton {
        let buttom = UIButton()
        buttom.backgroundColor = .bgSecond
        
        let imageview = UIImageView(image: image)
        imageview.contentMode = .scaleAspectFit
        buttom.addSubview(imageview)
        imageview.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.centerY.equalToSuperview()
            make.height.equalTo(32)
            make.width.equalTo(32)
        }
        
        let label = UILabel()
        label.text = text
        label.textColor = .white
        label.font = .systemFont(ofSize: 17, weight: .bold)
        buttom.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(imageview.snp.right).offset(20)
        }
        
        let imgaeViewArrow = UIImageView(image: .whiteRightArrow)
        buttom.addSubview(imgaeViewArrow)
        imgaeViewArrow.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(15)
            make.centerY.equalToSuperview()
            make.height.equalTo(18)
            make.width.equalTo(11)
        }
        
        if isBotSeparator == true {
            let sepView = UIView()
            sepView.backgroundColor = .black
            buttom.addSubview(sepView)
            sepView.snp.makeConstraints { make in
                make.height.equalTo(1)
                make.right.equalToSuperview()
                make.left.equalTo(label.snp.left)
                make.bottom.equalToSuperview()
            }
        }
        
        return buttom
    }

}


class WebViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var urlString: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
        
        // Загружаем URL
        if let urlString = urlString, let url = URL(string: urlString) {
            webView.load(URLRequest(url: url))
        }
    }
}
