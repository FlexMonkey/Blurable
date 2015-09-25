//
//  SliderWidget.swift
//  SceneKitExperiment
//
//  Created by Simon Gladman on 04/11/2014.
//  Copyright (c) 2014 Simon Gladman. All rights reserved.
//

import UIKit

class SliderWidget: UIControl
{
    let slider = UISlider(frame: CGRectZero)
    let label = UILabel(frame: CGRectZero)
    
    required init(title: String)
    {
        super.init(frame: CGRectZero)
        
        self.title = title
        
        updateLabel()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    var title: String = ""
    {
        didSet
        {
            updateLabel()
        }
    }
    
    var value: Float = 0
    {
        didSet
        {
            slider.value = value
            updateLabel()
        }
    }
    
    override func didMoveToSuperview()
    {
        slider.addTarget(self, action: "sliderChangeHandler", forControlEvents: .ValueChanged)
        
        layer.cornerRadius = 5
        layer.borderColor = UIColor.whiteColor().CGColor
        layer.borderWidth = 2
        layer.backgroundColor = UIColor.darkGrayColor().colorWithAlphaComponent(0.25).CGColor
        
        addSubview(slider)
        addSubview(label)
    }
    
    func sliderChangeHandler()
    {
        value = slider.value
        
        sendActionsForControlEvents(.ValueChanged)
    }
    
    func updateLabel()
    {
        label.text = title + ": " + (NSString(format: "%.3f", Float(value)) as String)
    }
    
    override func layoutSubviews()
    {
        label.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height / 2).insetBy(dx: 5, dy: 5)
        slider.frame = CGRect(x: 0, y: frame.height / 2, width: frame.width, height: frame.height / 2).insetBy(dx: 5, dy: 5)
    }
    
    override func intrinsicContentSize() -> CGSize
    {
        return CGSize(width: 640, height: 75)
    }
}
