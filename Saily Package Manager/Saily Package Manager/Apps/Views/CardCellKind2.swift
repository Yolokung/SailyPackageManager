//
//  CardCellKind1.swift
//  Saily Package Manager
//
//  Created by Lakr Aream on 2019/4/19.
//  Copyright © 2019 Lakr233. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire

class CardCellKind2: UIView {
    
    var heroID_title = String()
    var heroIF_image = String()
    
    var BGImage = UIImageView()
    var BigTitle = UITextView()
    var SamllTitle = UILabel()
    var DetailText = UITextView()
    
    func apart_download_image_and_init(_ imgView: UIImageView, link: String) {
        Saily.operation_quene.network_queue.async {
            print("[*] Attempt to download image at: " + link)
            if (Saily_FileU.exists(file_path: Saily.files.image_cache + "/" + (link.split(separator: "/").last?.description ?? ""))) {
                let data = (try? Data.init(contentsOf: URL.init(fileURLWithPath: Saily.files.image_cache + "/" + (link.split(separator: "/").last?.description ?? "")!)))!
                DispatchQueue.main.async {
                    self.BGImage.image = UIImage.init(data: data)
                }
                print("[*] Returned cache.")
                return
            }
            guard let url = URL.init(string: link) else {
                return
            }
            AF.download(url).responseData(completionHandler: { (data_res) in
                if (data_res.value == nil) {
                    return
                }
                guard let image = UIImage.init(data: data_res.value!) else {
                    return
                }
                print("[*] Saving image to: " + Saily.files.image_cache + "/" + (link.split(separator: "/").last?.description ?? ""))
                FileManager.default.createFile(atPath: Saily.files.image_cache + "/" + (link.split(separator: "/").last?.description ?? ""), contents: data_res.value, attributes: nil)
                DispatchQueue.main.async {
                    print("[*] Image downloaded.")
                    self.BGImage.image = image
                }
            })
            
        }
    }
    
    func apart_init(_ ins: discover_C, fater_View: UIView) {
        
        self.BGImage.image = #imageLiteral(resourceName: "PlaceHolder.png")
        self.BGImage.contentMode = .scaleAspectFill
        self.BGImage.clipsToBounds = true
        self.BigTitle.text = ins.title_big
        self.BigTitle.font = UIFont.systemFont(ofSize: 26)
        self.BigTitle.textColor = .gray
        self.BigTitle.backgroundColor = .clear
        self.SamllTitle.text = ins.title_small
        self.SamllTitle.font = UIFont.systemFont(ofSize: 16)
        self.SamllTitle.textColor = .lightGray
        self.DetailText.text = ins.text_details
        self.DetailText.backgroundColor = .clear
        self.DetailText.textColor = .white
        
        self.heroID_title = UUID().uuidString
        self.heroIF_image = UUID().uuidString
        
        DispatchQueue.main.async {
            self.DetailText.scrollToTop()
        }

        self.apart_download_image_and_init(self.BGImage, link: ins.image_link)
        
        fater_View.addSubview(BGImage)
        fater_View.addSubview(BigTitle)
        fater_View.addSubview(SamllTitle)
        
        let text_cover = UIImageView()
        text_cover.image = #imageLiteral(resourceName: "upshade.png")
        text_cover.contentMode = .scaleToFill
        text_cover.alpha = 0.8
        fater_View.addSubview(text_cover)
        
        fater_View.addSubview(DetailText)
        
        BigTitle.snp.makeConstraints { (c) in
            c.top.equalTo(fater_View.snp_top).offset(40)
            c.left.equalTo(fater_View.snp_left).offset(22)
            c.right.equalTo(fater_View.snp_right).offset(-22)
            c.height.equalTo(80)
        }
        BGImage.snp.makeConstraints { (c) in
            c.top.equalTo(BigTitle.snp_bottom).offset(12)
            c.bottom.equalTo(fater_View.snp_bottom)
            c.left.equalTo(fater_View.snp_left)
            c.right.equalTo(fater_View.snp_right)
        }
        SamllTitle.snp.makeConstraints { (c) in
            c.top.equalTo(fater_View.snp_top).offset(25)
            c.left.equalTo(fater_View.snp_left).offset(28.5)
        }
        DetailText.snp.makeConstraints { (c) in
            c.bottom.equalTo(fater_View.snp_bottom).offset(-10)
            c.left.equalTo(fater_View.snp_left).offset(22)
            c.right.equalTo(fater_View.snp_right).offset(-22)
            c.height.equalTo(70)
        }
        text_cover.snp.makeConstraints { (c) in
            c.bottom.equalTo(fater_View.snp_bottom)
            c.left.equalTo(fater_View.snp_left)
            c.right.equalTo(fater_View.snp_right)
            c.height.equalTo(100)
        }
        
        
    }

}
