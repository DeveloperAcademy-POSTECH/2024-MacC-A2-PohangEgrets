//
//  BodyTrackingManager.swift
//  pohang_egrets
//
//  Created by LeeWanJae on 10/7/24.
//

import Vision
import AVFoundation

protocol BodyTrackingManagerDelegate: AnyObject {
    func bodyTrackingManager(_ manager: BodyTrackingManager, didDetect observations: [VNHumanBodyPose3DObservation])
}

class BodyTrackingManager {
    
    weak var delegate: BodyTrackingManagerDelegate?
    private let sequenceRequestHandler = VNSequenceRequestHandler()
    
    // 마지막으로 트래킹 요청이 실행된 시간
    private var lastRequestTime: TimeInterval = 0
    
    // 트래킹 요청 간격 
    private let requestInterval: TimeInterval = 0.05
    
    func processFrame(sampleBuffer: CMSampleBuffer) {
        let currentTime = CACurrentMediaTime()
        
        // 요청 주기 제한: 마지막 요청 후 일정 시간이 지났을 때만 실행
        if currentTime - lastRequestTime < requestInterval {
            return
        }
        
        // 마지막 요청 시간을 현재 시간으로 업데이트
        lastRequestTime = currentTime
        
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        let request = VNDetectHumanBodyPose3DRequest { [weak self] (request, error) in
            if let error = error {
                print("바디 트래킹 요청 실패: \(error)")
                return
            }
            
            if let observations = request.results as? [VNHumanBodyPose3DObservation], !observations.isEmpty {
                DispatchQueue.main.async {
                    self?.delegate?.bodyTrackingManager(self!, didDetect: observations)
                }
            }
        }
        
        do {
            try sequenceRequestHandler.perform([request], on: pixelBuffer)
        } catch {
            print("Vision 요청 수행 중 오류 발생: \(error)")
        }
    }
}
