import UIKit

extension UILabel {
    /// Метод позволяет изменить цвет части текса у Label
    func halfTextColorChange (changeText : String, color: UIColor ) {
        guard let safeText = self.text else { return }
        
        let range = NSString(string: safeText).range(of: changeText)
        let attribute = NSMutableAttributedString.init(string: safeText)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        self.attributedText = attribute
    }
}
