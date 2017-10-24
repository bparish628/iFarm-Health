//
//  Site.swift
//  iFarm-Health
//
//  Created by Benji Parish on 10/23/17.
//  Copyright © 2017 Benji Parish. All rights reserved.
//

import Foundation
class Site {
    var title: String;
    var description: String;
    var url: String;
    
    init?(title: String, description: String, url: String) {
        self.title = title;
        self.description = description;
        self.url = url;
    }
}
