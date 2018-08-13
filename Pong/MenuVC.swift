//
//  MenuVC.swift
//  Pong
//
//  Created by Josh Jaslow on 2/20/17.
//  Copyright © 2017 Jaslow Enterprises. All rights reserved.
//

import Foundation
import UIKit

enum gameType {
    case easy
    case medium
    case hard
    case twoPlayer
}

class MenuVC: UIViewController {
    
    @IBAction func twoPlayer(_ sender: UIButton) {
        moveToGame(game: .twoPlayer)
    }
    
    @IBAction func easy(_ sender: UIButton) {
        moveToGame(game: .easy)
    }
    
    @IBAction func medium(_ sender: UIButton) {
        moveToGame(game: .medium)
    }
    
    @IBAction func hard(_ sender: UIButton) {
        moveToGame(game: .hard)
    }
    
    func moveToGame(game: gameType) {
        let gameVC = self.storyboard?.instantiateViewController(withIdentifier: "gameVC") as! GameViewController
        
        currentGameType = game
        
        self.navigationController?.pushViewController(gameVC, animated: true)
    }
}
