/*
 * ViewController
 * This class is used to Upload the image through ImagePickerController
 * @category   upload Image
 * @package    com.contus.today
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2018 Contus. All rights reserved.
 */
import UIKit
import CropViewController

/// This Controller is used to upload the image
class ViewController: UIViewController,CropViewControllerDelegate {
    // MARK: Properties
    /// Cropping Style Default
    private var croppingStyle = CropViewCroppingStyle.default
    /// Cropping Rect
    private var croppedRect = CGRect.zero
    /// Cropping Angle
    private var croppedAngle = 0
    /// It manages the system interfaces for taking pictures and choosing the media library.
    var imagePicker = UIImagePickerController()
    /// Text for the Companyname
    var company_name: String = ""
    // MARK: Outlets
    ///This image view is used to upload the selected image
    @IBOutlet weak var pictureSelected: UIImageView!
    ///This text Field is used to display the company name
    @IBOutlet weak var companyname: UITextField!
    ///This button is used to selecting the image
    @IBOutlet weak var imageselectorButton: UIButton!
     // MARK: View Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePicker.allowsEditing = true
    }
    // MARK: Button Action Methods
    /// This action is used to take photo and choose the photo libray
    ///
    /// - Parameter sender: Any Object.
    @IBAction func imageSelector(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    //MARK: - Open the Gallery
    func openGallary() {
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        //If you dont want to edit the photo then you can set allowsEditing to false
        imagePicker.allowsEditing = true
        imagePicker.delegate = self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
        self.present(imagePicker, animated: true, completion: nil)
    }
    //MARK: - Open the camera
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            //If you dont want to edit the photo then you can set allowsEditing to false
            imagePicker.allowsEditing = true
            imagePicker.delegate = self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
            self.present(imagePicker, animated: true, completion: nil)
        }
        else{
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: - Crop the picture
    public func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        self.croppedRect = cropRect
        self.croppedAngle = angle
        self.pictureSelected.image=image;
        cropViewController.dismiss(animated: true, completion: nil)
    }
}
    //Extension for selecting UIImagePickerControllerDelegate and UINavigationControllerDelegate
extension ViewController:  UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    //MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        /*
         Get the image from the info dictionary.
         If no need to edit the photo, use `UIImagePickerControllerOriginalImage`
         instead of `UIImagePickerControllerEditedImage`
         */
        guard let image = (info[UIImagePickerControllerOriginalImage] as? UIImage) else { return }
        //Compression of the image takes place
        // you can also replace UIImageJPEGRepresentation with UIImagePNGRepresentation.converts image to data
        let imgData: NSData = NSData(data: UIImageJPEGRepresentation((image), 0.5)!)
        let imageSize: Int = imgData.length
        print("size of image in MB: %f ", Double(imageSize) / 51200.0)
        /// cropping the image
        let cropController = CropViewController(croppingStyle: croppingStyle, image: image)
        cropController.delegate = self
        if croppingStyle == .circular {
            if picker.sourceType == .camera {
                picker.dismiss(animated: true, completion: {
                    self.present(cropController, animated: true, completion: nil)
                })
            } else {
                picker.pushViewController(cropController, animated: true)
            }
        }
        else { //otherwise dismiss, and then present from the main controller
            picker.dismiss(animated: true, completion: {
                self.present(cropController, animated: true, completion: nil)
                //self.navigationController!.pushViewController(cropController, animated: true)
            })
        }
    }
     //MARK: - cancel optiion for UIImagePickerController
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.isNavigationBarHidden = false
        self.dismiss(animated: true, completion: nil)
    }
}





