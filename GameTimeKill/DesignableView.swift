//
//  DesignableView.swift
//  SportNews
//
//  Created by Sergey Nazarov on 22.06.17.
//  Copyright © 2017 Msofter. All rights reserved.
//

import UIKit

@IBDesignable

class DesignableView: UIView {
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet{
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = .clear {
        didSet{
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderRadius: CGFloat = 0.0 {
        didSet{
            self.layer.cornerRadius = borderRadius
        }
    }
    
    @IBInspectable var shadowOfet: CGSize = CGSize(){
        didSet{
            self.layer.shadowOffset = shadowOfet
        }
    }
    
    @IBInspectable var shadowOpacity: Float = 0.0{
        didSet{
            self.layer.shadowOpacity = shadowOpacity
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat = 0.0{
        didSet{
            self.layer.shadowRadius = shadowRadius
        }
    }
    @IBInspectable var shadowColor: UIColor = .clear{
        didSet{
            self.layer.shadowColor = shadowColor.cgColor
        }
    }
}
