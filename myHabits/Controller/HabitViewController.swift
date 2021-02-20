import UIKit

class HabitViewController: UIViewController {
    var isEditMode = false
    var indexPath: IndexPath?
    var delegate: HabitsViewController?
    
    /// Устанавливает значения существующей ячейки
    /// Свойство для isEditMode = true
    var habit: Habit? {
        didSet {
            guard let safeHabit = habit else { return }
            nameTextField.text = safeHabit.name
            colorView.backgroundColor = safeHabit.color
            timeLabel.text = "Каждый день в " + safeHabit.shortDateString
            timeLabel.halfTextColorChange(changeText: safeHabit.shortDateString, color: safeHabit.color)
            datePicker.date = safeHabit.date
        }
    }
    
    //MARK: - UI elements
    /// Элементы верстки
    private lazy var nameTitleLabel: UILabel = {
        let label = UILabel()
        
        label.toAutoLayout()
        label.font = FontSet.fonts[.headline]
        label.textColor = .black
        label.text = "НАЗВАНИЕ"
        
        return label
    }()
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        
        textField.toAutoLayout()
        textField.placeholder = "Бегать по утрам, спать 8 часов и т.п."
        textField.font = FontSet.fonts[.body]
        textField.textColor = ColorSet.colors[.systemGray2]
        
