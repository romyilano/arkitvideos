//
//  ViewController.swift
//  ARKitTest2
//
//  Created by Romy Ilano on 12/10/17.
//  Copyright © 2017 Romy Ilano. All rights reserved.
//

import UIKit
import SceneKit
//import SpriteKit // you don't have to import spriteKit if you have scenekit or arkit? interesting
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    let videoURL = URL(string: "https://devstreaming-cdn.apple.com/videos/wwdc/2017/602pxa6f2vw71ze/602/602_sd_introducing_arkit_augmented_reality_for_ios.mp4")
    struct AspectRatio {
        static let width: CGFloat = 320
        static let height: CGFloat = 240
    }
    let AspectDiv: CGFloat = 1000
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
        
        createAVPlayerStuff()
    }
    
    // thanks andrew turkin - > https://github.com/AndrewTurkin/ARKitVideo.git
    func createAVPlayerStuff() {
        // create AVPlayer
        let player = AVPlayer(url: videoURL!)
        // place AVPlayer on SKVideoNode
        let playerNode = SKVideoNode(avPlayer: player)
        // flip video upside down
        playerNode.yScale = -1
        
        // create SKScene and set player node on it
        let spriteKitScene = SKScene(size: CGSize(width: AspectRatio.width, height: AspectRatio.height))
        spriteKitScene.scaleMode = .aspectFit
        playerNode.position = CGPoint(x: spriteKitScene.size.width/2, y: spriteKitScene.size.height/2)
        playerNode.size = spriteKitScene.size
        spriteKitScene.addChild(playerNode)
        
        // create 3D SCNNode and set SKScene as a material
        let videoNode = SCNNode()
        videoNode.geometry = SCNPlane(width: 0.2, height: 0.1)
        videoNode.geometry?.firstMaterial?.diffuse.contents = spriteKitScene
        videoNode.geometry?.firstMaterial?.isDoubleSided = true
        // place SCNNode inside ARKit 3D coordinate space
        videoNode.position = SCNVector3(x: 0, y: 0, z: -0.5)
        
        // create a new scene
        let scene = SCNScene()
        scene.rootNode.addChildNode(videoNode)
        // set the scene to the view
        sceneView.scene = scene
        playerNode.play()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
