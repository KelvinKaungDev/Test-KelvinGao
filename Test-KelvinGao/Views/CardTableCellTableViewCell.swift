//
//  CardTableCellTableViewCell.swift
import UIKit

class CardTableCellTableViewCell: UITableViewCell {

    @IBOutlet var cardTitle: UILabel!
    @IBOutlet var cardImage: UIImageView!
    @IBOutlet var cardView: UIView!
    
    func config(title : String, cardImage : String) {
        self.cardTitle.text = title
        self.cardImage.downloaded(from: URL(string: cardImage)!)
        cardView.layer.shadowColor = UIColor.gray.cgColor
        cardView.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        cardView.layer.shadowOpacity = 1.0
        cardView.layer.masksToBounds = false
        cardView.layer.cornerRadius = 2.0
    }
    
}
