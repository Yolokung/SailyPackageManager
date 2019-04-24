//
//  Saily_UI_Tweak_Webkit.swift
//  Saily Package Manager
//
//  Created by Lakr Aream on 2019/4/22.
//  Copyright © 2019 Lakr233. All rights reserved.
//

import UIKit
import WebKit

import NVActivityIndicatorView

class Saily_UI_Tweak_Webkit: UIViewController, WKNavigationDelegate {

    public var this_package: packages_C? = nil
    @IBOutlet weak var container: UIScrollView!
    @IBOutlet weak var this_Web: WKWebView!
    @IBOutlet weak var bundleID: UILabel!
    
    let loading_view = NVActivityIndicatorView(frame: CGRect(), type: .circleStrokeSpin, color: #colorLiteral(red: 0.01864526048, green: 0.4776622653, blue: 1, alpha: 1), padding: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("[*] Catch package info:")
        print(self.this_package?.info as Any)
        
        this_Web.navigationDelegate = self
        
        guard let depiction = self.this_package?.info["DEPICTION"] else {
            let non_view = UIImageView()
            non_view.image = #imageLiteral(resourceName: "mafumafu_dead_rul.png")
            non_view.contentMode = .scaleAspectFit
            self.container.addSubview(non_view)
            non_view.snp.makeConstraints { (c) in
                c.center.equalTo(self.this_Web.snp.center)
                c.width.equalTo(128)
                c.height.equalTo(128)
            }
            let non_connection = UILabel.init(text: "Error: -0x000de01c210n - No DEPICTION URL")
            non_connection.textColor = .gray
            non_connection.font = .boldSystemFont(ofSize: 12)
            self.container.addSubview(non_connection)
            non_connection.snp.makeConstraints { (x) in
                x.centerX.equalTo(self.this_Web.snp.centerX)
                x.top.equalTo(non_view.snp.bottom).offset(28)
                x.height.equalTo(25)
            }
            return
        }
        if let urldep = URL.init(string: depiction) {
            print("[*] Attempt to connect for depiction: " + urldep.description)
            var customRequest = URLRequest(url: urldep)
            customRequest.setValue("zh-CN,en,*", forHTTPHeaderField: "Accept-Language")
            customRequest.setValue("*/*", forHTTPHeaderField: "Accept")
            customRequest.setValue("gzip, deflate", forHTTPHeaderField: "Accept-Encoding")
            customRequest.setValue(CydiaNetwork.UA_Default, forHTTPHeaderField: "User-Agent")
            customRequest.setValue(CydiaNetwork.H_Firmware, forHTTPHeaderField: "X-Firmware")
            customRequest.setValue(CydiaNetwork.H_UDID, forHTTPHeaderField: "X-Unique-ID")
            customRequest.setValue(CydiaNetwork.H_Machine, forHTTPHeaderField: "X-Machine")
            customRequest.timeoutInterval = 8
            this_Web!.load(customRequest)
            this_Web.scrollView.isScrollEnabled = false
            self.view.addSubview(loading_view)
            loading_view.snp.makeConstraints { (c) in
                c.center.equalTo(self.this_Web.snp.center)
                c.width.equalTo(23)
                c.height.equalTo(23)
            }
            loading_view.startAnimating()
        }else{
            let non_view = UIImageView()
            non_view.image = #imageLiteral(resourceName: "mafumafu_dead_rul.png")
            non_view.contentMode = .scaleAspectFit
            self.container.addSubview(non_view)
            non_view.snp.makeConstraints { (c) in
                c.center.equalTo(self.this_Web.snp.center)
                c.width.equalTo(128)
                c.height.equalTo(128)
            }
            let non_connection = UILabel.init(text: "Error: -0xbadde01c210n - BAD DEPICTION URL")
            non_connection.textColor = .gray
            non_connection.font = .boldSystemFont(ofSize: 12)
            self.container.addSubview(non_connection)
            non_connection.snp.makeConstraints { (x) in
                x.centerX.equalTo(self.this_Web.snp.centerX)
                x.top.equalTo(non_view.snp.bottom).offset(28)
                x.height.equalTo(25)
            }
            return
        }

        
    }
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        self.this_Web.evaluateJavaScript("document.readyState", completionHandler: { (complete, error) in
            if complete != nil {
                self.this_Web.evaluateJavaScript("document.body.scrollHeight", completionHandler: { (height, error) in
                    print("[*] This web page is with height: " + height.debugDescription)
                })
            }
        })
        
        loading_view.stopAnimating()
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

