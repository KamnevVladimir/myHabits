import UIKit

enum FontNames {
    case title3
    case headline
    case body
    case footnoteBold
    case footnoteRegular
    case caption
}

struct FontSet {
    static let fonts: [FontNames: UIFont] = [
        .title3: UIFont(name: "SFProDisplay-Semibold", size: 20)!,
        .headline: UIFont(name: "SFProText-Semibold", size: 17)!,
        .body: UIFont(name: "SFProText-Regular", size: 17)!,
        .footnoteBold: UIFont(name: "SFProText-Semibold", size: 13)!,
        .footnoteRegular: UIFont(name: "SFProText-Regular", size: 13)!,
        .caption: UIFont(name: "SFProText-Regular", size: 12)!
    ]
}
