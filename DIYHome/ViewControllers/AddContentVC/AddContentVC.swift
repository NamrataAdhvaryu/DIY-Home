//
//  AddContentVC.swift
//  DIYHome
//
//  Created by Namrata Akash on 19/06/20.
//  Copyright © 2020 YB. All rights reserved.
//

import UIKit
import AVFoundation

class AddContentVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    //MARK: - Outlets
    @IBOutlet weak var lblNavBarTitle: UILabel!
    
    @IBOutlet weak var btnAddCategory: UIButton!
    @IBOutlet weak var btnAddPhoto: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    
    @IBOutlet weak var collViewForImageObj: UICollectionView!
    var arrForImages = [UIImage]();
    var imgSelected = UIImage()
    
    
    //MARK: - View Controller
    override func viewDidLoad()
    {
       super.viewDidLoad()
       SetCustomUI();
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        ClearAllDataForNewPost();
    }

    //MARK: - Other Methods
    func ClearAllDataForNewPost()
    {
        arrForImages.removeAll();
        self.collViewForImageObj .reloadData();
    }
    
    func SetCustomUI()
    {
         //Common
        self.view.backgroundColor = ConstantObj.COLOR_APP_THEME_MAIN_BG;
        lblNavBarTitle.text = "Add Content";
        lblNavBarTitle.textColor = ConstantObj.COLOR_APP_THEME_TEXT_MAIN_TITLE;
        
        btnAddPhoto.CreateRoundButton(aCornerRadius:50);
        btnNext.CreateRoundButton(aCornerRadius:30);
    }

    // MARK: - CollectionView Delegate Method
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return arrForImages.count;
    }
      
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let aCellObj = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCell;
       
        aCellObj.imgViewPhoto.image = arrForImages[indexPath.row] ;
        aCellObj.imgViewPhoto.SetShadowEffectOnImageView(cornerRadius: 0, borderWidth:3);
        return aCellObj;
    }
      
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 10;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsets(top: 0, left: 110, bottom: 0, right: 100);
    }
    
    
    //MARK: - Button click Methods
    @IBAction func BtnAddPhotoClick(_ sender: Any)
    {
       ShowImagePicker(aStrSourceType: "Photo");
    }
    
    @IBAction func BtnNextClick(_ sender: Any)
    {
        if(ValidateData())
        {
            let aStrImageName = CommonCodeObj.CreateBase64ForImage(aImgObj: imgSelected);
            
            let aAddContentDetailVCObj =  self.storyboard?.instantiateViewController(withIdentifier:"AddContentDetailVCIdentifier") as! AddContentDetailVC;
            aAddContentDetailVCObj.strSelectedImgName = aStrImageName;
            aAddContentDetailVCObj.arrForSelectedImgs = arrForImages

            self.navigationController?.pushViewController(aAddContentDetailVCObj, animated: true);
        }
    }
    

    //MARK: - Validateion Methods
    func ValidateData() -> Bool
    {
        var aBoolVal = true;
        return aBoolVal;
    }
    
    
    //MARK: - ImagePicker Methods
    func ShowImagePicker(aStrSourceType:String)
    {
        let aImgPicker = UIImagePickerController();

        aImgPicker.sourceType = .savedPhotosAlbum;
        aImgPicker.mediaTypes = ["public.image"]
        
        aImgPicker.delegate = self;
        self.present(aImgPicker, animated: true, completion: nil);
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        if let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String
        {
            if mediaType  == "public.image"
            {
                print("Image Selected")
                imgSelected = info[UIImagePickerController.InfoKey.originalImage] as! UIImage;

                self.dismiss(animated: true)
                {
                    //NOTE: set this code for only one image
                    self.arrForImages.removeAll();
                    
                    self.arrForImages.append(self.imgSelected);
                    self.collViewForImageObj .reloadData();
                }
            }
        }
    }
    
    func getThumbnailImageFromVideoUrl(url: URL, completion: @escaping ((_ image: UIImage?)->Void))
    {
        DispatchQueue.global().async
        {
            let asset = AVAsset(url: url) 
            let avAssetImageGenerator = AVAssetImageGenerator(asset: asset)
            avAssetImageGenerator.appliesPreferredTrackTransform = true
            let thumnailTime = CMTimeMake(value: 2, timescale: 1)
            do
            {
                let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumnailTime, actualTime: nil)
                let thumbImage = UIImage(cgImage: cgThumbImage)
                DispatchQueue.main.async
                {
                    completion(thumbImage)
                }
            }
            catch
            {
                print(error.localizedDescription)
                DispatchQueue.main.async
                {
                    completion(nil)
                }
            }
        }
    }
}
