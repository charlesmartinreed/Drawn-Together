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
    let undoButton = UIButton()
    let clearButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(canvas)
        
        
        layoutCanvas()
        
    }

    func layoutCanvas() {
        canvas.backgroundColor = .white //the canvas color seems to become black when the context is grabbed
        canvas.frame = view.frame
        
        view.addSubview(undoButton)
        view.addSubview(clearButton)
        
        //setting up buttons
        //TODO: Put the buttons, the color picker and the line width slider into a seperate view that is presented like a card view when the user pulls up
        undoButton.setTitle("Undo", for: .normal)
        undoButton.backgroundColor = Colors.notQuiteBlue
        undoButton.setTitleColor(UIColor.white, for: .normal)
        undoButton.layer.cornerRadius = 12

        undoButton.translatesAutoresizingMaskIntoConstraints = false
        undoButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        undoButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
        undoButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8).isActive = true
        undoButton.bottomAnchor.constraint(equalTo: clearButton.topAnchor, constant: -8).isActive = true
        
        undoButton.addTarget(canvas, action: #selector(canvas.undo), for: .touchUpInside)
        
        clearButton.setTitle("Clear", for: .normal)
        clearButton.backgroundColor = Colors.notQuiteBlue
        clearButton.setTitleColor(UIColor.white, for: .normal)
        clearButton.layer.cornerRadius = 12
        
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        clearButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        clearButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
        clearButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8).isActive = true
        clearButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8).isActive = true
        
        clearButton.addTarget(canvas, action: #selector(canvas.clear), for: .touchUpInside)
        
    }

}

