//
//  ViewController.swift
//  Itch
//
//  Created by James May on 19/11/16.
//  Copyright © 2016 James May. All rights reserved.
//

// todo: stop timer when background in app delegate

import UIKit
import AVFoundation


struct gameState{
// keep track of the game
    static var isEndGame = false //gameover
}


struct gameSettings{
    // set gameplay constants
    static var bubbleRadius = 50 // size of bubbles
    static var playingBlind = false //if playingBlind then bubbles are invisible
    static var initialBubbles = 6 // sets the number of bubbles to add during setup
    static var maxBubbles = 12 // sets the seconds before new bubble spawned
    static var timerInterval = 10 // sets the seconds before new bubble spawned
    static var respawning = false // new bubbles created on timer
}


class ViewController: UIViewController {
    // ViewController has overall control of screen and gameplay
    //   initialises game
    //   handles user interaction

    var bubbleWrap: UIBubbleWrap?
    var screenSize = UIScreen.main.bounds
    var gameTimer: Timer!
    

    @IBOutlet weak var restartButton: UIButton!
    //appears at end of game
    
    @IBAction func tappedRestart(_ sender: Any) {
    //if press restart
        startGame(numBubbles: gameSettings.initialBubbles)
    }
    
    
    override func viewDidLoad() {
    //game loads
        super.viewDidLoad()
        bubbleWrap = UIBubbleWrap() //initialise bubblewrap
        startGame(numBubbles: gameSettings.initialBubbles) //add bubbles to the game and setup game
        if gameSettings.respawning {
        // if respawning allowed set a timer to create additional bubbles
            gameTimer = Timer.scheduledTimer(timeInterval: TimeInterval(gameSettings.timerInterval), target: self, selector: #selector(timerTriggered), userInfo: nil, repeats: true)
        }
        print("view did load")
    }

    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape {
            print("Landscape")
        } else {
            print("Portrait")
        }
        if gameState.isEndGame {
            // print("rotating while end game")
        } else {
            screenSize = CGRect(origin: CGPoint(x: 0,y :0), size: size)
            //print(screenSize)
            let remainingBubbles = bubbleWrap?.count()
            cancelGame()
            startGame(numBubbles: remainingBubbles!)
        }
    }
    
    
    func timerTriggered(){
    // timer that triggers regularly. Used to launch new bubbles
        if !gameState.isEndGame {
            if (bubbleWrap?.count())! < gameSettings.maxBubbles {
                bubbleWrap?.createBubbles(screenView: self.view, screenSize: screenSize, numBubbles: 1)
            }
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent!) {
    //first touch of a sequence of touches. Useed for detecting taps

        if !gameState.isEndGame {
            if let touch = touches.first {
                let touchlocation = touch.location(in: self.view)
                bubbleWrap?.testIfTouchPopsBubbles(touchLocation: touchlocation)
            }
            if (bubbleWrap?.isAllPopped())! {
                endGameSuccessfully()
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
                endGameSuccessfully()
            }
        }
    }


    func startGame(numBubbles: Int){
        //called to setup the game
        
        gameState.isEndGame = false
        restartButton.isHidden = true
        bubbleWrap?.createBubbles(screenView: self.view, screenSize: screenSize, numBubbles: numBubbles)  //create new bubbles
        restartButton.superview!.bringSubview(toFront: restartButton)//ensure restart button is in front (z-order) although hidden
        print("START")
    }

    
    func cancelGame(){
    //called when game interrupted. e.g. screen rotation

        print("total popped: \(bubbleWrap?.poppedCount)")
        bubbleWrap?.reset()  //remove old popped bubbles from previus game
        gameState.isEndGame = true
        restartButton.isHidden = true
        print("CANCEL GAME")
    }
    
    
    func endGameSuccessfully(){
    //called when game over
        let systemSoundID: SystemSoundID = 1325 //fanfare sound
        AudioServicesPlaySystemSound (systemSoundID)
        
        print("total popped: \(bubbleWrap?.poppedCount)")
        bubbleWrap?.reset()  //remove old popped bubbles from previus game
        gameState.isEndGame = true
        restartButton.isHidden = false // make restart button visible
        print("WIN GAME")
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
}


