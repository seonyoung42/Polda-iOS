//
//  EditViewController.swift
//  SyPolaroid
//
//  Created by 장선영 on 2021/05/07.
//

import UIKit
import MaterialComponents.MaterialBottomSheet

class EditViewController: UIViewController, SendDataDelegate, UIViewControllerTransitioningDelegate, UIGestureRecognizerDelegate, UIPopoverPresentationControllerDelegate, SendMemoDelegate {
    
    @IBOutlet var wholeView: UIView!
    @IBOutlet weak var EditBackImage: UIImageView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var editView: UIView!
    @IBOutlet weak var editImage: UIImageView!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var colorButton: UIButton!
    
    var cover : Cover?
    var memoTitle : String?
    var memoContent : String?
    var tagArray = [String]()
    var tempFontName : String?
    var memoImage = UIImage(named: "text box")
    
    private lazy var imagePicker: UIImagePickerController = {
        let picker: UIImagePickerController = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        return picker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.EditBackImage.layer.cornerRadius = 40
        self.editImage.isUserInteractionEnabled = true
        
        self.editView.layer.cornerRadius = 5
//        self.editImage.layer.cornerRadius = 5
        self.shadowView.layer.cornerRadius = 5
        
        self.buttonView.layer.cornerRadius = 10
        self.buttonView.layer.borderColor = #colorLiteral(red: 1, green: 0.7921494842, blue: 0.7917907834, alpha: 1)
        self.buttonView.layer.borderWidth = 1
        
        setNavigationBar()
        setShadow()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.toolbar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.toolbar.isHidden = true
    }
    
    
    // > 사진 선택 버튼
    @IBAction func photoButton(_ sender: Any) {
        self.present(self.imagePicker, animated: true, completion: nil)
    }
    
   
    // > Coredata 에 이미지와 메모 저장하기
    @IBAction func saveData(_ sender: Any) {
        let rendererFormat = UIGraphicsImageRendererFormat.default()
        rendererFormat.opaque = false
        
        let renderer = UIGraphicsImageRenderer(size: editView.bounds.size,format: rendererFormat)
        let editedImage = renderer.image { ctx in editView.drawHierarchy(in: editView.bounds, afterScreenUpdates:true) }
        
        cover?.insertIntoRawMemos(DataManager.shared.saveMemo(title: memoTitle, content: memoContent, hashTag: tagArray, image: editedImage,fontName: tempFontName, memoImage: self.memoImage!), at: 0)
        
        self.navigationController?.popViewController(animated: true)
    }
    

    // > 바텀 시트 올라오기
    @IBAction func stickerBtnClicked(_ sender: UIBarButtonItem) {
        let stickerVC = PutStickerViewController()
        stickerVC.delegate = self
        // MDC 바텀 시트로 설정
        let bottomSheet: MDCBottomSheetController = MDCBottomSheetController(contentViewController: stickerVC)
        bottomSheet.mdc_bottomSheetPresentationController?.preferredSheetHeight = 300
        present(bottomSheet, animated: true, completion: nil)
    }
    
    @objc func singleTap(_ gesture : UIGestureRecognizer) {
        gesture.view?.superview?.removeFromSuperview()
    }
    
    // > Segue 데이터 전달
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? MemoViewController else { return }
        let renderer = UIGraphicsImageRenderer(size: editView.bounds.size)
        let editedImage = renderer.image { ctx in editView.drawHierarchy(in: editView.bounds, afterScreenUpdates: true) }
        
        destination.delegate = self
        destination.modalTransitionStyle = .flipHorizontal
        destination.modalPresentationStyle = .fullScreen
        
        destination.editedImage = editedImage
        destination.cover = cover
        
        destination.memoTitle = self.memoTitle
        destination.memoContent = self.memoContent
        destination.tagArray = self.tagArray
        destination.tempFontName = self.tempFontName
    }
    
    // > SendMemo Delegate protocol
    func sendMemo(title: String?, content: String?, tag: [String], font: String?, image: UIImage) {
        self.memoTitle = title ?? ""
        self.memoContent = content ?? ""
        self.tagArray = tag
        self.tempFontName = font
        self.memoImage = image
    }
}



