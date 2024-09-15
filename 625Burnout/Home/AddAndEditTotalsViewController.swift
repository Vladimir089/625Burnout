//
//  AddAndEditTotalsViewController.swift
//  625Burnout
//
//  Created by Владимир Кацап on 14.09.2024.
//

import UIKit
import Combine
import CombineCocoa

class AddAndEditTotalsViewController: UIViewController {
    
    //publishers
    var oldRacersPublisher: PassthroughSubject<[Race], Never>?
    var newRacesPublisher = PassthroughSubject<[Total], Never>()
    
    var cancellable = [AnyCancellable]()

    //other
    var racersOld: [Race]?
    var indexEditRace = 0
    var isEdit = true
    
    //ui
    lazy var topLabel = UILabel()
    lazy var editButton = UIButton()
    lazy var collection = UICollectionView()
    lazy var saveButton = UIButton()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .bgSecond
        createInterface()
        checkIsNew(editable: (racersOld?[indexEditRace].totals.count ?? 0 > 0) ? false : true)
        subscribe()
    }
    
    
    func subscribe() {
        newRacesPublisher
            .sink(receiveValue: { total in
                self.racersOld?[self.indexEditRace].totals = total
                self.collection.reloadData()
                
            })
            .store(in: &cancellable)
    }
    
    
    deinit {
        cancellable.forEach({$0.cancel()})
    }
    
    
    func checkIsNew(editable: Bool) {
        if editable {
            UIView.animate(withDuration: 0.3) { [self] in
                topLabel.text = "Add totals"
                editButton.alpha = 0
                saveButton.alpha = 100
                isEdit = true
                collection.reloadData()
            }
        } else {
            UIView.animate(withDuration: 0.3) { [self] in
                topLabel.text = "Totals"
                editButton.alpha = 100
                saveButton.alpha = 0
                isEdit = false
                collection.reloadData()
            }
        }
    }
    
    
    func createInterface() {
        let hideView = UIView()
        hideView.backgroundColor = .white.withAlphaComponent(0.1)
        hideView.layer.cornerRadius = 2.5
        view.addSubview(hideView)
        hideView.snp.makeConstraints { make in
            make.height.equalTo(5)
            make.width.equalTo(36)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(10)
        }
        
        topLabel = {
            let label = UILabel()
            label.text = "Add totals"
            label.textColor = .white
            label.font = .systemFont(ofSize: 17, weight: .bold)
            return label
        }()
        view.addSubview(topLabel)
        topLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(hideView.snp.bottom).inset(-15)
        }
        
        let backButton = BackButton()
        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.centerY.equalTo(topLabel)
            make.width.equalTo(60)
            make.height.equalTo(22)
        }
        backButton.tapPublisher
            .sink { _ in
                self.dismiss(animated: true)
            }
            .store(in: &cancellable)
        
        editButton = {
            let button = UIButton(type: .system)
            button.setTitle("Edit", for: .normal)
            button.setTitleColor(.systemRed, for: .normal)
            return button
        }()
        view.addSubview(editButton)
        editButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(15)
            make.centerY.equalTo(topLabel)
        }
        editButton.tapPublisher
            .sink { _ in
                DispatchQueue.main.async {
                    self.checkIsNew(editable: true)
                }
            }
            .store(in: &cancellable)
        
        collection = {
            let layout = UICollectionViewFlowLayout()
            let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collection.backgroundColor = .clear
            collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "1")
            layout.scrollDirection = .vertical
            collection.showsVerticalScrollIndicator = false
            collection.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
            collection.delegate = self
            collection.dataSource = self
            return collection
        }()
        view.addSubview(collection)
        collection.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.bottom.equalToSuperview()
            make.top.equalTo(topLabel.snp.bottom).inset(-15)
        }
        
        saveButton = {
            let button = UIButton(type: .system)
            button.setTitle("Save", for: .normal)
            button.backgroundColor = .primary
            button.layer.cornerRadius = 12
            button.setTitleColor(.black, for: .normal)
            return button
        }()
        
        saveButton.tapPublisher
            .sink { [self] tap in
                oldRacersPublisher?.send(racersOld ?? [])
                checkIsNew(editable: false)
            }
            .store(in: &cancellable)
        
        view.addSubview(saveButton)
        saveButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.height.equalTo(56)
        }

    }
    
    

    
    
    
   
    
    
    func createAndEditTotal(index: Int?, isNew: Bool) {
        let alertController = UIAlertController(title: "Add the pilot and his\nresults", message: nil, preferredStyle: .alert)
        alertController.addTextField()
        alertController.addTextField()
        alertController.textFields?[0].placeholder = "Pilot name"
        alertController.textFields?[1].placeholder = "00:00:00"
        alertController.textFields?[0].text = isNew ? "" : racersOld?[self.indexEditRace].totals[index ?? 0].pilotName
        alertController.textFields?[1].text = isNew ? "" : racersOld?[self.indexEditRace].totals[index ?? 0].time
        
        let saveButt = UIAlertAction(title: "Add", style: .default) { [self] action in
            
            let name: String =  alertController.textFields?[0].text ?? ""
            let time: String =  alertController.textFields?[1].text ?? ""
            
            let total = Total(pilotName: name, time:  time)
            
            if isNew {
                self.racersOld?[self.indexEditRace].totals.append(total)
            } else {
                self.racersOld?[self.indexEditRace].totals[index ?? 0] = total
            }
           
            newRacesPublisher.send(racersOld?[self.indexEditRace].totals ?? [])
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(cancelButton)
        alertController.addAction(saveButt)
        
        self.present(alertController, animated: true)
    }
    

}


