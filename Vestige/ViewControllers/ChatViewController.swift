//
//  ChatViewController.swift
//  Vestige
//
//  Created by Javanshir Najafzade on 05.11.26.
//


import UIKit
import SnapKit
import FirebaseFirestore

final class ChatViewController: UIViewController {

    private let cream = UIColor(named: "VestigeCream") ?? .systemBackground
    private let green = UIColor(named: "VestigeGreen") ?? .systemGreen
    private let secondaryText = UIColor(named: "VestigeSecondaryText") ?? .secondaryLabel

    private let otherUser: User
    private let myID = AuthService.shared.currentUser?.id ?? ""
    private var messages: [ChatMessage] = []
    private var listener: ListenerRegistration?

    private let tableView = UITableView()
    private let emptyLabel = UILabel()
    private let inputBar = UIView()
    private let inputTF = UITextField()
    private let sendButton = UIButton(type: .system)

    init(otherUser: User) {
        self.otherUser = otherUser
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        listener?.remove()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        startListening()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationController?.navigationBar.tintColor = green
    }

    private func setupUI() {
        view.backgroundColor = cream
        navigationItem.title = otherUser.name

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = cream
        appearance.shadowColor = .clear
        appearance.titleTextAttributes = [.foregroundColor: green]
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance

        [tableView, emptyLabel, inputBar].forEach { view.addSubview($0) }
        [inputTF, sendButton].forEach { inputBar.addSubview($0) }

        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .interactive
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        tableView.register(MessageCell.self, forCellReuseIdentifier: MessageCell.identifier)
        tableView.dataSource = self

        emptyLabel.text = "Say hi to \(otherUser.name)"
        emptyLabel.textColor = secondaryText
        emptyLabel.font = .systemFont(ofSize: 15, weight: .regular)

        inputBar.backgroundColor = cream

        inputTF.attributedPlaceholder = NSAttributedString(
            string: "Message",
            attributes: [.foregroundColor: secondaryText]
        )
        inputTF.textColor = green
        inputTF.tintColor = green
        inputTF.font = .systemFont(ofSize: 15)
        inputTF.backgroundColor = .white.withAlphaComponent(0.85)
        inputTF.layer.cornerRadius = 22
        inputTF.returnKeyType = .send
        inputTF.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 10))
        inputTF.leftViewMode = .always
        inputTF.delegate = self

        let config = UIImage.SymbolConfiguration(pointSize: 16, weight: .semibold)
        sendButton.setImage(UIImage(systemName: "paperplane.fill", withConfiguration: config), for: .normal)
        sendButton.tintColor = cream
        sendButton.backgroundColor = green
        sendButton.layer.cornerRadius = 22
        sendButton.addTarget(self, action: #selector(sendTapped), for: .touchUpInside)

        inputBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
        }

        sendButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalTo(inputTF)
            make.size.equalTo(44)
        }

        inputTF.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalTo(sendButton.snp.leading).offset(-10)
            make.top.bottom.equalToSuperview().inset(8)
            make.height.equalTo(44)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(inputBar.snp.top)
        }

        emptyLabel.snp.makeConstraints { make in
            make.center.equalTo(tableView)
        }
    }

    private func startListening() {
        listener = ChatService.shared.listenMessages(with: otherUser.id) { [weak self] messages in
            guard let self = self else { return }
            self.messages = messages
            self.emptyLabel.isHidden = !messages.isEmpty
            self.tableView.reloadData()
            self.tableView.layoutIfNeeded()
            self.scrollToBottom(animated: false)
        }
    }

    private func scrollToBottom(animated: Bool) {
        guard !messages.isEmpty else { return }
        let indexPath = IndexPath(row: messages.count - 1, section: 0)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: animated)
    }

    @objc private func keyboardWillShow() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.scrollToBottom(animated: true)
        }
    }

    @objc private func sendTapped() {
        let text = (inputTF.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }

        inputTF.text = ""
        ChatService.shared.send(text: text, to: otherUser.id)
    }
}

extension ChatViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: MessageCell.identifier,
            for: indexPath
        ) as? MessageCell else {
            return UITableViewCell()
        }

        let message = messages[indexPath.row]
        cell.configure(message: message, isMine: message.senderID == myID)
        return cell
    }
}

extension ChatViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendTapped()
        return false
    }
}

final class MessageCell: UITableViewCell {

    static let identifier = "MessageCell"

    private let green = UIColor(named: "VestigeGreen") ?? .systemGreen
    private let cream = UIColor(named: "VestigeCream") ?? .systemBackground
    private let secondaryText = UIColor(named: "VestigeSecondaryText") ?? .secondaryLabel

    private static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()

    private let bubbleView = UIView()
    private let messageLabel = UILabel()
    private let timeLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .clear
        selectionStyle = .none

        contentView.addSubview(bubbleView)
        [messageLabel, timeLabel].forEach { bubbleView.addSubview($0) }

        bubbleView.layer.cornerRadius = 18

        messageLabel.numberOfLines = 0
        messageLabel.font = .systemFont(ofSize: 16, weight: .regular)

        timeLabel.font = .systemFont(ofSize: 11, weight: .regular)

        messageLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.trailing.equalToSuperview().inset(14)
        }

        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(3)
            make.leading.greaterThanOrEqualToSuperview().inset(14)
            make.trailing.equalToSuperview().inset(14)
            make.bottom.equalToSuperview().inset(7)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(message: ChatMessage, isMine: Bool) {
        messageLabel.text = message.text
        timeLabel.text = Self.timeFormatter.string(from: message.date)

        bubbleView.backgroundColor = isMine ? green : .white.withAlphaComponent(0.85)
        messageLabel.textColor = isMine ? cream : green
        timeLabel.textColor = isMine ? cream.withAlphaComponent(0.7) : secondaryText

        bubbleView.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.bottom.equalToSuperview().inset(4)
            make.width.lessThanOrEqualToSuperview().multipliedBy(0.75)

            if isMine {
                make.trailing.equalToSuperview().inset(16)
            } else {
                make.leading.equalToSuperview().inset(16)
            }
        }
    }
}
