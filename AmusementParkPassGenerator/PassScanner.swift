//
//  PassScanner.swift
//  AmusementParkPassGenerator
//
//  Created by William Vivas on 5/24/17.
//  Copyright © 2017 William Vivas. All rights reserved.
//

import Foundation
import AudioToolbox

enum AccessType: String {

// Area Access

case AmusementAreas, KitchenAreas, RideControlAreas, MaintenanceAreas, OfficeAreas

// Ride Access

case AllRides, SkipRideLines

//DiscountAccess

case FoodDiscount, MerchandiseDiscount

}

enum Access {
    case Granted
    case Denied
    }



class PassScanner {
    
   
     static func scan(entrant: EntrantType, accessType: AccessType) -> Bool {
        
        
        var accessGranted: Bool = false
        
        switch accessType {
        // Area Access
        case .AmusementAreas:
            accessGranted = entrant is AmusementAreaAccessible
        case .KitchenAreas:
            accessGranted = entrant is KitchenAreaAccessible
        case .RideControlAreas:
            accessGranted = entrant is RideControlAreaAccessible
        case .MaintenanceAreas:
            accessGranted = entrant is MaintenanceAreaAccessible
        case .OfficeAreas:
            accessGranted = entrant is OfficeAreaAccessible
        // Ride Access
        case .AllRides:
            accessGranted = entrant is AllRidesAcesssible
        case .SkipRideLines:
            accessGranted = entrant is SkipAllRideLinesAcessible
        // Discount Access
        case .FoodDiscount:
            accessGranted = entrant is FoodDiscountAccessible
        case .MerchandiseDiscount:
            accessGranted = entrant is MerchandiseDiscountAccessible
        }
        
        var soundEffectURL: URL {
            let path = Bundle.main.path(forResource: "AccessDenied", ofType: "wav")!
            return URL(fileURLWithPath: path)
        }
     let soundEffectsPlayer = SoundEffectsPlayer()
        
        if accessGranted {
            print("Access to \(accessType) is granted")
            soundEffectsPlayer.playSound(for: .Granted)
        } else {
            print("Access to \(accessType) is denied")
            soundEffectsPlayer.playSound(for: .Denied)
        }
        return accessGranted
}
}








