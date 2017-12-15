//
//  ExerciseViewController.swift
//  iFarm-Health
//
//  Created by Benji Parish on 10/26/17.
//  Copyright © 2017 Benji Parish. All rights reserved.
//

import UIKit
import Charts
import CoreMotion

/**
 Controller of the Accelerometer view
 */
class AccelerometerViewController: UIViewController {

    let manager = CMMotionManager()
    @IBOutlet weak var stopExercise: UIButton!
    @IBOutlet var chartView: LineChartView!
    @IBOutlet weak var counter: UILabel!
    @IBOutlet weak var exerciseType: UILabel!
    var dataPoints: Array<DataPoint> = []
    var deltas: Array<Double> = []
    var timer = Timer()
    var seconds = Constants.timerLength
    var isRunning: Bool = false;
    var currentExercise = 0;

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup the chart
        setupChart()
        
        // Setup the accelerometer
        toggleAccelerometer()
        
        // listen to the stopExercise button
        stopExercise.addTarget(self, action: #selector(self.startExerciseButton), for: .touchUpInside)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
        Toggle's whether the accelerometer is running. If it's running then it will stop it
     */
    func toggleAccelerometer() {
        self.isRunning = !self.isRunning
        if manager.isAccelerometerAvailable {
            manager.accelerometerUpdateInterval = 0.04 // This is about 20hz, we want 100hz at 0.01
            if (!self.isRunning) {
                manager.startAccelerometerUpdates(to: .main) {
                    [weak self] (data: CMAccelerometerData?, error: Error?) in
                    if let acceleration = data?.acceleration {
                        self?.dataPoints.append(DataPoint(x: acceleration.x,y: acceleration.y, z: acceleration.z)!)
                        if (self?.dataPoints.count != 1) {
                            let index = (self?.dataPoints.count)! - 1
                            let deltaX = abs(Double((self?.dataPoints[index - 1].x)!) - Double((self?.dataPoints[index].x)!))
                            let deltaY = abs(Double((self?.dataPoints[index - 1].y)!) - Double((self?.dataPoints[index].y)!))
                            let deltaZ = abs(Double((self?.dataPoints[index - 1].z)!) - Double((self?.dataPoints[index].z)!))
                            let delta = (deltaX + deltaY + deltaZ) / 3
                            self?.deltas.append(delta)
                        }
                        self?.updateGraph()
                    }
                }
            } else {
                manager.stopAccelerometerUpdates()
            }
        }
        updateButtonTitle()
    }
    
    /** Sets up all the chart variables and configurations */
    func setupChart() {
        chartView.dragEnabled = false
        chartView.scaleXEnabled = false
        chartView.scaleYEnabled = false
        chartView.isExclusiveTouch = false
        chartView.backgroundColor = UIColor(red: 125/255, green: 125/255, blue: 125/255, alpha: 0.10)
        
        // settings for x-axis lines
        chartView.xAxis.drawLabelsEnabled = true
        chartView.xAxis.drawAxisLineEnabled = false
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.xAxis.labelPosition = XAxis.LabelPosition.bottom
        
        // settings for y-axis lines
        chartView.rightAxis.drawLabelsEnabled = false
        chartView.rightAxis.drawGridLinesEnabled = false
        chartView.rightAxis.drawZeroLineEnabled = true
        chartView.rightAxis.drawAxisLineEnabled = false
        chartView.leftAxis.drawLabelsEnabled = true
        chartView.leftAxis.drawGridLinesEnabled = true
        chartView.leftAxis.drawZeroLineEnabled = true
        
        // Setting minimums
        chartView.rightAxis.axisMaximum = 2
        chartView.rightAxis.axisMinimum = -2
        chartView.leftAxis.axisMaximum = 2
        chartView.leftAxis.axisMinimum = -2
        
        //Update the graph
        updateGraph()
    }
    
    /** Updates the graph will the x,y, and z data points */
    func updateGraph() {
        let data = LineChartData()
        data.addDataSet(createLine(color:UIColor.green, label: "X"))
        data.addDataSet(createLine(color:UIColor.blue, label: "Y"))
        data.addDataSet(createLine(color:UIColor.red, label: "Z"))
        
        self.chartView.data = data
        self.chartView.chartDescription?.text = "Accelerometer Data"
    }
    
    /** Resets the graph and all cord arrays to blank*/
    func resetGraph() {
        dataPoints = []
        deltas = []
        currentExercise = 0
        stopExercise.isHidden = false
        counter.isHidden = true
        exerciseType.isHidden = true
        updateGraph()
    }
    
    /** Helper to create line points for the Chart */
    private func createLine(color: UIColor, label: String) -> LineChartDataSet {
        var start = 0
        if (self.dataPoints.count > Constants.chartDataLength) {
            start = self.dataPoints.count - Constants.chartDataLength
        }
        var lineChartEntry = [ChartDataEntry]()
        for i in start..<self.dataPoints.count {
            if (label == "X") {
                let value = ChartDataEntry(x:Double(i), y: self.dataPoints[i].x)
                lineChartEntry.append(value)
            } else if (label == "Y") {
                let value = ChartDataEntry(x:Double(i), y: self.dataPoints[i].y)
                lineChartEntry.append(value)
            } else if (label == "Z") {
                let value = ChartDataEntry(x:Double(i), y: self.dataPoints[i].z)
                lineChartEntry.append(value)
            }
        }
        let line = LineChartDataSet(values: lineChartEntry, label: label)
        line.colors = [color]
        
        // We don't want there to be a circle on each point
        line.drawCirclesEnabled = false
        line.drawValuesEnabled = false
        return line;
    }
    
    func startExercise() {
        if (currentExercise < Constants.exercises.count) {
            exerciseType.text = Constants.exercises[currentExercise]
            // Set the timer to the length of time of each exercise
            seconds = Constants.exerciseTimerLength
            updateTimerText()
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(AccelerometerViewController.exerciseTimerUpdates)), userInfo: nil, repeats: true)
        } else {
            // If there are no more exercises, then lets go to the score page!
            toggleAccelerometer()
            goToScorePage()
        }
    }
    
    /** Passes the deltas and datapoints to the score page */
    func goToScorePage() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let scoreViewController = storyBoard.instantiateViewController(withIdentifier: "scoreView") as! ScoreViewController
        scoreViewController.deltas = deltas
        scoreViewController.dataPoints = dataPoints
        resetGraph()
        self.present(scoreViewController, animated:true, completion:nil)
    }
    
    /** Will run until the timer hits 0, updates the label */
    @objc func exerciseTimerUpdates() {
        seconds -= 1
        updateTimerText()
        if (seconds == 0) {
            currentExercise += 1
            timer.invalidate()
            startExercise()
        }
    }
    
    /** Updates the timer's text */
    func updateTimerText() {
        counter.text = String(seconds)
    }

    /** Toggles the hidden flags on buttons and will start/stop the accelerometer */
    @IBAction func startExerciseButton(sender: UIButton!) {
        stopExercise.isHidden = true
        counter.isHidden = false
        exerciseType.isHidden = false
        exerciseType.text = "Starting in..."
        seconds = Constants.timerLength
        updateTimerText()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(AccelerometerViewController.updateStartTimer)), userInfo: nil, repeats: true)
    }
    
    /** Exports the data */
    @IBAction func exportData(sender: UIButton!) {
        let fileName = "ExerciseData.csv"
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        var csv = "Index,X,Y,Z\n"
        for index in 0...(dataPoints.count - 1) {
            let point = dataPoints[index]
            let line = "\(index),\(point.x),\(point.y),\(point.z)\n"
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
    
    /** Will run until the timer hits 0, updates the label */
    @objc func updateStartTimer() {
        seconds -= 1
        updateTimerText()
        if (seconds == 0) {
            seconds = Constants.timerLength
            timer.invalidate()
            // Start the accelerometer
            toggleAccelerometer()
            startExercise()
        }
    }
    
    /** Updates the update buttons text */
    func updateButtonTitle() {
        title = "Start Exercise"
        if (!self.isRunning) {
            title = "Stop Exercise"
        }
        stopExercise.setTitle(title, for: .normal)
        self.navigationItem.title = "";
    }
}
