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
    let slider = UISlider(frame: CGRect.zero)
    let label = UILabel(frame: CGRect.zero)
    
    required init(title: String)
    {
        super.init(frame: CGRect.zero)
        
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
        slider.addTarget(self, action: #selector(SliderWidget.sliderChangeHandler), for: .valueChanged)
        
        layer.cornerRadius = 5
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 2
        layer.backgroundColor = UIColor.darkGray.withAlphaComponent(0.25).cgColor
        
        add(subview: slider)
        add(subview: label)
    }
    
    @objc func sliderChangeHandler()
    {
        value = slider.value
        sendActions(for: .valueChanged)
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
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 640, height: 200)
    }
}
