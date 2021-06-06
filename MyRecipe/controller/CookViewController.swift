//
//  CookViewController.swift
//  MyRecipe
//
//  Created by Tim Sun on 6/6/21.
//

import UIKit

class CookViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    var totalseconds = 0
    var seconds = 0
    var minutes = 0
    var hour = 0
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var timeSelecter: UIPickerView!
    
    @IBAction func start(_ sender: Any) {
        displayHMS(hour: hour, minutes: minutes, seconds: seconds)
        startTimer()
        //total seconds for countdown display for hour and minutes
        totalseconds = hour*3600 + minutes*60 + seconds
        startButton.isEnabled = false
        stopButton.isEnabled = true
        //disable picker to avoid a bug
        timeSelecter.isUserInteractionEnabled = false
        
    }
    //display hms with two digits
    func displayHMS(hour: Int, minutes: Int, seconds: Int){
        time.text = "\(String(format: "%02d",hour)):\(String(format: "%02d",minutes)):\(String(format: "%02d",seconds))"
    }
    //force stop
    @IBAction func stop(_ sender: Any) {
        self.totalseconds = 0
        timeSelecter.isUserInteractionEnabled = true
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    //number of rows
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
               case 0:
                   return 24
               case 1:
                   return 60
               case 2:
                   return 60
               default:
                   return 0
               }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            switch component {
            //display with units
            case 0:
                return "\(row) hours"
            case 1:
                return "\(row) min."
            case 2:
                return "\(row) sec."
            default:
                return ""
            }
        }
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            switch component {
            case 0:
                hour = row
            case 1:
                minutes = row
            case 2:
                seconds = row
            default:
                break;
            }
        }
    //reduce the time by 1 second
    func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [self] timer in
            self.totalseconds -= 1
            //time up
            if self.totalseconds == -1 {
                timer.invalidate()
                time.text = "Time's Up!"
                self.seconds = 0
                startButton.isEnabled = true
                stopButton.isEnabled = false
                timeSelecter.isUserInteractionEnabled = true
            } else {
                //keep updating
                var (h,m,s) = secondsToHMS(seconds: totalseconds)
                displayHMS(hour: h, minutes: m, seconds: s)
            }
        }
    }
    //convert seconds to hour,minutes and seconds
    func secondsToHMS(seconds : Int) -> (Int, Int, Int) {
        //s:remainder of hours->mins
      return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timeSelecter.dataSource = self
        timeSelecter.delegate = self
        //hide the stop button at the begining
        stopButton.isEnabled = false
    }
}
