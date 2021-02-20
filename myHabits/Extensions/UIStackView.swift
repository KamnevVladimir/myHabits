import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: UIView...) {
        for view in views {
            addArrangedSubview(view)
        }
    }
    
    func addArrayImageView(_ arrayImageView: [UIImageView]) {
        for imageView in arrayImageView {
            addArrangedSubview(imageView)
        }
    }
}
