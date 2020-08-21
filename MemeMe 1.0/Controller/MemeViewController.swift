//
//  MemeViewController.swift
//  MemeMe 1.0
//
//  Created by A Abdullah on 5/31/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit

class MemeViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var searchButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var topTextField: UITextField!
    
           
           override func viewDidLoad() {
               super.viewDidLoad()
               // Do any additional setup after loading the view, typically from a nib.
               
               setTextFields(textField: topTextField, string: AppApp.defaultTopTextFieldText)
               setTextFields(textField: bottomTextField, string: AppApp.defaultBottomTextFieldText)
               chickShareButton()
           }


           override func viewWillAppear(_ animated: Bool) {
               super.viewWillAppear(animated)
               // if there's an image share button
               chickShareButton()
            
               // set the font
               if AppApp.currentFontIndex != -1 {
                   topTextField.font = UIFont(name: AppApp.selectedFont, size: 40)
                   bottomTextField.font = UIFont(name: AppApp.selectedFont, size: 40)
               }
               //To enable or disable camera button
                             cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)
    
                             // subscribe keyboard notification
                             self.subscribeToKeyboardNotifications()
                         }
    
           // IBActions Album & Camera
           @IBAction func pickImageAlbum(_ sender: AnyObject) {
               
               presentImagePickerWith(sourceType: UIImagePickerController.SourceType.photoLibrary)
           }

           @IBAction func pickImageCamera (sender: AnyObject) {
               
               presentImagePickerWith(sourceType: UIImagePickerController.SourceType.camera)
           }
           
           

           // Delegates
            func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

                if let image = info[.originalImage] as? UIImage  {
                   imagePickerView.image = image
                   self.view.layoutIfNeeded()
                   self.dismiss(animated: true, completion: nil)
               }
           }
           
           
           func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
               dismiss(animated: true, completion: nil)
               
           }
           

   
           
          
           
           // keyboard notifications
    
           func unsubscribeFromKeyboardNotifications() {
               NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
               NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)

           }
           func subscribeToKeyboardNotifications() {
                  
                  NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
                  NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
              }
           
    
         
           @objc func keyboardWillShow(_ notification:Notification) {
               if (bottomTextField.isEditing){
               view.frame.origin.y -= getKeyboardHeight(notification)
               }
           }

           func getKeyboardHeight(_ notification:Notification) -> CGFloat {
               let userInfo = notification.userInfo
               let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
               return keyboardSize.cgRectValue.height
           }
       
           @objc func keyboardWillHide(_ notification:Notification) {
               view.frame.origin.y = 0
           }

           func generateMemedImage() -> UIImage {
               
               configureBars(hidden: true)
               
               UIGraphicsBeginImageContext(self.view.frame.size)
               self.view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
               let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
               UIGraphicsEndImageContext()
               configureBars(hidden: false)
               
               return memedImage
           }
           
           
           func save(memedImage: UIImage) {

               let meme = Meme(topText: topTextField.text! as NSString?, bottomText: bottomTextField.text! as NSString?,  image: imagePickerView.image, memedImage: memedImage)
                              (UIApplication.shared.delegate as!
                   AppDelegate).memes.append(meme)
           }
           
           
         // IBAction of cancel & share button
           
           @IBAction func shareAction(_ sender: AnyObject) {
               
               let memedImage = generateMemedImage()
               
               let shareActivityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
               
               shareActivityViewController.completionWithItemsHandler = { activity, completed, items, error in
                   
                   if completed {
                       
                       //save image & dismiss
                       self.save(memedImage: memedImage)
                       
                       self.dismiss(animated: true, completion: nil)
                       
                   }
                   
               }
               
               present(shareActivityViewController, animated: true, completion: nil)
           }
           
           
           @IBAction func cancelAction(_ sender: AnyObject) {
               
               if imagePickerView.image != nil {
                   
                   let alert = UIAlertController(title: AppApp.alert.alertTitle , message: AppApp.alert.alertMessage, preferredStyle: .alert)
                   let yes = UIAlertAction(title: "Yes", style: .default) { (UIAlertAction) in
                       
                       self.imagePickerView.image = nil
                       self.resetTextfieldText()
                       self.shareButton.isEnabled = false
                   }
                   
                   let no  = UIAlertAction(title: "No", style: .default, handler: nil)
                   
                   alert.addAction(yes)
                   alert.addAction(no)
                   
                   self.present(alert, animated: true, completion: nil)
               }
           }
           
           
           
       func presentImagePickerWith(sourceType: UIImagePickerController.SourceType){
               
               let imagePicker = UIImagePickerController()
               imagePicker.delegate = self
               imagePicker.sourceType = sourceType
               self.present(imagePicker, animated: true, completion:nil)
           }
           
           func resetTextfieldText(){
               topTextField.text = AppApp.defaultTopTextFieldText
               bottomTextField.text = AppApp.defaultBottomTextFieldText
           }
           
           
           func configureBars(hidden: Bool) {
               navBar.isHidden = hidden
               toolBar.isHidden = hidden
           }
       
           func chickShareButton() {
               if let _ = imagePickerView.image {
                   shareButton.isEnabled = true
               } else {
                   shareButton.isEnabled = false
            }
           }
           
           override var prefersStatusBarHidden: Bool {
               chickShareButton()
               //Hide Status Bar
               return true
           }

           
           override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
               
               super.viewWillTransition(to: size, with: coordinator)
               
               coordinator.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
                   
                   self.topTextField.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                   self.bottomTextField.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                   
               }) { (UIViewControllerTransitionCoordinatorContext) in
                   
                   UIView.animate(withDuration: 0.5, animations: {
                       
                       self.topTextField.transform = CGAffineTransform.identity
                       self.bottomTextField.transform = CGAffineTransform.identity
                       
                   })
               }
           }
           
       }


 extension MemeViewController: UITextFieldDelegate {
      
      func setTextFields(textField: UITextField, string: String) {
          
          //set textview's default behaviour
          textField.defaultTextAttributes = AppApp.memeTextAttributes
          textField.text = string
          textField.textAlignment = NSTextAlignment.center
          textField.delegate = self;
      }
           
           
           func textFieldDidBeginEditing(_ textField: UITextField) {
               
               //Erase the default text when editing
               if textField == topTextField && textField.text == AppApp.defaultTopTextFieldText {
                   
                   textField.text = ""
                   
               } else if textField == bottomTextField && textField.text == AppApp.defaultBottomTextFieldText {
                   
                   textField.text = ""
               }
           }
           
           
           func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
               
               var text = textField.text as NSString?
               text = text!.replacingCharacters(in: range, with: string) as NSString?
               
               
               textField.text = text?.uppercased
               return false
           }
           
           
           func textFieldShouldReturn(_ textField: UITextField) -> Bool {
               
               // hide keyboard
               textField.resignFirstResponder()
               return true
           }
           
           
           func textFieldDidEndEditing(_ textField: UITextField) {
               
               if textField == topTextField && textField.text!.isEmpty {
                   
                   textField.text = AppApp.defaultTopTextFieldText;
                   
               }else if textField == bottomTextField && textField.text!.isEmpty {
                   
                   textField.text = AppApp.defaultBottomTextFieldText;
               }
           }
       }
