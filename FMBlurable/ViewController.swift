//
//  ViewController.swift
//  FMBlurable
//
//  Created by SIMON_NON_ADMIN on 18/09/2015.
//  Copyright © 2015 Simon Gladman. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    let stackView = UIStackView()
    let horizontalStackView = UIStackView()
    
    let segmentedControl = UISegmentedControl(items: ["AAA", "BBB", "CCC", "DDD"])
    let toggleSwitch = UISwitch()
    let slider = UISlider()
    let stepper = UIStepper()
    let unarrangedLabel = UILabel()
    let unarrangedButton = UIButton(type: UIButtonType.InfoDark)
    
    let toolbar = UIToolbar()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        view.addSubview(stackView)
        view.addSubview(toolbar)

        stackView.frame = view.frame.insetBy(dx: 50, dy: 200)
        
        stackView.axis = UILayoutConstraintAxis.Vertical
        stackView.spacing = 10
        stackView.alignment = UIStackViewAlignment.Fill
        stackView.distribution = UIStackViewDistribution.EqualSpacing
        
        horizontalStackView.distribution = UIStackViewDistribution.FillEqually
        
        stackView.addArrangedSubview(segmentedControl)
        stackView.addArrangedSubview(slider)
        stackView.addArrangedSubview(horizontalStackView)
        
        horizontalStackView.addArrangedSubview(stepper)
        horizontalStackView.addArrangedSubview(toggleSwitch)
      
        unarrangedLabel.text = "Unarranged Label"
        unarrangedLabel.frame = CGRect(x: 20,
            y: 20,
            width: unarrangedLabel.intrinsicContentSize().width,
            height: unarrangedLabel.intrinsicContentSize().height)

        view.addSubview(unarrangedLabel)
        
        unarrangedButton.setTitle("Unarranged Button", forState: UIControlState.Normal)
        unarrangedButton.frame = CGRect(x: 20,
            y: 50,
            width: unarrangedButton.intrinsicContentSize().width,
            height: unarrangedButton.intrinsicContentSize().height)
        
        view.addSubview(unarrangedButton)
        
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        
        let toggleSegmentedControl = UIBarButtonItem(title: BarButtonLabel.SegmentedControl.rawValue, style: UIBarButtonItemStyle.Plain, target: self, action: "toolbarClickHandler:")
        
        let toggleToggleSwitch = UIBarButtonItem(title: BarButtonLabel.Switch.rawValue, style: UIBarButtonItemStyle.Plain, target: self, action: "toolbarClickHandler:")
        
        let toggleSlider = UIBarButtonItem(title: BarButtonLabel.Slider.rawValue, style: UIBarButtonItemStyle.Plain, target: self, action: "toolbarClickHandler:")
        
        let toggleStepper = UIBarButtonItem(title: BarButtonLabel.Stepper.rawValue, style: UIBarButtonItemStyle.Plain, target: self, action: "toolbarClickHandler:")
        
        let toggleUnarrangedLabel = UIBarButtonItem(title: BarButtonLabel.LabelOne.rawValue, style: UIBarButtonItemStyle.Plain, target: self, action: "toolbarClickHandler:")

        let toggleUnarrangedButton = UIBarButtonItem(title: BarButtonLabel.Button.rawValue, style: UIBarButtonItemStyle.Plain, target: self, action: "toolbarClickHandler:")
        
        toolbar.setItems([toggleSegmentedControl, spacer,
            toggleToggleSwitch, spacer,
            toggleSlider, spacer,
            toggleStepper, spacer,
            toggleUnarrangedLabel, spacer,
            toggleUnarrangedButton], animated: false)
    }

    func toolbarClickHandler(barButtonItem: UIBarButtonItem)
    {
        guard let title = barButtonItem.title,
            barButtonLabel = BarButtonLabel(rawValue: title) else
        {
            return
        }
        
        let widget: UIView
        
        switch barButtonLabel
        {
        case .SegmentedControl:
            widget = segmentedControl
        case .Switch:
            widget = toggleSwitch
        case .Slider:
            widget = slider
        case .Stepper:
            widget = stepper
        case .LabelOne:
            widget = unarrangedLabel
        case .Button:
            widget = unarrangedButton
        }
        
        if widget.isBlurred
        {
            widget.unBlur()
        }
        else
        {
            widget.blur(blurRadius: 2)
        }
    }
    
    override func viewDidLayoutSubviews()
    {
        stackView.frame = view.frame.insetBy(dx: 50, dy: 200)

        toolbar.frame = CGRect(x: 0,
            y: view.frame.height - toolbar.intrinsicContentSize().height,
            width: view.frame.width,
            height: toolbar.intrinsicContentSize().height)
    }
    
}

enum BarButtonLabel: String
{
    case SegmentedControl,
        Switch,
        Slider,
        Stepper,
        LabelOne,
        Button
}








