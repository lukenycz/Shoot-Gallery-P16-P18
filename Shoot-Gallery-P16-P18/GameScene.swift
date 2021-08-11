//
//  GameScene.swift
//  Shoot-Gallery-P16-P18
//
//  Created by Łukasz Nycz on 11/08/2021.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var gameTimer: Timer? = nil
    var targetGood: SKSpriteNode!
    var targetBad: SKSpriteNode!
    var background: SKSpriteNode!
    
    var timeLeftLabel: SKLabelNode!
    var scoreLabel: SKLabelNode!
    var endGameLabel: SKLabelNode!
    
    var timeLeft = 1 {
        didSet {
            timeLeftLabel.text = "Timeleft: \(timeLeft)"
        }
    }

    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
   
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        
        score = 0
        
        timeLeftLabel = SKLabelNode(fontNamed: "Chalkduster")
        timeLeftLabel?.position = CGPoint(x: 16, y: 730)
        timeLeftLabel?.horizontalAlignmentMode = .left
        
        addChild(timeLeftLabel)
        
        timeLeft = 20
        
        endGameLabel = SKLabelNode(fontNamed: "Chalkduster")
        endGameLabel.position = CGPoint(x: 512, y: 384)
        endGameLabel.horizontalAlignmentMode = .center
        endGameLabel.isHidden = true
        endGameLabel.fontColor = .systemRed
        
        addChild(endGameLabel)
        
        
        gameTimer?.invalidate()
        gameTimer = Timer.scheduledTimer(timeInterval: Double.random(in: 0.5...5.0), target: self, selector: #selector(createTargetBad), userInfo: nil, repeats: true)
        gameTimer = Timer.scheduledTimer(timeInterval: Double.random(in: 0.5...5.0), target: self, selector: #selector(createTargetGood), userInfo: nil, repeats: true)
        
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(endGame), userInfo: nil, repeats: true)
       
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
    }
    
    func stopTimer() {
        guard gameTimer != nil else {return}
        gameTimer?.invalidate()
        gameTimer = nil
    }
    
    @objc func endGame() {
        
        let nodes:SKNode = self
        timeLeft -= 1
        
        if timeLeft <= 0 {
            let frontground = SKSpriteNode(color: .gray, size: CGSize(width: 3000, height: 3000))
            frontground.alpha = 0.99
            frontground.zPosition = 3
            addChild(frontground)
            endGameLabel.isHidden = false
            endGameLabel.text = "Your score is: \(score)"
            endGameLabel.zPosition = 4
            isUserInteractionEnabled = false
    
            //self.view?.isPaused = true
            stopTimer()
            nodes.removeAllActions()
            removeAllActions()
            physicsWorld.speed = 0
            
            
            
        }
    }
    
    @objc func createTargetBad() {
        
        let random = Int.random(in: 16...200)
        let targetBad = SKSpriteNode(imageNamed: "ballRed")
        targetBad.size = CGSize(width: random, height: random)
        targetBad.name = "targetBad"
        targetBad.position = CGPoint(x: Int.random(in: 50...736), y: Int.random(in: 50...736))

        
        
        addChild(targetBad)
        
        targetBad.physicsBody?.categoryBitMask = 1
        targetBad.physicsBody?.velocity = CGVector(dx: -500, dy: 300)
        targetBad.physicsBody?.angularVelocity = 5
        targetBad.physicsBody?.linearDamping = 5
        targetBad.physicsBody?.angularDamping = 5
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: Int.random(in: 50...200), y: Int.random(in: 50...200)))
        let followLine = SKAction.follow(path, speed: CGFloat(Int.random(in: 50...200)))
        
        let reversedLine = followLine.reversed()
              
        let square = UIBezierPath(rect: CGRect(x: 0,y: 0, width: Int.random(in: 50...200), height: Int.random(in: 50...200)))
        let followSquare = SKAction.follow(square.cgPath, asOffset: true, orientToPath: false, speed: CGFloat(Int.random(in: 120...700)))
              
        let circle = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: Int.random(in: 50...200), height: Int.random(in: 50...200)), cornerRadius: 100)
        let followCircle = SKAction.follow(circle.cgPath, asOffset: true, orientToPath: false, speed: CGFloat(Int.random(in: 120...700)))
        
        targetBad.run(
                SKAction.sequence([
                    followLine,
                    reversedLine,
                    followSquare,
                    followCircle,
                    SKAction.wait(forDuration: 1.0),
                    SKAction.removeFromParent()
                ])
            )
    }
    @objc func createTargetGood() {
        let random = Int.random(in: 16...200)
        
        let targetGood = SKSpriteNode(imageNamed: "ballGreen")
        targetGood.size = CGSize(width: random, height: random)
        targetGood.name = "targetGood"
        targetGood.position = CGPoint(x: Int.random(in: 50...736), y: Int.random(in: 50...736))

        addChild(targetGood)
        
        targetGood.physicsBody?.categoryBitMask = 1
        targetGood.physicsBody?.velocity = CGVector(dx: -500, dy: 300)
        targetGood.physicsBody?.angularVelocity = 5
        targetGood.physicsBody?.linearDamping = 5
        targetGood.physicsBody?.angularDamping = 5
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: Int.random(in: 50...200), y: Int.random(in: 50...200)))
        let followLine = SKAction.follow(path, speed: CGFloat(Int.random(in: 120...700)))
        
        let reversedLine = followLine.reversed()
              
        let square = UIBezierPath(rect: CGRect(x: 0,y: 0, width: Int.random(in: 50...200), height: Int.random(in: 50...200)))
        let followSquare = SKAction.follow(square.cgPath, asOffset: true, orientToPath: false, speed:CGFloat(Int.random(in: 120...700)))
                      
        let circle = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: Int.random(in: 50...200), height: Int.random(in: 50...200)), cornerRadius: CGFloat(Int.random(in: 50...200)))
        let followCircle = SKAction.follow(circle.cgPath, asOffset: true, orientToPath: false, speed: CGFloat(Int.random(in: 120...700)))
        
        targetGood.run(
                SKAction.sequence([
                    followLine,
                    reversedLine,
                    followSquare,
                    followCircle,
                    SKAction.wait(forDuration: 1.0),
                    SKAction.removeFromParent()
                ])
            )
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{

            let location = touch.location(in: self)
            let node:SKNode = self.atPoint(location)

                if(node.name == "targetGood"){
                    
                    node.removeFromParent()
                    score += 10
                    if node.xScale < 64 || node.yScale < 64 {
                        score += 20
                    }
                    
                } else if (node.name == "targetBad") {
                    node.removeFromParent()
                    score -= 20
                    if node.xScale > 32 || node.yScale > 32 {
                        score -= 40
                    }
                }
            }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
}
