





import UIKit
import RxCocoa
import RxSwift

open class ContactsViewController: UITableViewController {
    public lazy var viewModel = ContactsViewModel()
    private let _disposeBag = DisposeBag()
    
    private lazy var newFriendCell: ContactsEntranceTableViewCell = {
        let v = getEntranceCell()
        let value = EntranceCellType.newFriend
        v.avatarImageView.image = value.iconImage
        v.titleLabel.text = value.title
        let tap = UITapGestureRecognizer()
        tap.rx.event.subscribe(onNext: { [weak self] _ in
            let vc = NewFriendListViewController()
            vc.hidesBottomBarWhenPushed = true
            self?.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: _disposeBag)
        v.contentView.addGestureRecognizer(tap)
        return v
    }()
    
    private lazy var groupNotiCell: ContactsEntranceTableViewCell = {
        let v = getEntranceCell()
        let value = EntranceCellType.groupNotification
        v.avatarImageView.image = value.iconImage
        v.titleLabel.text = value.title
        let tap = UITapGestureRecognizer()
        tap.rx.event.subscribe(onNext: { [weak self] _ in
            let vc = GroupApplicationTableViewController()
            vc.hidesBottomBarWhenPushed = true
            self?.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: _disposeBag)
        v.contentView.addGestureRecognizer(tap)
        return v
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        initView()
        bindData()
    }
    
    private func initView() {
        let titleLabel: UILabel = {
            let v = UILabel()
            v.font = .systemFont(ofSize: 22, weight: .medium)
            v.textColor = StandardUI.color_1B72EC
            v.text = "通讯录".innerLocalized()
            return v
        }()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: titleLabel)
        
        let findItem: UIBarButtonItem = {
            let v = UIBarButtonItem.init()
            v.image = UIImage.init(nameInBundle: "contact_search_icon")
            v.rx.tap.subscribe(onNext: {
                print("跳转搜索页面")
            }).disposed(by: _disposeBag)
            return v
        }()
        
        let addItem: UIBarButtonItem = {
            let v = UIBarButtonItem()
            v.image = UIImage.init(nameInBundle: "contact_add_icon")
            v.rx.tap.subscribe(onNext: { [weak self] in
                let vc = AddTableViewController()
                vc.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(vc, animated: true)
            }).disposed(by: _disposeBag)
            return v
        }()
        self.navigationItem.rightBarButtonItems = [addItem, findItem]
        
        let vStack: UIStackView = {
            let rowHeight = 60
            let myFriendCell: ContactsEntranceTableViewCell = {
                let v = getEntranceCell()
                let value = EntranceCellType.myFriend
                v.avatarImageView.image = value.iconImage
                v.titleLabel.text = value.title
                v.badgeLabel.isHidden = true
                let tap = UITapGestureRecognizer()
                tap.rx.event.subscribe(onNext: { [weak self] _ in
                    let vc = FriendListViewController()
                    vc.hidesBottomBarWhenPushed = true
                    self?.navigationController?.pushViewController(vc, animated: true)
                }).disposed(by: _disposeBag)
                v.addGestureRecognizer(tap)
                return v
            }()
            let myGroupCell: ContactsEntranceTableViewCell = {
                let v = getEntranceCell()
                let value = EntranceCellType.myGroup
                v.avatarImageView.image = value.iconImage
                v.titleLabel.text = value.title
                v.badgeLabel.isHidden = true
                let tap = UITapGestureRecognizer()
                tap.rx.event.subscribe(onNext: { [weak self] _ in
                    let vc = GroupListViewController()
                    vc.hidesBottomBarWhenPushed = true
                    self?.navigationController?.pushViewController(vc, animated: true)
                }).disposed(by: _disposeBag)
                v.contentView.addGestureRecognizer(tap)
                return v
            }()
            let arrangedViews: [UIView] = [newFriendCell, groupNotiCell, myFriendCell, myGroupCell]
            let v = UIStackView.init(arrangedSubviews: arrangedViews)
            v.axis = .vertical
            v.distribution = .fillEqually
            v.bounds = CGRect.init(x: 0, y: 0, width: Int(kScreenWidth), height: rowHeight * arrangedViews.count)
            return v
        }()
        
        tableView.tableHeaderView = vStack
    }
    
    private func bindData() {
        viewModel.newFriendCountRelay.map {$0 == 0}.bind(to: newFriendCell.badgeLabel.rx.isHidden).disposed(by: _disposeBag)
        viewModel.newGroupCountRelay.map {$0 == 0}.bind(to: groupNotiCell.badgeLabel.rx.isHidden).disposed(by: _disposeBag)
        viewModel.newFriendCountRelay.map {"\($0)"}.bind(to: newFriendCell.badgeLabel.rx.text).disposed(by: _disposeBag)
        viewModel.newGroupCountRelay.map {"\($0)"}.bind(to: groupNotiCell.badgeLabel.rx.text).disposed(by: _disposeBag)
        viewModel.frequentContacts.asDriver().drive { [weak self] _ in
            self?.tableView.reloadData()
        }.disposed(by: _disposeBag)
        
        viewModel.getFriendApplications()
        viewModel.getGroupApplications()
        viewModel.getFrequentUsers()
    }
    
    public override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == SectionName.frequentUsers.rawValue {
            let header = ViewUtil.createSectionHeaderWith(text: "常用联系人".innerLocalized())
            return header
        }
        
        return nil
    }
    
