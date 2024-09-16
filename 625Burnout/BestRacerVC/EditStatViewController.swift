//
//  EditStatViewController.swift
//  625Burnout
//
//  Created by Владимир Кацап on 16.09.2024.
//

import UIKit
import SnapKit
import Combine

class EditStatViewController: UIViewController {
    
    private let goBackButton = BackButton()
    var oldStat: Stat?
    
    //ui
    lazy var totalRacersTextField = UITextField()
    lazy var ratedRacingTextField = UITextField()
    lazy var bestResultTextField = UITextField()
    lazy var bestRacerTextField = UITextField()
    lazy var commandNameTextField = UITextField()
    
    lazy var saveButton = UIButton()
    
    
    var publisher: PassthroughSubject<Stat, Never>?
    var cancellable = [AnyCancellable]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .bgSecond
        createInterface()
        checkIsNew()
    }
    
    func checkIsNew() {
        if oldStat != nil {
            totalRacersTextField.text = oldStat?.totalRacers
            ratedRacingTextField.text = oldStat?.ratedRacing
            bestResultTextField.text = oldStat?.bestResult
            bestRacerTextField.text = oldStat?.bestRacer
            commandNameTextField.text = oldStat?.commandName
            saveButton.alpha = 1
            saveButton.isEnabled = true
        }
    }
    

    func createInterface() {
        let hideView = UIView()
        hideView.layer.cornerRadius = 2.5
        hideView.backgroundColor = .white.withAlphaComponent(0.1)
        view.addSubview(hideView)
        hideView.snp.makeConstraints { make in
            make.height.equalTo(5)
            make.width.equalTo(36)
            make.top.equalTo(10)
            make.centerX.equalToSuperview()
        }
        
        let addLabel = UILabel()
        addLabel.text = "Edit statistics"
        addLabel.textColor = .white
        addLabel.font = .systemFont(ofSize: 17, weight: .bold)
        view.addSubview(addLabel)
        addLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(hideView.snp.bottom).inset(-10)
        }
        
        view.addSubview(goBackButton)
        goBackButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.centerY.equalTo(addLabel)
            make.width.equalTo(57)
            make.height.equalTo(44)
        }
        goBackButton.tapPublisher
            .sink { tap in
                self.dismiss(animated: true)
            }
            .store(in: &cancellable)
        
        totalRacersTextField = createTextField(placeholder: "Total races")
        totalRacersTextField.keyboardType = .numberPad
        view.addSubview(totalRacersTextField)
        totalRacersTextField.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(addLabel.snp.bottom).inset(-30)
            make.height.equalTo(54)
        }
        
        ratedRacingTextField = createTextField(placeholder: "Rated racing")
        ratedRacingTextField.keyboardType = .numberPad
        view.addSubview(ratedRacingTextField)
        ratedRacingTextField.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(totalRacersTextField.snp.bottom).inset(-15)
            make.height.equalTo(54)
        }
        
        bestResultTextField = createTextField(placeholder: "Best result")
        view.addSubview(bestResultTextField)
        bestResultTextField.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(ratedRacingTextField.snp.bottom).inset(-15)
            make.height.equalTo(54)
        }
        
        bestRacerTextField = createTextField(placeholder: "Best racer")
        view.addSubview(bestRacerTextField)
        bestRacerTextField.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(bestResultTextField.snp.bottom).inset(-15)
            make.height.equalTo(54)
        }
        
        commandNameTextField = createTextField(placeholder: "Comand name")
        view.addSubview(commandNameTextField)
        commandNameTextField.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(bestRacerTextField.snp.bottom).inset(-15)
            make.height.equalTo(54)
        }
        
        let hideKBGesture = UITapGestureRecognizer(target: self, action: nil)
        hideKBGesture.tapPublisher
            .sink { _ in
                self.view.endEditing(true)
                self.checkFill()
            }
            .store(in: &cancellable)
        view.addGestureRecognizer(hideKBGesture)
        
        saveButton = {
            let button = UIButton(type: .system)
            button.setTitle("Save", for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.backgroundColor = .primary
            button.layer.cornerRadius = 12
            button.isEnabled = false
            button.alpha = 0.5
            return button
        }()
        view.addSubview(saveButton)
        saveButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.height.equalTo(56)
        }
        
        saveButton.tapPublisher
            .sink { [self] _ in
                let totat: String = totalRacersTextField.text ?? ""
                let rated: String = ratedRacingTextField.text ?? ""
                let result: String = bestResultTextField.text ?? ""
                let racer: String = bestRacerTextField.text ?? ""
                let comand: String = commandNameTextField.text ?? ""
                
                let stat = Stat(totalRacers: totat, ratedRacing: rated, bestResult: result, bestRacer: racer, commandName: comand)
                publisher?.send(stat)
                self.dismiss(animated: true)
                
            }
            .store(in: &cancellable)
            
        
    }
    
    func checkFill() {
        if totalRacersTextField.text?.count ?? 0 > 0, ratedRacingTextField.text?.count ?? 0 > 0, bestResultTextField.text?.count ?? 0 > 0, bestRacerTextField.text?.count ?? 0 > 0 , commandNameTextField.text?.count ?? 0 > 0 {
            saveButton.alpha = 1
            saveButton.isEnabled = true
        } else {
            saveButton.alpha = 0.5
            saveButton.isEnabled = false
        }
    }
    
    func createTextField(placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.backgroundColor = .clear
        textField.textAlignment = .right
        textField.layer.cornerRadius = 16
        textField.textColor = .white
        textField.layer.borderWidth = 1
        textField.delegate = self
        let label = UILabel()
        label.text = "   \(placeholder)"
        label.textColor = .white.withAlphaComponent(0.5)
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.frame = CGRect(x: 0, y: 0, width: 150, height: 30)
        textField.leftView = label
        textField.leftViewMode = .always
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        textField.rightViewMode = .always
        
        textField.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
        return textField
    }

}

extension EditStatViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        checkFill()
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        checkFill()
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        checkFill()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        checkFill()
        return true
    }
}
