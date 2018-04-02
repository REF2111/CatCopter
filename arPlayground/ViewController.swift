//
//  ViewController.swift
//  arPlayground
//
//  Created by Raphael-Alexander Berendes on 31.03.18.
//  Copyright © 2018 Raphael-Alexander Berendes. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate, AATKitDelegate {
    
    let drone = Drone()
    @IBOutlet var sceneView: ARSCNView!
    
    @IBOutlet weak var buttonForward: UIButton!
    @IBOutlet weak var buttonBackwards: UIButton!
    @IBOutlet weak var buttonLeft: UIButton!
    @IBOutlet weak var buttonRight: UIButton!
    @IBOutlet weak var buttonUp: UIButton!
    @IBOutlet weak var buttonDown: UIButton!
    @IBOutlet weak var buttonTurnLeft: UIButton!
    @IBOutlet weak var buttonTurnRight: UIButton!
    
    let kMovingLengthPerLoop: CGFloat = 0.03
    let kAnimationDurationMoving = 0.75
    let kRotationRadianPerLoop: CGFloat = 0.05
    
    @IBOutlet weak var bannerView: UIView!
    var loadedBanner = UIView()
    var bannerPlacement = NSObject()
    
    var player : AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAddApptr()
        setupScene()
        setupConfiguration()
        addDrone()
        configureMovementButtons()
    }
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "Meow", withExtension: "mp3") else {
            print("Sound Not Found")
            return
        }
        do {
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue) // Hier wird versucht (try), den AVAudioPlayer zu initialisieren
            guard let player = player else { // Hier wird geguckt, ob das der Player nach dem Initialisieren nil ist. Wenn ja, dann return
                print("Player Couldn't Be Set Up")
                return
            }
            player.play()
        } catch let error { // Hier wird glaube ich auf das Initialisieren des Players reagiert
            print(error.localizedDescription)
        }
    }
    
    func setupAddApptr() {
        let aatConfiguration = AATConfiguration()
        aatConfiguration.defaultViewController = self
        aatConfiguration.delegate = self
        //aatConfiguration.testModeAccountID = 154
        aatConfiguration.initialRules = ["BANNER;DFP;1;100;/57201580/AddApptr_TestBanner;;",
                                         "BANNER;REVMOB;1;100;Banner:582af8440286c86c750f6e0b:582b0b0d4833f4ed43ef352c;;",
                                         "BANNER;INMOBI;1;100;4028cba630724cd901316c8192b30f33;;",
                                         "BANNER;CRITEO;1;100;AddApptr - DE - CHB - InAppLiteGames_CrazyEightsFREE_Android_phone_320x50:938894;;"]
        
        AATKit.initialize(with: aatConfiguration)
        bannerPlacement = AATKit.createPlacement(withName: "BannerPlacement", andType: AATKitAdType.banner320x53) as! NSObject
        AATKit.setPlacementAlign(AATKitBannerAlign.center, for: bannerPlacement as! AATKitPlacement)
        AATKit.startPlacementAutoReload(bannerPlacement as! AATKitPlacement)
    }
    
    func setupScene() {
        let scene = SCNScene()
        sceneView.scene = scene
    }
    
    func setupConfiguration() {
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    func addDrone() {
        drone.loadModel()
        sceneView.scene.rootNode.addChildNode(drone)
    }
    
    func configureMovementButtons() {
        let buttonForwardLongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.moveForward(_:)))
        buttonForwardLongPressGestureRecognizer.minimumPressDuration = 0.0
        buttonForward.addGestureRecognizer(buttonForwardLongPressGestureRecognizer)
        
        let buttonBackwardsLongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.moveBackwards(_:)))
        buttonBackwardsLongPressGestureRecognizer.minimumPressDuration = 0.0
        buttonBackwards.addGestureRecognizer(buttonBackwardsLongPressGestureRecognizer)
        
        let buttonLeftLongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.moveLeft(_:)))
        buttonLeftLongPressGestureRecognizer.minimumPressDuration = 0.0
        buttonLeft.addGestureRecognizer(buttonLeftLongPressGestureRecognizer)
        
        let buttonRightLongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.moveRight(_:)))
        buttonRightLongPressGestureRecognizer.minimumPressDuration = 0.0
        buttonRight.addGestureRecognizer(buttonRightLongPressGestureRecognizer)
        
        let buttonUpLongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.moveUp(_:)))
        buttonUpLongPressGestureRecognizer.minimumPressDuration = 0.0
        buttonUp.addGestureRecognizer(buttonUpLongPressGestureRecognizer)
        
        let buttonDownLongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.moveDown(_:)))
        buttonDownLongPressGestureRecognizer.minimumPressDuration = 0.0
        buttonDown.addGestureRecognizer(buttonDownLongPressGestureRecognizer)
        
        let buttonTurnLeftLongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.turnLeft(_:)))
        buttonTurnLeftLongPressGestureRecognizer.minimumPressDuration = 0.0
        buttonTurnLeft.addGestureRecognizer(buttonTurnLeftLongPressGestureRecognizer)
        
        let buttonTurnRightLongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.turnRight(_:)))
        buttonTurnRightLongPressGestureRecognizer.minimumPressDuration = 0.0
        buttonTurnRight.addGestureRecognizer(buttonTurnRightLongPressGestureRecognizer)
        
    }
    
    @objc func moveForward(_ sender: UILongPressGestureRecognizer) {
        let x = -deltas().sin
        let z = -deltas().cos
        moveDrone(x: x, z: z, sender: sender)    }
    
    @objc func moveBackwards(_ sender: UILongPressGestureRecognizer) {
        let x = deltas().sin
        let z = deltas().cos
        moveDrone(x: x, z: z, sender: sender)    }
    
    @objc func moveLeft(_ sender: UILongPressGestureRecognizer) {
        let x = -deltas().cos
        let z = deltas().sin
        moveDrone(x: x, z: z, sender: sender)
    }
    
    @objc func moveRight(_ sender: UILongPressGestureRecognizer) {
        let x = deltas().cos
        let z = -deltas().sin
        moveDrone(x: x, z: z, sender: sender)    }
    
    @objc func moveUp(_ sender: UILongPressGestureRecognizer) {
        let moveUpAction = SCNAction.moveBy(x: 0, y: kMovingLengthPerLoop, z: 0, duration: kAnimationDurationMoving)
        execute(action: moveUpAction, sender: sender)
    }
    
    @objc func moveDown(_ sender: UILongPressGestureRecognizer) {
        let moveDownAction = SCNAction.moveBy(x: 0, y: -kMovingLengthPerLoop, z: 0, duration: kAnimationDurationMoving)
        execute(action: moveDownAction, sender: sender)
    }
    
    @objc func turnLeft(_ sender: UILongPressGestureRecognizer) {
        rotateDrone(yRadian: kRotationRadianPerLoop, sender: sender)
    }
    
    @objc func turnRight(_ sender: UILongPressGestureRecognizer) {
        rotateDrone(yRadian: -kRotationRadianPerLoop, sender: sender)
    }
    
    func execute(action: SCNAction, sender: UILongPressGestureRecognizer) {
        let loopAction = SCNAction.repeatForever(action)
        drone.runAction(loopAction)
        if (sender.state == .began) {
            playSound()
        } else if (sender.state == .ended) {
            drone.removeAllActions()
        }
    }
    
    func moveDrone(x: CGFloat, z: CGFloat, sender: UILongPressGestureRecognizer) {
        let action = SCNAction.moveBy(x: x, y: 0, z: z, duration: kAnimationDurationMoving)
        execute(action: action, sender: sender)
    }
    
    func rotateDrone(yRadian: CGFloat, sender: UILongPressGestureRecognizer) {
        let action = SCNAction.rotateBy(x: 0, y: yRadian, z: 0, duration: kAnimationDurationMoving)
        execute(action: action, sender: sender)
    }
    
    func deltas() -> (sin: CGFloat, cos: CGFloat) {
        return (sin: kMovingLengthPerLoop * CGFloat(sin(drone.eulerAngles.y)), cos: kMovingLengthPerLoop * CGFloat(cos(drone.eulerAngles.y)))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    func aatKitHaveAd(_ placement: AATKitPlacement) {
        loadedBanner = AATKit.getPlacementView(bannerPlacement as! AATKitPlacement)!
        bannerView.addSubview(loadedBanner)
    }
    
}
