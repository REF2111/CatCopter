//
//  Drone.swift
//  arPlayground
//
//  Created by Raphael-Alexander Berendes on 31.03.18.
//  Copyright © 2018 Raphael-Alexander Berendes. All rights reserved.
//

import UIKit
import SceneKit

class Drone: SCNNode {
    
    func loadModel() {
        guard let virtualObjectScene = SCNScene(named: "art.scnassets/Cat/Cat.scn") else {
            print("3D model not found")
            return
        }
        let wrapperNode = SCNNode()
        for child in virtualObjectScene.rootNode.childNodes {
            wrapperNode.addChildNode(child)
        }
        addChildNode(wrapperNode)
    }
}