    public override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == SectionName.company.rawValue {
            return 12
        }
        
        if section == SectionName.frequentUsers.rawValue {
            return 33
        }
        return CGFloat.leastNormalMagnitude
    }
    
    public override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    open override func numberOfSections(in tableView: UITableView) -> Int {
        return SectionName.allCases.count
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == SectionName.company.rawValue {
            return viewModel.companyDepartments.count
        }
        if section == SectionName.frequentUsers.rawValue {
            return viewModel.frequentContacts.value.count
        }
        return super.tableView(tableView, numberOfRowsInSection: section)
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == SectionName.company.rawValue {
            let item = viewModel.companyDepartments[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: ContactsEntranceTableViewCell.className) as! ContactsEntranceTableViewCell
            cell.badgeLabel.isHidden = true
            cell.avatarImageView.image = item.isHost ? UIImage.init(nameInBundle: "contact_my_group_icon") : UIImage.init(nameInBundle: "contacts_group_icon")
            cell.arrowImageView.isHidden = item.isHost
            cell.titleLabel.text = item.name
            return cell
        }
        
        if indexPath.section == SectionName.frequentUsers.rawValue {
            let item = viewModel.frequentContacts.value[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: FrequentUserTableViewCell.className) as! FrequentUserTableViewCell
            cell.avatarImageView.setImage(with: item.faceURL, placeHolder: "contact_my_friend_icon")
            cell.titleLabel.text = item.nickname

            return cell
        }
        return UITableViewCell()
    }
    
    open override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == SectionName.company.rawValue {
            let vc = ViewControllerFactory.getContactStoryboard().instantiateViewController(withIdentifier: "DepartmentVC")
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.section == SectionName.frequentUsers.rawValue {
            let user = viewModel.frequentContacts.value[indexPath.row]
            IMController.shared.getConversation(sessionType: .c2c, sourceId: user.userID) { [weak self] (conversation: ConversationInfo?) in
                guard let conversation = conversation else { return }
                let viewModel = MessageListViewModel.init(userId: user.userID, conversation: conversation)
                let controller = MessageListViewController.init(viewModel: viewModel)
                controller.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
    
    private func configureTableView() {
        tableView.rowHeight = 60
        tableView.backgroundColor = StandardUI.color_F1F1F1
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.register(ContactsEntranceTableViewCell.self, forCellReuseIdentifier: ContactsEntranceTableViewCell.className)
        tableView.register(FrequentUserTableViewCell.self, forCellReuseIdentifier: FrequentUserTableViewCell.className)
    }
    
    private func getEntranceCell() -> ContactsEntranceTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ContactsEntranceTableViewCell.className) as! ContactsEntranceTableViewCell
        return cell
    }
    
    enum SectionName: Int, CaseIterable {
        case company = 0
        case frequentUsers = 1
    }
    
    enum EntranceCellType: CaseIterable {
        case newFriend
        case groupNotification
        case myFriend
        case myGroup
        
        var iconImage: UIImage? {
            switch self {
            case .newFriend:
                return UIImage.init(nameInBundle: "contact_new_friend_icon")
            case .groupNotification:
                return UIImage.init(nameInBundle: "contact_new_group_icon")
            case .myFriend:
                return UIImage.init(nameInBundle: "contact_my_friend_icon")
            case .myGroup:
                return UIImage.init(nameInBundle: "contact_my_group_icon")
            }
        }
        
        var title: String {
            switch self {
            case .newFriend:
                return "新的好友".innerLocalized()
            case .groupNotification:
                return "群通知".innerLocalized()
            case .myFriend:
                return "我的好友".innerLocalized()
            case .myGroup:
                return "我的群组".innerLocalized()
            }
        }
    }
}
