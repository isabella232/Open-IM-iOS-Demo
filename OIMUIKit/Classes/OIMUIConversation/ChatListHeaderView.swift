





import UIKit
import SnapKit

class ChatListHeaderView: UIView {
    
    let avatarImageView: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFit
        v.backgroundColor = .brown
        v.layer.cornerRadius = 6
        v.clipsToBounds = true
        return v
    }()
    
    let companyNameLabel: UILabel = {
        let v = UILabel()
        v.font = .systemFont(ofSize: 12)
        v.textColor = StandardUI.color_333333
        return v
    }()
    
    let nameLabel: UILabel = {
        let v = UILabel()
        v.font = .systemFont(ofSize: 18)
        v.textColor = StandardUI.color_333333
        return v
    }()
    
    lazy var statusLabel: StatusLabelView = {
        let v = StatusLabelView()
        return v
    }()
    
    let callBtn: UIButton = {
        let v = UIButton()
        v.setImage(UIImage.init(nameInBundle: "chat_call_btn_icon"), for: .normal)
        return v
    }()
    
    let addBtn: UIButton = {
        let v = UIButton()
        v.setImage(UIImage.init(nameInBundle: "chat_add_btn_icon"), for: .normal)
        return v
    }()
    
    private lazy var searchBar: UISearchBar = {
        let margin: CGFloat = 14
        let v = UISearchBar.init(frame: CGRect.init(x: margin, y: 10, width: kScreenWidth - 2 * margin, height: 44))
        v.searchBarStyle = .minimal
        v.placeholder = "搜索".innerLocalized()
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.addSubview(searchBar)
        searchBar.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(14)
            make.height.equalTo(44)
            make.bottom.equalToSuperview()
        }
        self.addSubview(avatarImageView)
        avatarImageView.snp.makeConstraints { make in
            make.size.equalTo(48)
            make.bottom.equalTo(searchBar.snp.top).offset(-18)
            make.left.equalToSuperview().offset(StandardUI.margin_22)
        }
        
        let hStack: UIStackView = {
            let v = UIStackView.init(arrangedSubviews: [nameLabel, statusLabel])
            v.axis = .horizontal
            v.distribution = .equalSpacing
            v.spacing = 12
            v.alignment = .center
            return v
        }()
        
        let vStack: UIStackView = {
            let v = UIStackView.init(arrangedSubviews: [companyNameLabel, hStack])
            v.axis = .vertical
            v.distribution = .equalSpacing
            v.spacing = 2
            v.alignment = .leading
            return v
        }()
        
        self.addSubview(vStack)
        vStack.snp.makeConstraints { make in
            make.left.equalTo(avatarImageView.snp.right).offset(10)
            make.centerY.equalTo(avatarImageView)
        }
        
        let btnStack: UIStackView = {
            let v = UIStackView.init(arrangedSubviews: [callBtn, addBtn])
            callBtn.snp.makeConstraints { make in
                make.size.equalTo(30)
            }
            addBtn.snp.makeConstraints { make in
                make.size.equalTo(30)
            }
            v.axis = .horizontal
            v.distribution = .equalSpacing
            v.spacing = 16
            return v
        }()
        self.addSubview(btnStack)
        btnStack.snp.makeConstraints { make in
            make.centerY.equalTo(avatarImageView)
            make.right.equalToSuperview().offset(-StandardUI.margin_22)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
