//
//  AccessManager.swift
//  AmusementParkPassGenerator
//
//  Created by William Vivas on 5/15/17.
//  Copyright © 2017 William Vivas. All rights reserved.
//

import Foundation

// MARK: Validation Protocols

protocol Entrant {}
 

enum DiscountAccess{
    case foodDiscount(Amount: Double)
    case merchandiseDiscount(amount: Double)
}

enum areaAccess {
    case amusementAreaAccess
    case rideControlAccess
    case kitchenAreaAccess
    case maintenenceAreaAccess
    case officeAreaAccess
    case allrideAccess
    case skipAllRideLines
}

struct FullName {
    let firstName: String
    let lastName: String
    
    init(firstName: String, lastName: String) throws {
        if firstName.isEmpty {
            throw InputError.firstNameFieldEmpty
        }
        if lastName.isEmpty {
            throw InputError.lastNameEmpty
        }
        self.firstName = firstName
        self.lastName = lastName
    }
}

struct FullAddress {
    let streetAddress: String
    let city: String
    let state: String
    let zipCode: Int
    
    init(streetAddress: String, city: String, state: String, zipCode: Int) throws {
       
        if streetAddress.isEmpty {
            throw InputError.streetAddressIsEmpty
        }
        if city.isEmpty {
            throw InputError.cityIsEmpty
        }
        if state.isEmpty {
            throw InputError.stateIsEmpty
        }
        self.streetAddress = streetAddress
        self.city = city
        self.state = state
        self.zipCode = zipCode
    }
}

//MARK: area access protocols 

protocol AreaAccessible {
}

protocol AmusementAreaAccessible: AreaAccessible {
}

protocol KitchenAreaAccessible: AreaAccessible {
}

protocol RideControlAreaAccessible: AreaAccessible {
    
}

protocol MaintenanceAreaAccessible: AreaAccessible {
}

protocol OfficeAreaAccessible: AreaAccessible {
}

// MARK: Ride access protocols 

protocol RideAccessible{
}

protocol AllRidesAcesssible: RideAccessible {
}

protocol SkipAllRideLinesAcessible {
}

// MARK: discount protocols 

protocol DiscountAccessible{
}

protocol FoodDiscountAccessible: DiscountAccessible {
    var foodDiscountPercentage: Double { get }
}

protocol MerchandiseDiscountAccessible: DiscountAccessible {
    var MerchandiseDiscountPercentage: Double { get }
}

// MARK: personal info protocols 

protocol Nameable {
    var fullName: FullName { get }
}

protocol Addressable {
    var fullAddress: FullAddress { get }
}

protocol BirthdayWishable {

    var childsBirthMonth : Int { get set }
    var childsBirthYear : Int { get set }
    var childsBirthday : Int { get set }
}

// MARK: validation protocols

protocol EntrantType: AmusementAreaAccessible {
}

protocol GuestType: EntrantType, AllRidesAcesssible {
}

protocol EmployeeType: EntrantType, Nameable, Addressable {
}

protocol FullTimeEmployeeType: EmployeeType, FoodDiscountAccessible, MerchandiseDiscountAccessible, AllRidesAcesssible {
}
// MARK: Guest types

struct ClassicGuest: GuestType {
}


struct VipGuest: GuestType, SkipAllRideLinesAcessible, FoodDiscountAccessible, MerchandiseDiscountAccessible {
    let foodDiscountPercentage: Double = 0.10
    let MerchandiseDiscountPercentage: Double = 0.20

}

struct FreeChildGuest: GuestType, BirthdayWishable {
   

    let date = Date()
    var calendar = Calendar.current
    
    
    var childsBirthMonth : Int
    var childsBirthYear : Int
    var childsBirthday : Int
    
    func birthDateMatcher(childsBirthday : Int,childsBirthMonth : Int, childsBirthYear : Int ) throws  -> String {
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        let today = calendar.component(.day, from: date)
        
        if  childsBirthday == today && childsBirthMonth == month {
            return("Happy Birthday")
        }
        else {
            throw InputError.notGuestsBirthday
        }
    }
    
        func agechecker(childsDateOfBirth:String) -> String {
            
            let ageComponents = childsDateOfBirth.components(separatedBy: "-")
            
            let dateDOB = Calendar.current.date(from: DateComponents(year:
                Int(ageComponents[0]), month: Int(ageComponents[1]), day:
                Int(ageComponents[2])))!
            let childsAge = dateDOB.age
            
            if childsAge > 5 {
                return ("child is older than 5")
            }
            else {
                return ("child is younger than five")
            }
        }
        }



    extension Date {
        var age: Int{
            return Calendar.current.dateComponents([.year], from: self, to: Date()).year!
        }
        
        static func isTodayBirthday(eventDate: Date) -> Bool {
            let calendar = Calendar.current
            
            let today = Date()
            
            let todaysDayComponents = calendar.component(.day, from: today)
            let todaysMonthComponents = calendar.component(.month, from: today)
            let eventsDayComponents = calendar.component(.day, from: eventDate)
            let eventsMonthComponents = calendar.component(.month, from: eventDate)
            
            let todaysDateArray: [Int] = [todaysDayComponents,todaysMonthComponents]
            let childsBirthDateArray: [Int] = [eventsDayComponents, eventsMonthComponents]
            return todaysDateArray == childsBirthDateArray
        }
        }
    



// MARK: Employee types

class FullTimeEmployee: FullTimeEmployeeType {
    let fullName: FullName
    let fullAddress: FullAddress
    var foodDiscountPercentage: Double = 0.15
    var MerchandiseDiscountPercentage: Double = 0.25
    
    init(fullName: FullName, fullAddress: FullAddress) {
        self.fullName = fullName
        self.fullAddress = fullAddress
    }

}

class HourlyEmployeeeFoodServices: FullTimeEmployee, KitchenAreaAccessible {
}

class HourlyEmployeeRideServices: FullTimeEmployee, KitchenAreaAccessible {
}

class HourlyEmployeeMaintenence: FullTimeEmployee, KitchenAreaAccessible, RideControlAreaAccessible, MaintenanceAreaAccessible {
}

class Manager: FullTimeEmployee, KitchenAreaAccessible, RideControlAreaAccessible, MaintenanceAreaAccessible, OfficeAreaAccessible {
    override init(fullName: FullName, fullAddress: FullAddress) {
        super.init(fullName: fullName, fullAddress: fullAddress)
        self.foodDiscountPercentage = 0.25
    }
}


