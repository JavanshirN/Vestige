//
//  ChatListViewController.swift
//  Vestige
//
//  Created by Javanshir Najafzade on 05.11.26.
//


import UIKit
import SnapKit

final class ChatListViewController: UIViewController {

    private let cream = UIColor(named: "VestigeCream") ?? .systemBackground
    private let green = UIColor(named: "VestigeGreen") ?? .systemGreen
    private let secondaryText = UIColor(named: "VestigeSecondaryText") ?? .secondaryLabel

    private var users: [User] = []

    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let tableView = UITableView()
    private let emptyLabel = UILabel()
    private let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        loadUsers()
    }

    private func setupUI() {
        view.backgroundColor = cream
        navigationItem.backButtonDisplayMode = .minimal

        [titleLabel, subtitleLabel, tableView, emptyLabel].forEach { view.addSubview($0) }

        titleLabel.text = "Chat"
        titleLabel.textColor = green
        titleLabel.font = UIFont(name: "CormorantGaramond-Regular", size: 40) ?? .systemFont(ofSize: 40)

        subtitleLabel.text = "Start a conversation."
        subtitleLabel.textColor = secondaryText
        subtitleLabel.font = .systemFont(ofSize: 15, weight: .regular)

        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.register(UserCell.self, forCellReuseIdentifier: UserCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshUsers), for: .valueChanged)

        emptyLabel.text = "No other users yet."
        emptyLabel.textColor = secondaryText
        emptyLabel.font = .systemFont(ofSize: 15, weight: .regular)
        emptyLabel.isHidden = true

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(18)
            make.leading.trailing.equalToSuperview().inset(24)
        }

        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
            make.leading.trailing.equalTo(titleLabel)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }

        emptyLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    private func loadUsers() {
        ChatService.shared.fetchUsers { [weak self] result in
            guard let self = self else { return }
            self.refreshControl.endRefreshing()

            switch result {
            case .success(let users):
                self.users = users
                self.tableView.reloadData()
                self.emptyLabel.text = "No other users yet."
                self.emptyLabel.isHidden = !users.isEmpty

            case .failure(let error):
                print("FETCH USERS ERROR:", error)
                self.emptyLabel.text = "Could not load users.\nCheck your internet connection."
                self.emptyLabel.numberOfLines = 0
                self.emptyLabel.textAlignment = .center
                self.emptyLabel.isHidden = !self.users.isEmpty
            }
        }
    }

    @objc private func refreshUsers() {
        loadUsers()
    }
}

extension ChatListViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserCell.identifier,for: indexPath) as? UserCell else {
            return UITableViewCell()
        }

        cell.configure(user: users[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let chatVC = ChatViewController(otherUser: users[indexPath.row])
        chatVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(chatVC, animated: true)
    }
}

final class UserCell: UITableViewCell {

    static let identifier = "UserCell"

    private let green = UIColor(named: "VestigeGreen") ?? .systemGreen
    private let cream = UIColor(named: "VestigeCream") ?? .systemBackground
    private let secondaryText = UIColor(named: "VestigeSecondaryText") ?? .secondaryLabel

    private let card = UIView()
    private let avatarView = UIView()
    private let avatarLabel = UILabel()
    private let nameLabel = UILabel()
    private let emailLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .clear
        selectionStyle = .none

        contentView.addSubview(card)
        [avatarView, nameLabel, emailLabel].forEach { card.addSubview($0) }
        avatarView.addSubview(avatarLabel)

        card.backgroundColor = .white.withAlphaComponent(0.75)
        card.layer.cornerRadius = 16

        avatarView.backgroundColor = green
        avatarView.layer.cornerRadius = 24

        avatarLabel.textColor = cream
        avatarLabel.font = UIFont(name: "CormorantGaramond-Regular", size: 24) ?? .systemFont(ofSize: 24)

        nameLabel.textColor = green
        nameLabel.font = .systemFont(ofSize: 16, weight: .medium)

        emailLabel.textColor = secondaryText
        emailLabel.font = .systemFont(ofSize: 13, weight: .regular)

        card.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(6)
            make.leading.trailing.equalToSuperview().inset(24)
        }

        avatarView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(14)
            make.top.bottom.equalToSuperview().inset(12)
            make.size.equalTo(48)
        }

        avatarLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarView).offset(4)
            make.leading.equalTo(avatarView.snp.trailing).offset(14)
            make.trailing.equalToSuperview().inset(14)
        }

        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(2)
            make.leading.trailing.equalTo(nameLabel)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(user: User) {
        avatarLabel.text = String(user.name.prefix(1)).uppercased()
        nameLabel.text = user.name
        emailLabel.text = user.email
    }
}
