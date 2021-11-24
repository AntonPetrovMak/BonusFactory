//
//  AnyViewModel.swift
//  BonusFactory
//
//  Created by Petrov Anton on 25.11.2021.
//

import Combine

final class AnyViewModel<State, Event>: ObservableObject {

    private let wrappedObjectWillChange: () -> AnyPublisher<Void, Never>
    private let wrappedState: () -> State
    private let wrappedTrigger: (Event) -> Void

    var objectWillChange: some Publisher {
        wrappedObjectWillChange()
    }

    var state: State {
        wrappedState()
    }

    func trigger(_ event: Event) {
        wrappedTrigger(event)
    }

    init<V: ViewModel>(_ viewModel: V) where V.State == State, V.Event == Event {
        self.wrappedObjectWillChange = { viewModel.objectWillChange.eraseToAnyPublisher() }
        self.wrappedState = { viewModel.state }
        self.wrappedTrigger = viewModel.trigger
    }
    
}
