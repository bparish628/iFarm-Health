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

class AccelerometerViewController: UIViewController {

    let manager = CMMotionManager()
    @IBOutlet weak var stopExercise: UIButton!
    @IBOutlet weak var x: UILabel!
    @IBOutlet weak var y: UILabel!
    @IBOutlet weak var z: UILabel!
    @IBOutlet var chartView: LineChartView!
    var xcords: Array<Double> = []
    var ycords: Array<Double> = []
    var zcords: Array<Double> = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupChart()
        styleLabels()
        if manager.isAccelerometerAvailable {
            manager.accelerometerUpdateInterval = 0.05
            manager.startAccelerometerUpdates(to: .main) {
                [weak self] (data: CMAccelerometerData?, error: Error?) in
                if let acceleration = data?.acceleration {
                    let accelX = Double(round(1000*acceleration.x)/1000)
                    self?.x.text = String(accelX)
                    self?.xcords.append(accelX)
                    
                    let accelY = Double(round(1000*acceleration.y)/1000)
                    self?.y.text = String(accelY)
                    self?.ycords.append(accelY)
                    
                    let accelZ = Double(round(1000*acceleration.z)/1000)
                    self?.z.text = String(accelZ)
                    self?.zcords.append(accelZ)
                    
                    self?.updateGraph()
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
        chartView.rightAxis.axisMaximum = 1.2
        chartView.rightAxis.axisMinimum = -1.2
        chartView.leftAxis.axisMaximum = 1.2
        chartView.leftAxis.axisMinimum = -1.2
    }
    
    func updateGraph() {
        let data = LineChartData()
        data.addDataSet(createLine(data:self.xcords, color:UIColor.green, label: "X"))
        data.addDataSet(createLine(data:self.ycords, color:UIColor.blue, label: "Y"))
        data.addDataSet(createLine(data:self.zcords, color:UIColor.red, label: "Z"))
        
        self.chartView.data = data
        self.chartView.chartDescription?.text = "Accelerometer Data"
    }
    
    private func createLine(data: Array<Double>, color: UIColor, label: String) -> LineChartDataSet {
        var start = 0
        if (data.count > 50) {
            start = data.count - 50
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
