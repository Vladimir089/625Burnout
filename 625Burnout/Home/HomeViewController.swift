//
//  HomeViewController.swift
//  625Burnout
//
//  Created by Владимир Кацап on 13.09.2024.
//

import UIKit

protocol HomeViewControllerDelegate: AnyObject {
    func reload()
}

class HomeViewController: UIViewController {
    
    var noRaceView: UIView?
    var collection: UICollectionView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        createInterface()
        checkArray()
    }
    
    
    func checkArray() {
        if racers.count > 0 {
            collection?.alpha = 1
            noRaceView?.alpha = 0
            collection?.reloadData()
        } else {
            collection?.alpha = 0
            noRaceView?.alpha = 1
        }
    }
    

    func createInterface() {
        let topLabel = UILabel()
        topLabel.text = "Race"
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
        
        noRaceView = {
            let view = UIView()
            view.backgroundColor = .clear
            view.alpha = 0
            
            let imageView = UIImageView(image: .twoFlags)
            view.addSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.height.equalTo(41)
                make.width.equalTo(69)
                make.centerX.equalToSuperview()
                make.top.equalToSuperview()
            }
            
            let topLabel = UILabel()
            topLabel.text = "Empty"
            topLabel.textColor = .white
            topLabel.font = .systemFont(ofSize: 28, weight: .bold)
            view.addSubview(topLabel)
            topLabel.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalTo(imageView.snp.bottom).inset(-15)
            }
            
            let secondLabel = UILabel()
            secondLabel.text = "Add your first racing event"
            secondLabel.textColor = .white.withAlphaComponent(0.7)
            secondLabel.font = .systemFont(ofSize: 15, weight: .regular)
            view.addSubview(secondLabel)
            secondLabel.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalTo(topLabel.snp.bottom).inset(-10)
            }
            
            let addButton = UIButton(type: .system)
            addButton.backgroundColor = .primary
            addButton.layer.cornerRadius = 12
            
            view.addSubview(addButton)
            addButton.snp.makeConstraints { make in
                make.height.equalTo(44)
                make.width.equalTo(164)
                make.bottom.equalToSuperview().inset(15)
                make.centerX.equalToSuperview()
            }
            addButton.addTarget(self, action: #selector(createRace), for: .touchUpInside)
            
            let plusImageView = UIImageView(image: .plus)
            addButton.addSubview(plusImageView)
            plusImageView.snp.makeConstraints { make in
                make.height.equalTo(22)
                make.width.equalTo(25)
                make.centerY.equalToSuperview()
                make.left.equalToSuperview().inset(15)
            }
            
            let labelButton = UILabel()
            labelButton.text = "Click to add"
            labelButton.textColor = .black
            labelButton.font = .systemFont(ofSize: 17, weight: .semibold)
            addButton.addSubview(labelButton)
            labelButton.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.left.equalTo(plusImageView.snp.right).inset(-10)
            }
            
            return view
        }()
        
        view.addSubview(noRaceView!)
        noRaceView?.snp.makeConstraints({ make in
            make.center.equalToSuperview()
            make.height.equalTo(199)
            make.width.equalTo(294)
        })
    }
    
    @objc func createRace() {
        let vc = NewRaceViewController()
        vc.delegate = self
        self.present(vc, animated: true)
    }

}

extension HomeViewController: HomeViewControllerDelegate {
    func reload() {
        checkArray()
    }
    
    
}
