import UIKit

class InfoViewController: UIViewController {
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        
        label.toAutoLayout()
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.text = InfoText.titleInfoText
        label.textColor = .black
        label.textAlignment = .left
        
        return label
    }()
    
    private lazy var infoTextView: UITextView = {
        let textView = UITextView()
        
        textView.toAutoLayout()
        textView.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textView.textColor = .black
        textView.textAlignment = .left
        textView.text = InfoText.text
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.isUserInteractionEnabled = true

        textView.contentInset = .zero
        
        return textView
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.toAutoLayout()
        return view
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.toAutoLayout()
        return scrollView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "Информация"
        setupViews()
        setupLayout()
    
    }
    
    private func setupViews() {
        view.addSubviews(scrollView)
        scrollView.addSubviews(containerView)
        containerView.addSubviews(infoLabel, infoTextView)
    }
    
    private func setupLayout() {
        
        let constraints = [
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            infoLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 22),
            infoLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            infoLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),

            infoTextView.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 16),
            infoTextView.leadingAnchor.constraint(equalTo: infoLabel.leadingAnchor),
            infoTextView.trailingAnchor.constraint(equalTo: infoLabel.trailingAnchor),
            infoTextView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: infoTextView.contentInset.bottom - 22),
        ]
        
        NSLayoutConstraint.activate(constraints)
        
        
    }
}
