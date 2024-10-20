//
//  MainViewModel.swift
//  pohang_egrets_watch Watch App
//
//  Created by LeeWanJae on 10/19/24.
//

import SwiftUI
import Combine

class MainViewModel: ObservableObject {
    
    // MARK: - Property
    
    @Published var percent = 10.0
    @Published var waveOffset = Angle(degrees: 0)
    
    @Published var uiPosition: CGFloat = 0.0
    @Published var heartRate = 0.0
    @Published var isTrigger = false
    
    var cancellables = Set<AnyCancellable>()
    
    private var timer: Timer?
    
    // MARK: - Component
    
    let liveWorkoutUseCase = LiveWorkoutUseCase()
    
    // MARK: - Function
    
    func monitoringHeartRate(geoWidth: CGFloat) {
        liveWorkoutUseCase.$heartRate
            .receive(on: RunLoop.main)
            .sink { [weak self] newHeartRate in
                self?.heartRate = newHeartRate
                self?.updateUIPositionBasedOnHeartRate(geoWidth: geoWidth)
            }
            .store(in: &cancellables)
    }
    
    // 워크아웃 세션 시작
    func startWorkoutSession() {
        liveWorkoutUseCase.startWorkout(workoutType: .running)
    }
    
    // 워크아웃 세션 일시 정지 / 재개 토글
    func pauseWorkoutSession() {
        liveWorkoutUseCase.togglePause()
    }
    
    // 워크아웃 세션 종료
    func endWorkoutSession() {
        liveWorkoutUseCase.endWorkout()
    }
    
    /**
     workoutSession Start
     실시간 값 받아오기
     범위 최대 심박수(64%-76%) => 128 ~ 152
     양 끝 단 128이하 일 때 geo.size.width/2 , 152 이상 일 때 -geo.size.width/2
     128 ~ 152 사이일 때 geo.size.width/2 ~ -geo.size.width/2 사이에서 값의 크기에 따라 이동하게
     */
    func updateUIPositionBasedOnHeartRate(geoWidth: CGFloat) {
        let minHeartRate: Double = 128
        let maxHeartRate: Double = 152
        
        let minPosition = -geoWidth / 2
        let maxPosition = geoWidth / 2
        
        if heartRate <= minHeartRate {
            uiPosition = minPosition
        } else if heartRate >= maxHeartRate {
            uiPosition = maxPosition
        } else {
            let percentage = (heartRate - minHeartRate) / (maxHeartRate - minHeartRate)
            uiPosition = minPosition + (percentage * (maxPosition - minPosition))
        }
    }
    
    func increasingWaterPercent() {
        let duration: TimeInterval = 30.0
        let updateInterval: TimeInterval = 0.1
        let totalSteps = duration / updateInterval
        let increment = 100.0 / totalSteps
        
        timer = Timer.scheduledTimer(withTimeInterval: updateInterval, repeats: true) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            
            if self.percent >= 100 {
                self.percent = 100
                timer.invalidate()
            } else {
                self.percent += increment
            }
        }
    }
    
    func stopIncreasingPercent() {
        timer?.invalidate()
        timer = nil
    }
}
