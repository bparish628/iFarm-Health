//
//  DataPoint.swift
//  iFarm-Health
//
//  Created by Benji Parish on 12/10/17.
//  Copyright © 2017 Benji Parish. All rights reserved.
//

import Foundation

/**
 Contains a sites information
 */
class DataPoint {
    // MARK: - Variables
    
    /// The x value of the point
    var x: Double;
    
    /// The y value of the point
    var y: Double;
    
    /// The z value of the point
    var z: Double;
    
    // MARK: - Functions
    
    /**
     Initialize the datapoint with x,y, and z
     */
    init?(x: Double, y: Double, z: Double) {
        self.x = Double(round(1000 * x) / 1000);
        self.y = Double(round(1000 * y) / 1000);
        self.z = Double(round(1000 * z) / 1000);
    }
}

