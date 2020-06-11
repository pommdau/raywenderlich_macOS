import UIKit

class PhotoCommentViewController: UIViewController {

  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var nameTextField: UITextField!
  
  var photoName: String?
  var photoIndex: Int!

  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let photoName = photoName {
      self.imageView.image = UIImage(named: photoName)
    }
    
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillShow(_:)),
      name: UIResponder.keyboardWillShowNotification,
      object: nil)

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillHide(_:)),
      name: UIResponder.keyboardWillHideNotification,
      object: nil)
  }
  
  func adjustInsetForKeyboardShow(_ show: Bool, notification: Notification) {
    guard
      let userInfo = notification.userInfo,
      let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey]
        as? NSValue
      else {
        return
    }
      
    let adjustmentHeight = (keyboardFrame.cgRectValue.height + 20) * (show ? 1 : -1)
    scrollView.contentInset.bottom += adjustmentHeight
    scrollView.verticalScrollIndicatorInsets.bottom += adjustmentHeight
  }
    
  @objc func keyboardWillShow(_ notification: Notification) {
    adjustInsetForKeyboardShow(true, notification: notification)
  }
  @objc func keyboardWillHide(_ notification: Notification) {
    adjustInsetForKeyboardShow(false, notification: notification)
  }
  
  @IBAction func hideKeyboard(_ sender: AnyObject) {
    nameTextField.endEditing(true)
  }

}
