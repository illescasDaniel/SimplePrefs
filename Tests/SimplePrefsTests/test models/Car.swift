//
//  File.swift
//  
//
//  Created by Daniel Illescas Romero on 10/02/2020.
//

import Foundation

class Car: Codable {

	var brand: String
	var model: String
	var year: Int
	
	init(brand: String, model: String, year: Int) {
		self.brand = brand
		self.model = model
		self.year = year
	}
	
	//
	
	enum CodingKeys: String, CodingKey {
		case brand
		case model
		case year
	}
}
extension Car: Equatable {
	static func == (lhs: Car, rhs: Car) -> Bool {
		return lhs.brand == rhs.brand && lhs.model == rhs.model && lhs.year == rhs.year
	}
}
