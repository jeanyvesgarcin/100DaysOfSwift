//
//  ViewController.swift
//  Day49 - Project1
//
//  Created by Jean-Yves Garcin on 18/06/2023.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var highScore = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        highScore = defaults.integer(forKey: "HighScore")
        
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor

        askQuestion()
    }

    func askQuestion(action: UIAlertAction! = nil) {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        let country = countries[correctAnswer].uppercased()
        title = "Guess \(country) ? : Score (\(score) of 10)"
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String
        var message: String = ""
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
            if score > highScore {
                let defaults = UserDefaults.standard
                defaults.set(score, forKey: "HighScore")
                highScore = score
                message += "You've beaten your previous high score, well done!\n\n"
            }
        } else {
            title = "Wrong"
            message += "Wrong! Thats the flag of \(countries[sender.tag])\n\n";
            score -= 1
        }
        
        if (score >= 10) {
            message += "Your final score was \(score)"
        }
        else {
            message += "Your score is \(score)"
        }
        
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
        
        present(ac, animated: true)
    }
    
}

