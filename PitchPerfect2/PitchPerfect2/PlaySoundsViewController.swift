//
//  PlaySoundsViewController.swift
//  PitchPerfect2
//
//  Created by William Song on 3/11/15.
//  Copyright (c) 2015 Bill Song. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var audioPlayer:AVAudioPlayer!
    var audioPlayer2:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEngine: AVAudioEngine!
    var audioFile:AVAudioFile!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
        
        
        audioPlayer2 = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer2.enableRate = true
        audioPlayer2.prepareToPlay()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func playSlowAudio(sender: AnyObject) {
        stopAndReset()
        audioPlayer.rate = 0.5
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    @IBAction func playFastAudio(sender: AnyObject) {
        stopAndReset()
        audioPlayer.rate = 2.0
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }

    @IBAction func playChipmunkAudio(sender: AnyObject) {
       playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playDarthvaderAudio(sender: AnyObject) {
        playAudioWithVariablePitch(-1000)
    }
    
    @IBAction func playEchoAudio(sender: AnyObject) {
        stopAndReset()
        audioPlayer.rate = 1.5
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
        
        audioPlayer2.rate = 1.0
        audioPlayer2.currentTime = 0.0
        audioPlayer2.play()
    }
    
    @IBAction func playReverbAudio(sender: AnyObject) {
        stopAndReset()
        applyReverb()
    }
    
    
    func applyReverb() {
        let error = NSError()
        let url = receivedAudio.filePathUrl
        audioEngine = AVAudioEngine()
        var playerNode = AVAudioPlayerNode()
        audioEngine.attachNode(playerNode)
        let file = AVAudioFile(forReading: url, error: nil)
        var reverb = AVAudioUnitReverb()
        reverb.wetDryMix = 50
        audioEngine.attachNode(reverb)
        let mainMixer = audioEngine.mainMixerNode
        audioEngine.connect(playerNode, to: reverb, format: file.processingFormat)
        audioEngine.connect(reverb, to: audioEngine.outputNode, format: file.processingFormat)
        playerNode.scheduleFile(file, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        playerNode.play()
    }
    
    func playAudioWithVariablePitch(pitch: Float){
        stopAndReset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()

    }
    func stopAndReset(){
        audioPlayer.stop()
        audioPlayer2.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    @IBAction func btnStopPlay(sender: AnyObject) {
        audioPlayer.stop()
        audioPlayer2.stop()
        audioEngine.stop()
    }
}
