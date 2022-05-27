





import UIKit
import RxSwift

class SearchResultViewController: UIViewController, UISearchResultsUpdating {
    
    private lazy var searchResultView: SearchResultView = {
        let v = SearchResultView()
        v.isHidden = true
        return v
    }()
    
    private lazy var searchResultEmptyView: UIView = {
        let v = UIView()
        let label: UILabel = {
            let v = UILabel()
            v.text = "无法找到该".innerLocalized() + _searchType.title
            return v
        }()
        v.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        v.isHidden = true
        return v
    }()

    private let _disposebag = DisposeBag()
    private let _searchType: SearchType
    
    init(searchType: SearchType) {
        _searchType = searchType
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = [UIRectEdge.left, .right, .bottom]
        initView()
        bindData()
    }
    
    private func initView() {
        self.view.backgroundColor = .groupTableViewBackground

        view.addSubview(searchResultView)
        searchResultView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(52)
        }
        
        view.addSubview(searchResultEmptyView)
        searchResultEmptyView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(60)
        }
    }
    
    private func bindData() {
        self.searchResultView.tap.rx.event.subscribe(onNext: { [weak self] _ in
            guard let sself = self else { return }
            switch sself._searchType {
            case .user:
                print("跳转到用户详情")
                let vc = UserDetailTableViewController()
                vc.setUser(sself.userInfo)
                sself.presentingViewController?.navigationController?.pushViewController(vc, animated: true)
                self?.dismiss(animated: true, completion: nil)
            case .group:
                print("跳转到群组详情")
            }
        }).disposed(by: _disposebag)
    }
    
    enum SearchType {
        
        case group
        
        case user
        
        var title: String {
            switch self {
            case .group:
                return "群组".innerLocalized()
            case .user:
                return "用户".innerLocalized()
            }
        }
    }
    private var userInfo: FullUserInfo?
    func updateSearchResults(for searchController: UISearchController) {
        
        let keyword = searchController.searchBar.text
        guard let keyword = keyword, !keyword.isEmpty else {
            return
        }
        
        switch _searchType {
        case .group:
            IMController.shared.getGroupListBy(id: keyword).subscribe(onNext: { [weak self] (groupID: String?) in
                let shouldHideEmptyView = groupID != nil
                let shouldHideResultView = groupID == nil
                DispatchQueue.main.async {
                    self?.searchResultEmptyView.isHidden = shouldHideEmptyView
                    self?.searchResultView.isHidden = shouldHideResultView
                    self?.searchResultView.setTitle(groupID)
                }
            }).disposed(by: _disposebag)
        case .user:
            IMController.shared.getFriendsBy(id: keyword).subscribe { [weak self] (userInfo: FullUserInfo?) in
                self?.userInfo = userInfo
                let uid = userInfo?.userID
                let shouldHideEmptyView = uid != nil
                let shouldHideResultView = uid == nil
                DispatchQueue.main.async {
                    self?.searchResultEmptyView.isHidden = shouldHideEmptyView
                    self?.searchResultView.isHidden = shouldHideResultView
                    self?.searchResultView.setTitle(uid)
                }
            }.disposed(by: _disposebag)
        }
    }
}
