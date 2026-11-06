//
//  LoginViewController.swift
//  Vestige
//
//  Created by Javanshir Najafzade on 18.09.26.
//

import UIKit
import SnapKit

class LoginViewController: UIViewController {

    private let brandLabel: UILabel = {
        let brandLabel = UILabel()
        brandLabel.attributedText = NSAttributedString(
            string: "VESTIGE",
            attributes: [
                .kern: 4,
                .font: UIFont.systemFont(ofSize: 12, weight: .semibold),
                .foregroundColor: UIColor(named: "VestigeSecondaryText") ?? .secondaryLabel
            ]
        )
        return brandLabel
    }()

    private let welcomeLabel: UILabel = {
        let welcomeLabel = UILabel()
        welcomeLabel.text = "Welcome"
        welcomeLabel.textColor = UIColor(named: "VestigeGreen") ?? .systemGreen
        welcomeLabel.font = UIFont(name: "CormorantGaramond-Regular", size: 50) ?? .systemFont(ofSize: 50)
        return welcomeLabel
    }()

    private let subtitleLabel: UILabel = {
        let subtitleLabel = UILabel()
        subtitleLabel.text = "Log in to keep your memories."
        subtitleLabel.textColor = UIColor(named: "VestigeSecondaryText") ?? .secondaryLabel
        subtitleLabel.font = .systemFont(ofSize: 15, weight: .regular)
        return subtitleLabel
    }()

    private let emailTF: UITextField = {
        let emailTF = UITextField()
        emailTF.attributedPlaceholder = NSAttributedString(
            string: "Email",
            attributes: [.foregroundColor: UIColor(named: "VestigeSecondaryText") ?? .secondaryLabel]
        )
        emailTF.textColor = UIColor(named: "VestigeGreen") ?? .systemGreen
        emailTF.tintColor = UIColor(named: "VestigeGreen") ?? .systemGreen
        emailTF.font = .systemFont(ofSize: 15)
        emailTF.backgroundColor = .white.withAlphaComponent(0.75)
        emailTF.layer.cornerRadius = 16
        emailTF.keyboardType = .emailAddress
        emailTF.autocapitalizationType = .none
        emailTF.autocorrectionType = .no
        emailTF.returnKeyType = .next
        return emailTF
    }()

