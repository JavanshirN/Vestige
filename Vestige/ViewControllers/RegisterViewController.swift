//
//  RegisterViewController.swift
//  Vestige
//
//  Created by Javanshir Najafzade on 26.09.26.
//

import UIKit
import SnapKit

class RegisterViewController: UIViewController {
    
    private let nameTF: UITextField = {
        let nameTF = UITextField()
        nameTF.placeholder = "Name"
        nameTF.borderStyle = .roundedRect
        return nameTF
    }()
    
    private let emailTF: UITextField = {
        let emailTF = UITextField()
        emailTF.placeholder = "Email"
        emailTF.borderStyle = .roundedRect
        return emailTF
    }()
    
    private let passTF: UITextField = {
        let passTF = UITextField()
        passTF.placeholder = "Password"
        passTF.borderStyle = .roundedRect
        return passTF
    }()
    
    private let createBtn: UIButton = {
        let createBtn = UIButton()
        createBtn.setTitle("Create", for: .normal)
        createBtn.backgroundColor = .systemGreen
        createBtn.layer.cornerRadius = 10
        return createBtn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupUI()
    }
    
    private func setupUI(){
        
        [nameTF, emailTF, passTF, createBtn].forEach{view.addSubview($0)}
        
        nameTF.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }

        emailTF.snp.makeConstraints { make in
            make.top.equalTo(nameTF.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }

        passTF.snp.makeConstraints { make in
            make.top.equalTo(emailTF.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }

        createBtn.snp.makeConstraints { make in
            make.top.equalTo(passTF.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
    }
}
