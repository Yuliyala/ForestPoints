//
//  Font+Extensions.swift
//  ForestPoints
//
//  Created by Yuliya Lapenak on 12/15/25.
//

import SwiftUI

extension Font {
    /// Кастомный шрифт Signika SC
    static func signikaSC(size: CGFloat) -> Font {
        return .custom("Signika SC", size: size)
    }
    
    /// Кастомный шрифт Signika SC (bold)
    static func signikaSCBold(size: CGFloat) -> Font {
        return .custom("Signika SC Bold", size: size)
    }
}


