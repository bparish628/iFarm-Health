//
//  ExerciseViewController.swift
//  iFarm-Health
//
//  Created by Benji Parish on 10/26/17.
//  Copyright © 2017 Benji Parish. All rights reserved.
//

import UIKit
import CoreMotion

class AccelerometerViewController: UIViewController {

    let manager = CMMotionManager()
    @IBOutlet weak var stopExercise: UIButton!
    @IBOutlet weak var x: UILabel!
    @IBOutlet weak var y: UILabel!
    @IBOutlet weak var z: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        styleLabels()
        if manager.isAccelerometerAvailable {
            manager.accelerometerUpdateInterval = 0.01
            manager.startAccelerometerUpdates(to: .main) {
                [weak self] (data: CMAccelerometerData?, error: Error?) in
                if let acceleration = data?.acceleration {
                    self?.x.text = String(Double(round(1000*acceleration.x)/1000))
                    self?.y.text = String(Double(round(1000*acceleration.y)/1000))
                    self?.z.text = String(Double(round(1000*acceleration.z)/1000))
                }
            }
        }
        
        stopExercise.addTarget(self, action: #selector(self.goBack), for: .touchUpInside)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func styleLabels() {
        // X label
        x.layer.borderWidth = 2.0
        x.layer.cornerRadius = 8
        x.layer.borderColor = UIColor.green.cgColor
        
        // Y label
        y.layer.borderWidth = 2.0
        y.layer.cornerRadius = 8
        y.layer.borderColor = UIColor.blue.cgColor
        
        // Z label
        z.layer.borderWidth = 2.0
        z.layer.cornerRadius = 8
        z.layer.borderColor = UIColor.red.cgColor

    }

    /// Goes back to the previous screen. aka the beginning of the exercise
    @IBAction func goBack(sender: UIButton!) {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
