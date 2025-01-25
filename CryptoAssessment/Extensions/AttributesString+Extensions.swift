//
//  AttributesString+Extensions.swift
//  CryptoAssessment
//
//  Created by ikorobov on 17.1.25..
//

import Foundation

extension NSAttributedString {
    static func fromHtml(_ html: String) -> NSAttributedString? {
        guard let data = html.data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(
                   data: data,
                   options: [.documentType: NSAttributedString.DocumentType.html,
                             .characterEncoding: String.Encoding.utf8.rawValue],
                   documentAttributes: nil
            )
        } catch {
            print("Error parsing HTML: \(error)")
            return nil
        }
    }
}

extension AttributedString {
    init?(html: String, ignoringHTMLStyles: Bool = true) {
        guard let data = html.data(using: .utf8) else { return nil }
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        
        do {
            let attrString = try NSMutableAttributedString(
                data: data,
                options: options,
                documentAttributes: nil
            )
            
            if ignoringHTMLStyles {
                attrString.setAttributes( [:], range: NSRange(location: 0, length: attrString.length))
            }
            
            self.init(attrString)
            
        } catch {
            return nil
        }
            
    }
}
