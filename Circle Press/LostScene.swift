//
//  LostScene.swift
//  Circle Press
//
//  Created by Aashir Farooqi on 3/27/18.
//  Copyright © 2018 Aashir Farooqi. All rights reserved.
//

import SpriteKit
import Firebase

func DismissKeyboard() {
    keyboard?.endEditing(true)
}

 var keyboard: UITextField?

class LostScene: SKScene {
    
    let pressedAction =  SKAction.sequence([SKAction.scale(to: 1.15, duration: 0.0825), SKAction.scale(to: 1, duration: 0.125), SKAction.scale(to: 0.95, duration: 0.1), SKAction.scale(to: 1, duration: 0.085)])
    
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
        init(radius: CGFloat, position: CGPoint, iconName: String, texture: SKTexture){
            shapeNode = SKShapeNode.init(circleOfRadius: radius)
            iconNode = SKSpriteNode(imageNamed: iconName)
            iconNode?.size = CGSize(width: radius*1.35, height: radius*1.35)
            shapeNode?.position = position
            shapeNode?.fillColor = UIColor.white
            shapeNode?.fillTexture = texture
            
            shapeNode?.addChild(iconNode!)
           
            shapeNode!.glowWidth = 5
            
        }
        
    
        func AddTo(scene: SKScene){
            scene.addChild(shapeNode!)
            
        }
        
