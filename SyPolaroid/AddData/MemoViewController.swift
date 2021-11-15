//
//  MemoViewController.swift
//  SyPolaroid
//
//  Created by 장선영 on 2021/05/08.
//

import UIKit
import TagListView

protocol SendMemoDelegate {
    func sendMemo(title:String?,content:String?,tag:[String],font:String?,image: UIImage)
}

class MemoViewController: UIViewController, UITextFieldDelegate, TagListViewDelegate, UIFontPickerViewControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var memoView: UIView!
    @IBOutlet weak var memoBackImage: UIImageView!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var memoText: UITextView!
    @IBOutlet weak var TagScroll: UIScrollView!
    @IBOutlet weak var myTagListView: TagListView!
    @IBOutlet weak var fontButton: UIButton!
    @IBOutlet weak var dismissButton: UIButton!
    
    let screenWidth : Double = Double(UIScreen.main.bounds.width-20)
    let screenheight : Double = Double(UIScreen.main.bounds.height/5)
    
    var selectedRow = 0
    var tagArray = [String]()
    var editedImage = UIImage()
    var cover : Cover?
    var delegate : SendMemoDelegate?
    var memoTitle : String?
    var memoContent : String?
    var tempFontName : String?
    
    var dataArray = ["폰트예제입니다","폰트예제입니다","폰트예제입니다","폰트예제입니다",
                     "폰트예제입니다","폰트예제입니다","폰트예제입니다","폰트예제입니다"]
    var fontArray = ["S-CoreDream-6Bold","MARUBuriBetaot-Regular","SangSangShinb7OTF","NanumSquareR","SunBatang-Light","OTJalpullineunoneulM","KyoboHandwriting2019","BinggraeSamanco"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleField.delegate = self
        myTagListView.delegate = self
        
        titleField.backgroundColor = #colorLiteral(red: 1, green: 0.7921494842, blue: 0.7917907834, alpha: 1)
        titleField.text = memoTitle
        
        memoText.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        memoText.layer.borderWidth = 1.5
        memoText.layer.borderColor = #colorLiteral(red: 1, green: 0.7921494842, blue: 0.7917907834, alpha: 1)
        memoText.text = memoContent
        
        TagScroll.layer.borderWidth = 1.5
        TagScroll.layer.borderColor = #colorLiteral(red: 1, green: 0.7921494842, blue: 0.7917907834, alpha: 1)
        
        myTagListView.tagBackgroundColor = #colorLiteral(red: 1, green: 0.9189032316, blue: 0.9114453793, alpha: 1)
        myTagListView.borderColor = #colorLiteral(red: 1, green: 0.7921494842, blue: 0.7917907834, alpha: 1)
        myTagListView.addTags(tagArray)
        
        self.buttonView.layer.cornerRadius = 10
        self.buttonView.layer.borderColor = #colorLiteral(red: 1, green: 0.7921494842, blue: 0.7917907834, alpha: 1)
        self.buttonView.layer.borderWidth = 1
        
        let defaultSize = UIFont.systemFontSize
        let defaultFont = UIFont.systemFont(ofSize: defaultSize).familyName

        self.titleField.font = UIFont.init(descriptor: .init(name: tempFontName ?? defaultFont, size: defaultSize), size: defaultSize)
        self.memoText.font = UIFont.init(descriptor: .init(name: tempFontName ?? defaultFont, size: defaultSize), size: defaultSize)
        self.myTagListView.textFont = UIFont.init(descriptor: .init(name:tempFontName ?? defaultFont, size: defaultSize), size: defaultSize)
        
        self.memoBackImage.layer.cornerRadius = 40
        
        
        setNavigationBar()
        setShadow()
    }
    
    
    func setNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.topItem?.title = ""
    }
    
    func setShadow() {
        
        memoView.layer.shouldRasterize = true
        memoView.layer.shadowOpacity = 0.2
        memoView.layer.shadowRadius = 8
        memoView.layer.shadowOffset = CGSize(width: 10, height: 10)
    }

    // > 글꼴 선택 sheet
    @IBAction func selectFont(_ sender: UIButton) {
        
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: self.screenWidth, height: self.screenheight)
        
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: self.screenWidth, height: self.screenheight))
       
        
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.selectRow(selectedRow, inComponent: 0, animated: false)
        
        vc.view.addSubview(pickerView)
        print(vc.view.bounds.width)
        
        pickerView.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor).isActive = true
        pickerView.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor).isActive = true
        
        print(vc.view.bounds.width)
        print(pickerView.bounds.width)
        
        let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        
//        alert.popoverPresentationController?.sourceView = titleField
//        alert.popoverPresentationController?.sourceRect = titleField.bounds
        
        alert.setValue(vc, forKey: "contentViewController")
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
            alert.dismiss(animated: true, completion: nil)
        }))

        alert.addAction(UIAlertAction(title: "Select", style: .default, handler: { (UIAlertAction) in
            self.selectedRow = pickerView.selectedRow(inComponent: 0)
            let selected = Array(self.fontArray)[self.selectedRow]
            let defaultSize = UIFont.systemFontSize

            self.titleField.font = UIFont.init(descriptor: .init(name: selected, size: defaultSize), size: defaultSize)
            self.memoText.font = UIFont.init(descriptor: .init(name: selected, size: defaultSize), size: defaultSize)
            self.myTagListView.textFont = UIFont.init(descriptor: .init(name: selected, size: defaultSize), size: defaultSize)
        }))
        self.present(alert, animated: true, completion: nil)
    }
        
    
    @IBAction func tagListTapped(_ sender: UITapGestureRecognizer) {
        
        let alert = UIAlertController(title: "태그를 추가하세요", message: "", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { (ok) in
            let userInput = alert.textFields?[0].text ?? ""
                if userInput.count >= 1 {
                    self.myTagListView.addTag(userInput)
                    self.tagArray.append(userInput)
                } else {
                    ok.isEnabled = false
                }
        }
        
        let cancel = UIAlertAction(title: "cancel", style: .cancel) { (cancel) in }
        alert.addAction(cancel)
        alert.addAction(ok)
        alert.addTextField()
        self.present(alert, animated: true, completion: nil)
    }
    
    // > dismiss 할 때 editView로 데이터 보내기
    @IBAction func dismiss(_ sender: Any) {
        
        if let delegate = self.delegate {
            
            let renderer = UIGraphicsImageRenderer(size: memoView.bounds.size)
            let memoImage = renderer.image { ctx in memoView.drawHierarchy(in: memoView.bounds, afterScreenUpdates: true) }
            
            delegate.sendMemo(title: titleField.text, content: memoText.text, tag: tagArray, font : titleField.font?.familyName, image: memoImage)
        }
        dismiss(animated: true, completion: nil)
    }
    
    // 리턴 누르면 키보드 내려감 (textFieldDelegate지정 필수)
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleField.resignFirstResponder()
        return true
    }
    
    //터치 시 키보드 내려감
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        sender.removeTagView(tagView)

        for i in 0..<tagArray.count {
            if tagArray[i] == title {
                tagArray.remove(at: i)
                break}}
        print(tagArray)
    }
}

extension MemoViewController {
    
    func fontPickerViewControllerDidPickFont(_ viewController: UIFontPickerViewController) {
        guard let descriptor = viewController.selectedFontDescriptor else { return }
        let font = UIFont(descriptor: descriptor, size: 14)
        self.titleField.font = font
        self.memoText.font = font
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        dataArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 20))
        label.textAlignment = .center
        label.sizeToFit()
        label.text = dataArray[row]
        label.font = UIFont(name: fontArray[row], size: 20)
        return label
    }
}