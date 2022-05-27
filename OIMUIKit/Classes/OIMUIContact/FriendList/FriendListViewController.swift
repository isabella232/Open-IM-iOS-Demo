





import UIKit
import RxSwift

open class FriendListViewController: UIViewController {
    
    private lazy var _tableView: UITableView = {
        let v = UITableView()
        let config = SCIndexViewConfiguration.init(indexViewStyle: SCIndexViewStyle.default)!
        config.indexItemRightMargin = 8
        config.indexItemTextColor = UIColor.init(hexString: "#555555")
        config.indexItemSelectedBackgroundColor = UIColor.init(hexString: "#57be6a")
        config.indexItemsSpace = 4
        v.sc_indexViewConfiguration = config
        v.sc_translucentForTableViewInNavigationBar = true
        v.register(FriendListUserTableViewCell.self, forCellReuseIdentifier: FriendListUserTableViewCell.className)
        v.dataSource = self
        v.delegate = self
        v.rowHeight = UITableView.automaticDimension
        v.separatorInset = UIEdgeInsets.init(top: 0, left: 82, bottom: 0, right: StandardUI.margin_22)
        v.separatorColor = StandardUI.color_F1F1F1
        if #available(iOS 15.0, *) {
            v.sectionHeaderTopPadding = 0
        }
        return v
    }()
    
    private let _viewModel = FriendListViewModel()
    private let _disposeBag = DisposeBag()
    private lazy var resultC = FriendListResultViewController()
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "我的好友".innerLocalized()
        initView()
        bindData()
        _viewModel.getMyFriendList()
    }
    
    private func initView() {
        let searchC: UISearchController = {
            let v = UISearchController.init(searchResultsController: resultC)
            v.searchResultsUpdater = resultC
            v.searchBar.placeholder = "搜索好友".innerLocalized()
            v.obscuresBackgroundDuringPresentation = false
            return v
        }()
        self.navigationItem.searchController = searchC
        
        view.addSubview(_tableView)
        _tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func bindData() {
        _viewModel.lettersRelay.distinctUntilChanged().subscribe(onNext: { [weak self] (values: [String]) in
            guard let sself = self else { return }
            self?.resultC.dataList = sself._viewModel.myFriends
            self?._tableView.sc_indexViewDataSource = values
            self?._tableView.sc_startSection = 0
            self?._tableView.reloadData()
        }).disposed(by: _disposeBag)
    }
    
    deinit {
        print("dealloc \(type(of: self))")
    }
}

extension FriendListViewController: UITableViewDataSource, UITableViewDelegate {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return _viewModel.lettersRelay.value.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _viewModel.contactSections[section].count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FriendListUserTableViewCell.className) as! FriendListUserTableViewCell
        let user: UserInfo = _viewModel.contactSections[indexPath.section][indexPath.row]
        cell.titleLabel.text = user.nickname
        cell.avatarImageView.setImage(with: user.faceURL, placeHolder: "contact_my_friend_icon")
        return cell
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let name = _viewModel.lettersRelay.value[section]
        let header = ViewUtil.createSectionHeaderWith(text: name)
        return header
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 33
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
}
