//
//  MainStatusViewModel.swift
//  AsyncC
//
//  Created by Hyun Lee on 11/13/24.
//

import SwiftUI

class MainStatusViewModel: ObservableObject {
    var teamManagingUseCase: TeamManagingUseCase
    var appTrackingUseCase: AppTrackingUseCase
    
    init(teamManagingUseCase: TeamManagingUseCase, appTrackingUseCase: AppTrackingUseCase) {
        self.teamManagingUseCase = teamManagingUseCase
        self.appTrackingUseCase = appTrackingUseCase
    }
    
    
}
