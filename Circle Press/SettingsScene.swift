//
//  SettingsScene.swift
//  Circle Press
//
//  Created by Aashir Farooqi on 4/1/18.
//  Copyright © 2018 Aashir Farooqi. All rights reserved.
//

import SpriteKit
import AVFoundation

var emojiState = false
var soundState = false


class SettingsScene: SKScene {

    public var lastScene: SKScene?
    
    let pressedAction =  SKAction.sequence([SKAction.scale(to: 1.15, duration: 0.0825), SKAction.scale(to: 1, duration: 0.125), SKAction.scale(to: 0.95, duration: 0.1), SKAction.scale(to: 1, duration: 0.085)])
    
    private var emojiSwitch: toggleSwitch?
    private var soundSwitch: toggleSwitch?
    private var settingsLabel: SKLabelNode?
    private var emojiLabel: SKLabelNode?
    private var volumeLabel: SKLabelNode?
    private var back: SKShapeNode?
    private var about: SKShapeNode?
    private var rectAnchor: SKShapeNode?
    private var resetScore: Button?
    
    override func didMove(to view: SKView) {
        
        
        let background = SKSpriteNode(imageNamed: "BG.png")
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.size = self.size
        background.zPosition = -5
        self.addChild(background)
        
        do {    // allows music in background
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
        } catch is Error {
            print("nil")
        }
        
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        } catch is Error {
            print("nil")
        }
        
        let interval: CGFloat = 300
        rectAnchor = SKShapeNode(circleOfRadius: 0)
        rectAnchor!.position = CGPoint(x: self.size.width/2 - 25, y: 125)
    
        
        about = SKShapeNode(rect: CGRect(x: self.size.width/2 - 25, y: 125, width: 450, height: 200), cornerRadius: 0)
        about!.fillTexture = SKTexture(imageNamed: "GreensymCol 2.jpg")
        about!.fillColor = UIColor.yellow
        about!.glowWidth = 5
        
        
        let aboutLabel = SKLabelNode(text: "About")
        aboutLabel.fontSize = CGFloat(125)
        aboutLabel.fontName = UIFont(name: "BlobSpongeyLowercase", size: 250)?.familyName
        //aboutLabel.fontName = UIFont.boldSystemFont(ofSize: 15).familyName
        aboutLabel.position = CGPoint(x: 970, y: 185)
        
        
            self.addChild(rectAnchor!)
        
        
        back = SKShapeNode(circleOfRadius: 150)
        back?.position = CGPoint(x: self.size.width * (1.1/5), y: self.size.height * (1/7))
        back?.fillTexture = SKTexture(imageNamed: "GreensymCol 2.jpg")
        back?.glowWidth = 5
        back?.fillColor = UIColor(displayP3Red: 0.2, green: 0.2, blue: 1, alpha: 0.5)
        let backIcon = SKSpriteNode(imageNamed: "back.png")
        backIcon.size = CGSize(width: 100, height: 100)
        back?.addChild(backIcon)
        self.addChild(back!)
        
        settingsLabel = SKLabelNode(text: "Settings")
        settingsLabel?.fontName = UIFont(name: "BlobSpongeyLowercase", size: 250)?.familyName
        settingsLabel!.fontSize = CGFloat(200)
      
        settingsLabel!.position = CGPoint(x: self.size.width/2, y: self.size.height - 350)
        self.addChild(settingsLabel!)
        
        emojiLabel = SKLabelNode(text: "Emojis")
        emojiLabel!.fontSize = CGFloat(125)
        
        emojiLabel?.fontName = UIFont(name: "BlobSpongeyLowercase", size: 250)?.familyName
        emojiLabel!.position = CGPoint(x: self.size.width/3 - 15, y: self.size.height - 2*interval - 40)
        self.addChild(emojiLabel!)
        
        volumeLabel = SKLabelNode(text: "Volume")
        volumeLabel!.fontSize = CGFloat(125)
        
        volumeLabel?.fontName = UIFont(name: "BlobSpongeyLowercase", size: 250)?.familyName
        volumeLabel!.position = CGPoint(x: self.size.width/3, y: self.size.height - 3*interval - 40)
        self.addChild(volumeLabel!)
        
        
        emojiSwitch = toggleSwitch(scene: self, state: emojiState, onImage: "EmojiO.png", offImage: "EmojiNoLegal.png", y: self.size.height - 2*interval)
        emojiSwitch!.AddTo(scene: self)
        
        soundSwitch = toggleSwitch(scene: self, state: soundState, onImage: "Volume.png", offImage: "VolOff.png", y: self.size.height - 3*interval)
        soundSwitch!.AddTo(scene: self)
        
