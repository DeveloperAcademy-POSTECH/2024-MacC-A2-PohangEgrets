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
            
            // 이전 Line, Point 지우기
            
            clearOverlayLayer()
            
            let torso = try observation.recognizedPoints(.torso)
            let leftArm = try observation.recognizedPoints(.leftArm)
            if torso[.rightShoulder] != nil {
                
            // MARK: - cameraRelativePosition 예시 코드
                
                let rightShoulderPosition = try observation.cameraRelativePosition(.rightShoulder)
                print("rightShoulder Camera Position: \(rightShoulderPosition)")
            }
            
            // MARK: - x,y,z(단위 m) 예시 코드
            
            guard let rightShoulder = torso[.rightShoulder] else { return }
            
            let rightPosition = rightShoulder.localPosition
            let translationright = simd_make_float3(rightPosition.columns.3[0],
                                                    rightPosition.columns.3[1],
                                                    rightPosition.columns.3[2])
            print("rightShoulder / x: \(translationright.x * 100), y: \(translationright.y * 100), z: \(translationright.z * 100)")
            print("\(observation.parentJointName(.rightShoulder))")
            
            // MARK: - pointInImage 예시 코드
            
            let centerHead2D = try observation.pointInImage(.centerHead).location
            print("pointInImage centerHead:\(centerHead2D)")
            let centerShoulder2D = try observation.pointInImage(.centerShoulder).location
            print("pintInImage centerShoulder:\(centerShoulder2D)")
            
            // MARK: - pointInImage 값으로 Line, Point 찍기
            
            let centerHeadPoint = convertToScreenCoordinates(point: centerHead2D)
            let centerShoulderPoint = convertToScreenCoordinates(point: centerShoulder2D)
            
            drawLine(from: centerHeadPoint, to: centerShoulderPoint, color: UIColor.green.cgColor)
            drawPoint(at: centerHeadPoint, color: UIColor.green.cgColor)
        } catch {
            print("error")
        }
    }
}

extension ViewController {
    
    // MARK: - Line

    private func drawLine(from start: CGPoint, to end: CGPoint, color: CGColor) {
        let path = UIBezierPath()
        path.move(to: start)
        path.addLine(to: end)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 2.0
        
        overlayLayer.addSublayer(shapeLayer)
    }
    
    // MARK: - Point
    
    private func drawPoint(at position: CGPoint, color: CGColor) {
        let circlePath = UIBezierPath(arcCenter: position, radius: 5, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = color
        
        overlayLayer.addSublayer(shapeLayer)
    }
    
    // MARK: - Method to clear the overlay layer

    private func clearOverlayLayer() {
        overlayLayer.sublayers?.forEach { $0.removeFromSuperlayer() }
    }
    
    // MARK: - Method to convert normalized (0.0 - 1.0) points to screen coordinates
    
    private func convertToScreenCoordinates(point: CGPoint) -> CGPoint {
        let x = point.x * view.bounds.width
        let y = point.y * view.bounds.height
        return CGPoint(x: x, y: y)
    }
}
