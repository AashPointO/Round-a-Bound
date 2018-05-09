//
//  LeaderBoard.swift
//  Circle Press
//
//  Created by Aashir Farooqi on 4/4/18.
//  Copyright © 2018 Aashir Farooqi. All rights reserved.
//

import Foundation
import SpriteKit
import Firebase

func UploadRank(ranking: Int, score: Int, name: String) {
    var currentRankIndex = ranking - 1
    let nameTruncated = name.prefix(15)
    var newRankee = Rankee(name: String(nameTruncated) , score: score)
    var tempRankee = rankees[currentRankIndex]
    
    while currentRankIndex < 5 {
        rankees[currentRankIndex] = newRankee
        currentRankIndex += 1
        if currentRankIndex < 5 {
            newRankee = tempRankee
            tempRankee = rankees[currentRankIndex]
        }
    }
    
    PushToServer()
    
}

func PushToServer() {
   
    for i in 0...4 {
        let namePath = "Highscores/" + String(i+1) + "/name"
        let scorePath = "Highscores/" + String(i+1) + "/score"
        ref.database.reference().child(namePath).setValue(rankees[i].name)
        ref.database.reference().child(scorePath).setValue(rankees[i].score!)
        
    }
}

public var rankings = Analytics()
var rankees = Array(repeating: Rankee(), count: 5)

struct Rankee: Codable {
    var name = ""
    var score: Int?
}

func RefreshRankings() {
    //  ref.database.reference().child("Highscores/1/name").setValue("Aash")
    
    for i in 0...4 {
        
        let namePath = "Highscores/" + String(i+1) + "/name"
        let scorePath = "Highscores/" + String(i+1) + "/score"
        
        ref.database.reference().child(namePath).observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            rankees[i].name = snapshot.value as! String
            print(rankees[i].name)
        })
        ref.database.reference().child(scorePath).observeSingleEvent(of: DataEventType.value, with:  { (snapshot) in
            rankees[i].score = snapshot.value as! Int
            print(rankees[i].score)
            
        })
        
    }
}

class LeaderBoard: SKScene {
    
    
    public var lastScene: SKScene?
    
