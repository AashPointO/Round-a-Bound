//
//  GameScene.swift
//  Circle Press
//
//  Created by Aashir Farooqi on 3/15/18.
//  Copyright © 2018 Aashir Farooqi. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

let emojiList = ["EmojiHand.png", "EmojiNoLegal.png", "EmojiO.png", "ShrugEmojiLegal.png", "WomHiLegal.png"]
let monkeyList = ["MonkeyYes.png", "MonkeyNo.png", "MonkeySpeakNot.png"]
let PI = CGFloat(3.1415)

  let pressedAction =  SKAction.sequence([SKAction.scale(to: 1.075, duration: 0.0825), SKAction.scale(to: 1, duration: 0.125), SKAction.scale(to: 0.95, duration: 0.1), SKAction.scale(to: 1, duration: 0.085)])



let defaults = UserDefaults.standard

class PlayerCircle  {
    var state: CircleState = CircleState.still
    var circleNode =  SKShapeNode(circleOfRadius: 250)
}

class CircleBound {
    var lowerBound: SKShapeNode?
    var upperBound: SKShapeNode?
}

enum CircleState {
    case still
    case growing
    case shrinking
}

class ButtonIcon {
    var shapeNode: SKShapeNode?
    var iconNode: SKSpriteNode?
    init(color: UIColor, iconName: String) {
        shapeNode = SKShapeNode(circleOfRadius: 90)
        shapeNode?.fillTexture = SKTexture(imageNamed: "GreensymCol 2.jpg")
        shapeNode?.fillColor = color
        shapeNode?.glowWidth = 5
        iconNode = SKSpriteNode(imageNamed: iconName)
        iconNode?.size = CGSize(width: 100, height: 100)
        shapeNode?.addChild(iconNode!)
    }
    init(color: UIColor, iconName: String, radius: CGFloat, gWidth: CGFloat) {
        shapeNode = SKShapeNode(circleOfRadius: radius)
        shapeNode?.fillTexture = SKTexture(imageNamed: "GreensymCol 2.jpg")
        shapeNode?.fillColor = color
        shapeNode?.glowWidth = gWidth
        iconNode = SKSpriteNode(imageNamed: iconName)
        iconNode?.size = CGSize(width: radius/2, height: radius/2)
        shapeNode?.addChild(iconNode!)
    }
    func AddTo(scene: SKScene){
        scene.addChild(shapeNode!)
    }
}


class GameScene: SKScene {
    
    private var isGameRunning = true
    
    let steadyGrowShrinkSequence = SKAction.sequence([SKAction.scale(to: 1.025, duration: 0.25), SKAction.scale(to: 1, duration: 0.25), SKAction.scale(to: 0.975, duration: 0.25), SKAction.scale(to: 1, duration: 0.25)])
    
    let shake = SKAction.sequence([SKAction.rotate(byAngle: -0.2, duration: 0.075), SKAction.rotate(byAngle: 0.4, duration: 0.15), SKAction.rotate(byAngle: -0.2, duration: 0.075), SKAction.rotate(byAngle: -0.1, duration: 0.075/2), SKAction.rotate(byAngle: 0.1, duration: 0.075/2)])

    
    private var points = 0
    private var lastUpdateTime: TimeInterval = 0
    private var gameObject = PlayerCircle.init()
    private var smallerCircle: CircleBound?
    private var largerCircle: CircleBound?
    
    private var homeButton: ButtonIcon?
    private var settingsButton: ButtonIcon?
    private var rankingsButton: ButtonIcon?
    private var infoButton: ButtonIcon?
    
    private var bigCircle = SKShapeNode(circleOfRadius: 450)
    private var smallCircle = SKShapeNode(circleOfRadius: 100)
    
    private var isChangingSize = false
    
    private var upperLineSweetSpot = SKSpriteNode(color: UIColor.clear, size: CGSize(width: 5.0, height: 100))
    private var lowerLineSweetSpot = SKSpriteNode(color: UIColor.clear, size: CGSize(width: 5.0, height: 105))
    private var midDeathZone = SKSpriteNode(color: UIColor.clear, size: CGSize(width: 15.0, height: 240))
    private var upperDeathBound = SKSpriteNode(color: UIColor.clear, size: CGSize(width: 100.0, height: 15))
    
