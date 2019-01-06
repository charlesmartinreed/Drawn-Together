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
        let stackview = UIStackView(arrangedSubviews: [
            undoButton,
            clearButton
            ])
        stackview.distribution = .fillEqually
        
        //MARK:- Stackview constraints
        view.addSubview(stackview)
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        stackview.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        stackview.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    @objc fileprivate func handleUndo() {
        canvas.undo()
    }
    
    @objc fileprivate func handleClear() {
        canvas.clear()
    }

}

