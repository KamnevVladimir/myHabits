import UIKit

class HabitsDetailsViewController: UIViewController {
    var habit: Habit? {
        didSet {
            guard let safeHabit = habit else { return }
            title = safeHabit.name
        }
    }

    private lazy var trackDatesString = HabitsStore.shared.trackDatesString(habit!)
    var delegate: HabitsViewController?
    var indexPath: IndexPath?
    
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

        setupNavBar()
        setupViews()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .never
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
        editButton.setTitleTextAttributes([.font: FontSet.fonts[.body]!], for: .normal)
        editButton.setTitleTextAttributes([.font: FontSet.fonts[.body]!], for: .selected)
        editButton.setTitleTextAttributes([.font: FontSet.fonts[.body]!], for: .disabled)
        
        
        navigationController?.navigationBar.tintColor = ColorSet.colors[.violet]
        
        navigationController?.navigationBar.titleTextAttributes = [
            .font: FontSet.fonts[.headline] ?? UIFont.systemFont(ofSize: 20)]
        
        navigationItem.rightBarButtonItem = editButton
    }

    @objc
    private func editButtonTapped() {
        let habitViewController = HabitViewController()
        let habitNavigationController = UINavigationController(rootViewController: habitViewController)
        
        habitViewController.habit = habit
        habitViewController.indexPath = indexPath
        habitViewController.isEditMode = true
        habitViewController.delegate = delegate
        
        present(habitNavigationController, animated: true) {
            self.navigationController?.popViewController(animated: false)
        }
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
        return trackDatesString.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reusableCell")!
        
        let reverseIndex = trackDatesString.count - indexPath.row - 1
        cell.textLabel?.text = trackDatesString[reverseIndex]
        cell.textLabel?.font = FontSet.fonts[.body]
        cell.textLabel?.textColor = .black
        
        return cell
    }
    
    
}

//MARK: - UITableViewDelegate
extension HabitsDetailsViewController: UITableViewDelegate {
    
}
