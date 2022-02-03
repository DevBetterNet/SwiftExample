import SpriteKit

class EnemyNode: SKSpriteNode {
    var type: EnemyType
    var lastFireTime: Double = 0
    var shields: Int
    
    init(type: EnemyType, startPosition: CGPoint, xOffset: CGFloat, moveStrainght: Bool){
        self.type = type
        shields = type.shields
        
        let texture = SKTexture(imageNamed: type.name)
        super.init(texture: texture, color: .white, size: texture.size())
        
        physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
        physicsBody?.categoryBitMask = CollisionType.enemy.rawValue
        physicsBody?.collisionBitMask = CollisionType.player.rawValue | CollisionType.playerWeapon.rawValue
        physicsBody?.contactTestBitMask = CollisionType.player.rawValue | CollisionType.playerWeapon.rawValue
        name = "enemy"
        position = CGPoint(x: startPosition.x + xOffset, y: startPosition.y)
        
        configureMovement(moveStrainght)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("LOL NO")
    }
    
    func configureMovement (_ moveStraight: Bool){
        let path = UIBezierPath()
        path.move(to: .zero)
        if (moveStraight){
            path.addLine(to: CGPoint(x: -10000, y: 0))
        }
        else{
            path.addCurve(to: CGPoint(x: -3500, y: 0), controlPoint1: CGPoint(x: 0, y: -position.y*4), controlPoint2: CGPoint(x: -1000, y: -position.y))
        }
        
        let movement = SKAction.follow(path.cgPath, asOffset: true, orientToPath: true, speed: type.speed)
        
        let sequence = SKAction.sequence([movement, .removeFromParent()])
        run(sequence)
    }
    
    func fire() {
        let weapontype = "\(type.name)Weapon"
        let weapon = SKSpriteNode(imageNamed: weapontype)
        weapon.name = "enemyWeapon"
        weapon.position = position
        weapon.zRotation = zRotation;
        parent?.addChild(weapon)

        weapon.physicsBody = SKPhysicsBody(rectangleOf: weapon.size)
        weapon.physicsBody?.categoryBitMask = CollisionType.enemyWeapon.rawValue
        weapon.physicsBody?.collisionBitMask = CollisionType.player.rawValue
        weapon.physicsBody?.contactTestBitMask = CollisionType.player.rawValue
        weapon.physicsBody?.mass = 0.001
        
        let speed: CGFloat = 1
        let adjustedRatation = zRotation + (CGFloat.pi / 2)
        
        let dx = speed * cos(adjustedRatation)
        let dy = speed * sin(adjustedRatation)
        
        weapon.physicsBody?.applyImpulse(CGVector(dx: dx, dy: dy))
    }
}
