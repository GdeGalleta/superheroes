//
//  DecoderFactory.swift
//  Superheroes
//
//  Created by Dimitri Sopov on 16/3/22.
//

import Foundation

public protocol GenericDecoderFactory {
    associatedtype Input
    associatedtype Output
    func decode(dto: Input) -> Output
}
