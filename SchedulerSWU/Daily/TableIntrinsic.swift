//
//  TableIntrinsic.swift
//  SchedulerSWU
//
//  Created by swuad_08 on 2021/08/03.
//

import UIKit

class TableIntrinsic: UITableView {
    override var intrinsicContentSize: CGSize {
        let number = numberOfRows(inSection: 0)
        var height: CGFloat = 0

        for i in 0..<number {
            guard let cell = cellForRow(at: IndexPath(row: i, section: 0)) else {
                continue
            }
            height += cell.bounds.height
        }
        return CGSize(width: contentSize.width, height: height)
    }
}
