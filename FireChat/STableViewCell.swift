//
//  STableViewCell.swift
//  FireChat
//
//  Created by hackeru on 19 Kislev 5778.
//  Copyright © 5778 hackeru. All rights reserved.
//

import UIKit
protocol BtnDelegate {
    func didSelect(movie: String)
    //0546141022 almog
}
class STableViewCell: UITableViewCell {
    var delegate: BtnDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    var movie: String!
    @IBAction func btn(sender:UIButton){
        delegate?.didSelect(movie: movie)
    }

}
