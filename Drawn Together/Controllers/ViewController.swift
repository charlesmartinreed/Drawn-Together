//
//  ViewController.swift
//  Drawn Together
//
//  Created by Charles Martin Reed on 1/3/19.
//  Copyright © 2019 Charles Martin Reed. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK:- Properties
    let canvas = Canvas()
    
    let undoButton: UIButton = {
       let button = UIButton(type: .system)
        button.setTitle("Undo", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleUndo), for: .touchUpInside)
        return button
    }()
    
    let clearButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Clear", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleClear), for: .touchUpInside)
        return button
    }()
    
    //color buttons
    //var colors = [UIColor.yellow, UIColor.orange, UIColor.purple, UIColor.blue]
    
    let yellowButton: UIButton = {
       let button = UIButton(type: .system)
        button.backgroundColor = .yellow
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(handleColorChange(button:)), for: .touchUpInside)
        return button
    }()
    
    let redButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .red
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(handleColorChange(button:)), for: .touchUpInside)

        return button
    }()
    
    let blueButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .blue
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(handleColorChange(button:)), for: .touchUpInside)

        return button
    }()
    
    let brushSizeSlider: UISlider = {
       let slider = UISlider()
        slider.minimumValue = 5
        slider.maximumValue = 15
        slider.addTarget(self, action: #selector(handleSliderChanged(slider:)), for: .valueChanged)
        return slider
    }()

    
    override func loadView() {
        //we can immediately set the view controller's view to be the canvas
        self.view = canvas
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutToolbar()
    }

    
    func layoutToolbar() {
        //V1: using stack views to layout our tools window directly onto the canvas
        let colorsStackView = UIStackView(arrangedSubviews: [yellowButton, redButton, blueButton])
        colorsStackView.distribution = .fillEqually
        
        let stackview = UIStackView(arrangedSubviews: [
            undoButton,
            clearButton,
            colorsStackView,
            brushSizeSlider,
            ])
        stackview.spacing = 8
        stackview.distribution = .fillEqually
        
        //MARK:- Stackview constraints
        view.addSubview(stackview)
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        stackview.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        stackview.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
    }
    
    @objc fileprivate func handleUndo() {
        canvas.undo()
    }
    
    @objc fileprivate func handleClear() {
        canvas.clear()
    }
    
    @objc fileprivate func handleColorChange(button: UIButton) {
        //since we know the background color of the button, we can use that to change the stroke's color
        guard let color = button.backgroundColor else { return }
        canvas.setStrokeColor(color: color)
    }
    
    @objc fileprivate func handleSliderChanged(slider: UISlider) {
        canvas.setStrokeWidth(width: CGFloat(slider.value))
    }

}

