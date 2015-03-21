//
//  RecordSoundsViewController.swift
//  PitchPerfect2
//
//  Created by William Song on 3/6/15.
//  Copyright (c) 2015 Bill Song. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController,AVAudioRecorderDelegate {
    
    var recordedAudio:RecordedAudio!
    var audioRecorder:AVAudioRecorder!

    @IBOutlet weak var recordingMsg: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var btnRecord: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        recordingMsg.text = "Tap to Record"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        stopButton.hidden = true
    }

    @IBAction func recordSound(sender: UIButton) {
        recordingMsg.text = "Recording"
        stopButton.hidden = false
        btnRecord.enabled = false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
        
    }
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if(flag){
        
            recordedAudio = RecordedAudio(url: recorder.url, title: recorder.url.lastPathComponent!)
            //connect segue
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }else
        {
            println("Recording was not successful")
            stopButton.hidden = true
            btnRecord.enabled = true
            
        }
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "stopRecording"){
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController
            let data = sender as RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    @IBAction func btnStop(sender: AnyObject) {
        recordingMsg.text = "Tap to Record"
         btnRecord.enabled = true
        
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
}

