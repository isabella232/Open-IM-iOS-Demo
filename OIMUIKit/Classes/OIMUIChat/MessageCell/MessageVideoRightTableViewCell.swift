





import UIKit
import SnapKit

class MessageVideoRightTableViewCell: MessageBaseRightTableViewCell {
    
    let videoContentView: MessageVideoContentView = MessageVideoContentView()
    private var sizeConstraint: Constraint?
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        bubbleImageView.addSubview(videoContentView)
        videoContentView.snp.makeConstraints { make in
            sizeConstraint = make.size.equalTo(185).constraint
            make.edges.equalToSuperview()
        }

        bubbleImageView.image = nil
        containerView.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setMessage(model: MessageInfo, extraInfo: ExtraInfo?) {
        super.setMessage(model: model, extraInfo: extraInfo)
        if let elem = model.videoElem {
            videoContentView.timeLabel.text = FormatUtil.getMediaFormat(of: elem.duration)
            if let url = elem.snapshotUrl {
                videoContentView.imageView.setImage(with: elem.snapshotUrl, placeHolder: nil)
            } else if let path = elem.snapshotPath {
                videoContentView.imageView.setImagePath(path, placeHolder: nil)
            }
        }
    }
}

class MessageVideoContentView: UIView {
    private let playIconImageView: UIImageView = {
        let v = UIImageView.init(image: UIImage.init(nameInBundle: "msg_video_play_icon"))
        return v
    }()
    
    let timeLabel: UILabel = {
        let v = UILabel()
        v.font = .systemFont(ofSize: 14)
        v.textColor = .white
        return v
    }()
    
    let imageView: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFit
        v.layer.cornerRadius = 4
        v.clipsToBounds = true
        v.backgroundColor = .black
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.addSubview(playIconImageView)
        playIconImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        self.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { make in
            make.right.bottom.equalToSuperview().inset(6)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
