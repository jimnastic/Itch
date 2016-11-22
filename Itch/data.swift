//
//  data.swift
//  Itch
//
//  Created by James May on 22/11/16.
//  Copyright © 2016 James May. All rights reserved.
//

import Foundation


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

var bubbleWrap: UIBubbleWrap?
