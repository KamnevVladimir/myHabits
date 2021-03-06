import UIKit

class HabitsDetailsViewController: UIViewController {
    private var trackDatesString: [String]?
    private var datesString: [String]?
    private var habit: Habit?
    
    var delegate: HabitsViewController?
    var indexPath: IndexPath? {
        didSet {
            if let safeIndexPath = indexPath {
                habit = HabitsStore.shared.habits[safeIndexPath.item]
                title = habit!.name
                trackDatesString = HabitsStore.shared.trackDatesString(habit!)
                datesString = HabitsStore.shared.datesString(habit!)
            }
        }
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.toAutoLayout()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reusableCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorSet.colors[.nearWhite]
        navigationItem.largeTitleDisplayMode = .never
        
        setupNavBar()
        setupViews()
        setupLayout()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.updateCollectionView()
    }
   
    
    private func setupViews() {
        view.addSubview(tableView)
    }
    
    private func setupLayout() {
        let constraints = [
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupNavBar() {
        
        let editButton = UIBarButtonItem(title: "Править", style: .done, target: self, action: #selector(editButtonTapped))
        editButton.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 17, weight: .regular)], for: .normal)
        editButton.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 17, weight: .regular)], for: .selected)
        editButton.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 17, weight: .regular)], for: .disabled)
        
        
        navigationController?.navigationBar.tintColor = ColorSet.colors[.violet]
        
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 17, weight: .semibold)]
        
        navigationItem.rightBarButtonItem = editButton
    }

    @objc
    private func editButtonTapped() {
        let habitViewController = HabitViewController()
        let habitNavigationController = UINavigationController(rootViewController: habitViewController)
        
        habitViewController.habit = HabitsStore.shared.habits[indexPath!.item]
        habitViewController.indexPath = indexPath
        habitViewController.isEditMode = true
        habitViewController.habitsDetailsViewController = self
        
        present(habitNavigationController, animated: true)
    }
}

//MARK: - UITableViewDataSource
extension HabitsDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Активность"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datesString?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reusableCell")!
        
        guard var safeDatesString = datesString, !safeDatesString.isEmpty else { return cell }
        safeDatesString.reverse()
        
        cell.textLabel?.text = safeDatesString[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        cell.textLabel?.textColor = .black
        cell.accessoryType = .none
        
        if HabitsStore.shared.isDateIsToken(habit: habit!, indexDate: indexPath) {
            cell.accessoryType = .checkmark
        }
        
        return cell
    }
    
    
}

//MARK: - UITableViewDelegate
extension HabitsDetailsViewController: UITableViewDelegate {
    
}
