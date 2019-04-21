//
//  Saily_UI_Discover_Detail.swift
//  Saily Package Manager
//
//  Created by Lakr Aream on 2019/4/22.
//  Copyright © 2019 Lakr233. All rights reserved.
//

import UIKit

class Saily_UI_Discover_Detail: UITableViewController {

    public var discover_item = discover_C()
    
    public var objects = [UIView]()
    
    func apart_init(str: String) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorColor = .clear
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.objects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "idCell") ?? UITableViewCell.init(style: .subtitle, reuseIdentifier: "theCell")
        cell.contentView.addSubview(self.objects[indexPath.row])
        self.objects[indexPath.row].snp.makeConstraints { (c) in
            c.top.equalTo(cell.contentView.snp_top)
            c.left.equalTo(cell.contentView.snp_left)
            c.right.equalTo(cell.contentView.snp_right)
            c.bottom.equalTo(cell.contentView.snp_bottom)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return objects[indexPath.row].bounds.height
    }

}
