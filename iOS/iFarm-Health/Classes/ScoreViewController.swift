//
//  ScoreViewController.swift
//  iFarm-Health
//
//  Created by Benji Parish on 12/10/17.
//  Copyright © 2017 Benji Parish. All rights reserved.
//

import UIKit
import Charts
import CoreMotion

/**
 Controller of the Accelerometer view
 */
class ScoreViewController: UIViewController {
    var dataPoints: Array<DataPoint> = []
    var deltas: Array<Double> = []
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var exportButton: UIButton!
    @IBOutlet weak var goBackButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calculateScore()
        
        exportButton.addTarget(self, action: #selector(self.exportData), for: .touchUpInside)
        goBackButton.addTarget(self, action: #selector(self.goBack), for: .touchUpInside)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /** Calculates the score for the passed in deltas/datapoints */
    func calculateScore() {
        var score = 0.00
        for delta in deltas {
            score += delta
        }
        score /= Double((deltas.count))
        if (score > Constants.exerciseFGrade){
            scoreLabel.text = "F"
            scoreLabel.textColor = UIColor.red
            descriptionLabel.text = "Get Some Rest"
        } else if (score > Constants.exerciseDGrade) {
            scoreLabel.text = "D"
            scoreLabel.textColor = UIColor.orange
            descriptionLabel.text = "Poor"
        } else if (score > Constants.exerciseCGrade) {
            scoreLabel.text = "C"
            scoreLabel.textColor = UIColor.yellow
            descriptionLabel.text = "Below Average"
        } else if (score > Constants.exerciseBGrade) {
            scoreLabel.text = "B"
            scoreLabel.textColor = UIColor.yellow
            descriptionLabel.text = "Good"
        } else {
            scoreLabel.text = "A"
            scoreLabel.textColor = UIColor.green
            descriptionLabel.text = "Perfect"
        }
    }

    /** Exports the data as a csv */
    @IBAction func exportData(sender: UIButton!) {
        let fileName = "ExerciseData.csv"
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        var csv = "Index,X,Y,Z\n"
        for i in 0..<(dataPoints.count) {
            let point = dataPoints[i]
            let line = "\(i),\(point.x),\(point.y),\(point.z)\n"
            csv.append(line)
        }
        
        do {
            try csv.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
            let activityCtrl = UIActivityViewController(activityItems: [path!], applicationActivities: [])
            present(activityCtrl, animated: true, completion: nil)
        } catch {
            print("Failed to create the csv.")
        }
    }
    
    /// Goes back to the previous screen. aka the beginning of the exercise
    @IBAction func goBack(sender: UIButton!) {
        dismiss(animated: true, completion: nil)
    }
}

