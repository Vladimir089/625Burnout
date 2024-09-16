//
//  BestRacerViewController.swift
//  625Burnout
//
//  Created by Владимир Кацап on 16.09.2024.
//

import UIKit
import SnapKit
import Combine

class BestRacerViewController: UIViewController, UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    var stat: Stat?
    
    lazy var totalRacersLabel = UILabel()
    lazy var ratedRacersLabel = UILabel()
    
    
    lazy var profileImageView = UIImageView()
    lazy var resultLabel = UILabel()
    lazy var namePilotLabel = UILabel()
    lazy var commandNameLabel = UILabel()
    
    //publ
    var cancellable = [AnyCancellable]()
    var infoPublisher = PassthroughSubject<Stat, Never>()
    
    
    //comb
    var cancellables = [AnyCancellable]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        createInterface()
        loadData()
        subscribe()
    }
    
    
    
    
    func subscribe() {
        infoPublisher
            .sink(receiveValue: { stat in
                self.stat = stat
                
                do {
                    let data = try JSONEncoder().encode(stat) //тут мкассив конвертируем в дату
                    try self.saveAthleteArrToFile(data: data)
                    
                    self.reload()
                } catch {
                    print("Failed to encode or save athleteArr: \(error)")
                }
                
            })
            .store(in: &cancellable)
    }
    
    func saveAthleteArrToFile(data: Data) throws {
        let fileManager = FileManager.default
        if let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let filePath = documentDirectory.appendingPathComponent("stat.plist")
            try data.write(to: filePath)
        } else {
            throw NSError(domain: "SaveError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Unable to get document directory"])
        }
    }
    
   
    
    func reload() {
        totalRacersLabel.text = stat?.totalRacers
        ratedRacersLabel.text = stat?.ratedRacing
        resultLabel.text = stat?.bestResult
        namePilotLabel.text = stat?.bestRacer
        commandNameLabel.text = stat?.commandName
    }
    
    func loadData() {
        if let image = UserDefaults.standard.data(forKey: "image") {
            profileImageView.image = UIImage(data: image)
        }
        
        stat = loadAthleteArrFromFile()
        
        
        if stat != nil {
            reload()
        }
    }
    
    func loadAthleteArrFromFile() -> Stat? {
        let fileManager = FileManager.default
        guard let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Unable to get document directory")
            return nil
        }
        let filePath = documentDirectory.appendingPathComponent("stat.plist")
        do {
            let data = try Data(contentsOf: filePath)
            let athleteArr = try JSONDecoder().decode(Stat.self, from: data)
            return athleteArr
        } catch {
            print("Failed to load or decode athleteArr: \(error)")
            return nil
        }
    }

    func createInterface() {
        let topLabel = UILabel()
        topLabel.text = "Statistics"
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
        
        let totalRacersView = createBackView(image: .oneFlag, mainLabel: totalRacersLabel, botText: "Total races")
        view.addSubview(totalRacersView)
        totalRacersView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(separatorView.snp.bottom).inset(-15)
            make.height.equalTo(145)
            make.right.equalTo(view.snp.centerX).offset(-7.5)
        }
        
        let ratedRacersView = createBackView(image: .cub, mainLabel: ratedRacersLabel, botText: "Rated racing")
        view.addSubview(ratedRacersView)
        ratedRacersView.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(15)
            make.top.equalTo(separatorView.snp.bottom).inset(-15)
            make.height.equalTo(145)
            make.left.equalTo(view.snp.centerX).offset(7.5)
        }
        
        let profileView: UIView = {
            let view = UIView()
            view.backgroundColor = .bgSecond
            view.layer.cornerRadius = 12
            
            profileImageView.image = .nulProfile
            profileImageView.clipsToBounds = true
            profileImageView.layer.cornerRadius = 12
            profileImageView.isUserInteractionEnabled = true
            view.addSubview(profileImageView)
            profileImageView.snp.makeConstraints { make in
                make.left.equalToSuperview().inset(15)
                make.top.bottom.equalToSuperview().inset(15)
                make.width.equalTo(159)
            }
            
            let bestResultLabel = UILabel()
            bestResultLabel.text = "Best result:"
            bestResultLabel.textColor = .white
            bestResultLabel.font = .systemFont(ofSize: 17, weight: .bold)
            view.addSubview(bestResultLabel)
            bestResultLabel.snp.makeConstraints { make in
                make.top.equalToSuperview().inset(30)
                make.left.equalTo(profileImageView.snp.right).inset(-20)
            }
            
            resultLabel.textColor = .primary
            resultLabel.font = .systemFont(ofSize: 28, weight: .bold)
            resultLabel.textAlignment = .left
            resultLabel.text = "00:00:00"
            view.addSubview(resultLabel)
            resultLabel.snp.makeConstraints { make in
                make.left.equalTo(bestResultLabel.snp.left)
                make.top.equalTo(bestResultLabel.snp.bottom).inset(-5)
                make.right.equalToSuperview().inset(15)
            }
            
            let verticalSeparatorView = UIView()
            verticalSeparatorView.backgroundColor = .primary
            verticalSeparatorView.layer.cornerRadius = 1.5
            view.addSubview(verticalSeparatorView)
            verticalSeparatorView.snp.makeConstraints { make in
                make.height.equalTo(42)
                make.width.equalTo(3)
                make.left.equalTo(resultLabel.snp.left)
                make.bottom.equalToSuperview().inset(30)
            }
            
            namePilotLabel.text = "Racer Name"
            namePilotLabel.textColor = .white
            namePilotLabel.font = .systemFont(ofSize: 16, weight: .regular)
            namePilotLabel.textAlignment = .left
            view.addSubview(namePilotLabel)
            namePilotLabel.snp.makeConstraints { make in
                make.left.equalTo(verticalSeparatorView.snp.right).inset(-10)
                make.right.equalToSuperview().inset(15)
                make.bottom.equalTo(verticalSeparatorView.snp.centerY).offset(-2)
            }
            
            commandNameLabel.text = "Comand name"
            commandNameLabel.textColor = .white.withAlphaComponent(0.5)
            commandNameLabel.font = .systemFont(ofSize: 12, weight: .regular)
            commandNameLabel.textAlignment = .left
            view.addSubview(commandNameLabel)
            commandNameLabel.snp.makeConstraints { make in
                make.left.equalTo(verticalSeparatorView.snp.right).inset(-10)
                make.right.equalToSuperview().inset(15)
                make.top.equalTo(verticalSeparatorView.snp.centerY).offset(2)
            }
            
            return view
        }()
        
        view.addSubview(profileView)
        profileView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(totalRacersView.snp.bottom).inset(-15)
            make.height.equalTo(201)
        }
        let selectImageGesture = UITapGestureRecognizer(target: self, action: nil)
        selectImageGesture.tapPublisher
            .sink { tap in
                self.setImage()
            }
            .store(in: &cancellables)
        profileImageView.addGestureRecognizer(selectImageGesture)
        
        
        let editStatButton: UIButton = {
            let button = UIButton()
            button.backgroundColor = .clear
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
            button.layer.cornerRadius = 12
            
            let label = UILabel()
            label.text = "Edit statistics"
            label.textColor = .white.withAlphaComponent(0.5)
            label.font = .systemFont(ofSize: 17, weight: .bold)
            button.addSubview(label)
            label.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.centerX.equalToSuperview().offset(10)
            }
            
            let imageView = UIImageView(image: .pen)
            button.addSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.height.equalTo(24)
                make.width.equalTo(26)
                make.centerY.equalToSuperview()
                make.right.equalTo(label.snp.left).inset(-15)
            }
            
            return button
        }()
        view.addSubview(editStatButton)
        editStatButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(56)
            make.top.equalTo(profileView.snp.bottom).inset(-15)
        }
        editStatButton.tapPublisher
            .sink { tap in
                self.openEditPage()
            }
            .store(in: &cancellable)
        
    }
    
   
    func openEditPage() {
        let vc = EditStatViewController()
        vc.oldStat = stat
        vc.publisher = infoPublisher
        self.present(vc, animated: true)
        
    }
    
    
    
    func setImage() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = false
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let pickedImage = info[.originalImage] as? UIImage {
            profileImageView.image = pickedImage
            UserDefaults.standard.setValue(pickedImage.jpegData(compressionQuality: 0.1), forKey: "image")
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func createBackView(image: UIImage, mainLabel: UILabel, botText: String) -> UIView {
        let view = UIView()
        view.backgroundColor = .bgSecond
        view.layer.cornerRadius = 12
        
        let imageView = UIImageView(image: image)
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.left.top.equalToSuperview().inset(15)
            make.height.equalTo(24)
            make.width.equalTo(22)
        }
        
        let botLabel = UILabel()
        botLabel.text = botText
        botLabel.font = .systemFont(ofSize: 15, weight: .regular)
        botLabel.textColor = .white.withAlphaComponent(0.5)
        view.addSubview(botLabel)
        botLabel.snp.makeConstraints { make in
            make.left.bottom.equalToSuperview().inset(15)
        }
        
        mainLabel.text = "0"
        mainLabel.font = .systemFont(ofSize: 28, weight: .bold)
        mainLabel.textColor = .white
        mainLabel.textAlignment = .left
        view.addSubview(mainLabel)
        mainLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.bottom.equalTo(botLabel.snp.top).inset(-5)
        }
        
        return view
    }
    

}


struct Stat: Codable {
    var totalRacers: String
    var ratedRacing: String
    var bestResult: String
    var bestRacer: String
    var commandName: String
    
    init(totalRacers: String, ratedRacing: String, bestResult: String, bestRacer: String, commandName: String) {
        self.totalRacers = totalRacers
        self.ratedRacing = ratedRacing
        self.bestResult = bestResult
        self.bestRacer = bestRacer
        self.commandName = commandName
    }
    
}
