
import UIKit

class CustomTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var courseImage: UIImageView!
    @IBOutlet weak var courseName: UILabel!
    @IBOutlet weak var numberOfLessons: UILabel!
    @IBOutlet weak var numbersOfTest: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
