//
//  ViewModel.swift
//  BonusFactory
//
//  Created by Petrov Anton on 25.11.2021.
//

import Combine

protocol ViewModel: ObservableObject where ObjectWillChangePublisher.Output == Void {
    associatedtype State
    associatedtype Event

    var state: State { get }
    func trigger(_ event: Event)
}
