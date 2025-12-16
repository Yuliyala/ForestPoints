import SwiftUI
import UIKit

struct AttributedTextLabel: UIViewRepresentable {
    let attributedString: NSAttributedString
    
    func makeUIView(context: Context) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        label.setContentHuggingPriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }
    
    func updateUIView(_ uiView: UILabel, context: Context) {
        uiView.attributedText = attributedString
    }
}

func createAttributedString(
    from text: String,
    fontSize: CGFloat,
    lineHeight: CGFloat,
    lineSpacing: CGFloat,
    letterSpacing: CGFloat = 0
) -> NSAttributedString {
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineSpacing = lineSpacing
    paragraphStyle.minimumLineHeight = lineHeight
    paragraphStyle.maximumLineHeight = lineHeight
    paragraphStyle.alignment = .center
    
    let attributes: [NSAttributedString.Key: Any] = [
        .font: UIFont(name: "Signika SC Bold", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize, weight: .bold),
        .paragraphStyle: paragraphStyle,
        .foregroundColor: UIColor.white,
        .kern: letterSpacing
    ]
    
    return NSAttributedString(string: text, attributes: attributes)
}