    private let passwordTF: UITextField = {
        let passwordTF = UITextField()
        passwordTF.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [.foregroundColor: UIColor(named: "VestigeSecondaryText") ?? .secondaryLabel]
        )
        passwordTF.textColor = UIColor(named: "VestigeGreen") ?? .systemGreen
        passwordTF.tintColor = UIColor(named: "VestigeGreen") ?? .systemGreen
        passwordTF.font = .systemFont(ofSize: 15)
        passwordTF.backgroundColor = .white.withAlphaComponent(0.75)
        passwordTF.layer.cornerRadius = 16
        passwordTF.autocapitalizationType = .none
        passwordTF.autocorrectionType = .no
        passwordTF.returnKeyType = .go
        return passwordTF
    }()

    private let loginButton: UIButton = {
        let loginButton = UIButton()
        loginButton.setTitle("Login", for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        loginButton.backgroundColor = UIColor(named: "VestigeGreen") ?? .systemGreen
        loginButton.layer.cornerRadius = 16
        loginButton.layer.shadowColor = (UIColor(named: "VestigeGreen") ?? .systemGreen).cgColor
        loginButton.layer.shadowOpacity = 0.25
        loginButton.layer.shadowRadius = 10
        loginButton.layer.shadowOffset = CGSize(width: 0, height: 6)
        return loginButton
    }()

    private let registerButton: UIButton = {
        let registerButton = UIButton()

        let title = NSMutableAttributedString(
            string: "New here? ",
            attributes: [
                .foregroundColor: UIColor(named: "VestigeSecondaryText") ?? .secondaryLabel,
                .font: UIFont.systemFont(ofSize: 15, weight: .regular)
            ]
        )
        title.append(NSAttributedString(
            string: "Create Account",
            attributes: [
                .foregroundColor: UIColor(named: "VestigeGreen") ?? .systemGreen,
                .font: UIFont.systemFont(ofSize: 15, weight: .semibold)
            ]
        ))

        registerButton.setAttributedTitle(title, for: .normal)
        return registerButton
    }()

    private let eyeButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "VestigeCream") ?? .systemBackground
        navigationController?.navigationBar.tintColor = UIColor(named: "VestigeGreen") ?? .systemGreen

        setupUI()
        setupPasswordEye()
    }

    func setupUI(){
        [brandLabel, welcomeLabel, subtitleLabel, emailTF, passwordTF, loginButton, registerButton].forEach{view.addSubview($0)}

        emailTF.leftView = makeLeftIcon("envelope")
        emailTF.leftViewMode = .always
        emailTF.delegate = self

        passwordTF.leftView = makeLeftIcon("lock")
        passwordTF.leftViewMode = .always
        passwordTF.delegate = self

        brandLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.leading.equalToSuperview().inset(30)
        }

        welcomeLabel.snp.makeConstraints{ make in
            make.top.equalTo(brandLabel.snp.bottom).offset(6)
            make.leading.equalTo(brandLabel)
        }

        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(welcomeLabel.snp.bottom).offset(2)
            make.leading.equalTo(brandLabel)
        }

        emailTF.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(54)
        }

        passwordTF.snp.makeConstraints { make in
            make.top.equalTo(emailTF.snp.bottom).offset(16)
            make.leading.trailing.equalTo(emailTF)
            make.height.equalTo(emailTF)
        }

        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTF.snp.bottom).offset(28)
            make.leading.trailing.equalTo(emailTF)
            make.height.equalTo(54)
        }

        registerButton.snp.makeConstraints{ make in
            make.top.equalTo(loginButton.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }

        registerButton.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)

        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    private func makeLeftIcon(_ systemName: String) -> UIView {
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 20))

        let icon = UIImageView(image: UIImage(systemName: systemName))
        icon.tintColor = UIColor(named: "VestigeSecondaryText") ?? .secondaryLabel
        icon.contentMode = .scaleAspectFit
        icon.frame = CGRect(x: 18, y: 0, width: 20, height: 20)

        container.addSubview(icon)
        return container
    }

    private func setupPasswordEye() {
        passwordTF.isSecureTextEntry = true

        let container = UIView(frame: CGRect(x: 0, y: 0, width: 56, height: 30))

        eyeButton.setImage(eyeImage(isHidden: true), for: .normal)
        eyeButton.tintColor = UIColor(named: "VestigeGreen") ?? .systemGreen
        eyeButton.backgroundColor = (UIColor(named: "VestigeGreen") ?? .systemGreen).withAlphaComponent(0.1)
        eyeButton.layer.cornerRadius = 15
        eyeButton.frame = CGRect(x: 6, y: 0, width: 30, height: 30)
        eyeButton.addTarget(self, action: #selector(togglePassword), for: .touchUpInside)

        container.addSubview(eyeButton)

        passwordTF.rightView = container
        passwordTF.rightViewMode = .always
    }

    private func eyeImage(isHidden: Bool) -> UIImage? {
        let config = UIImage.SymbolConfiguration(pointSize: 14, weight: .medium)
        return UIImage(systemName: isHidden ? "eye.slash" : "eye", withConfiguration: config)
    }

    @objc private func togglePassword() {
        let text = passwordTF.text
        passwordTF.isSecureTextEntry.toggle()
        passwordTF.text = nil
        passwordTF.text = text

        eyeButton.setImage(eyeImage(isHidden: passwordTF.isSecureTextEntry), for: .normal)
    }

    @objc private func registerTapped(){
        let registerVC = RegisterViewController()
        navigationController?.pushViewController(registerVC, animated: true)
    }

    @objc private func loginTapped() {
        let email = emailTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let password = passwordTF.text ?? ""

        guard !email.isEmpty, !password.isEmpty else {
            showAlert(message: "Please fill in all fields.")
            return
        }

        setLoading(true)

        AuthService.shared.login(email: email, password: password) { [weak self] result in
            guard let self = self else { return }
            self.setLoading(false)

            switch result {
            case .success:
                UserSession.save(name: "", email: email)
                self.view.window?.rootViewController = MainTabBarViewController()
            case .failure:
                self.showAlert(message: "Email or password is wrong.")
            }
        }
    }

    private func setLoading(_ isLoading: Bool) {
        loginButton.isEnabled = !isLoading
        loginButton.setTitle(isLoading ? "Please wait..." : "Login", for: .normal)
        loginButton.alpha = isLoading ? 0.6 : 1
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Login failed", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTF {
            passwordTF.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            loginTapped()
        }
        return true
    }
}
