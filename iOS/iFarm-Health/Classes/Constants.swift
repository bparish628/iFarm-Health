//
//  Constants.swift
//  iFarm-Health
//
//  Created by Benji Parish on 12/14/17.
//  Copyright © 2017 Benji Parish. All rights reserved.
//

import Foundation


/** Constants for the exercise screen */
struct Constants {
    /// The length to wait until the first exercise starts
    static let timerLength = 3
    
    /// The max chart data displayed at one time
    static let chartDataLength = 50
    
    /// The length to wait until the next exercise starts
    static let exerciseTimerLength = 10
    
    /// The delta average needed for a B grade
    static let exerciseBGrade = 0.035
    
    /// The delta average needed for a C grade
    static let exerciseCGrade = 0.055
    
    /// The delta average needed for a D grade
    static let exerciseDGrade = 0.085
    
    /// The delta average needed for a F grade
    static let exerciseFGrade = 0.140
    
    /// The exercises to complete
    static let exercises = [
        "walking in a straight line",
        "right leg-balance",
        "left leg-balance"
    ]
}
