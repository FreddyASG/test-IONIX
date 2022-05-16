//
//  ViewReddit.swift
//  Reddit Chile Memes
//
//  Created by Freddy Silva on 16/5/22.
//

import UIKit

@IBDesignable
final class ViewReddit: UIView {
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var shadowColor: UIColor = .clear {
          didSet {
              setNeedsLayout()
          }
      }
      
      @IBInspectable var shadowX: CGFloat = 0 {
          didSet {
              setNeedsLayout()
          }
      }
      
      @IBInspectable var shadowY: CGFloat = -3 {
          didSet {
              setNeedsLayout()
          }
      }
      
      @IBInspectable var shadowBlur: CGFloat = 3 {
          didSet {
              setNeedsLayout()
          }
      }
      
      @IBInspectable var shadowOpacity: Float = 0.5 {
          didSet {
              setNeedsLayout()
          }
      }
        
    override func layoutSubviews() {
        
        self.layer.cornerRadius = cornerRadius
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = CGSize(width: shadowX, height: shadowY)
        self.layer.shadowRadius = shadowBlur
        self.layer.shadowOpacity = shadowOpacity
    }
}
