//
//  MainView.swift
//  pohang_egrets_watch Watch App
//
//  Created by LeeWanJae on 10/19/24.
//

import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = MainViewModel()
    
    var body: some View {
        GeometryReader { geo in
            let size = geo.size
            let circleSize: CGFloat = size.width / 2.5
            let circleRadius = circleSize / 2
            
            VStack {
                Spacer()
                Text("\(viewModel.heartRate)")
                    .foregroundStyle(.white)

                Circle()
                    .fill(Color.clear)
                    .stroke(Color.gray, lineWidth: 2)
                    .frame(width: circleSize, height: circleSize)
                    .overlay(
                        Wave(offSet: viewModel.waveOffset, percent: viewModel.percent)
                            .fill(Color.blue)
                    )
                    .clipShape(Circle())
                    .offset(x: viewModel.uiPosition)
                    .animation(.easeIn(duration: 1), value: viewModel.uiPosition)
                    .onAppear {
                        viewModel.startWorkoutSession()
                        viewModel.increasingWaterPercent()
                        withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                            viewModel.waveOffset = Angle(degrees: 360)
                        }
                        viewModel.updateUIPositionBasedOnHeartRate(geoWidth: size.width, circleRadius: circleRadius)
                        viewModel.monitoringHeartRate(geoWidth: size.width, circleRadius: circleRadius)
                    }
                    .onChange(of: viewModel.liveWorkoutUseCase.heartRate) {
                        print("view: \(viewModel.liveWorkoutUseCase.heartRate)")
                        viewModel.updateUIPositionBasedOnHeartRate(geoWidth: size.width, circleRadius: circleRadius)
                    }
                    .onDisappear {
                        viewModel.endWorkoutSession()
                        viewModel.stopIncreasingPercent()
                    }
                Spacer()
            }
        }
    }
}


#Preview {
    MainView()
}