extension AddAndEditTotalsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isEdit ? (racersOld?[indexEditRace].totals.count ?? 0) + 1 : racersOld?[indexEditRace].totals.count ?? 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "1", for: indexPath)
        cell.subviews.forEach { $0.removeFromSuperview() }
        cell.backgroundColor = .black
        cell.layer.cornerRadius = 12
        cell.clipsToBounds = true
        cell.layer.borderWidth = 0
        
        if indexPath.row == (racersOld?[indexEditRace].totals.count ?? 0) , isEdit == true {
            cell.layer.borderColor = UIColor.primary.cgColor
            cell.layer.borderWidth = 1
            let addPilotLabel = UILabel()
            addPilotLabel.text = "Add a pilot"
            addPilotLabel.textColor = .primary
            addPilotLabel.font = .systemFont(ofSize: 16, weight: .regular)
            cell.addSubview(addPilotLabel)
            addPilotLabel.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.left.equalToSuperview().inset(15)
            }
            
            let plusImageView = UIImageView(image: .plus.withRenderingMode(.alwaysTemplate))
            plusImageView.tintColor = .primary
            cell.addSubview(plusImageView)
            plusImageView.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.right.equalToSuperview().inset(15)
                make.width.height.equalTo(22)
            }
        } else {
            let numbLabel = UILabel()
            numbLabel.text = "\(indexPath.row + 1)"
            numbLabel.textColor = .primary
            numbLabel.font = .systemFont(ofSize: 17, weight: .regular)
            cell.addSubview(numbLabel)
            numbLabel.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.left.equalToSuperview().inset(15)
            }
            
            let nameLabel = UILabel()
            nameLabel.text = racersOld?[indexEditRace].totals[indexPath.row].pilotName
            nameLabel.textColor = .white
            nameLabel.font = .systemFont(ofSize: 16, weight: .regular)
            cell.addSubview(nameLabel)
            nameLabel.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.left.equalTo(numbLabel.snp.right).inset(-15)
            }
            
            let timeLabel = UILabel()
            timeLabel.text = racersOld?[indexEditRace].totals[indexPath.row].time
            timeLabel.textColor = .white.withAlphaComponent(0.5)
            timeLabel.font = .systemFont(ofSize: 17, weight: .regular)
            cell.addSubview(timeLabel)
            timeLabel.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.right.equalToSuperview().inset(15)
            }
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 54)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == (racersOld?[indexEditRace].totals.count ?? 0) , isEdit == true {
            createAndEditTotal(index: nil, isNew: true)
        } else if isEdit == true , indexPath.row != (racersOld?[indexEditRace].totals.count ?? 0){
            createAndEditTotal(index: indexPath.row, isNew: false)
        }
    }
    
    
}
