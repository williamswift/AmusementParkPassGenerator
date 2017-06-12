//
//  ViewController.swift
//  AmusementParkPassGenerator
//
//  Created by William Vivas on 5/15/17.
//  Copyright © 2017 William Vivas. All rights reserved.
//

import UIKit
import AudioToolbox

class ViewController: UIViewController {
    
    enum Access {
        case Granted
        case Denied
        
        private var filename: String {
            switch(self) {
            case .Granted: return "AccessGranted"
            case .Denied: return "AccessDenied"
            }
        }
        
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
    var entrants: [EntrantType] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        createInvalidEntrants()
        
        createValidEntrants()
        scanForAllAccessTypes(entrants: entrants)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scan(entrant: EntrantType, accessType: AccessType) {
        let soundEffectsPlayer = SoundEffectsPlayer()
        
        if let birthdayGuest = entrant as? BirthdayWishable {
            if Date.isTodayBirthday(eventDate: Date()) {
                print("Happy Birthday!")
            }
        }
    


        
        if PassScanner.scan( entrant: entrant, accessType: accessType) {
            print("Access to \(accessType) is granted")
            soundEffectsPlayer.playSound(for: .Granted)
        } else {
            print("Access to \(accessType) is denied")
            soundEffectsPlayer.playSound(for: .Denied)
        }
    }
    
    var sound: SystemSoundID = 0
    
    func playSound(for access: Access) {
        let soundURL = access.soundEffectURL as CFURL
        AudioServicesCreateSystemSoundID(soundURL, &sound)
        AudioServicesPlaySystemSound(sound)
    }
    
    func scanForAllAccessTypes(entrants: [EntrantType]) {
        for entrant in entrants {
            print()
            if let person = entrant as? Nameable {
                print(person.fullName)
            }
            scan(entrant: entrant, accessType: .AmusementAreas)
            scan(entrant: entrant, accessType: .KitchenAreas)
            scan(entrant: entrant, accessType: .RideControlAreas)
            scan(entrant: entrant, accessType: .MaintenanceAreas)
            scan(entrant: entrant, accessType: .OfficeAreas)
            scan(entrant: entrant, accessType: .AllRides)
            scan(entrant: entrant, accessType: .SkipRideLines)
            scan(entrant: entrant, accessType: .FoodDiscount)
            scan(entrant: entrant, accessType: .MerchandiseDiscount)
        }
    }
    
    func createValidEntrants() {
        entrants.append(ClassicGuest())
        
        entrants.append(VIPGuest())
        
        try! entrants.append(FreeChildGuest(childsBirthMonth: 7, childsBirthYear: 2015, childsBirthday: 19))
        
        let marioName = try! FullName(firstName: "Mario", lastName: "Mario")
        let marioAddress = try! FullAddress(streetAddress: "123 Mushroom", city: "Green Pipe", state: "MM", zipCode: 12345)
        let Mario = HourlyEmployeeFoodServices(fullName: marioName, fullAddress: marioAddress)
        entrants.append(Mario)
        
        let jimboName = try! FullName(firstName: "jimbo", lastName: "baggins")
        let jimboAddress = marioAddress
        let jimbo = HourlyEmployeeRideServices(fullName: jimboName, fullAddress: jimboAddress)
        entrants.append(jimbo)
        
        let woodyName = try! FullName(firstName: "woody", lastName: "harrison")
        let woodyAddress = marioAddress
        let woody = HourlyEmployeeMaintenance(fullName: woodyName, fullAddress: woodyAddress)
        entrants.append(woody)
        
        let rockName = try! FullName(firstName: "dwayne", lastName: "johnson")
        let rockAddress = try! FullAddress(streetAddress: "123 Lava", city: "Phoenix", state: "AZ", zipCode: 12345)
        let rock = Manager(fullName: rockName, fullAddress: rockAddress)
        entrants.append(rock)
    }
    
    func createInvalidEntrants() {
        // try to add guest too old for a free pass
        do {
            let child = try FreeChildGuest(childsBirthMonth: 7, childsBirthYear: 2014, childsBirthday: 20)
            entrants.append(child)
        } catch BirthdayError.InvalidBirthday {
            print("Invalid Birthday")
        } catch BirthdayError.TooOldForDiscount {
            print("Children must be less than five years old to receive free entry.")
        } catch let error {
            print(error)
        }
        
        // valid dummy values
        let validName = try! FullName(firstName: "Enrique", lastName: "Iglesias")
        let validAddress = try! FullAddress(streetAddress: "66 rodeo drive", city: "Los angeles", state: "CA", zipCode: 12345)
        
        // try to add a full-time employee with an empty first name
        do {
            let emptyFirstName = try FullName(firstName: "", lastName: "jones")
            let newEmployee = HourlyEmployeeFoodServices(fullName: emptyFirstName, fullAddress: validAddress)
            entrants.append(newEmployee)
        } catch InputError.firstNameFieldEmpty {
            print("First name cannot be empty")
        } catch let error {
            print(error)
        }
        
        // try to add a full-time employee with an empty last name
        do {
            let emptyLastName = try FullName(firstName: "fabio", lastName: "")
            let newEmployee = HourlyEmployeeRideServices(fullName: emptyLastName, fullAddress: validAddress)
            entrants.append(newEmployee)
        } catch InputError.lastNameEmpty {
            print("Last name cannot be empty")
        } catch let error {
            print(error)
        }
        
        // try to add a full-time employee with an empty street address
        do {
            let emptyStreetAddress = try FullAddress(streetAddress: "", city: "Knoxville", state: "TN", zipCode: 12345)
            let newEmployee = HourlyEmployeeMaintenance(fullName: validName, fullAddress: emptyStreetAddress)
            entrants.append(newEmployee)
        } catch InputError.streetAddressIsEmpty{
            print("Street address cannot be empty")
        } catch let error {
            print(error)
        }
        
        // try to add a full-time employee with an empty city
        do {
            let emptyCity = try FullAddress(streetAddress: "99 amity road", city: "", state: "AA", zipCode: 12345)
            let newEmployee = HourlyEmployeeMaintenance(fullName: validName, fullAddress: emptyCity)
            entrants.append(newEmployee)
        } catch InputError.cityIsEmpty {
            print("City cannot be empty")
        } catch let error {
            print(error)
        }
        
        // try to add a full-time employee with an empty city
        do {
            let emptyState = try FullAddress(streetAddress: "Real Street Address", city: "RealCity", state: "", zipCode: 12345)
            let newEmployee = Manager(fullName: validName, fullAddress: emptyState)
            entrants.append(newEmployee)
        } catch InputError.stateIsEmpty {
            print("State cannot be empty")
        } catch let error {
            print(error)
        }
    }
}