        return textField
    }()
    
    private lazy var colorTitleLabel: UILabel = {
        let label = UILabel()
        
        label.toAutoLayout()
        label.font = FontSet.fonts[.headline]
        label.textColor = .black
        label.text = "ЦВЕТ"
        
        return label
    }()
    
    private lazy var colorView: UIRoundView = {
        let view = UIRoundView()
        
        view.toAutoLayout()
        view.backgroundColor = ColorSet.colors[.orange]
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapRecognizer)
        
        return view
    }()
    
    private lazy var timeTitleLabel: UILabel = {
        let label = UILabel()
        
        label.toAutoLayout()
        label.font = FontSet.fonts[.headline]
        label.textColor = .black
        label.text = "ВРЕМЯ"
        
        return label
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        
        label.toAutoLayout()
        label.font = FontSet.fonts[.headline]
        label.textColor = .black
        
        return label
    }()
    
    /// datePicker для выбора времени
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        let currentDate = Date()
        
        datePicker.datePickerMode = .countDownTimer
        datePicker.calendar = Calendar(identifier: .chinese)
        datePicker.toAutoLayout()
        datePicker.addTarget(self, action: #selector(dateIsChanged), for: .valueChanged)
        datePicker.date = currentDate
        
        return datePicker
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.toAutoLayout()
        button.setTitle("Удалить привычку", for: .normal)
        button.titleLabel?.font = FontSet.fonts[.body]
        button.tintColor = .red
        button.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        button.isHidden = true
    
        return button
    }()
    
    /// Форматер для даты из datePicker
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()
    
    /// 4 StackView для удобства верстки в Auto Layout
    private lazy var nameStackView = HabitStackView()
    private lazy var colorStackView = HabitStackView()
    private lazy var timeStackView = HabitStackView()
    private lazy var summaryStackView = HabitStackView()
    
    /// ViewController, где выбирается цвет привычки
    @available(iOS 14.0, *)
    private lazy var colorPicker = UIColorPickerViewController()
    
    /// Жест для вызова colorPicker
    private lazy var tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(colorViewTapped))
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        if #available(iOS 14.0, *) {
            colorPicker.delegate = self
        }
        if isEditMode {
            deleteButton.isHidden = false
        }
        
        setupViews()
        setupLayout()
        setupNavBar()
        if !isEditMode {
            dateIsChanged()
        }
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.updateCollectionView()
    }

    //MARK: - setupViews
    private func setupViews() {
        nameStackView.addArrangedSubviews(nameTitleLabel,
                                          nameTextField)
        colorStackView.addArrangedSubviews(colorTitleLabel,
                                           colorView)
        timeStackView.addArrangedSubviews(timeTitleLabel,
                                          timeLabel)
        summaryStackView.addArrangedSubviews(nameStackView,
                                             colorStackView,
                                             timeStackView)
        view.addSubviews(summaryStackView, datePicker, deleteButton)
        
        
        summaryStackView.spacing = 15
    }
    //MARK: - setupLayout
    private func setupLayout() {
        let constraints = [
            summaryStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 22),
            summaryStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            summaryStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            datePicker.topAnchor.constraint(equalTo: summaryStackView.bottomAnchor, constant: 15),
            datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            colorView.heightAnchor.constraint(equalToConstant: 30),
            colorView.trailingAnchor.constraint(equalTo: colorStackView.leadingAnchor, constant: 30),
            
            deleteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            deleteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    //MARK: - setupNavBar
    private func setupNavBar() {
        /// Цвет кнопок
        navigationController?.navigationBar.tintColor = ColorSet.colors[.violet]
        /// Кнопка отмены с ее конфигурацией
        let cancelButton = UIBarButtonItem(title: "Отменить", style: .done, target: self, action: #selector(cancelButtonTapped))
        cancelButton.setTitleTextAttributes([.font: FontSet.fonts[.body]!], for: .normal)
        cancelButton.setTitleTextAttributes([.font: FontSet.fonts[.body]!], for: .selected)
        cancelButton.setTitleTextAttributes([.font: FontSet.fonts[.body]!], for: .disabled)
        
        /// Кнопка сохранения с ее конфигурацией
        let saveButton = UIBarButtonItem(title: "Сохранить", style: .done, target: self, action: #selector(saveButtonTapped))
        saveButton.setTitleTextAttributes([.font: FontSet.fonts[.headline]!], for: .normal)
        saveButton.setTitleTextAttributes([.font: FontSet.fonts[.headline]!], for: .selected)
        saveButton.setTitleTextAttributes([.font: FontSet.fonts[.headline]!], for: .disabled)
        
        /// Конфигурация title
        navigationItem.title = "Создать"
        navigationController?.navigationBar.titleTextAttributes = [
            .font: FontSet.fonts[.headline] ?? UIFont.systemFont(ofSize: 20)]
        
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = saveButton
    }
    
    @objc
    private func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func saveButtonTapped() {
        var habitText = nameTextField.text!
        let habitColor = colorView.backgroundColor!
        
        if habitText.isEmpty {
            habitText = "Без названия"
        }
        
        let habit = Habit(name: habitText, date: datePicker.date, color: habitColor)
        
        if !isEditMode {
            let store = HabitsStore.shared
            store.habits.append(habit)

        } else {
            HabitsStore.shared.habits[indexPath!.item] = habit
        }

        dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func colorViewTapped() {
        if #available(iOS 14.0, *) {
            present(colorPicker, animated: true, completion: nil)
        }
    }
    
    @objc
    private func dateIsChanged() {
        let date = datePicker.date
        let dateString = dateFormatter.string(from: date)
        let color = colorView.backgroundColor!
        
        timeLabel.text = "Каждый день в " + dateString
        /// Изменяем цвет у части текста timeLabel
        timeLabel.halfTextColorChange(changeText: dateString, color: color)
    }
    
    @objc
    private func deleteButtonTapped() {
        let deleteAlertVC = DeleteAlertViewController()
        deleteAlertVC.delegate = self
        present(deleteAlertVC, animated: true, completion: nil)
    }
}

@available(iOS 14.0, *)
extension HabitViewController: UIColorPickerViewControllerDelegate {
    /// Меняем цвет colorView в соответствии с выбранным цветом
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        colorView.backgroundColor = viewController.selectedColor
        dateIsChanged()
    }
    
    /// Меняем цвет colorView при закрытии контроллера в соответствии с выбранным цветом
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        colorView.backgroundColor = viewController.selectedColor
        dateIsChanged()
    }
}

//MARK: - HabitStackView
private class HabitStackView: UIStackView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        axis = .vertical
        distribution = .fill
        spacing = 7
        toAutoLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
