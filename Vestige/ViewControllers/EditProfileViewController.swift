//
//  EditProfileViewController.swift
//  Vestige
//
//  Created by Javanshir Najafzade on 05.11.26.
//


import UIKit
import SnapKit

final class EditProfileViewController: UIViewController {

    var onSaved: (() -> Void)?

    private let cream = UIColor(named: "VestigeCream") ?? .systemBackground
    private let green = UIColor(named: "VestigeGreen") ?? .systemGreen
    private let secondaryText = UIColor(named: "VestigeSecondaryText") ?? .secondaryLabel

    private let closeButton = UIButton(type: .system)
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let nameTF = UITextField()
    private let saveButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = cream

        [closeButton, titleLabel, subtitleLabel, nameTF, saveButton].forEach { view.addSubview($0) }

        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = green
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)

        titleLabel.text = "Edit Profile"
        titleLabel.textColor = green
        titleLabel.font = UIFont(name: "CormorantGaramond-Regular", size: 40) ?? .systemFont(ofSize: 40)

        subtitleLabel.text = "Change the name you see in the app."
        subtitleLabel.textColor = secondaryText
        subtitleLabel.font = .systemFont(ofSize: 15, weight: .regular)

        nameTF.attributedPlaceholder = NSAttributedString(
            string: "Name",
            attributes: [.foregroundColor: secondaryText]
        )
        nameTF.text = AuthService.shared.currentUser?.name
        nameTF.textColor = green
        nameTF.tintColor = green
        nameTF.font = .systemFont(ofSize: 15)
        nameTF.backgroundColor = .white.withAlphaComponent(0.75)
        nameTF.layer.cornerRadius = 16
        nameTF.autocapitalizationType = .words
        nameTF.returnKeyType = .done
        nameTF.leftView = makeLeftIcon("person")
        nameTF.leftViewMode = .always
        nameTF.delegate = self

        saveButton.setTitle("Save", for: .normal)
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

        nameTF.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(54)
        }

        saveButton.snp.makeConstraints { make in
            make.top.equalTo(nameTF.snp.bottom).offset(24)
            make.leading.trailing.equalTo(nameTF)
            make.height.equalTo(54)
        }

        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
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
        let name = nameTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        guard !name.isEmpty else {
            showAlert(title: "Error", message: "Name cannot be empty.")
            return
        }

        setLoading(true)

        AuthService.shared.updateName(name) { [weak self] error in
            guard let self = self else { return }
            self.setLoading(false)

            if let error = error {
                self.showAlert(title: "Error", message: error.localizedDescription)
                return
            }

            self.onSaved?()
            self.dismiss(animated: true)
        }
    }

    private func setLoading(_ isLoading: Bool) {
        saveButton.isEnabled = !isLoading
        saveButton.setTitle(isLoading ? "Please wait..." : "Save", for: .normal)
        saveButton.alpha = isLoading ? 0.6 : 1
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension EditProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        saveTapped()
        return true
    }
}