//
//  PeeringVC.swift
//  Drawn Together
//
//  Created by Charles Martin Reed on 2/20/19.
//  Copyright © 2019 Charles Martin Reed. All rights reserved.
//

import UIKit

class PeeringVC: UIViewController {
    
    //MARK:- Properties
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    //reference to our MP Connection handler
    
    //MARK:- Buttons
    lazy var hostButton: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Host a Canvas", for: .normal)
        button.backgroundColor = .red
        button.setTitleColor(.white, for: .normal)
        
        button.addTarget(self, action: #selector(hostButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var joinButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Join a Canvas", for: .normal)
        button.backgroundColor = .red
        button.setTitleColor(.white, for: .normal)
        
        button.addTarget(self, action: #selector(joinButtonTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //start browsing
        //appDelegate.multipeerCoordinator.browser.startBrowsingForPeers()
        
        view.backgroundColor = .white
        setupButtons()
        
    }
    
    func setupButtons() {
        view.addSubview(hostButton)
        view.addSubview(joinButton)
        
        let hostButtonConstraints: [NSLayoutConstraint] = [
            hostButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            hostButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            hostButton.widthAnchor.constraint(equalToConstant: 150),
            hostButton.heightAnchor.constraint(equalToConstant: 36)
        ]
        
        let joinButtonConstraints: [NSLayoutConstraint] = [
            joinButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            joinButton.topAnchor.constraint(equalTo: hostButton.bottomAnchor, constant: 8),
            joinButton.widthAnchor.constraint(equalToConstant: 150),
            joinButton.heightAnchor.constraint(equalToConstant: 36)]
        
        NSLayoutConstraint.activate(hostButtonConstraints)
        NSLayoutConstraint.activate(joinButtonConstraints)
    }
    
    //MARK:- Handler methods
    @objc func hostButtonTapped() {
        
        print("hosting")
    }
    
    @objc func joinButtonTapped() {
        print("joining")
    }

}
