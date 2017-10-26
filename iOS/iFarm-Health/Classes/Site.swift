//
//  Site.swift
//  iFarm-Health
//
//  Created by Benji Parish on 10/23/17.
//  Copyright © 2017 Benji Parish. All rights reserved.
//

import Foundation

/**
     Contains a sites information
 */
class Site {
    // MARK: - Variables

    /// The title of the site
    var title: String;
    
    /// The description of the site
    var description: String;
    
    /// The url to the site
    var url: String;
    
    // MARK: - Functions

    
    /**
         Initialize the site with a title, description, and url
     */
    init?(title: String, description: String, url: String) {
        self.title = title;
        self.description = description;
        self.url = url;
    }
}
