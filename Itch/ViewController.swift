//
//  ViewController.swift
//  Itch
//
//  Created by James May on 19/11/16.
//  Copyright © 2016 James May. All rights reserved.
//


import UIKit
import AVFoundation


struct gameState{
// keep track of the game
    static var isEndGame = false //gameover
}


struct gameSettings{
    // set gameplay constants
    static var playingBlind = true //if playingBlind then bubbles are invisible
    static var numBubbles = 7 // sets the number of bubbles to add during setup
}


class ViewController: UIViewController {
    // ViewController has overall control of screen and gameplay
    //   initialises game
    //   handles user interaction

    var bubbleWrap: UIBubbleWrap?
    let screenSize = UIScreen.main.bounds
    

    @IBOutlet weak var restartButton: UIButton!
    //appears at end of game
    
    @IBAction func tappedRestart(_ sender: Any) {
    //if press restart
        startGame()
        print("Restarted")
    }
    
    override func viewDidLoad() {
    //game loads
        super.viewDidLoad()
        bubbleWrap = UIBubbleWrap() //initialise bubblewrap
        startGame() //add bubbles to the game and setup game
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent!) {
    //first touch of a sequence of touches. Useed for detecting taps

        if !gameState.isEndGame {
            if let touch = touches.first {
                let touchlocation = touch.location(in: self.view)
                bubbleWrap?.testIfTouchPopsBubbles(touchLocation: touchlocation)
            }
            if (bubbleWrap?.isAllPopped())! {
                endGame()
            }
        }
    }

    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent!) {
    //More touches. Useed for detecting swipes

        if !gameState.isEndGame {
            if let touch = touches.first {
                let touchlocation = touch.location(in: self.view)
                bubbleWrap?.testIfTouchCrossesBubbleBoundaries(touchLocation: touchlocation)
            }
            if (bubbleWrap?.isAllPopped())! {
                endGame()
            }
        }
    }


    func startGame(){
        //called to setup the game
        
        gameState.isEndGame = false
        restartButton.isHidden = true
        bubbleWrap?.reset()  //remove old popped bubbles from previus game
        bubbleWrap?.createBubbles(screenView: self.view, screenSize: screenSize, numBubbles: gameSettings.numBubbles)  //create new bubbles
        restartButton.superview!.bringSubview(toFront: restartButton)//ensure restart button is in front (z-order) although hidden
    }

    
    func endGame(){
    //called when game over
        let systemSoundID: SystemSoundID = 1325 //fanfare sound
        AudioServicesPlaySystemSound (systemSoundID)
        
        gameState.isEndGame = true
        restartButton.isHidden = false // make restart button visible
        print("END GAME")
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
}


