//
//  ShowViewController.swift
//  SyPolaroid
//
//  Created by 장선영 on 2021/05/11.
//

import UIKit

class ShowViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var flipView: UIView!
    @IBOutlet weak var finalImage: UIImageView!
    @IBOutlet weak var savebutton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var showBackImage: UIImageView!
    
    var isDayImage: Bool = true
    var memo : Memo?
    var cover : Cover?
    var memoImage = UIImage()
    var sendImage = UIImage()
    var memoIndex : Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setShadow()
        setSwipeAction()

        finalImage.isUserInteractionEnabled = true
        
        self.showBackImage.layer.cornerRadius = 40
        
        if let image = memo?.editedImage {
            finalImage.image = UIImage(data: image)
        }
        
        if let memoData = memo?.memoImage {
            memoImage = UIImage(data: memoData)!
        }
       
    }
    
    @IBAction func saveToAlbum(_ sender: Any) {
        if let image = memo?.editedImage {
            sendImage = UIImage(data: image)!
        }
            UIImageWriteToSavedPhotosAlbum(sendImage, nil, nil, nil)
        self.showToast(message: "앨범에 저장되었어요 ٩(•̤̀ᵕ•̤́๑)ᵒᵏᵎᵎᵎᵎ")
        }
    
    @IBAction func shareImage(_ sender: Any) {
        
        if let image = memo?.editedImage {
            
            let editedImage = UIImage(data: image)
            let activityViewController = UIActivityViewController(activityItems: [editedImage!], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.shareButton
            activityViewController.popoverPresentationController?.delegate = self
            present(activityViewController, animated: true, completion: nil)
        }
    }
    
    // > Segue 데이터 전달
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? ShowMemoViewController else {
            return
            }
        
        destination.modalTransitionStyle = .flipHorizontal
        destination.modalPresentationStyle = .fullScreen
        destination.memo = memo
        destination.cover = cover
        destination.memoIndex = memoIndex
    }
}


// > Custom Functions
extension ShowViewController {
    
    // > 네비게이션 바 설정
    func setNavigationBar() {
        
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.toolbar.isHidden = false
        //툴바 투명하게
        self.navigationController?.toolbar.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
        self.navigationController?.toolbar.setShadowImage(UIImage(), forToolbarPosition: .any)
    }
    
    // > 뷰 그림자 설정
    func setShadow() {
        flipView.layer.shouldRasterize = true
        flipView.layer.shadowOpacity = 0.2
        flipView.layer.shadowRadius = 8
        flipView.layer.shadowOffset = CGSize(width: 10, height: 10)
    }
    
    // > 토스트 메시지 띄우기
    func showToast(message : String) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 150, y: self.view.frame.size.height-100, width: 300, height: 35))
        
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds = true
        
        self.view.addSubview(toastLabel)
        
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: { toastLabel.alpha = 0.0 }, completion: {(isCompleted) in toastLabel.removeFromSuperview() })
    }
    
    // > SwipeGesture 설정
    func setSwipeAction() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture(_:)))
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture(_:)))
        
        swipeRight.direction = .right
        swipeLeft.direction = .left
        
        [swipeRight,swipeLeft].forEach {
            self.view.addGestureRecognizer($0)
        }
    }
    
    // > SwipeGesture 상세 설정
    @objc func respondToSwipeGesture(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .right {
            
            if isDayImage {
                isDayImage = false
                finalImage.image = memoImage
                UIView.transition(with: finalImage, duration: 0.9, options: .transitionFlipFromLeft, animations: nil, completion: nil)
            } else {
                isDayImage = true
                if let image = memo?.editedImage {
                    finalImage.image = UIImage(data: image)
                }
                UIView.transition(with: finalImage, duration: 0.9, options: .transitionFlipFromLeft, animations: nil, completion: nil) }
        
        } else if gesture.direction == .left {
            
            if isDayImage {
                isDayImage = false
                finalImage.image = memoImage
                UIView.transition(with: finalImage, duration: 0.9, options: .transitionFlipFromRight, animations: nil, completion: nil)
            } else {
                isDayImage = true
                if let image = memo?.editedImage {
                finalImage.image = UIImage(data: image)
                }
                UIView.transition(with: finalImage, duration: 0.9, options: .transitionFlipFromRight, animations: nil, completion: nil) }
        }
    }
}
