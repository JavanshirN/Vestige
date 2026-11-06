//
//  PrivacyViewController.swift
//  Vestige
//
//  Created by Javanshir Najafzade on 05.11.26.
//


import UIKit
import SnapKit

final class PrivacyViewController: UIViewController {

    private let cream = UIColor(named: "VestigeCream") ?? .systemBackground
    private let green = UIColor(named: "VestigeGreen") ?? .systemGreen
    private let secondaryText = UIColor(named: "VestigeSecondaryText") ?? .secondaryLabel

    private let closeButton = UIButton(type: .system)
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let currentTF = UITextField()
    private let newTF = UITextField()
    private let repeatTF = UITextField()
    private let saveButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = cream

        [closeButton, titleLabel, subtitleLabel, currentTF, newTF, repeatTF, saveButton].forEach { view.addSubview($0) }

        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = green
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)

        titleLabel.text = "Privacy"
        titleLabel.textColor = green
        titleLabel.font = UIFont(name: "CormorantGaramond-Regular", size: 40) ?? .systemFont(ofSize: 40)

        subtitleLabel.text = "Change your password."
        subtitleLabel.textColor = secondaryText
        subtitleLabel.font = .systemFont(ofSize: 15, weight: .regular)

        configureField(currentTF, placeholder: "Current password", returnKey: .next)
        configureField(newTF, placeholder: "New password (min 6 characters)", returnKey: .next)
        configureField(repeatTF, placeholder: "Repeat new password", returnKey: .done)

        saveButton.setTitle("Update Password", for: .normal)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        saveButton.backgroundColor = green
        saveButton.layer.cornerRadius = 16
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)

        closeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(24)
            make.size.equalTo(30)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.leading.equalToSuperview().inset(30)
        }

        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
            make.leading.equalTo(titleLabel)
        }

        currentTF.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(54)
        }

        newTF.snp.makeConstraints { make in
            make.top.equalTo(currentTF.snp.bottom).offset(14)
            make.leading.trailing.equalTo(currentTF)
            make.height.equalTo(currentTF)
        }

        repeatTF.snp.makeConstraints { make in
            make.top.equalTo(newTF.snp.bottom).offset(14)
            make.leading.trailing.equalTo(currentTF)
            make.height.equalTo(currentTF)
        }

        saveButton.snp.makeConstraints { make in
            make.top.equalTo(repeatTF.snp.bottom).offset(24)
            make.leading.trailing.equalTo(currentTF)
            make.height.equalTo(54)
        }

        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    private func configureField(_ tf: UITextField, placeholder: String, returnKey: UIReturnKeyType) {
        tf.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [.foregroundColor: secondaryText]
        )
        tf.textColor = green
        tf.tintColor = green
        tf.font = .systemFont(ofSize: 15)
        tf.backgroundColor = .white.withAlphaComponent(0.75)
        tf.layer.cornerRadius = 16
        tf.isSecureTextEntry = true
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.returnKeyType = returnKey
        tf.leftView = makeLeftIcon("lock")
        tf.leftViewMode = .always
        tf.delegate = self
    }

    private func makeLeftIcon(_ systemName: String) -> UIView {
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 20))

        let icon = UIImageView(image: UIImage(systemName: systemName))
        icon.tintColor = secondaryText
        icon.contentMode = .scaleAspectFit
        icon.frame = CGRect(x: 18, y: 0, width: 20, height: 20)

        container.addSubview(icon)
        return container
    }

    @objc private func closeTapped() {
        dismiss(animated: true)
    }

    @objc private func saveTapped() {
        let current = currentTF.text ?? ""
        let newPassword = newTF.text ?? ""
        let repeated = repeatTF.text ?? ""

        guard !current.isEmpty, !newPassword.isEmpty, !repeated.isEmpty else {
            showAlert(title: "Error", message: "Please fill in all fields.")
            return
        }

        guard newPassword.count >= 6 else {
            showAlert(title: "Error", message: "New password must be at least 6 characters.")
            return
        }

        guard newPassword == repeated else {
            showAlert(title: "Error", message: "New passwords do not match.")
            return
        }

        guard newPassword != current else {
            showAlert(title: "Error", message: "New password must be different from the current one.")
            return
        }

        setLoading(true)

        AuthService.shared.changePassword(currentPassword: current, newPassword: newPassword) { [weak self] error in
            guard let self = self else { return }
            self.setLoading(false)

            if let error = error {
                self.showAlert(title: "Error", message: error.localizedDescription)
                return
            }

            let alert = UIAlertController(
                title: "Password updated",
                message: "Use your new password next time you log in.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
                self?.dismiss(animated: true)
            })
            self.present(alert, animated: true)
        }
    }

    private func setLoading(_ isLoading: Bool) {
        saveButton.isEnabled = !isLoading
        saveButton.setTitle(isLoading ? "Please wait..." : "Update Password", for: .normal)
        saveButton.alpha = isLoading ? 0.6 : 1
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension PrivacyViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == currentTF {
            newTF.becomeFirstResponder()
        } else if textField == newTF {
            repeatTF.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            saveTapped()
        }
        return true
    }
}
