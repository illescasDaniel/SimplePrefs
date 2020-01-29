//
//  File.swift
//  
//
//  Created by Daniel Illescas Romero on 29/01/2020.
//

import Foundation

public final class Box<T> {
	let value: T
	init(_ value: T) {
		self.value = value
	}
}