    private var labelTop: SKLabelNode?
    private var back: SKShapeNode?
    private var refresh: SKShapeNode?
    private var labelsScore = Array(repeating: SKLabelNode(), count: 5)
    private var labelsName = Array(repeating: SKLabelNode(), count: 5)
    
    
   
    
    func uploadRank(person: Rankee) -> Bool {
        
        return false
    }
    
    
    override func didMove(to view: SKView) {
        
        ReLoad()
        DismissKeyboard()
        
        let background = SKSpriteNode(imageNamed: "BG.png")
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.size = self.size
        background.zPosition = -5
        self.addChild(background)
        
        labelTop = SKLabelNode(text: "Rankings")
        labelTop?.fontName = UIFont(name: "BlobSpongeyLowercase", size: 250)?.familyName
        labelTop?.fontSize = CGFloat(250)
        labelTop?.position = CGPoint(x: self.size.width/2, y: self.size.height * (3.25/4))
        self.addChild(labelTop!)
        
        let labelGlobally = SKLabelNode(text: "(Globally)")
        labelGlobally.fontName = UIFont(name: "BlobSpongeyLowercase", size: 50)?.familyName
        labelGlobally.fontSize = CGFloat(150)
        labelGlobally.position = CGPoint(x: self.size.width/2, y: (labelTop?.position.y)! - 200)
        self.addChild(labelGlobally)
        
        back = SKShapeNode(circleOfRadius: 150)
        back?.position = CGPoint(x: self.size.width * (0.95/5), y: self.size.height * (1/7))
        back?.fillTexture = SKTexture(imageNamed: "GreensymCol 2.jpg")
        back?.glowWidth = 5
        back?.fillColor = UIColor(displayP3Red: 0.2, green: 0.2, blue: 1, alpha: 0.5)
        let backIcon = SKSpriteNode(imageNamed: "back.png")
        backIcon.size = CGSize(width: 100, height: 100)
        back?.addChild(backIcon)
        self.addChild(back!)
        
        refresh = SKShapeNode(circleOfRadius: 150)
        refresh?.position = CGPoint(x: self.size.width * (4.05/5), y: self.size.height * (1/7))
        refresh?.fillTexture = SKTexture(imageNamed: "GreensymCol 2.jpg")
        refresh?.glowWidth = 5
        refresh?.fillColor = UIColor(displayP3Red: 0.2, green: 0.5, blue: 1, alpha: 0.5)
        let refreshIcon = SKSpriteNode(imageNamed: "RefreshIcon.png")
        refreshIcon.size = CGSize(width: 100, height: 100)
        refresh?.addChild(refreshIcon)
        self.addChild(refresh!)
        
        var numLabels = Array(repeating: SKLabelNode(), count: 5)
        
        for i in 0...4 {
            
            let yPos = (labelTop?.position.y)! - 450 - (CGFloat(i) * (150))
            
            numLabels[i] = SKLabelNode(text: String(i+1) + ": ")
            numLabels[i].fontName = UIFont(name: "BlobSpongeyLowercase", size: 75)?.familyName
            numLabels[i].fontSize = CGFloat(75)
            numLabels[i].position = CGPoint(x: self.size.width/4.5, y: yPos)
            
            var score = 0
            if rankees[i].score != nil {
                score = rankees[i].score!
            }
            
            labelsScore[i] = SKLabelNode(text: String(score))
            labelsScore[i].fontName = UIFont(name: "BlobSpongeyLowercase", size: 75)?.familyName
            labelsScore[i].fontSize = CGFloat(75)
            labelsScore[i].position = CGPoint(x: self.size.width * (1.7/4), y: yPos)
            
            labelsName[i] = SKLabelNode(text: String(rankees[i].name))
            labelsName[i].fontName = UIFont(name: "BlobSpongeyLowercase", size: 75)?.familyName
            labelsName[i].fontSize = CGFloat(75)
            labelsName[i].position = CGPoint(x: self.size.width * (3/4), y: yPos)
            
            self.addChild(numLabels[i])
            self.addChild(labelsScore[i])
            self.addChild(labelsName[i])
            
        }
        
        let localHighScore = defaults.value(forKey: "highscore")
        if localHighScore != nil {
            let localScore = SKLabelNode(fontNamed: UIFont(name: "BlobSpongeyLowercase", size: 75)?.familyName)
            localScore.fontSize = 125
            localScore.position.y = (back?.position.y)! + 0.625 * (labelsName[4].position.y - (back?.position.y)!)
            localScore.position.x = self.size.width/2
            
            localScore.text = "(Locally) "
            
            let localNumScore = SKLabelNode(fontNamed: UIFont(name: "BlobSpongeyLowercase", size: 75)?.familyName)
            localNumScore.fontSize = 125
            localNumScore.position.y = localScore.position.y - 250
            localNumScore.position.x = self.size.width/2
            var sc = localHighScore!
            localNumScore.text = String(describing: sc)
            
            self.addChild(localScore)
            self.addChild(localNumScore)
        }
        
       
        
        ReLoad()
        
    }
    
    private var frameCount = 0
    
    override func update(_ currentTime: TimeInterval) {
        frameCount += 1
        if Int(frameCount) == 50  {
            print("refresshing at: " + String(frameCount))
            ReLoad()
        }
        
        
    }
    
    func ReLoad() {
        RefreshRankings()
        for i in 0...4 {
            
            var score = 0
            if rankees[i].score != nil {
                score = rankees[i].score!
            }
             labelsScore[i].text = String(score)
             labelsName[i].text  = String(rankees[i].name)
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let t = touch.location(in: self)
            if back!.contains(t) {
                let wait = SKAction.wait(forDuration: 0.25)
                back!.run(pressedAction)
                if (lastScene != nil) {
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
            } else if refresh!.contains(t) {
                refresh!.run(pressedAction)
                refresh!.run(SKAction.rotate(byAngle: -PI, duration: 0.20))
                ReLoad()
                }
            }
        }
}

