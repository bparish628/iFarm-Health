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

struct Constants {
    static let timerLength = 3
    static let chartDataLength = 50
}

/**
 Controller of the Accelerometer view
 */
class AccelerometerViewController: UIViewController {

    let manager = CMMotionManager()
    @IBOutlet weak var stopExercise: UIButton!
    @IBOutlet var exportBtn: UIButton!
    @IBOutlet var chartView: LineChartView!
    @IBOutlet weak var counter: UILabel!
    var xcords: Array<Double> = []
    var ycords: Array<Double> = []
    var zcords: Array<Double> = []
    var timer = Timer()
    var seconds = Constants.timerLength
    var isRunning: Bool = false;

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup the chart
        setupChart()
        
        // Setup the accelerometer
        toggleAccelerometer()
        
        // hide the export button
        exportBtn.isHidden = true

        // listen to the stopExercise button
        stopExercise.addTarget(self, action: #selector(self.updateButton), for: .touchUpInside)
        exportBtn.addTarget(self, action: #selector(self.exportData), for: .touchUpInside)
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
        exportBtn.isHidden = !self.isRunning
        if manager.isAccelerometerAvailable {
            manager.accelerometerUpdateInterval = 0.04 // This is about 20hz, we want 100hz at 0.01
            if (!self.isRunning) {
                manager.startAccelerometerUpdates(to: .main) {
                    [weak self] (data: CMAccelerometerData?, error: Error?) in
                    if let acceleration = data?.acceleration {
                        let accelX = Double(round(1000*acceleration.x)/1000)
                        self?.xcords.append(accelX)
                        
                        let accelY = Double(round(1000*acceleration.y)/1000)
                        self?.ycords.append(accelY)
                        
                        let accelZ = Double(round(1000*acceleration.z)/1000)
                        self?.zcords.append(accelZ)
                        
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
        data.addDataSet(createLine(data:self.xcords, color:UIColor.green, label: "X"))
        data.addDataSet(createLine(data:self.ycords, color:UIColor.blue, label: "Y"))
        data.addDataSet(createLine(data:self.zcords, color:UIColor.red, label: "Z"))
        
        self.chartView.data = data
        self.chartView.chartDescription?.text = "Accelerometer Data"
    }
    /** Resets the graph and all cord arrays to blank*/
    func resetGraph() {
        xcords = []
        ycords = []
        zcords = []
        updateGraph()
    }
    
    /** Helper to create line points for the Chart */
    private func createLine(data: Array<Double>, color: UIColor, label: String) -> LineChartDataSet {
        var start = 0
        if (data.count > Constants.chartDataLength) {
            start = data.count - Constants.chartDataLength
        }
        var lineChartEntry = [ChartDataEntry]()
        for i in start..<data.count {
            let value = ChartDataEntry(x:Double(i), y: data[i])
            lineChartEntry.append(value)
        }
        let line = LineChartDataSet(values: lineChartEntry, label: label)
        line.colors = [color]
        
        // We don't want there to be a circle on each point
        line.drawCirclesEnabled = false
        line.drawValuesEnabled = false
        return line;
    }

    /** Toggles the hidden flags on buttons and will start/stop the accelerometer */
    @IBAction func updateButton(sender: UIButton!) {
        if (self.isRunning) {
            stopExercise.isHidden = true
            exportBtn.isHidden = true
            counter.isHidden = false
            resetGraph()
            counter.text = String(seconds)
            timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(AccelerometerViewController.updateTimer)), userInfo: nil, repeats: true)
        } else {
            toggleAccelerometer()
        }
    }
    
    /** Exports the data */
    @IBAction func exportData(sender: UIButton!) {
        let fileName = "ExerciseData.csv"
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        var csv = "Index,X,Y,Z\n"
        for index in 0...(xcords.count - 1) {
            let line = "\(index),\(xcords[index]),\(ycords[index]),\(zcords[index])\n"
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
    @objc func updateTimer() {
        seconds -= 1
        counter.text = String(seconds)
        if (seconds == 0) {
            counter.isHidden = true
            stopExercise.isHidden = false
            seconds = Constants.timerLength
            timer.invalidate()
            toggleAccelerometer()
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
