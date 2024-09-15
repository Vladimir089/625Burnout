//
//  HomeViewController.swift
//  625Burnout
//
//  Created by Владимир Кацап on 13.09.2024.
//

import UIKit
import Combine



class HomeViewController: UIViewController {
    
    var racers: [Race] = []
    
    lazy var noRaceView = UIView()
    lazy var collection = UICollectionView()
    
    var raceCreated = PassthroughSubject<[Race], Never>()
    var cancellable: AnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        racers = loadAthleteArrFromFile() ?? []
        createInterface()
        checkArray()

        subscribe()
    }
    
    func subscribe() {
        cancellable = raceCreated
            .sink(receiveValue: { newRace in
                self.racers = newRace
                print(2)
                do {
                    let data = try JSONEncoder().encode(self.racers)
                    try self.saveAthleteArrToFile(data: data)
                    self.checkArray()
                } catch {
                    print("Failed to encode or save athleteArr: \(error)")
                }
            })
            
    }
    
    func saveAthleteArrToFile(data: Data) throws {
        let fileManager = FileManager.default
        if let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let filePath = documentDirectory.appendingPathComponent("race.plist")
            try data.write(to: filePath)
        } else {
            throw NSError(domain: "SaveError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Unable to get document directory"])
        }
    }
    
    func loadAthleteArrFromFile() -> [Race]? {
        let fileManager = FileManager.default
        guard let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Unable to get document directory")
            return nil
        }
        let filePath = documentDirectory.appendingPathComponent("race.plist")
        do {
            let data = try Data(contentsOf: filePath)
            let athleteArr = try JSONDecoder().decode([Race].self, from: data)
            return athleteArr
        } catch {
            print("Failed to load or decode athleteArr: \(error)")
            return nil
        }
    }
    
    
    
    func checkArray() {
        if racers.count > 0 {
            collection.alpha = 1
            noRaceView.alpha = 0
            collection.reloadData()
        } else {
            collection.alpha = 0
            noRaceView.alpha = 1
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
        
        view.addSubview(noRaceView)
        noRaceView.snp.makeConstraints({ make in
            make.center.equalToSuperview()
            make.height.equalTo(199)
            make.width.equalTo(294)
        })
        
        collection = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collection.backgroundColor = .clear
            collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "1")
            collection.delegate = self
            collection.dataSource = self
            collection.showsVerticalScrollIndicator = false
            collection.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 25, right: 0)
            return collection
        }()
        view.addSubview(collection)
        collection.snp.makeConstraints { make in
            make.bottom.right.left.equalToSuperview()
            make.top.equalTo(separatorView.snp.bottom).inset(-5)
        }
        
    }
    
    @objc func createRace() {
        let vc = NewRaceViewController()
        vc.racersNew = racers
        vc.raceCreated = raceCreated
        self.present(vc, animated: true)
    }
    
    @objc func createOrOpenTotals(sender: UIButton) {
        let vc = AddAndEditTotalsViewController()
        vc.oldRacersPublisher = raceCreated
        vc.racersOld = racers
        vc.indexEditRace = sender.tag
        self.present(vc, animated: true)
    }
    
}


extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return racers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "1", for: indexPath)
        cell.subviews.forEach { $0.removeFromSuperview() }
        cell.layer.cornerRadius = 16
        cell.backgroundColor = .bgSecond
        
        let labelTop = UILabel()
        labelTop.text = racers[indexPath.row].trackName
        labelTop.textColor = .white
        labelTop.font = .systemFont(ofSize: 20, weight: .bold)
        labelTop.textAlignment = .left
        cell.addSubview(labelTop)
        labelTop.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalToSuperview().inset(15)
        }
        
        let imageViewFlags = UIImageView(image: .twoFlagsSecond.withRenderingMode(.alwaysTemplate))
        imageViewFlags.tintColor = .white.withAlphaComponent(0.5)
        cell.addSubview(imageViewFlags)
        imageViewFlags.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(labelTop.snp.bottom).inset( -15)
            make.height.equalTo(20)
            make.width.equalTo(30)
        }
        
        let dateLabel = UILabel()
        dateLabel.text = "\(racers[indexPath.row].date) · \(racers[indexPath.row].location)"
        dateLabel.textColor = .white.withAlphaComponent(0.5)
        dateLabel.textAlignment = .left
        dateLabel.font = .systemFont(ofSize: 17, weight: .regular)
        cell.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(imageViewFlags)
            make.left.equalTo(imageViewFlags.snp.right).inset(-5)
            make.right.equalToSuperview().inset(15)
        }
        
        let imageView = UIImageView(image: UIImage(data: racers[indexPath.row].Image))
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        cell.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).inset(-15)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(136)
        }
        
        let buttonView = UIButton()
        let labelButton = UILabel()
        let imageViewButton = UIImageView()
        
        buttonView.layer.cornerRadius = 12
        buttonView.tag = indexPath.row
        
        if racers[indexPath.row].totals.count > 0 {
            labelButton.text = "View totals"
            labelButton.textColor = .black
            labelButton.font = .systemFont(ofSize: 17, weight: .bold)
            imageViewButton.image = UIImage.rightArrow
            buttonView.backgroundColor = .primary
        } else {
            labelButton.text = "Add totals"
            labelButton.textColor = .white.withAlphaComponent(0.5)
            labelButton.font = .systemFont(ofSize: 17, weight: .bold)
            imageViewButton.image = UIImage.whitePlus
            buttonView.backgroundColor = .clear
            buttonView.layer.borderWidth = 1
            buttonView.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
        }
        
        buttonView.addSubview(labelButton)
        labelButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.centerY.equalToSuperview()
        }
        buttonView.addSubview(imageViewButton)
        imageViewButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(15)
            make.centerY.equalToSuperview()
            make.width.equalTo(imageViewButton.image == .whitePlus ? 19 : 12)
            make.height.equalTo(imageViewButton.image == .whitePlus ? 22 : 20)
        }
        
        cell.addSubview(buttonView)
        buttonView.snp.makeConstraints { make in
            make.left.bottom.equalToSuperview().inset(15)
            make.height.equalTo(44)
            make.right.equalTo(cell.snp.centerX)
        }
        buttonView.addTarget(self, action: #selector(createOrOpenTotals(sender:)), for: .touchUpInside)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 30, height: 310)
    }
    
    
}
