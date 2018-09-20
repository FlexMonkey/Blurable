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
    let unarrangedButton = UIButton(type: UIButtonType.infoDark)
    let compositeComponent = SliderWidget(title: "Composite Component")
    
    let toolbar = UIToolbar()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        view.addSubview(stackView)
        view.addSubview(toolbar)

        stackView.frame = view.frame.insetBy(dx: 50, dy: 180)
        
        stackView.axis = UILayoutConstraintAxis.vertical
       
        stackView.alignment = UIStackViewAlignment.fill
        stackView.distribution = UIStackViewDistribution.equalSpacing
        
        horizontalStackView.distribution = UIStackViewDistribution.fillEqually
        
        stackView.addArrangedSubview(segmentedControl)
        stackView.addArrangedSubview(slider)
        stackView.addArrangedSubview(horizontalStackView)
        stackView.addArrangedSubview(compositeComponent)
        
        horizontalStackView.addArrangedSubview(stepper)
        horizontalStackView.addArrangedSubview(toggleSwitch)
      
        unarrangedLabel.text = "label"

        view.addSubview(unarrangedLabel)
        
        unarrangedButton.setTitle("button", for: UIControlState.normal)
        
        view.addSubview(unarrangedButton)
        
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        let toggleSegmentedControl = UIBarButtonItem(title: BarButtonLabel.segmented.rawValue, style: UIBarButtonItemStyle.plain, target: self, action: #selector(ViewController.toolbarClickHandler(_:)))
        
        let toggleToggleSwitch = UIBarButtonItem(title: BarButtonLabel.switch.rawValue, style: UIBarButtonItemStyle.plain, target: self, action: #selector(ViewController.toolbarClickHandler(_:)))
        
        let toggleSlider = UIBarButtonItem(title: BarButtonLabel.slider.rawValue, style: UIBarButtonItemStyle.plain, target: self, action: #selector(ViewController.toolbarClickHandler(_:)))
        
        let toggleStepper = UIBarButtonItem(title: BarButtonLabel.stepper.rawValue, style: UIBarButtonItemStyle.plain, target: self, action: #selector(ViewController.toolbarClickHandler(_:)))
        
        let toggleUnarrangedLabel = UIBarButtonItem(title: BarButtonLabel.label.rawValue, style: UIBarButtonItemStyle.plain, target: self, action: #selector(ViewController.toolbarClickHandler(_:)))

        let toggleUnarrangedButton = UIBarButtonItem(title: BarButtonLabel.button.rawValue, style: UIBarButtonItemStyle.plain, target: self, action: #selector(ViewController.toolbarClickHandler(_:)))
        
       let toggleCompositeComponent = UIBarButtonItem(title: BarButtonLabel.composite.rawValue, style: UIBarButtonItemStyle.plain, target: self, action: #selector(ViewController.toolbarClickHandler(_:)))
        
        toolbar.setItems([toggleSegmentedControl, spacer,
            toggleToggleSwitch, spacer,
            toggleSlider, spacer,
            toggleStepper, spacer,
            toggleUnarrangedLabel, spacer,
            toggleUnarrangedButton, spacer,
            toggleCompositeComponent], animated: false)
    }

    @objc func toolbarClickHandler(_ barButtonItem: UIBarButtonItem)
    {
        guard let title = barButtonItem.title,
            let barButtonLabel = BarButtonLabel(rawValue: title) else
        {
            return
        }
        
        let widget: UIView
        
        switch barButtonLabel
        {
        case .segmented:
            widget = segmentedControl
        case .switch:
            widget = toggleSwitch
        case .slider:
            widget = slider
        case .stepper:
            widget = stepper
        case .label:
            widget = unarrangedLabel
        case .button:
            widget = unarrangedButton
        case .composite:
            widget = compositeComponent
        }
        
        if widget.isBlurred
        {
            widget.unBlur()
        }
        else
        {
            widget.blur(radius: 2)
        }
    }
    
    override func viewDidLayoutSubviews()
    {
        stackView.frame = CGRect(x: 0,
            y: topLayoutGuide.length,
            width: view.frame.width,
            height: view.frame.height - topLayoutGuide.length).insetBy(dx: 40, dy: 40)

        toolbar.frame = CGRect(x: 0,
                               y: view.frame.height - toolbar.intrinsicContentSize.height - 20,
            width: view.frame.width,
            height: toolbar.intrinsicContentSize.height)
        
        unarrangedButton.frame = CGRect(x: view.frame.width - unarrangedButton.intrinsicContentSize.width - 40,
            y: 40,
            width: unarrangedButton.intrinsicContentSize.width,
            height: unarrangedButton.intrinsicContentSize.height)
        
        unarrangedLabel.frame = CGRect(x: 20,
            y: 40,
            width: unarrangedLabel.intrinsicContentSize.width,
            height: unarrangedLabel.intrinsicContentSize.height)
    }
    
}

enum BarButtonLabel: String
{
    case segmented,
        `switch`,
         slider,
         stepper,
         label,
         button,
        composite
}
