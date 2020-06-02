//
//  File.swift
//  
//
//  Created by Roman Tuzhilkin on 5/28/20.
//

import Foundation

public struct HelloRequest: Codable {
    
    public init(foo: String, bar: Int) {
        self.foo = foo
        self.bar = bar
    }

    public init() {
        self.foo = ""
        self.bar = 0
    }
    
    var foo: String
    var bar: Int
}

public struct HelloReply: Codable {
    
    public init(baz: Int) {
        self.baz = baz
    }
    
    public init() {
        self.baz = 0
    }

    var baz: Int
}

public var someHelloRequest = HelloRequest.init()
public var someHelloReply = HelloReply.init()
