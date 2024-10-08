//
//  ViewController.swift
//  pohang_egrets
//
//  Created by LeeWanJae on 10/7/24.
//

import UIKit
import AVFoundation
import Vision
import simd

class ViewController: UIViewController {
    let cameraManager = CameraManager()
    let bodyTrackingManager = BodyTrackingManager()
    var previewLayer: AVCaptureVideoPreviewLayer?
    var overlayLayer = CALayer()
    
    var jointAveragePoints: [VNHumanBodyPose3DObservation.JointName: CGPoint] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        cameraManager.delegate = self
        bodyTrackingManager.delegate = self
        
        if let previewLayer = cameraManager.getPreviewLayer() {
            self.previewLayer = previewLayer
            previewLayer.frame = view.bounds
            view.layer.insertSublayer(previewLayer, at: 0)
            
            overlayLayer.frame = view.bounds
            view.layer.addSublayer(overlayLayer)
        }
        
        cameraManager.startSession()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cameraManager.stopSession()
    }
}

extension ViewController: CameraManagerDelegate {
    func cameraManager(_ manager: CameraManager, didOutput sampleBuffer: CMSampleBuffer) {
        bodyTrackingManager.processFrame(sampleBuffer: sampleBuffer)
    }
}

extension ViewController: BodyTrackingManagerDelegate {
    func bodyTrackingManager(_ manager: BodyTrackingManager, didDetect observations: [VNHumanBodyPose3DObservation]) {
        
        do {
            guard let observation = observations.first else { return }
            
            DispatchQueue.main.async {
                self.drawBodyPose(observation: observation)
            }
        }
    }
}

extension ViewController {
    
    // MARK: - Method to clear the overlay layer
    
    private func clearOverlayLayer() {
        overlayLayer.sublayers?.forEach { $0.removeFromSuperlayer() }
    }

    // MARK: - drawBodyPose
    
    private func drawBodyPose(observation: VNHumanBodyPose3DObservation) {
        guard let previewLayer = self.previewLayer else { return }

        // 기존의 라인과 포인트를 지움
        clearOverlayLayer()

        do {
            let recognizedPoints = try observation.recognizedPoints(.all)
            
            // 새로운 CAShapeLayer 생성
            let shapeLayer = CAShapeLayer()
            let path = UIBezierPath()

            let jointPairs: [(VNHumanBodyPose3DObservation.JointName, VNHumanBodyPose3DObservation.JointName)] = [
                (.centerShoulder, .centerHead),  //neck -> centerShoulder, nose -> centerHead
                (.centerShoulder, .leftShoulder),
                (.centerShoulder, .rightShoulder),
                (.leftShoulder, .leftElbow),
                (.leftElbow, .leftWrist),
                (.rightShoulder, .rightElbow),
                (.rightElbow, .rightWrist),
                (.leftShoulder, .leftHip),
                (.rightShoulder, .rightHip),
                (.leftHip, .rightHip),
                (.leftHip, .leftKnee),
                (.leftKnee, .leftAnkle),
                (.rightHip, .rightKnee),
                (.rightKnee, .rightAnkle)
            ]
            
            for (jointA, jointB) in jointPairs {
                guard observation.confidence > 0.8 else {
                    continue
                }

                let screenWidth = view.bounds.width
                let screenHeight = view.bounds.height

                // 각 관절의 위치를 가져오기
                let pointALocationNormCG = try CGPoint(x: observation.pointInImage(jointA).location.x, y: observation.pointInImage(jointA).location.y)
                let pointBLocationNormCG = try CGPoint(x: observation.pointInImage(jointB).location.x, y: observation.pointInImage(jointB).location.y)
                
                // 누적 평균 좌표로 변환
                let updatedPointA = updatePoint(for: jointA, with: pointALocationNormCG, method: .average)
                let updatedPointB = updatePoint(for: jointB, with: pointBLocationNormCG, method: .average)
                
                // 화면 좌표로 변환
                let pointALocation = CGPoint(x: updatedPointA.y * screenWidth, y: updatedPointA.x * screenHeight)
                let pointBLocation = CGPoint(x: updatedPointB.y * screenWidth, y: updatedPointB.x * screenHeight)

                
                // 경로에 선 추가
                path.move(to: pointALocation)
                path.addLine(to: pointBLocation)
            }
            
            // Path를 CAShapeLayer에 설정
            shapeLayer.path = path.cgPath
            shapeLayer.strokeColor = UIColor.green.cgColor
            shapeLayer.lineWidth = 2.0
            
            // 원 그리기 (중심점)
            let point = VNPoint(x: 0, y: 0)
            let pointLocation = CGPoint(x: point.location.x, y: 1 - point.location.y)
            let convertedPoint = previewLayer.layerPointConverted(fromCaptureDevicePoint: pointLocation)
            
            let circlePath = UIBezierPath(arcCenter: convertedPoint, radius: 5, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
            let circleShapeLayer = CAShapeLayer()
            circleShapeLayer.path = circlePath.cgPath
            circleShapeLayer.fillColor = UIColor.blue.cgColor
            
            // CAShapeLayer 추가
            overlayLayer.addSublayer(shapeLayer)
            overlayLayer.addSublayer(circleShapeLayer)
        } catch {
            print("관절 포인트를 가져오는 중 오류 발생: \(error)")
        }
    }
    
    // 관절 좌표의 평균을 계산하는 함수
    private func updatePoint(for joint: VNHumanBodyPose3DObservation.JointName, with newPoint: CGPoint, method: CalculationMethod) -> CGPoint {
        // 이전에 저장된 좌표가 있다면 불러오기
        
        switch method {
        case .average:
            print("average")
            return calculateAveragePoint(for: joint, with: newPoint)
        case .median:
            return calculateAveragePoint(for: joint, with: newPoint)
        }
    }
    
    private func calculateAveragePoint(for joint: VNHumanBodyPose3DObservation.JointName, with newPoint: CGPoint) -> CGPoint {
        
        let previousPoint = jointAveragePoints[joint] ?? newPoint
        
        let averagedX = (previousPoint.x * 0.7) + (newPoint.x * 0.3)
        let averagedY = (previousPoint.y * 0.7) + (newPoint.y * 0.3)
        
        let averagedPoint = CGPoint(x: averagedX, y: averagedY)
        
        // 딕셔너리에 업데이트된 좌표 저장
        jointAveragePoints[joint] = averagedPoint
        
        return averagedPoint
    }
    
    
    enum CalculationMethod {
        case average, median
    }
}
