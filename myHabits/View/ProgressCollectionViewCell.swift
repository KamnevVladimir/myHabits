import UIKit

class ProgressCollectionViewCell: UICollectionViewCell {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.toAutoLayout()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = ColorSet.colors[.systemGray2]
        label.text = "Всё получится!"
        
        return label
    }()
    
    private lazy var procentLabel: UILabel = {
        let label = UILabel()
        
        label.toAutoLayout()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = ColorSet.colors[.systemGray2]
        
        return label
    }()
    
    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        
        progressView.toAutoLayout()
        progressView.trackTintColor = ColorSet.colors[.nearWhite]
        progressView.progressTintColor = ColorSet.colors[.violet]
        
        return progressView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.toAutoLayout()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        setupViews()
        setupLayout()
        setupProgress()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupProgress() {
        self.progressView.progress = HabitsStore.shared.todayProgress
        self.procentLabel.text = "\(Int(HabitsStore.shared.todayProgress * 100))%"
    }
    
    private func setupViews() {
        stackView.addArrangedSubviews(titleLabel,
                                      procentLabel)
        contentView.addSubviews(stackView,
                                progressView)
        
        contentView.layer.cornerRadius = 4
    }
    
    private func setupLayout() {
        let constraints = [
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            
            progressView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10),
            progressView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 7),
            progressView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}
