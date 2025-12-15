import SwiftUI
import UIKit

struct AttributedTextLabel: UIViewRepresentable {
    let attributedString: NSAttributedString
    
    func makeUIView(context: Context) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
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
    lineSpacing: CGFloat
) -> NSAttributedString {
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineSpacing = lineSpacing
    paragraphStyle.minimumLineHeight = lineHeight
    paragraphStyle.maximumLineHeight = lineHeight
    paragraphStyle.alignment = .center
    
    let attributes: [NSAttributedString.Key: Any] = [
        .font: UIFont(name: "Signika SC", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize, weight: .bold),
        .paragraphStyle: paragraphStyle,
        .foregroundColor: UIColor.white
    ]
    
    return NSAttributedString(string: text, attributes: attributes)
}