// > 스티커 기능 설정
extension EditViewController {
    // > 스티커 삭제 (꾹 눌러서 삭제)
    @objc func longPress(_ gesture : UILongPressGestureRecognizer){
        if gesture.state != .ended { return }
        
        let alert = UIAlertController(title: "해당 스티커를 삭제하시겠습니까?", message: "", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) {_ in
            gesture.view?.removeFromSuperview()}
        alert.addAction(ok)
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel) { (cancel) in})
        self.present(alert, animated: true, completion: nil)
    }
    
    // > 스티커 위치조절
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        // 2
        guard let gestureView = gesture.view else {
            return
        }
        gestureView.center = CGPoint( x: gestureView.center.x + translation.x, y : gestureView.center.y + translation.y)
        gesture.setTranslation(.zero, in: view)
    }
    
    // > 스티커 크기 조절
    @objc func handlePinchGesture(_ gesture: UIPinchGestureRecognizer) {
        guard let gestureView = gesture.view else {
          return
        }
        gestureView.transform = gestureView.transform.scaledBy(x: gesture.scale, y:gesture.scale)
        gesture.scale = 1
    }
    
    // > 스티커 회전
    @objc func handleRotateGesture(_ gesture: UIRotationGestureRecognizer) {
        guard let gestureView = gesture.view else { return }
        gestureView.transform = gestureView.transform.rotated(by: gesture.rotation)
        gesture.rotation = 0
    }
    
    // > 동시에 여러 움직임 인식 가능
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
}


// >> 프레임 색상 설정
extension EditViewController : UIColorPickerViewControllerDelegate {
    @IBAction func showColorPicker(_ sender: Any) {
        let picker = UIColorPickerViewController()
        picker.supportsAlpha = true
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }

    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        let color = viewController.selectedColor
        editView.backgroundColor = color
        dismiss(animated: true, completion: nil)
    }

    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        let color = viewController.selectedColor
        editView.backgroundColor = color
    }
    
}



// > imagePicker 메서드
extension EditViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage: UIImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.editImage.image = editedImage
        } else if let originalImage: UIImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.editImage.image = originalImage
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}

// > Custom Funcions
extension EditViewController {
    //네이게이션 바 세팅
    func setNavigationBar() {
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.toolbar.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
        self.navigationController?.toolbar.setShadowImage(UIImage(), forToolbarPosition: .any)
    }
    
    // 이미지 배경에 그림자 넣기
    func setShadow() {
        editView.clipsToBounds = true
        shadowView.backgroundColor = .white
        shadowView.layer.shouldRasterize = true
        shadowView.layer.shadowOpacity = 0.2
        shadowView.layer.shadowRadius = 8
        shadowView.layer.shadowOffset = CGSize(width: 10, height: 10)
    }
    
    // 선택한 스티커 데이터 받기
    func sendData(image: UIImage) {
        let imageSticker = UIImageView(image: image)
        imageSticker.frame = CGRect(origin: CGPoint(x: 120, y: 150), size: CGSize(width: 50, height: 50))
        imageSticker.image = image
        imageSticker.isUserInteractionEnabled = true
        imageSticker.contentMode = .scaleAspectFit
        
        //스티커 편집뷰 위에 붙이기
        self.editView.addSubview(imageSticker)
        // 스티커 편집뷰 밖으로 튀어나오지 않게
        self.editView.clipsToBounds = true
        
        //스티커 조절 기능 추가
        let panGesture = UIPanGestureRecognizer.init(target: self, action: #selector(handlePanGesture(_:)))
        let pinchGesture = UIPinchGestureRecognizer.init(target: self, action: #selector(handlePinchGesture(_:)))
        let rotateGesture = UIRotationGestureRecognizer.init(target: self, action: #selector(handleRotateGesture(_:)))
        let removeGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.longPress))
        
        [panGesture,pinchGesture,rotateGesture,removeGesture].forEach {
            $0.delegate = self
            imageSticker.addGestureRecognizer($0)
        }
    }
}
