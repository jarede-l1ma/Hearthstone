import Foundation
import UIKit

extension String {
    
    func htmlToAttributedString(fontSize: CGFloat = 16, color: UIColor = .label) -> NSAttributedString? {
        let fontName = UIFont.systemFont(ofSize: fontSize).fontName
        let hexColor = color.toHexString() ?? "#000000"
        let htmlTemplate = """
        <html>
        <head>
        <style>
        body {
            font-family: -apple-system, "\(fontName)";
            font-size: \(fontSize)px;
            color: \(hexColor);
            margin: 0;
            padding: 0;
        }
        </style>
        </head>
        <body>
        \(self)
        </body>
        </html>
        """
        guard let data = htmlTemplate.data(using: .utf8) else { return nil }
        return try? NSAttributedString(
            data: data,
            options: [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue
            ],
            documentAttributes: nil
        )
    }
}

extension UIColor {
    
    func toHexString() -> String? {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        guard getRed(&r, green: &g, blue: &b, alpha: &a) else { return nil }
        
        let rgb = Int(r * 255) << 16 | Int(g * 255) << 8 | Int(b * 255)
        return String(format: "#%06x", rgb)
    }
}
