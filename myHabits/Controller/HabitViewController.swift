import UIKit

class HabitViewController: UIViewController {
    var isEditMode = false
    var indexPath: IndexPath?
    var habitsDetailsViewController: HabitsDetailsViewController?
    var habitsViewController: HabitsViewController?
    
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
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .black
        label.text = "НАЗВАНИЕ"
        
        return label
    }()
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        
        textField.toAutoLayout()
        textField.placeholder = "Бегать по утрам, спать 8 часов и т.п."
        textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textField.textColor = .black
        
        return textField
    }()
    
    private lazy var colorTitleLabel: UILabel = {
        let label = UILabel()
        
        label.toAutoLayout()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
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
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .black
        label.text = "ВРЕМЯ"
        
        return label
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        
        label.toAutoLayout()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .black
        
        return label
    }()
    
    /// datePicker для выбора времени
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        let currentDate = Date()
        
        datePicker.datePickerMode = .time
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        datePicker.toAutoLayout()
        datePicker.addTarget(self, action: #selector(dateIsChanged), for: .valueChanged)
        datePicker.date = currentDate
        
        return datePicker
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.toAutoLayout()
        button.setTitle("Удалить привычку", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
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
    private lazy var hStackView : UIStackView = {
        let stackView = UIStackView()
        
        stackView.toAutoLayout()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 7
        
        return stackView
    }()
    
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
        habitsViewController?.updateCollectionView()
    }

    //MARK: - setupViews
    private func setupViews() {
        hStackView.addArrangedSubviews(nameTitleLabel, nameTextField,
                                       colorTitleLabel, colorView,
                                       timeTitleLabel, timeLabel)
        view.addSubviews(hStackView, datePicker, deleteButton)
    }
    //MARK: - setupLayout
    private func setupLayout() {
        let constraints = [
            hStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 22),
            hStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            hStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            datePicker.topAnchor.constraint(equalTo: hStackView.bottomAnchor, constant: 15),
            datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            colorView.heightAnchor.constraint(equalToConstant: 30),
            colorView.trailingAnchor.constraint(equalTo: hStackView.leadingAnchor, constant: 30),
            
            deleteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            deleteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
        ]
        
        NSLayoutConstraint.activate(constraints)
        
        hStackView.setCustomSpacing(15, after: nameTextField)
        hStackView.setCustomSpacing(15, after: colorView)
        hStackView.setCustomSpacing(15, after: timeLabel)
    }
    //MARK: - setupNavBar
    private func setupNavBar() {
        /// Цвет кнопок
        navigationController?.navigationBar.tintColor = ColorSet.colors[.violet]
        /// Кнопка отмены с ее конфигурацией
        let cancelButton = UIBarButtonItem(title: "Отменить", style: .done, target: self, action: #selector(cancelButtonTapped))
        cancelButton.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 17, weight: .regular)], for: .normal)
        cancelButton.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 17, weight: .regular)], for: .selected)
        cancelButton.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 17, weight: .regular)], for: .disabled)
        
        /// Кнопка сохранения с ее конфигурацией
        let saveButton = UIBarButtonItem(title: "Сохранить", style: .done, target: self, action: #selector(saveButtonTapped))
        saveButton.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 17, weight: .semibold)], for: .normal)
        saveButton.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 17, weight: .semibold)], for: .selected)
        saveButton.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 17, weight: .semibold)], for: .disabled)
        
        /// Конфигурация title
        navigationItem.title = "Создать"
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 17, weight: .semibold)]
        
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = saveButton
    }
    
    @objc
    private func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func saveButtonTapped() {
        /// Параметры новой привычки
        var habitText = nameTextField.text!
        let habitColor = colorView.backgroundColor!
        
        if habitText.isEmpty {
            habitText = "Без названия"
        }
        
        /// В зависимости от режима работы сохраняем/изменяем привычку
        if !isEditMode {
            /// Создаем новую привычку
            let habit = Habit(name: habitText, date: datePicker.date, color: habitColor)
            let store = HabitsStore.shared
            store.habits.append(habit)
            dismiss(animated: true, completion: nil)
        } else {
            /// Привычка изменяется и происходит переход на DetailsViewController
            let habit = HabitsStore.shared.habits[indexPath!.item]
            habit.color = habitColor
            habit.name = habitText
            HabitsStore.shared.habits[indexPath!.item] = habit
            
            habitsDetailsViewController?.title = habitText
            dismiss(animated: true, completion: nil)
        }
    }
    
    @objc
    private func colorViewTapped() {
        if #available(iOS 14.0, *) {
            colorPicker.selectedColor = colorView.backgroundColor ?? UIColor.orange
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
        let deleteAlertVC = DeleteAlertViewController(title: "Удалить привычку", message: "Вы хотите удалить привычку \"" + (nameTextField.text)! + "\"", preferredStyle: .alert)
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
