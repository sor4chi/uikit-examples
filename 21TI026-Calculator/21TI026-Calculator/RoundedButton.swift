//
//  RoundedButton.swift
//  21TI026-Calculator
//
//  Created by 川村空千 on 2023/08/31.
//

import UIKit

@IBDesignable class RoundButton: UIButton {
    var cornerRadius: CGFloat = 0;
    
    override var bounds: CGRect {
        didSet {
            refreshCorners(value: cornerRadius)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    override func prepareForInterfaceBuilder() {
        sharedInit()
    }
    
    func sharedInit() {
        refreshCorners(value: cornerRadius)
    }
    
    func refreshCorners(value: CGFloat) {
        layer.cornerRadius = min(bounds.width, bounds.height) / 2.0
    }
}
