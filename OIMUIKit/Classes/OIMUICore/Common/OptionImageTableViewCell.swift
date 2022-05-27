





import UIKit

class OptionImageTableViewCell: UITableViewCell {

    let titleLabel: UILabel = {
        let v = UILabel()
        v.font = UIFont.systemFont(ofSize: 18)
        v.textColor = StandardUI.color_333333
        return v
    }()
    
    let iconImageView: UIImageView = {
        let v = UIImageView()
        v.clipsToBounds = true
        v.contentMode = .scaleAspectFill
        return v
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .disclosureIndicator
        self.selectionStyle = .none
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(StandardUI.margin_22)
            make.centerY.equalToSuperview()
        }
        
        contentView.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-5)
            make.centerY.equalToSuperview()
            make.size.lessThanOrEqualTo(StandardUI.avatar_42)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.layer.cornerRadius = 0
    }
}
