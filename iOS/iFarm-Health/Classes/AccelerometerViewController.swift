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
    @IBOutlet weak var info: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if manager.isAccelerometerAvailable {
            manager.accelerometerUpdateInterval = 0.01
            manager.startAccelerometerUpdates(to: .main) {
                [weak self] (data: CMAccelerometerData?, error: Error?) in
                if let acceleration = data?.acceleration {
                    let rotation = String(acceleration.x)
                    self?.info.text = String(rotation)
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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