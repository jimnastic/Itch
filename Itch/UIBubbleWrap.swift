//
//  UIBubbleWrap.swift
//  Itch
//
//  Created by James May on 20/11/16.
//  Copyright © 2016 James May. All rights reserved.
//

import UIKit

class UIBubbleWrap {

    var bubbles: [UIBubble]
    var poppedCount: Int

    
    init() {
        bubbles = []
        poppedCount = 0
    }
    
    
    func addBubble(centerX: Int, centerY: Int, radius: Int, color: UIColor) -> UIView{
    //add a new bubble to the bubbleWrap
        
        let tempBubble = UIBubble(centerX: centerX, centerY: centerY, radius: radius, color: color)
        bubbles.append(tempBubble) //add bubble to bubblewrap
        return tempBubble.view
    }
   
    
    func createBubbles(screenView: UIView, screenSize: CGRect, numBubbles: Int){
    //create a bunch of bubbles and add them to the screen
        var centerX: Int
        var centerY: Int
        let radius: Int = gameSettings.bubbleRadius
        
        for _ in 1...numBubbles{
            centerX = Int(arc4random_uniform(UInt32(screenSize.width)))
            centerX -= radius
            centerY = Int(arc4random_uniform(UInt32(screenSize.height)))
            centerY -= radius
            
            screenView.addSubview(addBubble(centerX: centerX, centerY: centerY, radius: radius, color: UIColor.red))
            print("Added! Bubble count: \(count()) at \(centerX), \(centerY)")
        }
    }

    func count()->Int{
    //count of bubbles
        return bubbles.count
    }

    
    func isAllPopped()-> Bool{
    //test if all the bubbles are popped
        if count()<1 {
            return true
        } else {
            return false
        }
    }
    
    
    func reset() {
    //reset the bubblewrap
        for bubble in (bubbles) {
            deleteBubble(bubble: bubble)
        }
        poppedCount = 0
//        bubbles.removeAll()
    }

    
    func deleteBubble(bubble: UIBubble) {
        bubble.pop()
        bubble.view.removeFromSuperview()
        let index = bubbles.index(where: {$0===bubble})
        bubbles.remove(at: index!)
        print("Popped/deleted! Bubble count: \(count()). Popped bubble:\(index)")
        
    }

    
    func popBubble(bubble: UIBubble){
        deleteBubble(bubble: bubble)
        poppedCount += 1
    }
    
    
    func testIfTouchPopsBubbles(touchLocation: CGPoint){
    //test if latest touch pops any of the bubbles
        
        var i = 0
        for bubble in (bubbles) {
            let (within, _) = bubble.testTouchInBubble(touchLocation: touchLocation)
            if within == true {
                popBubble(bubble: bubble)
                // print("\(i) popped:  within: \(bubble.touchedWithin) entered: \(bubble.touchEntered)")
            }
            i+=1
        }
    }

    
    func testIfTouchCrossesBubbleBoundaries(touchLocation: CGPoint){
    //test if latest touch crosses any bubble boundaries

        var i = 0
        for bubble in (bubbles) {
            let (_, entered) = bubble.testTouchInBubble(touchLocation: touchLocation)
            if entered == true {
                bubble.swipeInto()
                // print("\(i) entered:  within: \(bubble.touchedWithin) entered: \(bubble.touchEntered)")
            }
            i+=1
        }
    }
}
