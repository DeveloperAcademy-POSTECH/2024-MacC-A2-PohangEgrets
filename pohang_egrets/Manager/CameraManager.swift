//
//  CameraManager.swift
//  pohang_egrets
//
//  Created by LeeWanJae on 10/7/24.
//

import AVFoundation
import UIKit

protocol CameraManagerDelegate: AnyObject {
    func cameraManager(_ manager: CameraManager, didOutput sampleBuffer: CMSampleBuffer)
}

class CameraManager: NSObject {
    
    weak var delegate: CameraManagerDelegate?
    
    private var captureSession: AVCaptureSession?
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    private var videoDataOutput: AVCaptureVideoDataOutput?
    
    override init() {
        super.init()
        setupSession()
    }
    
    private func setupSession() {
        captureSession = AVCaptureSession()
        captureSession?.sessionPreset = .high // high의 경우 프레임 기본 30
        
        guard let captureSession = captureSession else { return }
        
        guard let frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
              let input = try? AVCaptureDeviceInput(device: frontCamera) else {
            print("전면 카메라 장치 설정 실패")
            return
        }
        
        captureSession.addInput(input)
        
        do {
            try frontCamera.lockForConfiguration()
            frontCamera.activeVideoMinFrameDuration = CMTimeMake(value: 1, timescale: 30)  // 최소 프레임 속도 조절
            frontCamera.activeVideoMaxFrameDuration = CMTimeMake(value: 1, timescale: 30)  // 최대 프레임 속도 조절
            frontCamera.unlockForConfiguration()
        } catch {
            print("카메라 설정 실패: \(error.localizedDescription)")
        }
        
        videoDataOutput = AVCaptureVideoDataOutput()
        videoDataOutput?.setSampleBufferDelegate(self, queue: DispatchQueue(label: "VideoDataOutputQueue"))
        if let videoDataOutput = videoDataOutput {
            captureSession.addOutput(videoDataOutput)
        }
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = .resizeAspectFill
    }
    
    func getPreviewLayer() -> AVCaptureVideoPreviewLayer? {
        return videoPreviewLayer
    }
    
    func startSession() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession?.startRunning()
        }
    }
    
    func stopSession() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession?.stopRunning()
        }
    }
}

extension CameraManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        delegate?.cameraManager(self, didOutput: sampleBuffer)
    }
}