        func RunStillAction(){
           let steadyGrowShrinkSequence = SKAction.sequence([SKAction.scale(to: 1.02, duration: 0.275), SKAction.scale(to: 1, duration: 0.275), SKAction.scale(to: 0.99, duration: 0.25), SKAction.scale(to: 1, duration: 0.25)])
            self.shapeNode!.run(SKAction.repeatForever(steadyGrowShrinkSequence), withKey: "play")
        }
        
    }
    
    private var retryButton: Button?
    public var score: Int?
    private var homeButton: Button?
    private var rankingsButton: Button?
    private var settingsButton: Button?
    private var shareButton: Button?
    private var label: SKLabelNode?
    
    public var rank = -1
    private var userName = "Anonymous"
    
    func fadeAll(){
        let fadeTime = 1.0
        retryButton?.iconNode?.run(SKAction.fadeOut(withDuration: fadeTime))
        settingsButton?.iconNode?.run(SKAction.fadeOut(withDuration: fadeTime))
        rankingsButton?.iconNode?.run(SKAction.fadeOut(withDuration: fadeTime))
        shareButton?.iconNode?.run(SKAction.fadeOut(withDuration: fadeTime))
    }
    
    func GetRank() -> Int {
        if score! > rankees[0].score! {
            return 1
        } else if score! > rankees[1].score! {
            return 2
        } else if score! > rankees[2].score!  {
            return 3
        } else if score! > rankees[3].score!  {
            return 4
        } else if score! > rankees[4].score! {
            return 5
        }
        return -1
    }
    
    override func didMove(to view: SKView) {
        
       
        
        if (rankees[4].score != nil) && (score! > rankees[4].score!) {
            rank = GetRank()
        } else {
            rank = -1
        }
        
        let background = SKSpriteNode(imageNamed: "BG.png")
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.size = self.size
        background.zPosition = -5
        self.addChild(background)
        
        let labelCircle = SKShapeNode(circleOfRadius: 200)
        
        label = SKLabelNode(text: String(score!))
        label?.fontName = UIFont(name: "BlobSpongeyLowercase", size: 250)?.familyName
     
        
        if (defaults.value(forKey: "highscore") == nil) {
            defaults.set(score!, forKey: "highscore")
        } else if score! > defaults.value(forKey: "highscore") as! Int {
            defaults.setValue(score!, forKey: "highscore")
        }
        
        let highScoreLabel = SKLabelNode(text: "High Score: " + String(describing: defaults.value(forKey: "highscore")!))
         highScoreLabel.fontName = UIFont(name: "BlobSpongeyLowercase", size: 250)?.familyName
        
        label?.position = CGPoint(x: -15, y: -85)
        label?.fontSize = 250
     
        labelCircle.addChild(label!)
        labelCircle.position = CGPoint(x: self.size.width/2, y: self.size.height * (8 / 10))
        labelCircle.fillTexture = SKTexture(imageNamed: "GreensymCol 2.jpg")
        labelCircle.fillColor = UIColor.clear
        labelCircle.glowWidth = 5
        labelCircle.strokeColor = UIColor.clear
        
        self.addChild(labelCircle)
        
        let steadyGrowShrinkSequence = SKAction.sequence([SKAction.scale(to: 1.02, duration: 0.275), SKAction.scale(to: 1, duration: 0.275), SKAction.scale(to: 0.99, duration: 0.25), SKAction.scale(to: 1, duration: 0.25)])
        
        labelCircle.run(SKAction.repeatForever(steadyGrowShrinkSequence))
        
        if rank < 0 {
            highScoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height * (6 / 10))
        } else {
            highScoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height * (7 / 10))
        }
        highScoreLabel.fontSize = 150
        
        self.addChild(highScoreLabel)
        
        
        homeButton = Button.init(radius: 115, position: CGPoint(x: self.size.width/4, y: highScoreLabel.position.y * (3/4)), iconName: "homeIcon.png", texture: SKTexture(imageNamed: "GreensymCol 2.jpg"))
        homeButton?.shapeNode?.fillColor = UIColor(red: 100, green: 100, blue: 50, alpha: 0.5)
        homeButton?.AddTo(scene: self)
        
        
        settingsButton = Button.init(radius: 115, position: CGPoint(x: self.size.width/2 + (homeButton?.shapeNode!.position.x)!, y: (homeButton?.shapeNode?.position.y)!), iconName: "SettingsIcon.png", texture: SKTexture(imageNamed: "GreensymCol 2.jpg"))
        settingsButton?.iconNode?.color = UIColor.black
        settingsButton?.shapeNode?.fillColor = UIColor(red: 100, green: 50, blue: 50, alpha: 0.5)
        settingsButton?.AddTo(scene: self)
        
        
        
        
        if rank < 0 {
            retryButton = Button.init(radius: 250, position: CGPoint(x: self.size.width/2, y: highScoreLabel.position.y / 2), iconName: "undo.png", texture: SKTexture(imageNamed: "GreensymCol 2.jpg"))
        
            retryButton?.shapeNode?.fillColor = UIColor(red: 500, green: 100, blue: 200, alpha: 0.5)
            retryButton?.RunStillAction()
            
            rankingsButton = Button.init(radius: 115, position: CGPoint(x: self.size.width/4, y: highScoreLabel.position.y * (1/4)), iconName: "LeaderBoardIcon.png", texture: SKTexture(imageNamed: "GreensymCol 2.jpg"))
            rankingsButton?.shapeNode?.fillColor = UIColor(red: 100, green: 100, blue: 50, alpha: 0.5)
            
            shareButton = Button.init(radius: 115, position: CGPoint(x: (settingsButton?.shapeNode?.position.x)!, y: (rankingsButton?.shapeNode?.position.y)!), iconName: "share.png", texture: SKTexture(imageNamed: "GreensymCol 2.jpg"))
            shareButton?.shapeNode?.fillColor = UIColor(red: 100, green: 100, blue: 50, alpha: 0.5)
            shareButton?.iconNode?.position = CGPoint(x: -3, y: -5)
            
        } else {
            
            highScoreLabel.text = "New Global High Score!"
            highScoreLabel.fontSize = 100
            
            retryButton = Button.init(radius: 115, position: CGPoint(x: self.size.width/4, y: highScoreLabel.position.y * (1/4)), iconName: "undo.png", texture: SKTexture(imageNamed: "GreensymCol 2.jpg"))
            
            retryButton?.shapeNode?.fillColor = UIColor(red: 100, green: 100, blue: 50, alpha: 0.5)
            
            rankingsButton = Button.init(radius: 300, position: CGPoint(x: self.size.width/2, y: highScoreLabel.position.y / 2), label: "Publish Score", texture: SKTexture(imageNamed: "GreensymCol 2.jpg"))
            rankingsButton?.labelNode?.fontName = UIFont(name: "BlobSpongeyLowercase", size: 25)?.familyName
            rankingsButton?.labelNode?.fontSize = 75
            rankingsButton?.labelNode?.position = CGPoint(x: 0, y: -20)
            rankingsButton?.shapeNode?.fillColor = UIColor.magenta
            rankingsButton?.RunStillAction()
            
            shareButton = Button.init(radius: 115, position: CGPoint(x: (settingsButton?.shapeNode?.position.x)!, y: (retryButton?.shapeNode?.position.y)!), iconName: "share.png", texture: SKTexture(imageNamed: "GreensymCol 2.jpg"))
            shareButton?.shapeNode?.fillColor = UIColor(red: 100, green: 100, blue: 50, alpha: 0.5)
            shareButton?.iconNode?.position = CGPoint(x: -3, y: -5)
            
            PlaceKeyboard(yPos: highScoreLabel.position.y - 250)
            
        }
        
        retryButton?.AddTo(scene: self)
        rankingsButton?.AddTo(scene: self)
        shareButton?.AddTo(scene: self)
       
       
        
    }
    
    override func sceneDidLoad() {
        super.sceneDidLoad()
        keyboard?.delegate = AppDelegate().userText.delegate
        
        
    }
    
    func PlaceKeyboard(yPos: CGFloat){
      
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 2436:
                keyboard = UITextField(frame: CGRect(x: self.size.width/135, y: 275, width: 300, height: 40))
                print("iPhone X")
                break;
            default:
                keyboard = UITextField(frame: CGRect(x: self.size.width/150, y: 175, width: 300, height: 40))
                
            }
        } else {
            keyboard = UITextField(frame: CGRect(x: 220, y: 175, width: 300, height: 40))
        }
        
        
        keyboard?.placeholder = "name"
        keyboard?.tintColor = UIColor.magenta
        keyboard?.font = UIFont(name: "BlobSpongeyLowercase", size: 15)
        keyboard?.textColor = UIColor.white
        keyboard?.borderStyle = UITextBorderStyle.bezel
        keyboard?.backgroundColor = UIColor.black
        keyboard?.autocorrectionType = UITextAutocorrectionType.no
        keyboard?.keyboardType = UIKeyboardType.default
        keyboard?.textAlignment = NSTextAlignment.center
        keyboard?.attributedPlaceholder = NSAttributedString.init(string: "name")
        keyboard?.clearButtonMode = UITextFieldViewMode.whileEditing
        keyboard?.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        
        self.view?.addSubview(keyboard!)
    }
    
   
    
    func ResignKeyboard() {
        keyboard?.resignFirstResponder()
        keyboard?.removeFromSuperview()
    }

    func sharePopUp(){
        if var top = scene?.view?.window?.rootViewController {
            while let presentedViewController = top.presentedViewController {
                top = presentedViewController
            }
            var message =  "I scored " + String(score!) + " points in Round a Bound! Check the game out on the app store!"
            if score! == 1 {
                message = "I scored a single point in Round a Bound! Check the game out on the app store!"
            }
            
            let bounds = UIScreen.main.bounds
            UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0.0)
            self.view?.drawHierarchy(in: bounds, afterScreenUpdates: false)
            let img = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            let activityVC = UIActivityViewController(activityItems: [img!, message], applicationActivities: nil)
            activityVC.popoverPresentationController?.sourceView = view
            top.present(activityVC, animated: true, completion: nil)
        }
        
    }
    private var textInputOn = false
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
 
        for touch in touches {
            let t = touch.location(in: self)
                DismissKeyboard()
                if (retryButton?.shapeNode?.contains(t))! {
                        ResignKeyboard()
                        let gameScene = GameScene(size: SCENE_SIZE)
                
                        gameScene.scaleMode = .aspectFill
            
                        let wait = SKAction.wait(forDuration: 0.375)
                        let action = SKAction.run {
                            self.scene?.view?.presentScene(gameScene, transition: SKTransition.crossFade(withDuration: TRANSITION_TIME))
                        }
             
                        let rot180Left = SKAction.rotate(byAngle: CGFloat(PI) , duration: 0.25)
                        let rotRight = SKAction.rotate(byAngle: CGFloat(-PI / (15)) , duration: 0.10)
                        retryButton?.shapeNode?.run(pressedAction)
                        retryButton?.iconNode?.run(SKAction.sequence([rot180Left, rotRight]))
                        self.run(SKAction.sequence([wait, action]))
                    
                    } else if (homeButton?.shapeNode?.contains(t))! {
                        ResignKeyboard()
                        let startScene = StartScene(size: SCENE_SIZE)
                        startScene.scaleMode = .aspectFill
                
                        let wait = SKAction.wait(forDuration: 0.375)
                        let action = SKAction.run {
                            self.scene?.view?.presentScene(startScene, transition: SKTransition.crossFade(withDuration: TRANSITION_TIME))
                        }
                
                        homeButton?.shapeNode?.run(pressedAction)
                        self.run(SKAction.sequence([wait, action]))
                
                    } else if (shareButton?.shapeNode?.contains(t))! {
                
                        shareButton?.shapeNode?.run(pressedAction)
                        sharePopUp()
                
                    } else if (settingsButton?.shapeNode?.contains(t))! {
                        ResignKeyboard()
                        let settingsScene = SettingsScene(size: SCENE_SIZE)
                        settingsScene.scaleMode = .aspectFill
                       settingsScene.lastScene = self
                
                        let wait = SKAction.wait(forDuration: 0.375)
                        let action = SKAction.run {
                            self.scene?.view?.presentScene(settingsScene, transition: SKTransition.crossFade(withDuration: TRANSITION_TIME))
                        }
                
                        settingsButton?.shapeNode?.run(pressedAction)
                        settingsButton?.shapeNode?.run(SKAction.rotate(byAngle: PI / 4, duration: 0.15))
                
                
                        self.run(SKAction.sequence([wait, action]))
                        fadeAll()
                } else if (rankingsButton?.shapeNode?.contains(t))! {
                        ResignKeyboard()
                    
                        if rank > 0 {
                            userName = (keyboard?.text!)!
                            UploadRank(ranking: rank, score: score!, name: userName)
                        }
                    
                    
                        rankingsButton?.shapeNode?.run(pressedAction)
                    
                        let rankingsScene = LeaderBoard(size: SCENE_SIZE)
                        rankingsScene.scaleMode = .aspectFill
                        if rank > 0 {
                            rankingsScene.lastScene = StartScene()
                        } else {
                            rankingsScene.lastScene = self
                        }
                
                        let wait = SKAction.wait(forDuration: 0.375)
                        let action = SKAction.run {
                        self.scene?.view?.presentScene(rankingsScene, transition: SKTransition.crossFade(withDuration:  TRANSITION_TIME))
                        }
                    
                        self.run(SKAction.sequence([wait, action]))
                        fadeAll()
                  
                }
        }
    }
}
