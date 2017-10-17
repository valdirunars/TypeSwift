//
//  CodeBlock.swift
//  TypeSwiftPackageDescription
//
//  Created by Þorvaldur on 17/10/2017.
//

import Foundation

public struct CodeBlock: TypeScriptInitializable, SwiftStringConvertible {

    public let swiftValue: String

    private init(swiftValue: String) {
        self.swiftValue = swiftValue
    }

    public init(typescript: String) throws {
        var str = typescript
        let regexForVariable = "\\$\\{[^\\}]*\\}"

        if let range = str.rangeOfTypeScriptFormatString() {
            var stringFormat = String(str[range])


            while let rangeOfVariable = stringFormat.range(of: regexForVariable,
                                               options: .regularExpression,
                                               range: nil,
                                               locale: nil) {

                let varInsertion = String(stringFormat[rangeOfVariable])

                let rangeOfLast = stringFormat.index(before: varInsertion.endIndex)..<varInsertion.endIndex
                let newStr = varInsertion.replacingCharacters(in: rangeOfLast,
                                                              with: ")")
                    .replacingOccurrences(of: "${", with: "\\(")

                stringFormat = stringFormat.replacingOccurrences(of: varInsertion,
                                                                 with: newStr)
            }

            str = str.replacingCharacters(in: range, with: stringFormat)
        }

        if str.range(of: regexForVariable,
                     options: .regularExpression,
                     range: nil,
                     locale: nil) != nil {
            try self.init(typescript: str)
        } else {
            self.init(swiftValue: str)
        }
    }
}
