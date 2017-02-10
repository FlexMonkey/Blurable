//
//  FMBlurable.swift
//  FMBlurable
//
//  Created by SIMON_NON_ADMIN on 18/09/2015.
//  Copyright © 2015 Simon Gladman. All rights reserved.
//
// Thanks to romainmenke (https://twitter.com/romainmenke) for hint on a larger sample...

import UIKit


protocol Blurable
{
    var layer: CALayer { get }
    var subviews: [UIView] { get }
    var frame: CGRect { get }
    var superview: UIView? { get }
    
    func addSubviewTo(_ view: UIView)
    func removeFromSuperview()
    
    func blur(blurRadius: CGFloat)
    func unBlur()
    
    var isBlurred: Bool { get }
}

extension Blurable
{
    func blur(blurRadius: CGFloat)
    {
        if self.superview == nil
        {
            return
        }
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: frame.width, height: frame.height), false, 1)
        
        layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
  
        UIGraphicsEndImageContext();
        
        guard let blur = CIFilter(name: "CIGaussianBlur"),
            let this = self as? UIView else
        {
            return
        }
  
        blur.setValue(CIImage(image: image!), forKey: kCIInputImageKey)
        blur.setValue(blurRadius, forKey: kCIInputRadiusKey)
        
        let ciContext  = CIContext(options: nil)
        
        let result = blur.value(forKey: kCIOutputImageKey) as! CIImage!
        
        let boundingRect = CGRect(x:0,
            y: 0,
            width: frame.width,
            height: frame.height)
        
        let cgImage = ciContext.createCGImage(result!, from: boundingRect)

        let filteredImage = UIImage(cgImage: cgImage!)
        
        let blurOverlay = BlurOverlay()
        blurOverlay.frame = boundingRect
        
        blurOverlay.image = filteredImage
        blurOverlay.contentMode = UIViewContentMode.left
     
        if let superview = superview as? UIStackView,
            let index = (superview as UIStackView).arrangedSubviews.index(of: this)
        {
            removeFromSuperview()
            superview.insertArrangedSubview(blurOverlay, at: index)
        }
        else
        {
            blurOverlay.frame.origin = frame.origin
            
            UIView.transition(from: this,
                              to: blurOverlay,
                duration: 0.2,
                options: UIViewAnimationOptions.curveEaseIn,
                completion: nil)
        }
        
        objc_setAssociatedObject(this,
            &BlurableKey.blurable,
            blurOverlay,
            objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
    
    func unBlur()
    {
        guard let this = self as? UIView,
            let blurOverlay = objc_getAssociatedObject(self as? UIView, &BlurableKey.blurable) as? BlurOverlay else
        {
            return
        }
        
        if let superview = blurOverlay.superview as? UIStackView,
            let index = (blurOverlay.superview as! UIStackView).arrangedSubviews.index(of: blurOverlay)
        {
            blurOverlay.removeFromSuperview()
            superview.insertArrangedSubview(this, at: index)
        }
        else
        {
            this.frame.origin = blurOverlay.frame.origin
            
            UIView.transition(from: blurOverlay,
                              to: this,
                duration: 0.2,
                options: UIViewAnimationOptions.curveEaseIn,
                completion: nil)
        }
        
        objc_setAssociatedObject(this,
            &BlurableKey.blurable,
            nil,
            objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
    
    var isBlurred: Bool
    {
        return objc_getAssociatedObject(self as? UIView, &BlurableKey.blurable) is BlurOverlay
    }
}

extension UIView: Blurable
{
    internal func addSubviewTo(_ view: UIView) {
        self.addSubview(view)
    }

    class func blur() {
        self.blur()
    }
    
    class func unBlur() {
        self.unBlur()
    }
}

class BlurOverlay: UIImageView
{
}

struct BlurableKey
{
    static var blurable = "blurable"
}
