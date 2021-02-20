import UIKit

enum ColorName {
    case systemGray
    case systemGray2
    case nearWhite
    case violet
    case blue
    case green
    case blueViolet
    case orange
}

struct ColorSet {
    static let colors: [ColorName: UIColor] = [
        .systemGray: UIColor.systemGray,
        .systemGray2: UIColor.systemGray2,
        .nearWhite: UIColor(red: 242, green: 242, blue: 247),
        .violet: UIColor(red: 161, green: 22, blue: 204),
        .blue: UIColor(red: 41, green: 109, blue: 255),
        .green: UIColor(red: 29, green: 179, blue: 34),
        .blueViolet: UIColor(red: 98, green: 54, blue: 255),
        .orange: UIColor(red: 255, green: 159, blue: 79)]
}