    private var label = SKLabelNode(text: "Click to Start!")
    
    

    func FadeAllOut(){
        
        let fadeOut = SKAction.fadeOut(withDuration: 0.5)
        let scaleEnlarge = SKAction.scale(by: 1.2, duration: 0.5)
        
        bigCircle.run(scaleEnlarge)
        largerCircle?.lowerBound?.run(scaleEnlarge)
        largerCircle?.upperBound?.run(scaleEnlarge)
        bigCircle.run(fadeOut)
        largerCircle?.lowerBound?.run(fadeOut)
        largerCircle?.upperBound?.run(fadeOut)
        
        smallCircle.run(scaleEnlarge)
        smallerCircle?.lowerBound?.run(scaleEnlarge)
        smallerCircle?.upperBound?.run(scaleEnlarge)
        smallCircle.run(fadeOut)
        smallerCircle?.lowerBound?.run(fadeOut)
        smallerCircle?.upperBound?.run(fadeOut)
        
        gameObject.circleNode.run(scaleEnlarge, withKey: "press")
        gameObject.circleNode.run(fadeOut)
   
    }
    
    func MoveToLostScene(finalScore: Int) {
        
        FadeAllOut()

        let lostScene = LostScene(size: SCENE_SIZE)
        lostScene.score = finalScore
        lostScene.scaleMode = .aspectFill
        
        let wait = SKAction.wait(forDuration: 0.5)
        let action = SKAction.run {
                self.scene?.view?.presentScene(lostScene, transition: SKTransition.crossFade(withDuration: TRANSITION_TIME))
        }
        
        self.run(SKAction.sequence([wait, action]))
        
    }
    
    func MoveToStartScene(){
        FadeAllOut()
        let startScene = StartScene(size: SCENE_SIZE)
        startScene.scaleMode = .aspectFill
        
        let wait = SKAction.wait(forDuration: 0.5)
        let action = SKAction.run {
            self.scene?.view?.presentScene(startScene, transition: SKTransition.crossFade(withDuration: TRANSITION_TIME))
        }
        
        self.run(SKAction.sequence([wait, action]))
    }
    
    func MoveToRankingsScene() {
        FadeAllOut()
        let leaderBoardScene = LeaderBoard(size: SCENE_SIZE)
        leaderBoardScene.lastScene = GameScene()
        leaderBoardScene.scaleMode = .aspectFill
        
        let wait = SKAction.wait(forDuration: 0.5)
        let action = SKAction.run {
            self.scene?.view?.presentScene(leaderBoardScene, transition: SKTransition.crossFade(withDuration: TRANSITION_TIME))
        }
        
        self.run(SKAction.sequence([wait, action]))
    }
    
    func MoveToSettingsScene() {
        FadeAllOut()
        let settingsScene = SettingsScene(size: SCENE_SIZE)
        settingsScene.lastScene = GameScene()
        settingsScene.scaleMode = .aspectFill
        
        let wait = SKAction.wait(forDuration: 0.5)
        let action = SKAction.run {
            self.scene?.view?.presentScene(settingsScene, transition: SKTransition.crossFade(withDuration: TRANSITION_TIME))
        }
        
        self.run(SKAction.sequence([wait, action]))
    }
    
