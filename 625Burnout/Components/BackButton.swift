//
//  BackButton.swift
//  625Burnout
//
//  Created by Владимир Кацап on 13.09.2024.
//

import UIKit

class BackButton: UIButton {

    override init(frame: CGRect) {
        super .init(frame: frame)
        createButton()
    }
    
    // make.width.equalTo(57)
    //make.height.equalTo(44)
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createButton() {
        let label = UILabel()
        label.text = "Back"
        label.textColor = .primary
        label.font = .systemFont(ofSize: 17, weight: .regular)
        addSubview(label)
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        let backImageView = UIImageView(image: .leftArrow)
        addSubview(backImageView)
        backImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
            make.height.equalTo(22)
            make.width.equalTo(13)
        }
    }
    
}
