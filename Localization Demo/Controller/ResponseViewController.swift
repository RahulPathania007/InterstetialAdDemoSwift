//
//  ResponseViewController.swift
//  Localization Demo
//
//  Created by Sunfocus Solutions on 22/02/24.
//

import UIKit
import GoogleMobileAds
import OpalImagePicker
import PhotosUI

struct PhotosVideos {
    var type: String
    var url: URL
    var imageData: Data? // For image data
    var videoData: Data? // For video data
    var image: UIImage
}




class ResponseViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var changeLangButton: UIButton!
    @IBOutlet weak var showAd: UIButton!
    @IBOutlet weak var openGallery: UIButton!
    
    //MARK: - Variables
    var selectedAppLang: Language = .english
    var adManager = AdManager.shared
    var imageDataArray = [Data]()

    //MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setData()
        self.showStartupAd()
        self.setCornerRadius(buttons: [changeLangButton,showAd,openGallery], cornerRadius: 20)
    }
    
    
    
    
    func setDataAccordingToLanguages(key: String, language: Language = .english){
        switch language{
        case .english:
            self.welcomeLabel.text = key.localizableString(lan: "en")
        case .spanish:
            self.welcomeLabel.text = key.localizableString(lan: "es")
        case .german:
            self.welcomeLabel.text = key.localizableString(lan: "de")
        case .hindi:
            self.welcomeLabel.text = key.localizableString(lan: "hi")
        case .chinese:
            self.welcomeLabel.text = key.localizableString(lan: "zh-HK")
        case .japanese:
            self.welcomeLabel.text = key.localizableString(lan: "ja")
        case .def: break
        }
    }
    
    private func showStartupAd(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
            self.adManager.showStartupAd(controller: self)
            self.adManager.startupInterstetial?.fullScreenContentDelegate = self
        }
    }
    
    
    private func setCornerRadius(buttons: [UIButton], cornerRadius: Double){
        self.changeLangButton.layer.cornerRadius = 15
        self.showAd.layer.cornerRadius = 15
        self.openGallery.layer.cornerRadius = 15
    }
    
    
    private func setData(){
        self.selectedAppLang = LanguageManager.getSelectedLanguage()
        self.languageLabel.text = selectedAppLang.rawValue
        self.setDataAccordingToLanguages(key: "WelcomeNote", language: self.selectedAppLang)
    }
    
    //MARK: - IBAction
    @IBAction func changeLanguageButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    
    
    @IBAction func showInterstetialAd(_ sender: UIButton) {
        self.adManager.showStartupAd(controller: self)
        self.adManager.startupInterstetial?.fullScreenContentDelegate = self
    }
    
    
    @IBAction func openGallery(_ sender: UIButton) {
        let imagePicker = OpalImagePickerController()
        presentOpalImagePickerController(imagePicker, animated: true,
                                         select: { (assets) in
            self.getURLsFromPHAssets(assets) { urls in
                for res in urls{
                    if res.type == "image"{
                        self.imageDataArray.append(res.imageData!)
                    }else{
                        self.imageDataArray.append(res.videoData!)
                    }
                }
            }
            imagePicker.dismiss(animated: true){
                let urlData = self.getUrlWithUrl()
            }
        }, cancel: {
        })
        
        
    }
    
    
    func getUrlWithUrl() -> [URL]{
        var imgUrls = [URL]()
        var index = 1
        
        for data in imageDataArray {
            if let image = UIImage(data: data), let compressedImageData = compressImage(image) {
                // For images
                let fileName = "photo_\(index).jpg"
                let tempFileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
                // Save the compressed image data to the temporary file
                try? compressedImageData.write(to: tempFileURL)
                imgUrls.append(tempFileURL)
                index += 1
            } else {
                imgUrls.append(saveTempFile(data: data, index: index))
                index += 1
            }
        }
        print("***Asset Url's: \(imgUrls)")
        return imgUrls
    }
    
    
    
    
}

extension String{
    func localizableString(lan: String) -> String{
        let path = Bundle.main.path(forResource: lan, ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
}

extension ResponseViewController: GADFullScreenContentDelegate {
    /// Tells the delegate that the ad failed to present full screen content.
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Ad did fail to present full screen content.")
    }

    /// Tells the delegate that the ad will present full screen content.
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad will present full screen content.")
    }

    /// Tells the delegate that the ad dismissed full screen content.
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did dismiss full screen content.")
        // Load a new ad once the user dismisses the current one
        self.adManager.loadStartupAd()
    }
}

extension ResponseViewController{
    func getURLsFromPHAssets(_ assets: [PHAsset], completion: @escaping ([PhotosVideos]) -> Void) {
        var urls: [PhotosVideos] = []
        let imageManager = PHImageManager.default()
        let dispatchGroup = DispatchGroup()

        for asset in assets {
            dispatchGroup.enter()

            if asset.mediaType == .video {
                let optionsVideo = PHVideoRequestOptions()
                optionsVideo.isNetworkAccessAllowed = true
                // Inside the video processing block
                imageManager.requestAVAsset(forVideo: asset, options: optionsVideo) { avAsset, _, _ in
                    if let avAsset = avAsset as? AVURLAsset {
                        let videoURL = avAsset.url

                        // Get the first frame as an image
                        let imageGenerator = AVAssetImageGenerator(asset: avAsset)
                        imageGenerator.appliesPreferredTrackTransform = true

                        do {
                            let cgImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
                            let thumbnail = UIImage(cgImage: cgImage)

                            // Extract video data if needed
                            let videoData = try Data(contentsOf: videoURL)

                            // Now 'thumbnail' is the first frame of the video
                            // Proceed with your logic, e.g., appending it to the 'urls' array
                            urls.append(PhotosVideos(type: "video", url: videoURL, imageData: nil, videoData: videoData, image: thumbnail))

                            // Continue with the rest of your code...
                        } catch {
                            print("Error generating video thumbnail: \(error)")
                        }
                        // Clean up: Remove temporary file
                      //  try? FileManager.default.removeItem(at: tempURL)

                        dispatchGroup.leave()
                    } else {
                        dispatchGroup.leave()
                    }
                }
            } else {
                // Inside the image processing block
                let options = PHImageRequestOptions()
                options.isSynchronous = true
                imageManager.requestImageDataAndOrientation(for: asset, options: options) { imageData, _, _, _ in
                    if let imageData = imageData {
                        let temporaryDirectory = FileManager.default.temporaryDirectory
                        let temporaryURL = temporaryDirectory.appendingPathComponent(UUID().uuidString)

                        do {
                            try imageData.write(to: temporaryURL)
                            urls.append(PhotosVideos(type: "image", url: temporaryURL, imageData: imageData, image: UIImage(data: imageData) ?? UIImage(named: "image_placeholder")!))
                        } catch {
                            print("Error writing image data to file: \(error)")
                        }
                    }
                    dispatchGroup.leave()
                }
            }
        }
        dispatchGroup.notify(queue: .main) {
            completion(urls)
        }
    }
    
    func compressImage(_ image: UIImage) -> Data? {
        // Apply your image compression logic here
        // For example, compress to JPEG with a compression quality of 0.5
        let compressedImageData = image.jpegData(compressionQuality: 0.7)
        return compressedImageData
    }
        
        // Function to save video data to a temporary file
    func saveTempFile(data: Data, index: Int) -> URL {
        let fileName = "video_\(index).mp4"
        let tempFileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        do {
            try data.write(to: tempFileURL)
            return tempFileURL
        } catch {
            fatalError("Failed to save video data to temporary file: \(error)")
        }
    }
}


