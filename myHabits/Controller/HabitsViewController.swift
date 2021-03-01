import UIKit

class HabitsViewController: UIViewController {
    
    private lazy var addHabbitButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addHabbitItemTapped))
        return button
    }()
    
    // Create customize UICollectionView
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = ColorSet.colors[.nearWhite]
        collectionView.register(ProgressCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: ProgressCollectionViewCell.self))
        collectionView.register(HabitCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: HabitCollectionViewCell.self))
        
        return collectionView
    }()
    
    var progressDelegate: ProgressCollectionViewCell?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupView()
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .always
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.reloadData()
        
        // Fixing collectionView frame with view area
        collectionView.frame = CGRect(x: 0,
                                      y: view.safeAreaInsets.top,
                                      width: view.bounds.width,
                                      height: view.bounds.height - view.safeAreaInsets.top)
    }
    
    private func setupView() {
        view.addSubview(collectionView)
    }
    
    // Setups navigation bar
    private func setupNavigationBar() {
        navigationItem.title = "Сегодня"
     
        // Add right button on navigation bar
        navigationItem.rightBarButtonItem = addHabbitButton
        navigationItem.rightBarButtonItem?.tintColor = ColorSet.colors[.violet]
    }
    
    @objc
    private func addHabbitItemTapped() {
        let habitViewController = HabitViewController()
        let habitNavigationController = UINavigationController(rootViewController: habitViewController)
        
        habitViewController.isEditMode = false
        habitViewController.habitsViewController = self
        
        present(habitNavigationController, animated: true, completion: nil)
    }
    
    func updateCollectionView() {
        collectionView.reloadData()
        progressDelegate?.setupProgress()
    }

}

//MARK: - UICollectionViewDataSource

extension HabitsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return HabitsStore.shared.habits.count
        }
    }
    
    // Create custom cells for collection view
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ProgressCollectionViewCell.self), for: indexPath) as! ProgressCollectionViewCell
            progressDelegate = cell
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: HabitCollectionViewCell.self), for: indexPath) as! HabitCollectionViewCell
    
            cell.habit = HabitsStore.shared.habits[indexPath.item]
            cell.delegate = self
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.section == 1 else { return }
        let habitsDetailsViewController = HabitsDetailsViewController()
        
        navigationController?.pushViewController(habitsDetailsViewController, animated: true)
        habitsDetailsViewController.delegate = self
        habitsDetailsViewController.indexPath = indexPath
        
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension HabitsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return CGSize(width: view.bounds.width - 32, height: 60)
        default:
            return CGSize(width: view.bounds.width - 32, height: 130)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch section {
        case 0:
            return UIEdgeInsets(top: 22, left: 16, bottom: 18, right: 16)
        default:
            return UIEdgeInsets(top: 0, left: 16, bottom: 22, right: 16)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
}
