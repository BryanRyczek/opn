//
//  UIHelperMethods.swift
//  Glint
//
//  Created by Bryan Ryczek on 4/14/16.
//  Copyright © 2016 Open. All rights reserved.
//

import UIKit
import SpriteKit

let actionTypes : [String] = ["Message", "Hours", "Offers", "Reviews"]

//MARK: COLORS!
let opnBlue: UIColor = UIColor(red: 31/255, green: 54/255, blue: 232/255, alpha: 1)
let opnRed: UIColor = UIColor(red: 226/255, green: 2/255, blue: 64/255, alpha: 1)

extension UIColor {
    static func randomColor() -> UIColor {
        // If you wanted a random alpha, just create another
        // random number for that too.
        return UIColor(red:   .random(),
                       green: .random(),
                       blue:  .random(),
                       alpha: 1.0)
    }
}

//MARK: FONTS
let avenir55 = "AvenirLTStd-Roman"
let avenir65 = "AvenirLTStd-Medium"
let avenir85 = "AvenirLTStd-Heavy"
let fontAwesome = "FontAwesome"

//MARK: print all fonts available to the project's target
func printFonts() {
    let fontFamilyNames = UIFont.familyNames
    for familyName in fontFamilyNames {
        print("------------------------------")
        print("Font Family Name = [\(familyName)]")
        let names = UIFont.fontNames(forFamilyName: familyName )
        print("Font Names = [\(names)]")
    }
}

//MARK: DATES
extension Date {
    
    func dayNumberOfWeek() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday! - 1
    }
    
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).lowercased()
        // or use lowercaseed(with: locale)
    }
    
}

func addTimeToCurrentDateString(_ addMinutes: Int, addHours: Int) -> String {
    
    let calendar = Calendar.current
    let addMin = calendar.date(byAdding: .minute, value: addMinutes, to: Date())
    let addHrs = calendar.date(byAdding: .hour, value: addHours, to: addMin!)
    
    let formatter = DateFormatter()
    formatter.amSymbol = "AM"
    formatter.pmSymbol = "PM"
    
    switch determineTimeScheme() {
    case true: //12 Hour Clock
        formatter.dateFormat = "h:mm a"
        let standardTime = formatter.string(from: addHrs!)
        return "\(standardTime)"
    case false: // 24 Hour clock (no AM / PM)
        formatter.dateFormat = "h:mm"
        let militaryTime = formatter.string(from: addHrs!)
        return "\(militaryTime)"
    }
}

func formatGMTDate(_ date: Date) -> String {
    
    let formatter = DateFormatter()
    formatter.amSymbol = "AM"
    formatter.pmSymbol = "PM"
    
    switch determineTimeScheme() {
    case true:
        formatter.dateFormat = "h:mm a"
        let standardTime = formatter.string(from: date)
        return "\(standardTime)"
    case false:
        formatter.dateFormat = "h:mm"
        let militaryTime = formatter.string(from: date)
        return "\(militaryTime)"
    }
    
}

//determines if user is using 12 hour or 24 hour clock setting
func determineTimeScheme() -> Bool {
    let formatString: NSString = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: Locale.current)! as NSString
    let hasAMPM = formatString.contains("a")
    return hasAMPM
}

//MARK: IMAGES
func getImageWithColor(color: UIColor, size: CGSize) -> UIImage {
    let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: size.width, height: size.height))
    UIGraphicsBeginImageContextWithOptions(size, false, 0)
    color.setFill()
    UIRectFill(rect)
    let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return image
}

//MARK: MISC
//type inference functions so we can add stored properties to extenstions
func associatedObject<ValueType: AnyObject>(
    _ base: AnyObject,
    key: UnsafePointer<UInt8>,
    initialiser: () -> ValueType)
    -> ValueType {
        if let associated = objc_getAssociatedObject(base, key)
            as? ValueType { return associated }
        let associated = initialiser()
        objc_setAssociatedObject(base, key, associated,
                                 .OBJC_ASSOCIATION_RETAIN)
        return associated
}

func associateObject<ValueType: AnyObject>(
    _ base: AnyObject,
    key: UnsafePointer<UInt8>,
    value: ValueType) {
    objc_setAssociatedObject(base, key, value,
                             .OBJC_ASSOCIATION_RETAIN)
}

//MARK: Load Nib From UIView
class NibLoadingView: UIView {
    
    @IBOutlet weak var view: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        nibSetup()
    }
    
    fileprivate func nibSetup() {
        backgroundColor = .clear
        
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true
        
        addSubview(view)
    }
    
    fileprivate func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        return nibView
    }
}

