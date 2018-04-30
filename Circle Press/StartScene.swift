//
//  StartScene.swift
//  Circle Press
//
//  Created by Aashir Farooqi on 3/27/18.
//  Copyright © 2018 Aashir Farooqi. All rights reserved.
//

import SpriteKit

let TRANSITION_TIME = 0.5



class Button {
    var shapeNode: SKShapeNode?
    var labelNode: SKLabelNode?
    var iconNode: SKSpriteNode?
    init(){
        
    }
    init(radius: CGFloat, position: CGPoint, label: String, texture: SKTexture){
        shapeNode = SKShapeNode.init(circleOfRadius: radius)
        labelNode = SKLabelNode.init(text: label)
        shapeNode?.position = position
        shapeNode?.fillColor = UIColor.white
        shapeNode?.fillTexture = texture
        labelNode?.position = CGPoint(x: 0, y: -75)
        shapeNode?.addChild(labelNode!)
        labelNode!.fontSize = CGFloat(230)
        labelNode!.fontName = UIFont.boldSystemFont(ofSize: 25).familyName
        shapeNode!.glowWidth = 5
        
    }
    
    init(radius: CGFloat, position: CGPoint, iconName: String, texture: SKTexture, size: CGSize){
        shapeNode = SKShapeNode.init(circleOfRadius: radius)
        iconNode = SKSpriteNode(imageNamed: iconName)
        shapeNode?.position = position
        shapeNode?.fillColor = UIColor.white
        shapeNode?.fillTexture = texture
        iconNode?.position = CGPoint(x: 0, y: 0)
        shapeNode?.addChild(iconNode!)
        iconNode!.size = size
        shapeNode!.glowWidth = 5
        
    }
    
    func AddTo(scene: SKScene){
        scene.addChild(shapeNode!)
        
    }
    
    func RunStillAction(){
            let steadyGrowShrinkSequence = SKAction.sequence([SKAction.scale(to: 1.04, duration: 0.275), SKAction.scale(to: 1, duration: 0.275), SKAction.scale(to: 0.99, duration: 0.5), SKAction.scale(to: 1, duration: 0.5)])
        self.shapeNode!.run(SKAction.repeatForever(steadyGrowShrinkSequence), withKey: "play")
    }
    
    func DoesContain(point: CGPoint) -> Bool {
        return (self.shapeNode?.contains(point))!
    }
    
}

let roundText = SKLabelNode(text: "Round")
let aText = SKLabelNode(text: "a")
let boundText = SKLabelNode(text: "Bound")

class StartScene: SKScene {
    
    func FadeAllOut(){
        playButton?.shapeNode?.run(SKAction.fadeOut(withDuration: TRANSITION_TIME))
        settingsButton?.shapeNode?.run(SKAction.fadeOut(withDuration: TRANSITION_TIME))
        rankingsButton?.shapeNode?.run(SKAction.fadeOut(withDuration: TRANSITION_TIME))
    }
    
    let wait = SKAction.wait(forDuration: TRANSITION_TIME)
    
    private var startShape: SKShapeNode?
    
    private var playButton: Button?
    private var settingsButton: Button?
    private var rankingsButton: Button?
    private var playLabel = SKLabelNode(text: "Play")
    private var playPNG: SKSpriteNode?
    
    
    private var aBackCircle: SKShapeNode?
    
