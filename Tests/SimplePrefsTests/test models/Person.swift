//
//  File.swift
//  
//
//  Created by Daniel Illescas Romero on 30/12/2019.
//

struct Person: Codable, Equatable {

	var name: String = ""	
	
	// optional
	enum CodingKeys: String, CodingKey {
		case name
	}
}
