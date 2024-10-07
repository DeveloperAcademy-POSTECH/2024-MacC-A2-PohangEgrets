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
    
    func processFrame(sampleBuffer: CMSampleBuffer) {
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
