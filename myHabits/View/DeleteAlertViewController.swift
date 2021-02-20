import UIKit

class DeleteAlertViewController: UIAlertController {
    var delegate: HabitViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let safeDelegate = delegate else { return }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) {[unowned self] _ in
            HabitsStore.shared.habits.remove(at: (safeDelegate.indexPath?.item)!)
            self.delegate?.dismiss(animated: true, completion: nil)
        }
        
        title = "Вы хотите удалить привычку \"" + (delegate?.habit?.name)! + "\""
        
        addAction(cancelAction)
        addAction(deleteAction)
    }

}
