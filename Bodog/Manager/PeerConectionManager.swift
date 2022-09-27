//
//  PeerConectionManager.swift
//  Bodog
//
//  Created by Anastasia Koldunova on 20.09.2022.
//

import MultipeerConnectivity


protocol PeerConectedProtocol : AnyObject {
    func connected()
}

protocol PeerDisconectedProtocol: AnyObject {
    func disconected()
    func recieved(message: MessageType)
}

class PeerContectionManager: NSObject {
    //MARK: - Properties
    var peerID: MCPeerID!
    var mcSession: MCSession!
    var mcAdvertiserAssistant: MCNearbyServiceAdvertiser!
    var mcBrowser: MCBrowserViewController?
    //MARK: -Delegates
    weak var conectedDelegate : PeerConectedProtocol?
    weak var disconectedProtocol: PeerDisconectedProtocol?
    //MARK: -Initializer
    override init() {
        super.init()
         setupConnectivity()
         setupHostSession()
    }
    //MARK: - Configure Peer Connection
    func setupConnectivity() {
        if mcSession != nil {
            mcSession.disconnect()
        }
        let name = Defaults.userName
        peerID = MCPeerID(displayName: name)
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .none)
        mcSession.delegate = self
    }
    
    func setupHostSession() {
        mcAdvertiserAssistant = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: "ba-td")
        mcAdvertiserAssistant.delegate = self
    }
    //MARK: - MCBrowser
    func presentMCBrowser(from vc: UIViewController) {
        let browser = MCNearbyServiceBrowser(peer: peerID, serviceType: "ba-td")
        mcBrowser = MCBrowserViewController(browser: browser, session: mcSession)
        mcBrowser!.delegate = self
        mcBrowser!.minimumNumberOfPeers = 2
        mcBrowser!.maximumNumberOfPeers = 2
                
        mcBrowser!.modalTransitionStyle = .coverVertical
        mcBrowser!.modalPresentationStyle = .overFullScreen
        
        vc.present(mcBrowser!, animated: true)
    }
    
    //MARK: Conection & Sending
    func disconect() {
        if mcSession != nil {
            mcSession.disconnect()
        }
    }
    
    func startAdvertisingPeer() {
        mcAdvertiserAssistant.startAdvertisingPeer()
    }
    
    func stopAvertisingPeer() {
        mcAdvertiserAssistant.stopAdvertisingPeer()
    }
    
   
    
    func send(message: MessageType) {
        do {
            guard let data = try? JSONEncoder().encode(message) else { return }
            try self.mcSession.send(data, toPeers: self.mcSession.connectedPeers, with: .reliable)
        } catch {
            print(error.localizedDescription)
        }
    }
    
}

//MARK: - MCSessionDelegate
extension PeerContectionManager : MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .notConnected:
            self.disconectedProtocol?.disconected()
            print("Not connected")
        case .connecting:
            print("connecting")
        case .connected:
            DispatchQueue.main.async {
                self.mcAdvertiserAssistant.stopAdvertisingPeer()
//                guard self.mcBrowser != nil else {
//                    self.multiplayerGame()
//                    return }
                if let mcBrowser = self.mcBrowser {
                    self.browserViewControllerDidFinish(mcBrowser)
                }
                self.conectedDelegate?.connected()
            }
            print("CONNECTED")
        @unknown default:
            fatalError()
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        do {
            let message = try JSONDecoder().decode(MessageType.self, from: data)
            switch message {
            case .startGame(let score) :
                disconectedProtocol?.recieved(message: .startGame(score))
            case .gameOver(let array):
                disconectedProtocol?.recieved(message: .gameOver(array))
            case .user(let userInfo):
                disconectedProtocol?.recieved(message: .user(userInfo))
            }
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    
}
//MARK: - MCNearbyServiceAdvertiserDelegate
extension PeerContectionManager: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        invitationHandler(true, mcSession)
    }
    
    
}
//MARK: - MCBrowserViewControllerDelegate
extension PeerContectionManager: MCBrowserViewControllerDelegate {
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        if let vc = UIApplication.getTopViewController() {
            vc.dismiss(animated: true) {
                self.conectedDelegate?.connected()
            }
        }
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        if let vc = UIApplication.getTopViewController() {
            vc.dismiss(animated: true) {
//                self.conectedDelegate?.connected()
            }
        }
    }
    
    
}