//MARK: TableViewCell
//Enable / Disable UITableViewCell
extension UITableViewCell {
    func enable(_ on: Bool) {
        self.isUserInteractionEnabled = on
        for view in contentView.subviews {
            view.isUserInteractionEnabled = on
            view.alpha = on ? 1 : 0.5
        }
    }
}


//MARK: STRINGS
//this method takes an HTML tagged String and returns an attributed string based on the HTML tags (<b>String</b>).
func convertHTMLTextToAttributedString(_ inputText: String, fontSize : Int) -> NSAttributedString {
    
    var html = inputText
    
    // Replace newline character by HTML line break
    while let range = html.range(of: "\n") {
        html.replaceSubrange(range, with: "<br />")
    }
    
    // Embed in a <span> for font attributes:
    html = "<span style=\"font-family: Helvetica; font-size:\(fontSize)pt;\">" + html + "</span>"
    
    let data = html.data(using: String.Encoding.unicode, allowLossyConversion: true)!
    let attrStr = try? NSAttributedString(
        data: data,
        options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
        documentAttributes: nil)
    return attrStr!
}

//used for image matching static data
func currentUserFirstNameLowercase (_ username: String) -> String {
    let firstName = username.components(separatedBy: " ")[0]
    let firstNameLowercase = firstName.lowercased()
    return firstNameLowercase
}

func currentUserFirstName (_ username: String) -> String {
    let firstName = username.components(separatedBy: " ")[0]
    return firstName
}

// MARK: - String Extension to handle HTML encoded strings
extension String {
    init(htmlEncodedString: String) {
        let encodedData = htmlEncodedString.data(using: String.Encoding.utf8)!
        let attributedOptions : [String: AnyObject] = [
            NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType as AnyObject,
            NSCharacterEncodingDocumentAttribute: String.Encoding.utf8 as AnyObject
        ]
        var attributedString:NSAttributedString?
        do{
            attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
        }catch{
            print(error)
        }
        self.init(attributedString!.string)!
    }
}

//MARK: String extension for easy subscripting syntax

//let str = "abcdef"
//str[1 ..< 3] // returns "bc"
//str[5] // returns "f"
//str[80] // returns ""
//str.substring(from: 3) // returns "def"
//str.substring(to: str.length - 2) // returns "abcd"

extension String {
    
    var length: Int {
        return self.characters.count
    }
    
    subscript (i: Int) -> String {
        return self[Range(i ..< i + 1)]
    }
    
    func substring(from: Int) -> String {
        return self[Range(min(from, length) ..< length)]
    }
    
    func substring(to: Int) -> String {
        return self[Range(0 ..< max(0, to))]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return self[Range(start ..< end)]
    }
    
}

//MARK: Contains Emjoi
extension String {
    
    var containsEmoji: Bool {
        for scalar in unicodeScalars {
            switch scalar.value {
            case 0x1F600...0x1F64F, // Emoticons
            0x1F300...0x1F5FF, // Misc Symbols and Pictographs
            0x1F680...0x1F6FF, // Transport and Map
            0x2600...0x26FF,   // Misc symbols
            0x2700...0x27BF,   // Dingbats
            0xFE00...0xFE0F:   // Variation Selectors
                return true
            default:
                continue
            }
        }
        return false
    }
    
}

//MARK: remove whitespaces from string
extension String {
    func replace(_ string:String, replacement:String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
    }
    
    func condenseWhitespace() -> String {
        return self.components(separatedBy: CharacterSet.whitespacesAndNewlines)
            .filter { !$0.isEmpty }
            .joined(separator: " ")
    }
    
}



//MARK: helper method for circularMatchIndicator
func randomAngle() -> Int {
    return Int(360 * Int(arc4random_uniform(UInt32(1))))
}

func randomInt(_ min: Int, max: Int) -> Int {
    if max < min { return min }
    return Int(arc4random_uniform(UInt32((max - min) + 1))) + min
}

extension UIView {
    class func fromNib<T : UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}

//apply corner radius
extension UIView{
    func setCornerRadius(_ radius: CGFloat? = nil){
        self.layer.cornerRadius = radius ?? self.frame.width / 2
        self.layer.masksToBounds = true
    }
}


//MARK: Storyboard methods
//this method will allow the developer to 
//func clearBackgroundColor (view: UIView) {
//    for view in backgroundColoredViews {
//        view.backgroundColor = UIColor.clearColor()
//}