    override func didMove(to view: SKView) {
        self.lastUpdateTime = 0
        
        if defaults.value(forKey: "highscore") == nil || ((defaults.value(forKey: "highscore") as! Int) < 6) {
            infoToggle()
        }
        
        let background = SKSpriteNode(imageNamed: "BG.png")
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.size = self.size
        background.zPosition = -5
        self.addChild(background)
    
    // Following allows for background music to play through sounds
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
        } catch is Error {
            print("nil")
        }
        
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        } catch is Error {
            print("nil")
        }
        
        
        self.addChild(gameObject.circleNode)
        
        bigCircle.position = CGPoint(x: self.size.width/2, y: self.size.height/3)
        
        let CircleTexture = SKTexture(imageNamed: "PurpGradPS.png")
       
        
      
        bigCircle.strokeTexture = CircleTexture
        bigCircle.fillColor = SKColor.clear
        bigCircle.lineWidth = 100
        bigCircle.run(SKAction.repeatForever(SKAction.rotate(byAngle: 2*3.1415, duration: 45)))
        self.addChild(bigCircle)
        
        
        smallCircle.position = CGPoint(x: self.size.width/2, y: self.size.height/3)
        
        smallCircle.strokeTexture = CircleTexture
        smallCircle.fillColor = SKColor.clear
        smallCircle.lineWidth = 100
        smallCircle.run(SKAction.repeatForever(SKAction.rotate(byAngle: -2*3.1415, duration: 45)))
        self.addChild(smallCircle)
        
     
        

        gameObject.circleNode.position = CGPoint(x: self.size.width / 2, y: self.size.height/3)
        gameObject.circleNode.glowWidth = 1.5
        
        gameObject.circleNode.strokeTexture = SKTexture(imageNamed: "GreenYellow.jpg")
        gameObject.circleNode.lineWidth = 5
        gameObject.circleNode.zPosition = 4
        
        
        
        
        gameObject.circleNode.run(SKAction.repeatForever(steadyGrowShrinkSequence), withKey: "press")
        
        lowerLineSweetSpot.position = CGPoint(x: self.size.width / 2, y: self.size.height/2.64)
        self.addChild(lowerLineSweetSpot)
        
        midDeathZone.position = CGPoint(x: self.size.width / 2, y: lowerLineSweetSpot.position.y + lowerLineSweetSpot.size.height*1.575)
        self.addChild(midDeathZone)
        
        upperLineSweetSpot.position = CGPoint(x: self.size.width / 2, y: midDeathZone.position.y*1.175)
        self.addChild(upperLineSweetSpot)
        
        upperDeathBound.position = CGPoint(x: self.size.width / 2, y: upperLineSweetSpot.position.y * 1.045)
        self.addChild(upperDeathBound)
    
        
        label.position = CGPoint(x: self.size.width / 2, y: self.size.height/1.675)
        label.fontName = UIFont(name: "BlobSpongeyLowercase", size: 250)?.familyName
        label.fontSize = 150.0
        
        self.addChild(label)
        
        
        
        
        smallerCircle = CircleBound.init()
        
        smallerCircle?.lowerBound = SKShapeNode.init(circleOfRadius: 50.0)
        smallerCircle?.upperBound = SKShapeNode.init(circleOfRadius: 150.0)
        smallerCircle?.lowerBound?.zPosition = 4

        smallerCircle?.upperBound?.zPosition = 3
        smallerCircle?.lowerBound?.position = CGPoint(x: self.size.width / 2, y: self.size.height/3)
        smallerCircle?.upperBound?.position = CGPoint(x: self.size.width / 2, y: self.size.height/3)
        smallerCircle?.lowerBound?.glowWidth = 2.5
        smallerCircle?.upperBound?.glowWidth = 2.5
       
        largerCircle = CircleBound.init()
        
        largerCircle?.lowerBound = SKShapeNode.init(circleOfRadius: 400.0)
        largerCircle?.upperBound = SKShapeNode.init(circleOfRadius: 500.0)
        largerCircle?.lowerBound?.zPosition = 2
        largerCircle?.upperBound?.zPosition = 2
        
      
        largerCircle?.lowerBound?.position = CGPoint(x: self.size.width / 2, y: self.size.height/3)
        largerCircle?.upperBound?.position = CGPoint(x: self.size.width / 2, y: self.size.height/3)
        largerCircle?.lowerBound?.glowWidth = 2.5
        largerCircle?.upperBound?.glowWidth = 2.5
        
        self.addChild((smallerCircle?.lowerBound)!)
        self.addChild((smallerCircle?.upperBound)!)
        self.addChild((largerCircle?.upperBound)!)
        self.addChild((largerCircle?.lowerBound)!)
        
        let buttonHeights = self.size.height * (5.5/7.05)
        
        homeButton = ButtonIcon(color: UIColor(red: 0, green: 100, blue: 50, alpha: 0.5), iconName: "homeIcon.png")
        homeButton?.shapeNode?.position = CGPoint(x: self.size.width * (1.9/4), y: buttonHeights)
        homeButton?.AddTo(scene: self)
        
        settingsButton = ButtonIcon(color: UIColor(red: 100, green: 100, blue: 50, alpha: 0.5), iconName: "SettingsIcon.png")
        settingsButton?.shapeNode?.position = CGPoint(x: self.size.width * (2.7/4), y: buttonHeights)
        settingsButton?.AddTo(scene: self)
        
        rankingsButton = ButtonIcon(color: UIColor(red: 25, green: 25, blue: 100, alpha: 0.5), iconName: "LeaderBoardIcon.png")
        rankingsButton?.shapeNode?.position = CGPoint(x: self.size.width * (3.5/4), y: buttonHeights)
        rankingsButton?.AddTo(scene: self)
        
        infoButton = ButtonIcon(color: UIColor(red: 100, green: 50, blue: 100, alpha: 0.5), iconName: "info.png", radius: 175, gWidth: 5)
       
        infoButton?.shapeNode?.position = CGPoint(x: self.size.width*(0.8/4), y: buttonHeights)
        infoButton?.AddTo(scene: self)

        infoBack.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        infoBack.size = CGSize(width: 1000, height: 1600)
        infoBack.zPosition = 100
        
        infoBack.scale(to: CGSize(width:1, height: 1))
        
        xOut.shapeNode!.position = CGPoint(x: -500, y: 775)
        xOut.shapeNode!.zPosition = 101
        
        infoBack.addChild(xOut.shapeNode!)
        
        
        for i in 0...2 {
            infoText[i].fontSize = 75
            infoText[i].position = CGPoint(x: 0, y: infoBack.size.height + 550 - CGFloat(i * 100))
            infoText[i].fontName = UIFont(name: "BlobSpongeyLowercase", size: 250)?.familyName
            infoText[i].zPosition = 102
            infoBack.addChild(infoText[i])
        }
    
        referenceBigCircle.fillColor = UIColor.clear
        referenceSmallCircle.fillColor = UIColor.clear
        referenceBigCircle.lineWidth = 70
        referenceSmallCircle.lineWidth = 70
        
        referenceUpperBound.upperBound = SKShapeNode(circleOfRadius: 435)
        referenceUpperBound.lowerBound = SKShapeNode(circleOfRadius: 365)
        
        referenceUpperBound.upperBound!.zPosition = 102
        referenceUpperBound.lowerBound!.zPosition = 10
        referenceUpperBound.upperBound!.position = CGPoint(x: 0, y: -200)
        referenceUpperBound.lowerBound!.position = CGPoint(x: 0, y: -200)
        
        referenceUpperBound.upperBound!.fillColor = UIColor.clear
        referenceUpperBound.lowerBound!.fillColor = UIColor.clear
        referenceUpperBound.upperBound!.strokeColor = UIColor.white
        referenceUpperBound.lowerBound!.strokeColor = UIColor.white
        
        referenceUpperBound.lowerBound!.glowWidth = 2.25
        referenceUpperBound.upperBound!.glowWidth = 2.25
        
        referenceLowerBound.upperBound = SKShapeNode(circleOfRadius: 170)
        referenceLowerBound.lowerBound = SKShapeNode(circleOfRadius: 105)
        
        referenceLowerBound.upperBound!.zPosition = 102
        referenceLowerBound.lowerBound!.zPosition = 102
        referenceLowerBound.upperBound!.position = CGPoint(x: 0, y: -200)
        referenceLowerBound.lowerBound!.position = CGPoint(x: 0, y: -200)
        
        referenceLowerBound.upperBound!.fillColor = UIColor.clear
        referenceLowerBound.lowerBound!.fillColor = UIColor.clear
        referenceLowerBound.upperBound!.strokeColor = UIColor.white
        referenceLowerBound.lowerBound!.strokeColor = UIColor.white
        
        referenceLowerBound.lowerBound!.glowWidth = 2.25
        referenceLowerBound.upperBound!.glowWidth = 2.25
        
        referenceBigCircle.position = CGPoint(x: 0, y: -200)
        referenceSmallCircle.position = CGPoint(x: 0, y: -200)
        
        referenceBigCircle.zPosition = 102
        referenceSmallCircle.zPosition = 102
        
        referenceBigCircle.strokeTexture = SKTexture(imageNamed: "PurpGradPS.png")
        referenceSmallCircle.strokeTexture = SKTexture(imageNamed: "PurpGradPS.png")
        
        referenceGamNode.run(SKAction.repeatForever(growEnlarge))
        referenceGamNode.glowWidth = 5
        referenceGamNode.strokeColor = UIColor.green
        referenceGamNode.position = CGPoint(x: 0, y: -200)
        referenceGamNode.zPosition = 103
        
       
        
        infoBack.addChild(referenceGamNode)
        infoBack.addChild(referenceBigCircle)
        infoBack.addChild(referenceSmallCircle)
        infoBack.addChild(referenceUpperBound.upperBound!)
        infoBack.addChild(referenceUpperBound.lowerBound!)
        infoBack.addChild(referenceLowerBound.upperBound!)
        infoBack.addChild(referenceLowerBound.lowerBound!)
    }
    
    private let growEnlarge = SKAction.sequence([SKAction.scale(to: 2, duration: 0.35), SKAction.scale(to: 0.6, duration: 0.5), SKAction.scale(to: 1, duration: 0.15)])
    private let referenceGamNode = SKShapeNode(circleOfRadius: 200)
    private let referenceBigCircle = SKShapeNode(circleOfRadius: 400)
    private let referenceSmallCircle = SKShapeNode(circleOfRadius: 400/3)
    private let referenceUpperBound = CircleBound()
    private let referenceLowerBound = CircleBound()
    
    private let infoText = [SKLabelNode(text: "Tap the screen when the"), SKLabelNode(text: "green circle is in one of"), SKLabelNode(text: "the purple areas!")]
    private let infoBack = SKSpriteNode(imageNamed: "BG-Light.png")
    private var infoState = false
    private let xOut = ButtonIcon(color: UIColor.red, iconName: "x.png", radius: 75, gWidth: 5)
    private var infoTransition = false
    
    func infoToggle(){
        print(infoState)
        
       
        
        switch infoState {
        case false:
            infoTransition = true
            print("addingChild")
            self.addChild(infoBack)
            infoBack.run(SKAction.sequence([SKAction.scale(to: 1.05, duration: 0.25), SKAction.scale(to: 0.95, duration: 0.1), SKAction.scale(to: 1, duration: 0.05)]))
            infoState = true
            
            let wait = SKAction.wait(forDuration: 0.51)
            let action = SKAction.run {
                self.infoTransition = false
            }
            self.run(SKAction.sequence([wait, action]))
            
            
            return;
         
        case true:
            infoBack.run(SKAction.sequence([SKAction.scale(to: 1.05 , duration: 0.1), SKAction.scale(to: CGSize(width: 1, height: 1), duration: 0.2)]))
           
            infoTransition = true
            let wait = SKAction.wait(forDuration: 0.31)
            let action = SKAction.run {
                 print("removingChild")
                 self.infoBack.removeFromParent()
                 self.infoTransition = false
            }
            self.run(SKAction.sequence([wait, action]))
            infoState = false
            
            return;
        }
        
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let t = touch.location(in: self)
            if !infoState && !infoTransition {
                if (homeButton?.shapeNode?.contains(t))! {
                    homeButton?.shapeNode?.run(SKAction.sequence([SKAction.scale(to: 1.25, duration: 0.05),         SKAction.scale(to: 1, duration: 0.15), SKAction.scale(to: 0.85, duration: 0.125), SKAction.scale(to: 1, duration: 0.125)]))
                        MoveToStartScene()
                
                } else if (settingsButton?.shapeNode?.contains(t))! {
                    settingsButton?.shapeNode?.run(SKAction.sequence([SKAction.scale(to: 1.25, duration: 0.05),         SKAction.scale(to: 1, duration: 0.15), SKAction.scale(to: 0.85, duration: 0.125), SKAction.scale(to: 1, duration: 0.125)]))
                    MoveToSettingsScene()
                
                
                } else if (rankingsButton?.shapeNode?.contains(t))! {
                    rankingsButton?.shapeNode?.run(SKAction.sequence([SKAction.scale(to: 1.25, duration: 0.05),         SKAction.scale(to: 1, duration: 0.15), SKAction.scale(to: 0.85, duration: 0.125), SKAction.scale(to: 1, duration: 0.125)]))
                    MoveToRankingsScene()
                
                } else if (infoButton?.shapeNode?.contains(t))! {
                    if !infoTransition {
                        infoButton?.shapeNode?.run(SKAction.sequence([SKAction.scale(to: 1.25, duration: 0.05),     SKAction.scale(to: 1, duration: 0.15), SKAction.scale(to: 0.85, duration: 0.125), SKAction.scale(to: 1, duration: 0.125)]))
                        infoToggle()
                    }
                
                } else if  !HitMiddle() && !gameObject.circleNode.intersects(upperDeathBound) && gameObject.circleNode.intersects(lowerLineSweetSpot) && isGameRunning {
               
                    EnlargeShrink()
                    points = points + 1
                    label.text = String(points)
                
                } else {
                    isGameRunning = false
                    if soundState {
                        run(SKAction.playSoundFileNamed("Ohh.m4a", waitForCompletion: false))
                    }
                    MoveToLostScene(finalScore: points)
                }
            } else {
                if !infoTransition {
                    print("else")
                    infoToggle()
                }
            }
        }
        
    }
    
    private var frameCount = 0
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
       
        
    
        if gameObject.state != CircleState.still {
        if gameObject.circleNode.intersects(upperDeathBound) && !isChangingSize {
            if isGameRunning {
                if soundState {
                    run(SKAction.playSoundFileNamed("Ohh.m4a", waitForCompletion: false))
                }
                MoveToLostScene(finalScore: points)
                isGameRunning = false
            }
            
        }
        
        if !gameObject.circleNode.intersects(lowerLineSweetSpot) {
            if isGameRunning && !isChangingSize {
                if soundState {
                    run(SKAction.playSoundFileNamed("Ohh.m4a", waitForCompletion: false))
                }
                MoveToLostScene(finalScore: points)
                isGameRunning = false
            }
        }
        
        } else { // GAME HASN'T STARTED
            if (frameCount % 200 == 0) {
                //print(frameCount)
                infoButton?.shapeNode?.run(steadyGrowShrinkSequence)
                infoButton?.shapeNode?.run(shake)
            }
        }
        
        frameCount += 1
        
        self.lastUpdateTime = currentTime
    }
    
    func HitMiddle() -> Bool {
        if gameObject.state == CircleState.still {
            return false
        } else if gameObject.circleNode.intersects(midDeathZone) && !gameObject.circleNode.intersects(upperLineSweetSpot){
            return true
        } else {
            return false
        }
       
    }
    
    func getRandMonkEmoji() -> SKSpriteNode {
        let randNum = arc4random() % 3
        let emojiName = monkeyList[Int(randNum)]
        let xRand = CGFloat(arc4random() % 1300) + 200
        let yRand = CGFloat(arc4random() % 1750) + 250
        
        let monkeySprite = SKSpriteNode(imageNamed: emojiName)
        
        monkeySprite.position = CGPoint(x: xRand, y: yRand)
        monkeySprite.zPosition = 5
        monkeySprite.size = CGSize(width: 1, height: 1)
        
        return monkeySprite
        
    }
    
    func getRandEmoji() -> SKSpriteNode {
        
        let randNum = arc4random() % 5
        let emojiName = emojiList[Int(randNum)]
        let xRand = CGFloat(arc4random() % 1400) + 50
        let yRand = CGFloat(arc4random() % 2000) + 20
        
        let sprite = SKSpriteNode(imageNamed: emojiName)
        
        sprite.position = CGPoint(x: xRand, y: yRand)
        sprite.zPosition = 5
        sprite.size = CGSize(width: 1, height: 1)
        
        return sprite
    }
                        
    func EmojiAppear() {
        var rotScale = CGFloat(arc4random() % 4)
        rotScale = rotScale / PI
        let rotSeq = SKAction.sequence([SKAction.rotate(byAngle: rotScale * PI/4, duration: 0.15), SKAction.rotate(byAngle: rotScale * -PI/4, duration: 0.15)])
        
        if points % 10 == 0 {
            let monkeySprite = getRandMonkEmoji()
            
            self.addChild(monkeySprite)
            //monkeySprite.run(SKAction.rotate(byAngle: PI/6, duration: 0.0))
            let randScale = CGFloat(250 + arc4random() % 200)
            
            let seq1 = SKAction.sequence([SKAction.scale(to: randScale, duration: 0.35)])
            monkeySprite.run(seq1)
            
            var randDx = CGFloat(arc4random() % 400 + 200)
            var randDy = CGFloat(arc4random() % 500 + 400)
           
            let rand = Int(arc4random() % 7)
            if rand % 3 == 0 {
                randDx = -randDx
            }
            if rand % 2 == 0 {
                randDy = -randDy
            }
            
            
            let vec = CGVector(dx: randDx, dy: randDy)
            let vecNeg = CGVector(dx: -randDx, dy: -randDy)
            
            monkeySprite.run(SKAction.repeatForever(SKAction.sequence([SKAction.move(by: vec, duration: 2), SKAction.move(by: vecNeg, duration: 2)])))
           
            monkeySprite.run(SKAction.repeatForever(rotSeq))
            
        } else {
        let emojiSprite = getRandEmoji()
        self.addChild(emojiSprite)
        let randScale = CGFloat(100 + arc4random() % 250)
         let seq = SKAction.sequence([SKAction.scale(to: randScale, duration: 0.35), SKAction.scale(to: 0, duration: 0.35), SKAction.fadeOut(withDuration: 0.0)])
        
        emojiSprite.run(seq)
        emojiSprite.run(rotSeq)
        
        }
        
    }
    func EnlargeShrink() {
        
       
        
        var scaleFactor = Double(points) * 0.005
        if scaleFactor >= 0.45 {
            scaleFactor = 0.45
        }
        let enlarge = SKAction.scale(to: 2.2, duration: 0.775 - scaleFactor)
        let shrink = SKAction.scale(to: 0.0, duration: 0.75 - scaleFactor)
        
       
        
        let state: CircleState = (gameObject.state)
        if isGameRunning{
        switch state {
        case .still:
            if soundState {
                run(SKAction.playSoundFileNamed("Bloop.m4a", waitForCompletion: false))
            }
            gameObject.circleNode.run(enlarge)
            gameObject.state = CircleState.growing
            break;
        case .growing:
            if emojiState {
                EmojiAppear()
            }
            if soundState {
                run(SKAction.playSoundFileNamed("Beep.m4a", waitForCompletion: false))
            }
            gameObject.circleNode.run(shrink)
            gameObject.state = CircleState.shrinking
            largerCircle?.upperBound?.run(pressedAction)
            largerCircle?.lowerBound?.run(pressedAction)
            bigCircle.run(pressedAction)
            
            isChangingSize = true
            
            let wait = SKAction.wait(forDuration: 0.01)
            let action = SKAction.run {
                self.isChangingSize = false
            }
            self.run(SKAction.sequence([wait, action]))
            
            
            break;
        default:
            if gameObject.circleNode.intersects(lowerLineSweetSpot){
                if emojiState {
                    EmojiAppear()
                }
                if soundState {
                    run(SKAction.playSoundFileNamed("Bloop.m4a", waitForCompletion: false))
                }
                gameObject.circleNode.run(enlarge)
                gameObject.state = CircleState.growing
                smallerCircle?.upperBound?.run(pressedAction)
                smallerCircle?.lowerBound?.run(pressedAction)
                smallCircle.run(pressedAction)
                
                isChangingSize = true
                
                let wait = SKAction.wait(forDuration: 0.01)
                let action = SKAction.run {
                   self.isChangingSize = false
                }
                self.run(SKAction.sequence([wait, action]))
                
                break;
            }
        }
    }
}
}



