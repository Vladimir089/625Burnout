//
//  LoadViewController.swift
//  PariClean
//
//  Created by Владимир Кацап on 12.08.2024.
//
import SnapKit
import UIKit

class LoadViewController: UIViewController {
    
    var progressLabel: UILabel?
    var timer: Timer?
    var progress: Int = 0
    var progressForView: Float = 0
    var progressView: UIProgressView?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        createInterface()
        startProgress()
    }
    
    func createInterface() {
        let imageView = UIImageView(image: .logOld)
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(327)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-70)
        }
        
        progressView = {
            let progressView = UIProgressView()
            progressView.setProgress(0, animated: true)
            progressView.layer.cornerRadius = 2
            progressView.backgroundColor = .white.withAlphaComponent(0.3)
            progressView.progressTintColor = UIColor(red: 0/255, green: 188/255, blue: 255/255, alpha: 1)
            progressView.clipsToBounds = true
            return progressView
        }()
        view.addSubview(progressView!)
        progressView?.snp.makeConstraints({ make in
            make.height.equalTo(10)
            make.width.equalTo(205)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(80)
        })
        
        progressLabel = {
            let label = UILabel()
            label.text = "Loading 0%"
            label.font = .systemFont(ofSize: 17, weight: .regular)
            label.textColor = .white.withAlphaComponent(0.7)
            return label
        }()
        view.addSubview(progressLabel!)
        progressLabel?.snp.makeConstraints({ make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(progressView!.snp.top).inset(-15)
        })
    }


    func startProgress() {
        progress = 0
        progressLabel?.text = "\(progress)%"      //ПОРМЕНЯТЬ НА timeInterval: 0.08
        timer = Timer.scheduledTimer(timeInterval: 0.0, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
    }
    
    @objc func updateProgress() {
            if progress < 100 {
                progress += 1
                progressLabel?.text = "Loading \(progress)%"
                progressForView += 0.01
                UIView.animate(withDuration: 0.1) {
                    self.progressView?.setProgress(self.progressForView, animated: true)
                }
            } else {
                timer?.invalidate()
                timer = nil
                if isBet == false {
                    if UserDefaults.standard.object(forKey: "tab") != nil {
                        self.navigationController?.setViewControllers([TabBarViewController()], animated: true)
                    } else {
                       self.navigationController?.setViewControllers([OnbUserViewController()], animated: true)
                    }
                } else {
                    
                }
            }
        }
    
}
