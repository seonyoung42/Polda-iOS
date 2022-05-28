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
    var editImage = UIImage()
    var sendImage = UIImage()
    var memoIndex : Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setShadow()
        setSwipeAction()

        finalImage.isUserInteractionEnabled = true
        self.showBackImage.layer.cornerRadius = 40
        
        self.finalImage.layer.cornerRadius = 5
        self.flipView.layer.cornerRadius = 5
        
        if let image = memo?.editedImage {
            editImage = UIImage(data: image)!
            finalImage.image = editImage
        }
        
        if let memoData = memo?.memoImage {
            memoImage = UIImage(data: memoData)!
        }
        
        savebutton.addTarget(self, action: #selector(saveImageToAlbum), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(shareImageToOthers), for: .touchUpInside)
    }

    
    // > Segue 데이터 전달
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? ShowMemoViewController else { return }
        
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
    
    // > 이미지 앨범에 저장
    @objc func saveImageToAlbum() {
        var savedImage : UIImage?
        savedImage = isDayImage ? editImage : memoImage

        guard let savedImage = savedImage else { return }
        
        CustomAlbum.sharedInstance.saveImageToAlbum(image: savedImage) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    self.showToast(message: "앨범에 저장되었어요 ٩(•̤̀ᵕ•̤́๑)ᵒᵏᵎᵎᵎᵎ".localized())
                case .failure(_):
                    self.showToast(message: "에러가 발생했어요".localized())
                }
            }
        }
    }
    
    // > image 외부로 공유하기
    @objc func shareImageToOthers() {
        isDayImage ? presentActivityController(item: editImage) : presentActivityController(item: memoImage)
    }
    
    func presentActivityController(item: Any) {
        let activityVC = UIActivityViewController(activityItems: [item], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.shareButton
        activityVC.popoverPresentationController?.delegate = self
        present(activityVC, animated: true, completion: nil)
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
                setTransition(isDayImage: false, image: memoImage, transition: .transitionFlipFromLeft)
            } else {
                setTransition(isDayImage: true, image: editImage, transition: .transitionFlipFromLeft)
            }
        } else if gesture.direction == .left {
            if isDayImage {
                setTransition(isDayImage: false, image: memoImage, transition: .transitionFlipFromRight)
            } else {
                setTransition(isDayImage: true, image: editImage, transition: .transitionFlipFromRight)
            }
        }
    }
    
    func setTransition(isDayImage dayImage: Bool, image: UIImage, transition options: UIView.AnimationOptions) {
        isDayImage = dayImage
        finalImage.image = image
        UIView.transition(with: finalImage, duration: 0.9, options: options, animations: nil, completion: nil)
        
    }
}
