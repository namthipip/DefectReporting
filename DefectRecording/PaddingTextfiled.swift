//
//  PaddingTextfiled.swift
//  DefectTrackingApp
//
//  Created by Namthip Silsuwan on 3/29/2561 BE.
//  Copyright © 2561 Namthip Silsuwan. All rights reserved.
//

import UIKit

@IBDesignable class PaddingTextfiled: UITextField {

    @IBInspectable let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10);
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }

}
