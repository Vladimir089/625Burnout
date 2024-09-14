//
//  NewRaceViewController.swift
//  625Burnout
//
//  Created by Владимир Кацап on 13.09.2024.
//

import UIKit
import Combine

class NewRaceViewController: UIViewController, UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    private let goBackButton = BackButton()
    private lazy var saveButton = UIButton()
    var racersNew: [Race] = []

    var raceCreated: PassthroughSubject<[Race], Never>?
    
    //main
    private lazy var imageView = UIImageView()
    private lazy var trackNameTextField = createTextField(placeholder: "Track name")
    private lazy var locationTextField = createTextField(placeholder: "Location")
    private lazy var dateTextField = createTextField(placeholder: "Date")

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .bgSecond
        createInterface()
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
        addLabel.text = "Add a race"
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
        goBackButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        
        imageView = {
            let imageView = UIImageView(image: .noImageView)
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 12
            imageView.backgroundColor = .black
            imageView.isUserInteractionEnabled = true
            return imageView
        }()
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(addLabel.snp.bottom).inset(-15)
            make.height.equalTo(148)
        }
        let gestureSetImage = UITapGestureRecognizer(target: self, action: #selector(setImage))
        imageView.addGestureRecognizer(gestureSetImage)
        
        view.addSubview(trackNameTextField)
        trackNameTextField.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(54)
            make.top.equalTo(imageView.snp.bottom).inset(-15)
        }
        
        view.addSubview(locationTextField)
        locationTextField.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(54)
            make.top.equalTo(trackNameTextField.snp.bottom).inset(-10)
        }
        
        view.addSubview(dateTextField)
        let imageViewCalendar = UIImageView(image: .calendar.resize(targetSize: CGSize(width: 20, height: 20)))
        imageViewCalendar.contentMode = .scaleAspectFit

        let leftViewContainer = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 20))
        leftViewContainer.addSubview(imageViewCalendar)
        imageViewCalendar.frame = CGRect(x:15, y: leftViewContainer.frame.minY, width: 20, height: 20)
        dateTextField.leftView = leftViewContainer
        dateTextField.leftViewMode = .always
        
        // Создаем и настраиваем UIDatePicker
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        datePicker.locale = Locale(identifier: "en_EN") // Устанавливаем локаль для формата даты
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)

        dateTextField.inputView = datePicker

        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
        toolbar.setItems([doneButton], animated: true)
        dateTextField.inputAccessoryView = toolbar
        
        dateTextField.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(54)
            make.top.equalTo(locationTextField.snp.bottom).inset(-10)
        }
        
        saveButton = {
            let button = UIButton(type: .system)
            button.backgroundColor = .primary.withAlphaComponent(0.5)
            button.setTitle("Save", for: .normal)
            button.layer.cornerRadius = 12
            button.setTitleColor(.black, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
            button.isUserInteractionEnabled = false
            return button
        }()
        view.addSubview(saveButton)
        saveButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.height.equalTo(56)
        }
        saveButton.addTarget(self, action: #selector(saveRace), for: .touchUpInside)
        
        let hideKBGesture = UITapGestureRecognizer(target: self, action: #selector(hideKB))
        view.addGestureRecognizer(hideKBGesture)
    }
    
    @objc func saveRace() {
        
        let image: Data = imageView.image?.jpegData(compressionQuality: 1) ?? Data()
        let trackName:String = trackNameTextField.text ?? ""
        let location: String = locationTextField.text ?? ""
        let date: String = dateTextField.text ?? ""
        
        let race = Race(Image: image, trackName: trackName, location: location, date: date, totals: [])
        racersNew.append(race)
        print(racersNew)
        raceCreated?.send(racersNew)
        close()
    }
    
    func checkButton() {
        if imageView.image != .noImageView , trackNameTextField.text?.count ?? 0 > 0, locationTextField.text?.count ?? 0 > 0 , dateTextField.text?.count ?? 0 > 0 {
            saveButton.isUserInteractionEnabled = true
            saveButton.backgroundColor = .primary
        } else {
            saveButton.isUserInteractionEnabled = false
            saveButton.backgroundColor = .primary.withAlphaComponent(0.5)
        }
    }
    
    @objc func hideKB() {
        checkButton()
        view.endEditing(true)
    }
    
    @objc func dateChanged(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        dateTextField.text = formatter.string(from: sender.date)
    }

    // Метод, вызываемый при нажатии на кнопку "Готово"
    @objc func doneTapped() {
        dateTextField.resignFirstResponder()
    }
    
    func createTextField(placeholder: String) -> UITextField {
        let textfield = UITextField()
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.5)
        ]
        textfield.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: attributes)
        textfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        textfield.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        textfield.rightViewMode = .always
        textfield.leftViewMode = .always
        textfield.textColor = .white
        textfield.backgroundColor = .bgSecond
        textfield.layer.borderWidth = 1
        textfield.delegate = self
        textfield.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        textfield.layer.cornerRadius = 10
        return textfield
    }
    
    @objc func setImage() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = false
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let pickedImage = info[.originalImage] as? UIImage {
            imageView.image = pickedImage
            checkButton()
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    @objc func close() {
        self.dismiss(animated: true)
    }

}

extension NewRaceViewController: UITextFieldDelegate {
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        checkButton()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        checkButton()
        view.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkButton()
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        checkButton()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        checkButton()
        return true
    }
}
