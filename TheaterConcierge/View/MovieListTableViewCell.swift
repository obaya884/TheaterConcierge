//
//  MovieListTableViewCell.swift
//  TheaterConcierge
//
//  Created by 大林拓実 on 2019/10/05.
//  Copyright © 2019 大林拓実. All rights reserved.
//

import UIKit

final class MovieListTableViewCell: UITableViewCell {
    
    @IBOutlet var movieTitleLabel: UILabel!
    @IBOutlet var appreciationDateLabel: UILabel!
    @IBOutlet var rightAngleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        rightAngleLabel.font = UIFont(name: "FontAwesome5Free-Solid", size: 17)
        rightAngleLabel.text = "angle-right"
        contentView.backgroundColor = UIColor(hex: "7697CA")
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
