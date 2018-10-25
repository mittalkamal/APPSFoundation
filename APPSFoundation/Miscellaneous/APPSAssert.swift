//
//  APPSAssert.swift
//  APPSFoundation
//
//  Created by Ken Grigsby on 2/2/17.
//  Copyright © 2017 Appstronomy, LLC. All rights reserved.
//

public func APPSAssertHardFail(_ condition: @autoclosure () -> Bool, _ message: @autoclosure () -> String = "", file: StaticString = #file, line: UInt = #line, function: StaticString = #function) {
    if !condition() {
        // Like Apple's assert no variadic parameters are allowed
        withVaList([]) { // see top of help for withVaList for explanation of this usage
            
            APPSAssertHandler.handler.assertFailure(withExpression: "",       // don't know how to convert autoclosure to string
                function: function.description,
                file: file.description,
                line: Int(line),
                description: message(),
                arguments: $0)
        }
    }
}


public func APPSAssertSoftFail(_ condition: @autoclosure () -> Bool, _ message: @autoclosure () -> String = "", file: StaticString = #file, line: UInt = #line, function: StaticString = #function) {
    if !condition() {
        // Like Apple's assert no variadic parameters are allowed
        withVaList([]) { // see top of help for withVaList for explanation of this usage
            APPSAssertHandler.handler.assertFailureOrReturn(withExpression: "",       // don't know how to convert autoclosure to string
                function: function.description,
                file: file.description,
                line: Int(line),
                description: message(),
                arguments: $0)
        }
    }
}


public func APPSAssert(_ condition: @autoclosure () -> Bool, _ message: @autoclosure () -> String = "", file: StaticString = #file, line: UInt = #line, function: StaticString = #function) {
    APPSAssertHardFail(condition, message, file: file, line: line, function: function)
}
