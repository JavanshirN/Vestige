//
//  RegisterViewController.swift
//  Vestige
//
//  Created by Javanshir Najafzade on 26.09.26.
//


import UIKit
import SnapKit

private let vestigeGreen = UIColor(named: "VestigeGreen") ?? .systemGreen
private let vestigeSecondary = UIColor(named: "VestigeSecondaryText") ?? .secondaryLabel
private let vestigeCream = UIColor(named: "VestigeCream") ?? .systemBackground

class RegisterViewController: UIViewController {

    private let brandLabel: UILabel = {
        let brandLabel = UILabel()
        brandLabel.attributedText = NSAttributedString(
            string: "VESTIGE",
            attributes: [
                .kern: 4,
                .font: UIFont.systemFont(ofSize: 12, weight: .semibold),
                .foregroundColor: vestigeSecondary
            ]
        )
        return brandLabel
    }()

    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Create Account"
        titleLabel.textColor = vestigeGreen
        titleLabel.font = UIFont(name: "CormorantGaramond-Regular", size: 44) ?? .systemFont(ofSize: 44)
        return titleLabel
    }()

    private let subtitleLabel: UILabel = {
        let subtitleLabel = UILabel()
        subtitleLabel.text = "Start leaving your mark."
        subtitleLabel.textColor = vestigeSecondary
        subtitleLabel.font = .systemFont(ofSize: 15, weight: .regular)
        return subtitleLabel
    }()

    private let nameTF: UITextField = {
        let nameTF = UITextField()
        nameTF.attributedPlaceholder = NSAttributedString(
            string: "Name",
            attributes: [.foregroundColor: vestigeSecondary]
        )
        nameTF.textColor = vestigeGreen
        nameTF.tintColor = vestigeGreen
        nameTF.font = .systemFont(ofSize: 15)
        nameTF.backgroundColor = .white.withAlphaComponent(0.75)
        nameTF.layer.cornerRadius = 16
        nameTF.autocapitalizationType = .words
        nameTF.returnKeyType = .next
        return nameTF
    }()

    private let emailTF: UITextField = {
        let emailTF = UITextField()
        emailTF.attributedPlaceholder = NSAttributedString(
            string: "Email",
            attributes: [.foregroundColor: vestigeSecondary]
        )
        emailTF.textColor = vestigeGreen
        emailTF.tintColor = vestigeGreen
        emailTF.font = .systemFont(ofSize: 15)
        emailTF.backgroundColor = .white.withAlphaComponent(0.75)
        emailTF.layer.cornerRadius = 16
        emailTF.keyboardType = .emailAddress
        emailTF.autocapitalizationType = .none
        emailTF.autocorrectionType = .no
        emailTF.returnKeyType = .next
        return emailTF
    }()

    private let passTF: UITextField = {
        let passTF = UITextField()
        passTF.attributedPlaceholder = NSAttributedString(
            string: "Password (min 6 characters)",
            attributes: [.foregroundColor: vestigeSecondary]
        )
        passTF.textColor = vestigeGreen
        passTF.tintColor = vestigeGreen
        passTF.font = .systemFont(ofSize: 15)
        passTF.backgroundColor = .white.withAlphaComponent(0.75)
        passTF.layer.cornerRadius = 16
        passTF.autocapitalizationType = .none
        passTF.autocorrectionType = .no
        passTF.returnKeyType = .go
        return passTF
    }()

    private let createBtn: UIButton = {
        let createBtn = UIButton()
        createBtn.setTitle("Create Account", for: .normal)
        createBtn.setTitleColor(.white, for: .normal)
        createBtn.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        createBtn.backgroundColor = vestigeGreen
        createBtn.layer.cornerRadius = 16
        createBtn.layer.shadowColor = vestigeGreen.cgColor
        createBtn.layer.shadowOpacity = 0.25
        createBtn.layer.shadowRadius = 10
        createBtn.layer.shadowOffset = CGSize(width: 0, height: 6)
        return createBtn
    }()

    private let loginButton: UIButton = {
        let loginButton = UIButton()

        let title = NSMutableAttributedString(
            string: "Already have an account? ",
            attributes: [
                .foregroundColor: vestigeSecondary,
                .font: UIFont.systemFont(ofSize: 15, weight: .regular)
            ]
        )
        title.append(NSAttributedString(
            string: "Login",
            attributes: [
                .foregroundColor: vestigeGreen,
                .font: UIFont.systemFont(ofSize: 15, weight: .semibold)
            ]
        ))

        loginButton.setAttributedTitle(title, for: .normal)
        return loginButton
    }()

    private let eyeButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = vestigeCream

        setupNavigationBar()
        setupUI()
        setupPasswordEye()
    }

    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = vestigeGreen
    }

    private func setupUI() {
        [brandLabel, titleLabel, subtitleLabel, nameTF, emailTF, passTF, createBtn, loginButton].forEach { view.addSubview($0) }

        nameTF.leftView = makeLeftIcon("person")
        nameTF.leftViewMode = .always
        nameTF.delegate = self

        emailTF.leftView = makeLeftIcon("envelope")
        emailTF.leftViewMode = .always
        emailTF.delegate = self

        passTF.leftView = makeLeftIcon("lock")
        passTF.leftViewMode = .always
        passTF.delegate = self

        brandLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.equalToSuperview().inset(30)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(brandLabel.snp.bottom).offset(6)
            make.leading.equalTo(brandLabel)
        }

        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
            make.leading.equalTo(brandLabel)
        }

        nameTF.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(54)
        }

        emailTF.snp.makeConstraints { make in
            make.top.equalTo(nameTF.snp.bottom).offset(14)
            make.leading.trailing.equalTo(nameTF)
            make.height.equalTo(nameTF)
        }

        passTF.snp.makeConstraints { make in
            make.top.equalTo(emailTF.snp.bottom).offset(14)
            make.leading.trailing.equalTo(nameTF)
            make.height.equalTo(nameTF)
        }

        createBtn.snp.makeConstraints { make in
            make.top.equalTo(passTF.snp.bottom).offset(26)
            make.leading.trailing.equalTo(nameTF)
            make.height.equalTo(54)
        }

        loginButton.snp.makeConstraints { make in
            make.top.equalTo(createBtn.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }

        createBtn.addTarget(self, action: #selector(createTapped), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(backToLogin), for: .touchUpInside)

        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    private func makeLeftIcon(_ systemName: String) -> UIView {
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 20))

        let icon = UIImageView(image: UIImage(systemName: systemName))
        icon.tintColor = vestigeSecondary
        icon.contentMode = .scaleAspectFit
        icon.frame = CGRect(x: 18, y: 0, width: 20, height: 20)

        container.addSubview(icon)
        return container
    }

    private func setupPasswordEye() {
        passTF.isSecureTextEntry = true

        let container = UIView(frame: CGRect(x: 0, y: 0, width: 56, height: 30))

        eyeButton.setImage(eyeImage(isHidden: true), for: .normal)
        eyeButton.tintColor = vestigeGreen
        eyeButton.backgroundColor = vestigeGreen.withAlphaComponent(0.1)
        eyeButton.layer.cornerRadius = 15
        eyeButton.frame = CGRect(x: 6, y: 0, width: 30, height: 30)
        eyeButton.addTarget(self, action: #selector(togglePassword), for: .touchUpInside)

        container.addSubview(eyeButton)

        passTF.rightView = container
        passTF.rightViewMode = .always
    }

    private func eyeImage(isHidden: Bool) -> UIImage? {
        let config = UIImage.SymbolConfiguration(pointSize: 14, weight: .medium)
        return UIImage(systemName: isHidden ? "eye.slash" : "eye", withConfiguration: config)
    }

    @objc private func togglePassword() {
        let text = passTF.text
        passTF.isSecureTextEntry.toggle()
        passTF.text = nil
        passTF.text = text

        eyeButton.setImage(eyeImage(isHidden: passTF.isSecureTextEntry), for: .normal)
    }

    @objc private func backToLogin() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func createTapped() {
        let name = nameTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let email = emailTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let password = passTF.text ?? ""

        guard !name.isEmpty, !email.isEmpty, !password.isEmpty else {
            showAlert(message: "Please fill in all fields.")
            return
        }

        setLoading(true)

        AuthService.shared.register(name: name, email: email, password: password) { [weak self] result in
            guard let self = self else { return }
            self.setLoading(false)

            switch result {
            case .success:
                self.view.window?.rootViewController = MainTabBarViewController()
            case .failure(let error):
                self.showAlert(message: error.localizedDescription)
            }
        }
    }

    private func setLoading(_ isLoading: Bool) {
        createBtn.isEnabled = !isLoading
        createBtn.setTitle(isLoading ? "Please wait..." : "Create Account", for: .normal)
        createBtn.alpha = isLoading ? 0.6 : 1
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Could not register", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension RegisterViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTF {
            emailTF.becomeFirstResponder()
        } else if textField == emailTF {
            passTF.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            createTapped()
        }
        return true
    }
}
