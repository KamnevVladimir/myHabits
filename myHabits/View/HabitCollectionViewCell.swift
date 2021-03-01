import UIKit

class HabitCollectionViewCell: UICollectionViewCell {
    var habit: Habit? {
        didSet {
            guard let safeHabit = habit else { return }
            habitNameLabel.text = safeHabit.name
            habitNameLabel.textColor = safeHabit.color
            habitTimeLabel.text = safeHabit.dateString
            habitRepeatLabel.text = "Подряд: " + HabitsStore.shared.trackedInARow(safeHabit)
            roundColorView.layer.borderColor = safeHabit.color.cgColor
            
            if safeHabit.isAlreadyTakenToday {
                roundColorView.backgroundColor = safeHabit.color
            } else {
                roundColorView.backgroundColor = UIColor.clear
            }
        }
    }
    var delegate: HabitsViewController?
    
    /// Название привычки
    private lazy var habitNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.toAutoLayout()
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        return label
    }()
    
    /// Время выполнения привычки
    private lazy var habitTimeLabel: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    /// Количество подряд за день выполнения привычки
    private lazy var habitRepeatLabel: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular
        )
        return label
    }()
    
    /// Вертикальный StackView для описания привычки
    private lazy var habitStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.toAutoLayout()
        stackView.axis = .vertical
        stackView.distribution = .equalCentering
        return stackView
    }()
    
    /// Цветное круглое View привычки
    private lazy var roundColorView: UIRoundView = {
        let view = UIRoundView()
        view.toAutoLayout()
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGestureRecognizer)
        view.layer.borderWidth = 2
        return view
    }()
    
    /// Отметка выполненной привычки
    private lazy var checkmarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.toAutoLayout()
        imageView.image = UIImage(systemName: "checkmark")
        imageView.tintColor = .white
        return imageView
    }()
    
    /// Нажатие по roundColorView
    private lazy var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(roundColorViewTapped))
    
    private var isHabitDone: Bool {
        guard let safeHabit = habit else { return false }
        return safeHabit.isAlreadyTakenToday
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupLayout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubviews(habitNameLabel,
                                habitStackView,
                                roundColorView,
                                checkmarkImageView)
        
        habitStackView.addArrangedSubviews(habitTimeLabel, habitRepeatLabel)
        
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
        
        
    }
    
    private func setupLayout() {
        let constraints = [
            habitNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            habitNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            habitStackView.topAnchor.constraint(equalTo: habitNameLabel.bottomAnchor, constant: 4),
            habitStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            habitStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            roundColorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            roundColorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -26),
            roundColorView.widthAnchor.constraint(equalToConstant: 36),
            roundColorView.heightAnchor.constraint(equalToConstant: 36),
            
            checkmarkImageView.centerXAnchor.constraint(equalTo: roundColorView.centerXAnchor),
            checkmarkImageView.centerYAnchor.constraint(equalTo: roundColorView.centerYAnchor),
            
            habitNameLabel.trailingAnchor.constraint(equalTo: roundColorView.leadingAnchor, constant: -20),
            
            habitStackView.trailingAnchor.constraint(equalTo: roundColorView.leadingAnchor, constant: -20)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc
    private func roundColorViewTapped() {
        if !isHabitDone {
            HabitsStore.shared.track(habit!)
            roundColorView.backgroundColor = UIColor(cgColor:  roundColorView.layer.borderColor!)
        }
        delegate?.updateCollectionView()
    }
}
