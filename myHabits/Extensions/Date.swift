import Foundation

private enum NearestDays: String {
    case today = "Сегодня"
    case yesterday = "Вчера"
    case beforeYesterday = "Позавчера"
}

extension Date {
    
    var formattedDate: String {
        guard let dateDay = Calendar.current.dateComponents([.day], from: self).day else { return "Error"}
        guard let currentDay = Calendar.current.dateComponents([.day], from: .init()).day else { return "Error"}
        
        switch currentDay - dateDay {
        case 0:
            return NearestDays.today.rawValue
        case 1:
            return NearestDays.yesterday.rawValue
        case 2:
            return NearestDays.beforeYesterday.rawValue
        default:
            return getDateString(date: self)
        }
    }
    
    
    func getDateString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter.string(from: date)
    }
}
    
