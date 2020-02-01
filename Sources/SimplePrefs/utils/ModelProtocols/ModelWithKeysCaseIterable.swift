//
//  File.swift
//  
//
//  Created by Daniel Illescas Romero on 01/02/2020.
//

public protocol AllModelProperties {
	var allProperties: [Any?] { get }
}

public protocol CodableModelWithStringKeysCaseIterable: Codable {
	associatedtype CodingKeys: CodingKey, CaseIterable, RawRepresentable where CodingKeys.RawValue == String
}
