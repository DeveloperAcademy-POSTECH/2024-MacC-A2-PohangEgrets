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
            let screenSize = geo.size
            let circleSize: CGFloat = screenSize.width * 0.66
            
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    VStack {
                        Text("\(Int(viewModel.heartRate))")
                            .font(Font.system(size: 20, weight: .bold))
                        Text("BPM")
                            .font(Font.system(size: 12, weight: .bold))
                    }
                    .padding(.trailing, 12)
                }
                .padding(.top, -20)

                Button {
                    viewModel.isTrigger.toggle()
                    
                    if viewModel.isTrigger == true {
                        viewModel.startWorkoutSession()
                        viewModel.increasingWaterPercent()
                        withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                            viewModel.waveOffset = Angle(degrees: 360)
                        }
                        viewModel.updateUIPositionBasedOnHeartRate(geoWidth: screenSize.width)
                        viewModel.monitoringHeartRate(geoWidth: screenSize.width)
                    } else {
                        viewModel.endWorkoutSession()
                        viewModel.stopIncreasingPercent()
                    }
                } label: {
                    ZStack {
                        Circle()
                            .fill(Color.clear)
                            .stroke(.circleBg, lineWidth: 10)
                            .frame(width: circleSize, height: circleSize)
                            .overlay(
                                ZStack {
                                    Wave(offSet: viewModel.waveOffset, percent: viewModel.percent)
                                        .fill(Color.circleBg)
                                    Text("START")
                                        .foregroundStyle(viewModel.isTrigger ? .clear : .white)
                                        .font(Font.system(size: 24, weight: .bold))
                                }
                            )
                            .clipShape(Circle())
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .offset(x: viewModel.uiPosition)
                .animation(.easeIn(duration: 1), value: viewModel.uiPosition)
                .onDisappear {
                    viewModel.endWorkoutSession()
                    viewModel.stopIncreasingPercent()
                }
                .ignoresSafeArea(.all)
                
                Spacer()
            }
        }
    }
}

#Preview {
    MainView()
}
