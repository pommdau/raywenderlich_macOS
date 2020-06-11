import UIKit

class PhotoCommentViewController: UIViewController {
  //1
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var nameTextField: UITextField!
  
  //2
  var photoName: String?

  override func viewDidLoad() {
    super.viewDidLoad()
    //3
    if let photoName = photoName {
      self.imageView.image = UIImage(named: photoName)
    }
  }
}
