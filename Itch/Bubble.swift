//
//  Bubble.swift
//  Itch
//
//  Created by James May on 19/11/16.
//  Copyright © 2016 James May. All rights reserved.
//

import Foundation


class Bubble {
    var popped:Bool = false
    

    init() {
        popped = false
    }

    
    func pop(){
        popped = true
    }
    
    func isPopped()-> Bool{
        if self.popped {
            return true
        } else {
            return false
        }
    }
}

