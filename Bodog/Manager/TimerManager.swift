//
//  TimerManager.swift
//  Bodog
//
//  Created by Anastasia Koldunova on 15.09.2022.
//

import SpriteKit

protocol TimerDelegate {
    
    func setUpLabelWithSeconds(seconds : String)
    func timerHasEndedCountDown()
}


class TimerManager {
    
    enum TimerKeys {
        static var timerStarted = "timer_started_date"
    }
//MARK: - Properties
    private var timerStarted : Date?
    var seconds: Int
    var delegate: TimerDelegate?
    private var scene: SKScene
    private var isTimerRunning: Bool = false
 
    
    // MARK: - Inizializstion
    init(seconds: Int, at scene: SKScene) {
        self.seconds = seconds
        self.scene = scene
    }
  
    // MARK: - Public Methods
    func startTimer() {
        if !isTimerRunning {
            runTimer()
        }
    }
    
    func stopTimer() {
        scene.removeAction(forKey: "countdown")
        timerStarted = nil
    }
    
    func restartTimer(with seconds: Int) {
        scene.removeAction(forKey: "countdown")
        isTimerRunning = false
        self.seconds = seconds
        timerStarted = Date().addingTimeInterval(TimeInterval(seconds))
        delegate?.setUpLabelWithSeconds(seconds: timeString(time: timerStarted!.timeIntervalSinceNow))
    }
    
    //MARK: - Private Methods
    private func runTimer() {
        if timerStarted == nil {
        timerStarted = Date().addingTimeInterval(TimeInterval(seconds))
        }
        isTimerRunning = true
        let wait = SKAction.wait(forDuration: 1)
        let block = SKAction.run { [weak self] in
            guard let self = self else { return }
            self.updateTimer()
        }
        let sequance = SKAction.sequence([wait, block])
        scene.run(SKAction.repeatForever(sequance), withKey: "countdown")
    }
    
    private func updateTimer() {
        guard let timerStarted = timerStarted else { return }
        let diff = timerStarted.timeIntervalSinceNow
        if diff < 0 {
            scene.removeAction(forKey: "countdown")
            self.timerStarted = nil
            delegate?.timerHasEndedCountDown()
        } else {
            delegate?.setUpLabelWithSeconds(seconds: timeString(time: diff))
        }
    }
    
    private func timeString(time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format: "%02i:%02i%:%02i", hours, minutes, seconds)
    }
}
