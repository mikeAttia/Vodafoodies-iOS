//
//  TagLabel.swift
//  VodaFoodies
//
//  Created by Michael Attia on 9/11/17.
//  Copyright © 2017 Michael Attia. All rights reserved.
//

import UIKit

class TagLabel: UILabel {

    private var labelType: LabelType = LabelType.open
    var textInsets = UIEdgeInsets.init(top: 0, left: 3, bottom: 0, right: 3) {
        didSet { invalidateIntrinsicContentSize() }
    }
    
    
    func setLabelType(_ type: LabelType){
        self.textColor = UIColor.black
        
        switch type {
        case .open:
            self.backgroundColor = UIColor.green
        case .cancelled:
            self.backgroundColor = UIColor.red
        case .ordered:
            self.backgroundColor = UIColor.orange
        case .delivered:
            self.backgroundColor = UIColor.blue
        }
        
        self.text = type.rawValue
    }
    
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insetRect = UIEdgeInsetsInsetRect(bounds, textInsets)
        let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
        let invertedInsets = UIEdgeInsets(top: -textInsets.top,
                                          left: -textInsets.left,
                                          bottom: -textInsets.bottom,
                                          right: -textInsets.right)
        return UIEdgeInsetsInsetRect(textRect, invertedInsets)
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, textInsets))
    }
    
    
    enum LabelType: String {
        case open // green
        case cancelled // red
        case ordered // orangy yellow
        case delivered // blue
    }
}