    override func didMove(to view: SKView) {
        
        RefreshRankings()
        
        let background = SKSpriteNode(imageNamed: "BG.png")
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.size = self.size
        background.zPosition = -5
        self.addChild(background)
    
       
        
        roundText.position = CGPoint(x: self.size.width * (1.25/3), y: self.size.height * (4/5.1))
        roundText.fontName = UIFont(name: "BlobSpongeyLowercase", size: 250)?.familyName
        roundText.fontSize = CGFloat(250)
        self.addChild(roundText)
        
        boundText.position = CGPoint(x: self.size.width * (1.75/3), y: self.size.height * (3/5.25))
        boundText.fontName = UIFont(name: "BlobSpongeyLowercase", size: 250)?.familyName
        boundText.fontSize = CGFloat(250)
        self.addChild(boundText)
        
        aText.position = CGPoint(x: 0, y: -65)
        aText.fontName = UIFont(name: "BlobSpongeyLowercase", size: 250)?.familyName
        aText.fontSize = CGFloat(250)
        
        aBackCircle = SKShapeNode(circleOfRadius: 105)
        aBackCircle?.position = CGPoint(x: self.size.width/2 + 15, y: 0.5 * (roundText.position.y + boundText.position.y) + 65)
        aBackCircle?.addChild(aText)
        aBackCircle?.glowWidth = 5
        aBackCircle?.fillColor = UIColor(red: 5, green: 1, blue: 1, alpha: 0.5)
        aBackCircle?.fillTexture = SKTexture(imageNamed: "GreensymCol 2.jpg")
        
        
        self.addChild(aBackCircle!)
        aText.run(SKAction.repeatForever(SKAction.sequence([SKAction.scale(to: 1.01, duration: 0.25), SKAction.scale(to: 1.00, duration: 0.25), SKAction.scale(to: 0.99, duration: 0.25), SKAction.scale(to: 1, duration: 0.25)])))
        
        
    
        playButton = Button(radius: 275, position: CGPoint(x: self.size.width/3.25, y: self.size.height/2.35), iconName: "play.png", texture: SKTexture(imageNamed: "GreensymCol 2.jpg"), size: CGSize(width: 600, height: 600))
        
        playButton?.shapeNode?.fillColor = UIColor(red: 0, green: 1, blue: 1, alpha: 1)
     
        settingsButton = Button(radius: 250, position: CGPoint(x: self.size.width * (2.95/4) , y: self.size.height / 3.5), iconName: "SettingsIcon.png", texture: SKTexture(imageNamed: "GreensymCol 2.jpg"), size: CGSize(width: 450, height: 450))
        
        settingsButton?.AddTo(scene: self)
        settingsButton?.RunStillAction()
        settingsButton?.labelNode?.fontSize = CGFloat(125)
        settingsButton?.labelNode?.position = CGPoint(x: 0, y: -40)
        settingsButton?.shapeNode?.fillColor = UIColor(red: 1, green: 0, blue: 1, alpha: 1)
        playButton?.AddTo(scene: self)
        let lAction = SKAction.run {
            self.playButton?.RunStillAction()
        }
        self.run(SKAction.sequence([wait, lAction]))
    
        rankingsButton = Button(radius: 200, position: CGPoint(x: self.size.width/3.5 , y: self.size.height/6 - 5), iconName: "LeaderBoardIcon.png", texture: SKTexture(imageNamed: "GreensymCol 2.jpg"), size: CGSize(width: 200, height: 200))
    
        rankingsButton?.AddTo(scene: self)
       
        rankingsButton?.labelNode?.fontSize = CGFloat(75)
        rankingsButton?.labelNode?.position = CGPoint(x: 0, y: -25)
        rankingsButton?.shapeNode?.fillColor = UIColor(red: 0.3, green: 0.2, blue: 1, alpha: 1)
        let action = SKAction.run {
            self.rankingsButton?.RunStillAction()
        }
         self.run(SKAction.sequence([wait, action]))
        
        
        
       
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
         let pressedAction =  SKAction.sequence([SKAction.scale(to: 1.15, duration: 0.0825), SKAction.scale(to: 1, duration: 0.125), SKAction.scale(to: 0.95, duration: 0.1), SKAction.scale(to: 1, duration: 0.085)])
        
        
        for touch in touches {
            let t = touch.location(in: self)
           
            // PLAY BUTTON
            if (playButton?.shapeNode?.contains(t))! {
                let gameScene = GameScene(size: SCENE_SIZE)
                gameScene.scaleMode = .aspectFill
                
                let action = SKAction.run {
                     self.scene?.view?.presentScene(gameScene, transition: SKTransition.crossFade(withDuration: TRANSITION_TIME))
                }
                
                let shake = SKAction.sequence([SKAction.rotate(byAngle: PI/24, duration: TRANSITION_TIME/4), SKAction.rotate(byAngle: -PI/12, duration: TRANSITION_TIME/2), SKAction.rotate(byAngle: PI/24, duration: TRANSITION_TIME/4)])
                
                FadeAllOut()
                playButton?.shapeNode?.run(pressedAction)
                playButton?.iconNode?.run(shake)
                self.run(SKAction.sequence([wait, action]))
                
            } else if (settingsButton?.shapeNode?.contains(t))! {
                
                
                let settingsScene = SettingsScene(size: SCENE_SIZE)
                settingsScene.lastScene = StartScene()
                settingsScene.scaleMode = .aspectFill
                let action = SKAction.run {
                   // self.scene?.view?.presentScene(settingsScene, transition: SKTransition.crossFade(withDuration: TRANSITION_TIME))
                    self.scene?.view?.presentScene(settingsScene, transition: SKTransition.crossFade(withDuration: TRANSITION_TIME))
                }
                let seqRot = SKAction.sequence([SKAction.rotate(byAngle: PI*(1.5/4), duration: 0.2)])
                
                FadeAllOut()
                settingsButton?.shapeNode?.run(seqRot)
                settingsButton?.shapeNode?.run(pressedAction)
                self.run(SKAction.sequence([wait, action]))
                
                
                
            } else if (rankingsButton?.shapeNode?.contains(t))! {
                rankingsButton?.shapeNode?.run(pressedAction)
            
                let leaderScene = LeaderBoard(size: SCENE_SIZE)
                
                leaderScene.scaleMode = .aspectFill
                
                let action = SKAction.run {
                    self.scene?.view?.presentScene(leaderScene, transition: SKTransition.crossFade(withDuration: TRANSITION_TIME))
                }
                 self.run(SKAction.sequence([wait, action]))
                
                
            }
        }
    }
}
