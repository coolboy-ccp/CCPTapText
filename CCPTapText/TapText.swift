//
//  TapText.swift
//  CCPTapText
//
//  Created by 123 on 2020/6/19.
//  Copyright © 2020 ccp. All rights reserved.
//

import UIKit

protocol TapTextElement {
    var string: String { get }
    var color: UIColor { get }
    func action(str: String)
}

class TapText: UILabel {
    
    private lazy var textStorage = NSTextStorage()
    private lazy var textLayout = NSLayoutManager()
    private lazy var textContainer = NSTextContainer()
    
    func addTap(_ text: String, _ elements: TapTextElement...) {
        self.text = text
        self.elements = elements
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction(_:)))
        addGestureRecognizer(tap)
        setup()
    }
    
    private func setup() {
        textStorage.addLayoutManager(textLayout)
        textLayout.addTextContainer(textContainer)
        textContainer.lineFragmentPadding = 0
        textContainer.lineBreakMode = .byWordWrapping
        textContainer.maximumNumberOfLines = 2
        textContainer.size = CGSize(width: bounds.width, height: 100)
        isUserInteractionEnabled = true
        textStorage.setAttributedString(attributes)
        attributedText = attributes
        
    }
    
    fileprivate func action(at location: CGPoint, for element: TapTextElement) {
        guard textStorage.length > 0 else { return }
        let index = textLayout.glyphIndex(for: location, in: textContainer)
        let elementRange = nsOrigin.range(of: element.string)
        if (elementRange.location ... elementRange.location + elementRange.length).contains(index) {
            element.action(str: element.string)
        }
    }

    private lazy var origin: String = {
        return text ?? ""
    }()
    
    private lazy var nsOrigin: NSString = {
        return origin as NSString
    }()
    
    private lazy var attributes: NSMutableAttributedString = {
        let font = self.font ?? UIFont.systemFont(ofSize: 12)
        let color = self.textColor ?? .gray
        let attributes = NSMutableAttributedString(string: origin, attributes: [
            .font : font,
            .foregroundColor : color
        ])
        
        for e in elements {
            attributes.addAttributes([.foregroundColor : e.color], range: nsOrigin.range(of: e.string))
        }
        return attributes
    }()

    
    private var elements = [TapTextElement]()
    
    @objc private func tapAction(_ tap: UIGestureRecognizer) {
        let tapPoint = tap.location(in: self)
        _ = elements.map { action(at: tapPoint, for: $0) }
    }
    
}

