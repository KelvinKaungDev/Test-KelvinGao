import UIKit

class BannerTableViewCell: UITableViewCell {

    @IBOutlet var cardView: UIView!
    @IBOutlet var cardImage: UIImageView!
    
    func config(cardImage : String) {
        self.cardImage.downloaded(from: URL(string: "https://images.freeimages.com/images/large-previews/cc5/the-bulk-1641574.jpg")!)
        cardView.layer.shadowColor = UIColor.gray.cgColor
        cardView.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        cardView.layer.shadowOpacity = 1.0
        cardView.layer.masksToBounds = false
        cardView.layer.cornerRadius = 2.0
    }

}
