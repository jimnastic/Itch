//
//  UIBubble.swift
//  Itch
//
//  Created by James May on 19/11/16.
//  Copyright © 2016 James May. All rights reserved.
//

import UIKit
import AVFoundation



class UIBubble: Bubble {
    // represents a bubble on the screen
    // also inherits isPopped()->Bool and pop()
    
    var view: UIView
    var centerX: Int = 0 //x position of center of the bubble
    var centerY: Int = 0 //y position of center of the bubble
    var radius: Int = 0  // radius of bubble
    var touchedWithin: Bool = false //latest touch is within bubble
    var touchEntered: Bool = false //latest touch entered boundary of bubble
    
    //create an individual bubble
    init(centerX: Int, centerY: Int, radius: Int, color: UIColor) {
        let height = radius * 2
        let width = radius * 2
        print("\(centerX) \(centerY)")
        view = UIView(frame: CGRect(x: centerX, y: centerY, width: width, height:height))
        view.layer.cornerRadius = CGFloat(radius)
        
        if gameSettings.playingBlind == false {
            view.backgroundColor = color
        }
    }
    
    //pop a bubble
    override func pop(){
        super.pop()
        
        let systemSoundID: SystemSoundID = 1057 //tick
        // popcorn:1013 tweet: 1016
        // sound list: https://github.com/TUNER88/iOSSystemSoundsLibrary
        AudioServicesPlaySystemSound (systemSoundID)

        if gameSettings.playingBlind == false {
            view.backgroundColor = UIColor.gray
        }
        
    
    }
    
    //swipe across boundary into a bubble
    func enter(){
        let systemSoundID: SystemSoundID = 1104 //tock sound
        AudioServicesPlaySystemSound (systemSoundID)
    }
    
    //test if a touch (swipe or tap) is in a bubble 
    // also tests if this is the first entry into a bubble or previous was outside
    func testTouchInBubble(touchLocation: CGPoint) -> (withinBubble:Bool, enteredBubble:Bool){
        
        if self.isPopped() {
            return (false, false)
        } else {
            let frame = view.frame
            if frame.contains(touchLocation){
                if isWithinRadius(frame: frame, location: touchLocation) {
                    if touchedWithin == false {
                        touchEntered = true
                    } else {
                        touchEntered = false
                    }
                    touchedWithin = true
                } else {
                    touchedWithin = false
                    touchEntered = false
                }
            } else {
                touchedWithin = false
                touchEntered = false
            }
           // print("entered:\(touchEntered) within:\(touchedWithin) ")
            return(touchedWithin, touchEntered)
        }
    }

    //test if touch is within the circle radius
    func isWithinRadius(frame: CGRect, location: CGPoint) -> Bool {
        // test if location is within oval defined by rect
    
        let xDist = location.x - frame.origin.x - (frame.width/2)
        let yDist = location.y - frame.origin.y - (frame.height/2)
        let distanceSquared = xDist * xDist + yDist * yDist
        let radiusSquared = frame.width/2 * frame.height/2
        //        print("x:\(xDist) y:\(yDist) sqr:\(sqrt(distanceSquared))")
        if distanceSquared <= radiusSquared {
            return true
            } else {
            return false
        }
    }

}
