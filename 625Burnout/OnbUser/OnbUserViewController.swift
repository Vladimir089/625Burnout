//
//  OnbUserViewController.swift
//  625Burnout
//
//  Created by Владимир Кацап on 13.09.2024.
//

import UIKit

class OnbUserViewController: UIViewController {
    
    var viewsArr: [UIView] = []
    var topLabel: UILabel?
    var imageView: UIImageView?
    
    var taps = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .bgSecond
        loadArr()
        createInterface()
    }
    

    func createInterface() {
        let stackView = UIStackView(arrangedSubviews: viewsArr)
        stackView.backgroundColor = .clear
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.height.equalTo(5)
            make.width.equalTo(130)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.centerX.equalToSuperview()
        }
        viewsArr[0].backgroundColor = .primary
        
        topLabel = {
            let label = UILabel()
            label.text = "Adding racing events"
            label.textAlignment = .center
            label.textColor = .white
            label.numberOfLines = 2
            label.font = .systemFont(ofSize: 34, weight: .bold)
            return label
        }()
        view.addSubview(topLabel!)
        topLabel?.snp.makeConstraints({ make in
            make.centerX.equalToSuperview()
            make.top.equalTo(stackView.snp.bottom).inset(-15)
        })
        
        imageView = {
            let imageView = UIImageView(image: .user1)
            imageView.contentMode = .scaleAspectFit
            return imageView
        }()
        view.addSubview(imageView!)
        imageView?.snp.makeConstraints({ make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(664)
        })
        
        let nextButton: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("Next", for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
            button.backgroundColor = .primary
            button.layer.cornerRadius = 12
            return button
        }()
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.height.equalTo(56)
        }
        nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        
        
    }
    
    @objc func nextTapped() {
        taps += 1
        
        for i in viewsArr {
            i.backgroundColor = .white.withAlphaComponent(0.3)
        }
        
        switch taps {
        case 1:
            UIView.animate(withDuration: 0.3) { [self] in
                topLabel?.text = "Keep statistics and\nmark the best result"
                imageView?.image = .user2
                viewsArr[1].backgroundColor = .primary
            }
        case 2:
            UIView.animate(withDuration: 0.3) { [self] in
                topLabel?.text = "Add racing results"
                imageView?.image = .user3
                viewsArr[2].backgroundColor = .primary
            }
        case 3:
            navigationController?.setViewControllers([TabBarViewController()], animated: true)
        default:
            return
        }
    }
    
    func loadArr() {
        for _ in 0..<3 {
            let view = UIView()
            view.layer.cornerRadius = 2.5
            view.backgroundColor = .white.withAlphaComponent(0.3)
            viewsArr.append(view)
        }
    }

}
