//
//  StartViewModel.swift
//  BonusFactory
//
//  Created by Petrov Anton on 25.11.2021.
//

import Combine

class StartViewModel: ViewModel {
    
    @Published var state: StartState
    
    init() {
        state = .init(isLoading: true)
    }

    func trigger(_ event: StartEvent) {
        
    }
}
