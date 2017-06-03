//
//  Audio.swift
//  AmusementParkPassGenerator
//
//  Created by William Vivas on 6/3/17.
//  Copyright © 2017 William Vivas. All rights reserved.
//

import Foundation
import AudioToolbox

extension Access {
    
    var soundEffectName: String {
        switch self {
        case .Granted: return "AccessGranted"
        case .Denied: return "AccessDenied"
        }
        
    }
    
    
    var soundEffectURL: URL {
        let path = Bundle.main.path(forResource: soundEffectName, ofType: "wav")!
        return URL(fileURLWithPath: path)
}
}

class SoundEffectsPlayer {
    var sound: SystemSoundID = 0
    
    func playSound(for access: Access) {
        let soundURL = access.soundEffectURL as CFURL
        AudioServicesCreateSystemSoundID(soundURL, &sound)
        AudioServicesPlaySystemSound(sound)
    }
}
