//
//  ViewController.swift
//  Drawn Together
//
//  Created by Charles Martin Reed on 1/3/19.
//  Copyright © 2019 Charles Martin Reed. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ViewController: UIViewController {
    
    //MARK:- Properties
    let canvas = Canvas()
    
    var peerID: MCPeerID!
    var mcSession: MCSession!
    var mcAdvertiserAssistant: MCAdvertiserAssistant!
    
    let addUserButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "addFriendIcon"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addUserButtonTapped), for: .touchUpInside)
        return button
    }()
    
    
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
        canvas.frame = view.frame
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeMultipeer()
        setupTopButtons()
        layoutToolbar()
    }
    
    func initializeMultipeer() {
        peerID = MCPeerID(displayName: UIDevice.current.name)
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        mcSession.delegate = self
    }

    func setupTopButtons() {
        view.addSubview(addUserButton)
        
        addUserButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        addUserButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8).isActive = true
        addUserButton.widthAnchor.constraint(equalToConstant: 36).isActive = true
        addUserButton.heightAnchor.constraint(equalToConstant: 36).isActive = true
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
    
    @objc fileprivate func addUserButtonTapped() {
        let ac = UIAlertController(title: "Add a friend!", message: "Connect to other nearby users", preferredStyle: .actionSheet)
        
        ac.addAction(UIAlertAction(title: "Host a friend", style: .default) { [unowned self] action in
            self.mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "canvas-app", discoveryInfo: nil, session: self.mcSession)
            self.mcAdvertiserAssistant.start()
        })
        
        ac.addAction(UIAlertAction(title: "Join a friend", style: .default, handler: { [unowned self] action in
            let mcBrowser = MCBrowserViewController(serviceType: "canvas-app", session: self.mcSession)
            mcBrowser.delegate = self
            self.present(mcBrowser, animated: true, completion: nil)
        }))
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        present(ac, animated: true, completion: nil)
        
        
    }

}

extension ViewController: MCSessionDelegate, MCBrowserViewControllerDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            print("Connected: \(peerID.displayName)")
        case .connecting:
            print("Connecting: \(peerID.displayName)")
        case .notConnected:
            print("Not Connected: \(peerID.displayName)")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    
}



