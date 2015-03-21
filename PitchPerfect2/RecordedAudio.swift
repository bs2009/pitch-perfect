//
//  RecordedAudio.swift
//  PitchPerfect2
//
//  Created by William Song on 3/14/15.
//  Copyright (c) 2015 Bill Song. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
    let filePathUrl: NSURL
    let title: String
    
    init(url: NSURL, title: String) {
        self.filePathUrl = url
        self.title = title
    }
}
