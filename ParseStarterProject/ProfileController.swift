//
//  ProfileController.swift
//  MyBank
//
//  Created by Elise Lawley on 2/12/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import CoreData
import MobileCoreServices

class ProfileController: UIViewController, UINavigationControllerDelegate,UIImagePickerControllerDelegate, PFLogInViewControllerDelegate{
    
    var imagePicker = UIImagePickerController()
    var popImage:UIImage?

    @IBOutlet weak var unameText: UITextField!
    @IBOutlet weak var pwordText: UITextField!
    
    @IBOutlet weak var chooseButton: UIButton!
    @IBOutlet weak var pic: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var user = PFUser.currentUser()
        var username = user.username
        unameText.text = user.username
        if let userImageFile = user["avatar"] as? PFFile {
            userImageFile.getDataInBackgroundWithBlock{(imageData:NSData!,error:NSError!)->Void in
                if error == nil {
                        let popImage = UIImage(data:imageData)
                        self.pic.image = popImage
                }
            }
        }
        if popImage == nil {
            var silhouette = UIImage(named:"silhouette.jpg")
            self.pic.image = silhouette
        }
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func UpdateInfo(sender: AnyObject) {
        if pwordText.text != nil {
            PFUser.currentUser().password = pwordText.text
        }
        PFUser.currentUser().username = unameText.text
        PFUser.currentUser().saveInBackgroundWithTarget(nil, selector: nil)
    }
    
    @IBAction func TakePic(sender: AnyObject) {
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
            var picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = UIImagePickerControllerSourceType.Camera
            var mediaTypes: Array<AnyObject> = [kUTTypeImage]
            picker.mediaTypes = mediaTypes
            picker.allowsEditing = true
            self.presentViewController(picker, animated: true, completion: nil)
        }
        else {
            NSLog("No Camera")
        }
        
    }
    
    @IBAction func choosePic(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum;
            imagePicker.allowsEditing = true
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    /*func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: NSDictionary!) {
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        var originalImage:UIImage?, editedImage:UIImage?, imageToSave:UIImage?
        let compResult:CFComparisonResult = CFStringCompare(mediaType as NSString!, kUTTypeImage, CFStringCompareFlags.CompareCaseInsensitive)
        if (compResult == CFComparisonResult.CompareEqualTo) {
            editedImage = info[UIImagePickerControllerEditedImage] as! UIImage?
            originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage?.self
            if (editedImage == nil) {
                imageToSave = editedImage
            } else {
                imageToSave = originalImage
            }
            pic.image = imageToSave
            pic.reloadInputViews()
            UIImageWriteToSavedPhotosAlbum(imageToSave, nil, nil, nil)
        }
        picker.dismissViewControllerAnimated(true, completion: nil)
    }*/
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        if let touch = touches.first as? UITouch {
            // ...
        }
        super.touchesBegan(touches , withEvent:event)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
