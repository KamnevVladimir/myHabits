import UIKit

extension UIView {
    func setShadowWithColor(color: UIColor = .black, opacity: Float = 1.0, offset: CGSize = .zero, radius: CGFloat) {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowRadius = radius 
    }
    
    func toAutoLayout() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func makeRound() {
        self.layer.cornerRadius = bounds.width / 2
    }
    
    func addSubviews(_ subviews: UIView...) {
        subviews.forEach(){ addSubview($0) }
    }
    

}