        resetScore = Button(radius: 175, position: CGPoint(x: self.size.width - (back?.position.x)!, y: (back?.position.y)! ), label: "Reset Score", texture: SKTexture(imageNamed: "RedGrad.png"))
        resetScore?.labelNode?.fontSize = 55
        resetScore?.labelNode?.position.y = -10
        resetScore?.labelNode?.fontName = UIFont(name: "BlobSpongeyLowercase", size: 15)?.familyName
        resetScore?.AddTo(scene: self)
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let t = touch.location(in: self)
            if (emojiSwitch!.anchor!.contains(t)) {
                if !emojiState  {
                    if soundState {
                        run(SKAction.playSoundFileNamed("Bloop.m4a", waitForCompletion: false))
                         AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                    } else {
                        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                    }
                } else { // true
                    AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                }
                emojiSwitch!.toggle(state: &emojiState )
            } else if (soundSwitch?.anchor!.contains(t))! {
                if !soundState {
                    run(SKAction.playSoundFileNamed("Beep.m4a", waitForCompletion: false))
                     AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                } else { // true
                    AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                }
                soundSwitch!.toggle(state: &soundState)
            } else if (about!.contains(t)){
                about!.run(SKAction.rotate(byAngle: 2 * PI, duration: 6))
                
            } else if (back!.contains(t)) {
                let wait = SKAction.wait(forDuration: 0.25)
                
                back!.run(pressedAction)
                if (lastScene != nil){
                    let backScene = lastScene
                    backScene?.size = SCENE_SIZE
                    backScene?.scaleMode = .aspectFill
                    let action = SKAction.run {
                        self.scene?.view?.presentScene(backScene!, transition: SKTransition.crossFade(withDuration: TRANSITION_TIME))
                    }
                    self.run(SKAction.sequence([wait, action]))
                } else {
                    let startScene = StartScene(size: SCENE_SIZE)
                    startScene.scaleMode = .aspectFill
                    let action = SKAction.run {
                        self.scene?.view?.presentScene(startScene, transition: SKTransition.crossFade(withDuration: TRANSITION_TIME))
                    }
                    self.run(SKAction.sequence([wait, action]))
                }
            } else if (resetScore!.shapeNode?.contains(t))! {
                resetScore!.shapeNode?.run(pressedAction)
                defaults.setValue(nil, forKey: "highscore")
            }
        }
    }

    
    
    class toggleSwitch {
        var redBack: SKSpriteNode?
        var greenBack: SKSpriteNode?
        var anchor: SKSpriteNode?
        var circleToggle: SKShapeNode?
        var icon: SKSpriteNode?
        var onName: String?
        var offName: String?
        
        init(scene: SKScene, state: Bool, onImage: String, offImage: String, y: CGFloat){
            
            onName = onImage
            offName = offImage
            
            anchor = SKSpriteNode(color: UIColor.clear, size: CGSize(width: 1, height: 1))
            redBack = SKSpriteNode(imageNamed: "ToggleBackHalf.png")
            greenBack = SKSpriteNode(imageNamed: "ToggleBackHalf.png")
            circleToggle = SKShapeNode(circleOfRadius: 100)
            circleToggle?.fillColor = UIColor.white
            if state {
                circleToggle?.position = CGPoint(x: 75, y: 0)
                circleToggle?.fillTexture = SKTexture(imageNamed: "GreenGrad.png")
                icon = SKSpriteNode(imageNamed: onImage)
                
            } else {
                circleToggle?.position = CGPoint(x: -70, y: 0)
                
                circleToggle?.fillTexture = SKTexture(imageNamed: "RedGrad.png")
                icon = SKSpriteNode(imageNamed: offImage)
            }
            circleToggle?.glowWidth = 5
            
            icon?.size = CGSize(width: 125, height: 125)
            
            
            anchor?.position = CGPoint(x: scene.size.width*(3/4.25 ),y: y )
            anchor?.color = UIColor.clear
            redBack?.size = CGSize(width: 250/1.5, height: 125)
            greenBack?.size = CGSize(width: 250/1.5, height: 125)
            redBack?.color = UIColor.red
            greenBack?.color = UIColor.yellow
            
            redBack?.position = CGPoint(x: -90, y: 0)
            greenBack?.position = CGPoint(x: 90, y: 3)
            
            greenBack?.run(SKAction.rotate(byAngle: PI, duration: 0))
            
            circleToggle!.zPosition = 3
            circleToggle?.addChild(icon!)
            
            anchor?.addChild(circleToggle!)
            anchor?.addChild(redBack!)
            anchor?.addChild(greenBack!)
            
        }
        
        func AddTo(scene: SKScene){
            scene.addChild(anchor!)
        }
        
        func toggle(state: UnsafeMutablePointer<Bool>){
            
            let dx: CGFloat = 75
            let timeFrame = 0.25
        
            
            
            let sequence = SKAction.sequence([SKAction.scale(to: 0.65, duration: timeFrame/2), SKAction.scale(to: 1.25, duration: timeFrame/2-0.05), SKAction.scale(to: 1, duration: 0.05)])
            let pressedAction =  SKAction.sequence([SKAction.scale(to: 1.15, duration: 0.0825), SKAction.scale(to: 1, duration: 0.125), SKAction.scale(to: 0.95, duration: 0.1), SKAction.scale(to: 1, duration: 0.085)])
            
            switch state.pointee {
            case true:
                circleToggle!.run(SKAction.rotate(byAngle: -PI*2, duration: timeFrame))
                
                icon!.run(sequence)
                circleToggle!.run(SKAction.moveTo(x: -dx, duration: timeFrame))
                circleToggle!.fillTexture = SKTexture(imageNamed: "RedGrad.png")
                
                circleToggle!.run(pressedAction)
                state.pointee = false;
                break;
            default:
                circleToggle!.run(SKAction.rotate(byAngle: PI*2, duration: timeFrame))
                
                circleToggle!.fillTexture = SKTexture(imageNamed: "GreenGrad.png")
                icon!.run(sequence)
                circleToggle!.run(SKAction.moveTo(x: dx, duration: timeFrame))
                
                circleToggle!.run(pressedAction)
                state.pointee = true;
            }
            
            
        }
        
    }
}
