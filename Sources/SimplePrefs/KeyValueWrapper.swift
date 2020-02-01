//
//  File.swift
//  
//
//  Created by Daniel Illescas Romero on 01/02/2020.
//

internal protocol StoragePropertyWrapper {
	
	associatedtype Wrapped
	
	var wrappedValue: Wrapped? { get set }
	
	var key: String { get }
	var defaultValue: Wrapped? { get }
	
	init<C: CodingKey>(_ key: C, defaultValue: Wrapped?)
	init(_ key: String, defaultValue: Wrapped?)
}
