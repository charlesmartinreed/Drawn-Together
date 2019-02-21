//
//  MultipeerCoordinator.swift
//  Drawn Together
//
//  Created by Charles Martin Reed on 2/20/19.
//  Copyright © 2019 Charles Martin Reed. All rights reserved.
//

import UIKit
import MultipeerConnectivity

//protocol MulitpeerCoordinatorDelegate {
//    var session: MCSession { get set }
//    var peerId: MCPeerID { get set }
//    var browser: MCNearbyServiceBrowser { get set }
//    var adveriser: MCNearbyServiceAdvertiser { get set }
//
//    var foundPeers: [MCPeerID] { get set }
//    var deviceName: String { get set }
//}

class MultipeerCoordinator: NSObject, MCSessionDelegate, MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate {
    
    //MARK:- MCNearbyServiceBrowser delegate methods
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        
        //add the discovered peers
        foundPeers.append(peerID)
        guard let otherPeer = foundPeers.popLast() else { return }
        //with context is probably where I want to pass my canvas
        browser.invitePeer(otherPeer, to: session, withContext: nil, timeout: 20)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        
        //try to remove the peers
        for (index, peer) in foundPeers.enumerated() {
            if peer == peerID {
                foundPeers.remove(at: index)
                break
            }
        }
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        //for now, just log to console
        print(error.localizedDescription)
    }
    
    //MARK:- MCNearbyServiceAdvertiser methods
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        
        //application receives invitation
        //peerID is inviter, context can be used to provide info
        let invHandler = invitationHandler
        invHandler(true, self.session)
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        print(error.localizedDescription)
    }
    
    //MARK:- MCSession delegate methods
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            print("connected")
        case .connecting:
            print("connecting")
        case .notConnected:
            print("not connected")
        }
    }
    
    //send data in other vcs with appDelegate.multipeerCoordinator.sendData()
    func sendData(send data: Dictionary<String, String>, toPeer targetPeer: [MCPeerID]) -> Bool {
        let peersArray = targetPeer
        
        do {
            //MARK:- FOR TESTING PURPOSES, this is a <String, String>
            let dataToSend = try NSKeyedArchiver.archivedData(withRootObject: data, requiringSecureCoding: true)
            //sketchy comparison - reliable is like TCP, unreliable is like UDP
            try session.send(dataToSend, toPeers: peersArray, with: .unreliable)
        } catch let error {
            print(error.localizedDescription)
            return false
        }
        return true
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        
        do {
            let extractedData = try NSKeyedUnarchiver.unarchivedObject(ofClasses: [AnyObject.self], from: data)
            let receivedData = extractedData as! Dictionary<String, String>
        } catch let error {
            print(error.localizedDescription)
        }
        
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    var session: MCSession!
    var peerId: MCPeerID!
    var browser: MCNearbyServiceBrowser!
    var advertiser: MCNearbyServiceAdvertiser!
    var foundPeers = [MCPeerID]()
    
    //var delegate: MulitpeerCoordinatorDelegate?
    
    override init() {
        super.init()
        
        //provided for self identification
        peerId = MCPeerID(displayName: UIDevice.current.name)
        
        //start the session and browser, set proper delegates
        session = MCSession(peer: peerId)
        session.delegate = self
        
        //serviceType dictates what broadcasters advertise under and what browsers use to search for other peers
        browser = MCNearbyServiceBrowser(peer: peerId, serviceType: "canvasApp-mpc")
        browser.delegate = self
        
        //finally, set up the advertiser
        advertiser = MCNearbyServiceAdvertiser(peer: peerId, discoveryInfo: nil, serviceType: "canvasApp-mpc")
    }
    
//    func browser(browser: MCNearbyServiceBrowser!, lostPeer peerID: MCPeerID!) {
//        //remove lost peer
//        for (index, peer) in foundPeers.enumerated() {
//            if peer == peerID {
//                foundPeers.remove(at: index)
//                break
//            }
//        }
//    }
}
