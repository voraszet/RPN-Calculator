//
//  TapeViewController.swift
//  CalculatorRPN
//
//  Created by Adrijus Zelinskis on 23/02/2017.
//  Copyright © 2017 Adrijus Zelinskis. All rights reserved.
//

import Foundation
import UIKit

class TapeViewController: UIViewController {
    
    
    @IBOutlet weak var tapeTextarea: UITextView!
    var labelText = String()
    
    //  TAPE ARRAY
    var fullTape = [String]()


    override func viewDidLoad() {
        tapeTextarea.text = labelText
    
        var x:Int = 0
        
        for i in fullTape {
            tapeTextarea.text = tapeTextarea.text + " \(fullTape[x])"
            x = x + 1
                
            UserDefaults.standard.set(tapeTextarea.text, forKey: "tapeValues")
        }
    }
    
    //  PASSING TAPE TO FIRST CONTROLLER
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc:ViewController = segue.destination as! ViewController
        for test in (fullTape) {
            vc.secondTape.append(test)   
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        if let x = UserDefaults.standard.object(forKey: "tapeValues") as? String
        {
            tapeTextarea.text = x
            print(x)
        }
    }
    
    @IBAction func clearAll() {
        fullTape.removeAll()
        tapeTextarea.text = ""
        UserDefaults.standard.set("", forKey: "tapeValues")
        
    }
    
    
    
    
}
