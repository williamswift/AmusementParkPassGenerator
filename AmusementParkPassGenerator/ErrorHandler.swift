//
//  ErrorHandler.swift
//  AmusementParkPassGenerator
//
//  Created by William Vivas on 5/19/17.
//  Copyright © 2017 William Vivas. All rights reserved.
//

import Foundation


// MARK : error types

enum InputError : Error {
    case firstNameFieldEmpty
    case lastNameEmpty
    case streetAddressIsEmpty
    case cityIsEmpty
    case stateIsEmpty
    case zipCodeIsEmpty
    case childIsOlderThanFive
    case notGuestsBirthday
}

enum BirthdayError: Error {
    case InvalidBirthday
    case TooOldForDiscount

}
