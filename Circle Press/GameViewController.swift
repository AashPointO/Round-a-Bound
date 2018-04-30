//
//  GameViewController.swift
//  Circle Press
//
//  Created by Aashir Farooqi on 3/15/18.
//  Copyright © 2018 Aashir Farooqi. All rights reserved.
//
import UIKit
import SpriteKit
import GameplayKit
import Firebase
import FirebaseDatabase


var ref: DatabaseReference!

var SCENE_SIZE = CGSize(width: 1600, height: 2662.4)


class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CheckPhoneSize()
        
        ref = Database.database().reference()
    
        let scene = StartScene(size: SCENE_SIZE)
        
        let skView = self.view as! SKView
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .aspectFill
       
        
        skView.presentScene(scene)
        
    }
    
    func CheckPhoneSize() {
        
        
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 2436:
                SCENE_SIZE = CGSize(width: 1200, height: 2436)
                print("iPhone X")
                break;
            default:
                SCENE_SIZE = CGSize(width: 1280, height: 2436)
                
            }
        }
    }
    
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
}
