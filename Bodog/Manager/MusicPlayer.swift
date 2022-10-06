//
//  MusicPlayer.swift
//  Bodog
//
//  Created by Anastasia Koldunova on 23.09.2022.
//

import AVFoundation

var isSilent: Bool = UserDefaults.standard.bool(forKey: "isSilent") {
    didSet {
        if isSilent {
            player?.pause()
        } else {
            player?.play()
        }
    }
}

var player: AVAudioPlayer?

func playBackgroundMusic() {
    guard let url = Bundle.main.url(forResource: "backgroundMusic",
                                    withExtension: "wav") else { return }
    //    guard !isSilent else { return }
    
    do {
        try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
        try AVAudioSession.sharedInstance().setActive(true)
        
        player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)
        
        guard let player = player else { return }
        
        player.volume = 0.5
        player.numberOfLoops = -1
        
        player.play()
        
    } catch let error {
        print(error.localizedDescription)
    }
}
