//
//  FMBlurable.swift
//  FMBlurable
//
//  Created by SIMON_NON_ADMIN on 18/09/2015.
//  Copyright © 2015 Simon Gladman. All rights reserved.
//

import UIKit


protocol Blurable
{
    var layer: CALayer { get }
    var subviews: [UIView] { get }
    var frame: CGRect { get }
    
    func addSubview(view: UIView)
    func bringSubviewToFront(view: UIView)
    
    func blur(blurRadius blurRadius: CGFloat)
    func unBlur()
    
    var isBlurred: Bool { get }
}

extension Blurable
{
    func blur(blurRadius blurRadius: CGFloat)
    {
        if subviews.last is BlurOverlay
        {
            return
        }

        UIGraphicsBeginImageContextWithOptions(CGSize(width: frame.width, height: frame.height), false, 1)
        
        layer.renderInContext(UIGraphicsGetCurrentContext()!)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
  
        UIGraphicsEndImageContext();
        
        guard let blur = CIFilter(name: "CIGaussianBlur") else
        {
            return
        }
  
        blur.setValue(CIImage(image: image), forKey: kCIInputImageKey)
        blur.setValue(blurRadius, forKey: kCIInputRadiusKey)
        
        let ciContext  = CIContext(options: nil)
        
        let result = blur.valueForKey(kCIOutputImageKey) as! CIImage!
        
        let cgImage = ciContext.createCGImage(result,
            fromRect: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))

        let filteredImage = UIImage(CGImage: cgImage)
        
        let blurOverlay = BlurOverlay()
        blurOverlay.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        
        blurOverlay.image = filteredImage
        
        subviews.forEach{ $0.hidden = true }
        
        addSubview(blurOverlay)
    }
    
    func unBlur()
    {
        if let blurOverlay = subviews.last as? BlurOverlay
        {
            blurOverlay.removeFromSuperview()
            
            subviews.forEach{ $0.hidden = false }
        }
    }
    
    var isBlurred: Bool
    {
        return subviews.last is BlurOverlay
    }
}

extension UIView: Blurable
{
}

class BlurOverlay: UIImageView
{
}