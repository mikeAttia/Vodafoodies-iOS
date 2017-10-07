//
//  LoadingTableDelegate.swift
//  VodaFoodies
//
//  Created by Michael Attia on 10/7/17.
//  Copyright © 2017 Michael Attia. All rights reserved.
//

import UIKit

class LoadingTableDelegate: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    @discardableResult
    init(tableView: UITableView, cellType: TempCell) {
        let tempCellNib = UINib(nibName: cellType.rawValue, bundle: nil)
        tableView.register(tempCellNib, forCellReuseIdentifier: cellType.rawValue)
        table = tableView
        tempCellType = cellType
        super.init()
    }
    
    // Variables
    var cellHeight: CGFloat{
        switch tempCellType {
        case .imgWithLabel:
            return 50
        case .labelWithDetail:
            return 40
        case .openOrderCell:
            return 90
        }
    }
    var table: UITableView
    var tempCellType: TempCell
    
    // Sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(tableView.bounds.height/cellHeight) + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tempCellType.rawValue, for: indexPath) as! GradientsOwner
        
        cell.gradientLayers.forEach { gradientLayer in
            let baseColor = UIColor(red: 239/255, green: 241/255, blue: 244/255, alpha: 1)
            gradientLayer.colors = [baseColor.cgColor,
                                    baseColor.brightened(by: 0.93).cgColor,
                                    baseColor.cgColor]
        }
        
        return cell as! UITableViewCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as? GradientsOwner
        cell?.slide(to: .right)
    }
}

enum TempCell: String {
    case openOrderCell = "OpenOrderdTempCell"
    case labelWithDetail = "labelWithDetail"
    case imgWithLabel = "ImgWithLabel"
}
