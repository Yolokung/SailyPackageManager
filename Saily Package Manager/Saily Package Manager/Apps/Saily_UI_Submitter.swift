//
//  Saily_UI_Submitter.swift
//  Saily Package Manager
//
//  Created by Lakr Aream on 2019/4/29.
//  Copyright © 2019 Lakr233. All rights reserved.
//

import UIKit

import LTMorphingLabel
import NVActivityIndicatorView
import EzPopup

class Saily_UI_Submitter: UIViewController, LTMorphingLabelDelegate {
    
    @IBOutlet weak var title_install: LTMorphingLabel!
    @IBOutlet weak var text: UITextView!
    @IBOutlet weak var progress: UIProgressView!
    
    public var popVC: PopupViewController?
    public var pusher: UIViewController?
    
    public var perform_install = false
    public var perform_remove  = false
    public var perform_auto_remove = false
    
    private var job_count = 0
    private var job_queue = [Int]()
    private var job_inprogress = false
    private var job_should_abort = false
    
    private var first_trigger = true
    
    var timer: Timer?
    let progresss = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), type: .circleStrokeSpin, color: .white, padding: nil)
    
    @objc func watch_output() {
        text.text = Saily_FileU.simple_read(Saily.files.daemon_root + "/cmd.out")
        scrollTextViewToBottom(textView: text)
        if (job_should_abort == true) {
            self.title_install.text = "Error Abort!".localized()
            timer?.invalidate()
            timer = nil
            progresss.stopAnimating()
            self.popVC?.canTapOutsideToDismiss = true
            return
        }
        
        
        
        if (Saily_FileU.simple_read(Saily.files.daemon_root + "/status")?.split(separator: "\n").last?.uppercased().contains("SAILY_DONE") ?? false || self.first_trigger) {
            try? FileManager.default.removeItem(atPath: Saily.files.daemon_root)
            Saily_FileU.make_sure_file_exists_at(Saily.files.daemon_root, is_direct: true)
            first_trigger = false
            if (job_queue.count > 0) {
                // still have jobs~
                
                switch job_queue.first {
                case 101:
                    print("[Install]")
                    self.title_install.text = "Perform Install Action".localized()
                    Saily.objc_bridge.callToDaemon(with: "com.Saily.dpkg.install.perform")
                case 111:
                    print("[Remove]")
                    self.title_install.text = "Perform Remove Action".localized()
                    Saily.objc_bridge.callToDaemon(with: "com.Saily.apt.remove.perform")
                case 121:
                    print("[Auto Remove]")
                    self.title_install.text = "Perform Auto Remove Action".localized()
                    Saily.objc_bridge.callToDaemon(with: "com.Saily.apt.autoremove.perform")
                default:
                    break
                }
                
                job_queue.remove(at: 0)
                
            }else{
                //Done
                self.title_install.text = "Finished.".localized()
                timer?.invalidate()
                timer = nil
                progresss.stopAnimating()
                Saily.operation_container = installer_Unit()
                self.popVC?.canTapOutsideToDismiss = true
                return
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title_install.delegate = self
        title_install.morphingEffect = .evaporate
        
        self.view.addSubview(progresss)
        
        progresss.snp.makeConstraints { (x) in
            x.left.equalTo(self.view.snp.left).offset(18)
            x.bottom.equalTo(self.view.snp.bottom).offset(-15)
            x.width.equalTo(18)
            x.height.equalTo(18)
        }
        progresss.startAnimating()
        
        self.text.text = ""
        
        self.progress.progress = 0
        
        if (Saily.operation_container.installs.count > 0) {
            self.job_queue.append(101)
        }
        if (Saily.operation_container.removes.count > 0) {
            self.job_queue.append(111)
        }
        
        timer = Timer.scheduledTimer(timeInterval: 0.233, target: self, selector: #selector(watch_output), userInfo: nil, repeats: true)
        timer?.fire()
    }
    
    func scrollTextViewToBottom(textView: UITextView) {
        if textView.text.count > 0 {
            let location = textView.text.count - 1
            let bottom = NSMakeRange(location, 1)
            textView.scrollRangeToVisible(bottom)
        }
    }
    
    func set_progress(value: Float) {
        DispatchQueue.main.async {
            self.progress.setProgress(value, animated: true)
        }
    }


}
