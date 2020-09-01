//
//  ViewController.swift
//  Project 01 - iOS Note App
//
//  Created by 김민희 on 2020/08/21.
//  Copyright © 2020 김민희. All rights reserved.
//

import UIKit

class FolderListViewController: UIViewController {
    private var folderListData: [FolderListData] = []
    
    @IBOutlet weak var folderListTableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var toolbar: UIToolbar!
  
    
    @IBAction func editButtonClicked(_ sender: UIBarButtonItem) {
        if folderListTableView.isEditing {
            sender.title = "편집"
            folderListTableView.setEditing(false, animated: true)
        } else {
            sender.title = "완료"
            folderListTableView.setEditing(true, animated: true)
        }
    }
    
    @IBAction func makeFolderButtonClicked(_ sender: UIBarButtonItem) {
        // 새로운 폴더 버튼 클릭 시 Action
        let alert = UIAlertController(title: "새로운 폴더", message: "이 폴더의 이름을 입력하십시오.", preferredStyle: .alert)
        let save = UIAlertAction(title: "저장", style: .default) { (ok) in
            
            let folder = FolderListData(folderName: alert.textFields?[0].text ?? "", folderCount: 0)
            self.folderListData.append(folder)
            self.folderListTableView.reloadData()
        }
        
        let cancel = UIAlertAction(title: "취소", style: .default)
        
        alert.addAction(cancel)
        alert.addAction(save)
        
        alert.addTextField { (myTextField) in
            myTextField.placeholder = "이름"
            save.isEnabled = false
            
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: myTextField, queue: OperationQueue.main, using:
                {_ in
                    
                    let textCount = myTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0
                    let textIsNotEmpty = textCount > 0
                    
                    save.isEnabled = textIsNotEmpty
            })
        }
        alert.view.tintColor = UIColor(red: 255/255, green: 130/255, blue: 28/255, alpha: 1)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        setView()
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}
extension FolderListViewController {
    func setView() {
        setFolderListData()
        // 리스트 옮기기 직접 구현 코드들
//        let longPressGestrue = UILongPressGestureRecognizer(target: self, action: #selector(longPressCalled(_:)))
//        folderListTableView.addGestureRecognizer(longPressGestrue)
        folderListTableView.delegate = self
        folderListTableView.dataSource = self
        
        folderListTableView.layer.borderWidth = 1
        folderListTableView.layer.borderColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1).cgColor
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        
        toolbar.setBackgroundImage(UIImage(), forToolbarPosition: .bottom, barMetrics: .default)
        toolbar.isTranslucent = false

        
    
    }
    func setFolderListData() {
        let folder1 = FolderListData(folderName: "메모", folderCount: 0)
        folderListData = [folder1]
    }
    func snapShotOfCell(_ inputView: UIView) -> UIView {
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0.0)
        inputView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()! as UIImage
        UIGraphicsEndImageContext()
        
        let cellSnapShot : UIView = UIImageView(image: image)
        cellSnapShot.layer.masksToBounds = false
        cellSnapShot.layer.cornerRadius = 0.0
        cellSnapShot.layer.shadowOffset = CGSize(width: -5.0, height: 0.0)
        cellSnapShot.layer.shadowRadius = 5.0
        cellSnapShot.layer.shadowOpacity = 0.4
        return cellSnapShot
    }
    @objc func longPressCalled(_ longPress: UILongPressGestureRecognizer) {
        let locationView = longPress.location(in: folderListTableView)
        let indexPath = folderListTableView.indexPathForRow(at: locationView)
        struct My {
            static var cellSnapshot : UIView?
        }
        struct Path {
            static var initialIndexPath : IndexPath?
        }
        switch longPress.state {
        case UIGestureRecognizerState.began:
            guard let indexPath = indexPath else {return}
            guard let cell = folderListTableView.cellForRow(at: indexPath) else {return}
            Path.initialIndexPath = indexPath
            My.cellSnapshot = snapShotOfCell(cell)
            
            var center = cell.center
            My.cellSnapshot!.center = center
            My.cellSnapshot!.alpha = 0.0
            folderListTableView.addSubview(My.cellSnapshot!)
            
            UIView.animate(withDuration: 0.25, animations: { () -> Void in
                center.y = locationView.y
                My.cellSnapshot!.center = center
                My.cellSnapshot!.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                My.cellSnapshot!.alpha = 0.98
                cell.alpha = 0.0
            }, completion: { (finished) -> Void in
                if finished {
                    cell.isHidden = true
                }
            })
            
        case UIGestureRecognizerState.changed:
            var center = My.cellSnapshot!.center
            center.y = locationView.y
            My.cellSnapshot!.center = center
            
            if((indexPath != nil) && (indexPath != Path.initialIndexPath)) {
                swap(&folderListData[indexPath!.row], &folderListData[Path.initialIndexPath!.row])
                folderListTableView.moveRow(at: Path.initialIndexPath!, to: indexPath!)
                Path.initialIndexPath = indexPath
            }
        default :
            guard let cell = folderListTableView.cellForRow(at: Path.initialIndexPath!) else {return}
            cell.isHidden = false
            cell.alpha = 0.0
            
            UIView.animate(withDuration: 0.25, animations: { () -> Void in
                My.cellSnapshot!.center = cell.center
                My.cellSnapshot!.transform = CGAffineTransform.identity
                My.cellSnapshot!.alpha = 0.0
                cell.alpha = 1.0
            }, completion: { (finished) -> Void in
                if finished {
                    Path.initialIndexPath = nil
                    My.cellSnapshot!.removeFromSuperview()
                    My.cellSnapshot = nil
                }
            })
            
            
        }
    }
}
extension FolderListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableViewHeight.constant = CGFloat(folderListData.count * 50)
        return folderListData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let folderCell = tableView.dequeueReusableCell(withIdentifier: FolderCell.identifier, for: indexPath) as? FolderCell else { return UITableViewCell() }
        folderCell.setFolderListData(folderName: folderListData[indexPath.row].folderName, folderCount: folderListData[indexPath.row].folderCount)
        
        return folderCell
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        return
    }
    // 첫번째 줄의 '메모' 폴더는 기본 폴더이기 때문에 수정되하지 못하게 만듦.
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == 0 {
            return false
        } else {
            return true
        }
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == 0 {
            return false
        } else {
            return true
        }
    }
}

extension FolderListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    // 테이블 뷰 오->왼 Swipe Action
    // 반대편은 leadingSwipeActionsConfigurationForRowAt 함수로 구현 가능
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if indexPath.row == 0 {
            //첫번째 폴더는 basic 폴더이기 때문에 삭제를 막아두겠습니다
            return UISwipeActionsConfiguration.init()
        } else {
            
        let share = UIContextualAction(style: .normal, title: "Share") { action, view, completion in completion(true) }
        let folder = UIContextualAction(style: .normal, title: "Folder") { action, view, completion in completion(true) }
        // 삭제 클릭 시 나타나는 Action
        let delete = UIContextualAction(style: .destructive, title: "Delete") { action, view, completion in
            
            let alert = UIAlertController(title: "폴더를 삭제하시겠습니까?", message: "모든 메모와 하위 폴더가 삭제됩니다.", preferredStyle: .alert)
            let realdelete = UIAlertAction(title: "확인", style: .default) { (ok) in
                //삭제를 선택한 열이 배열에서 삭제
                self.folderListData.remove(at: indexPath.row)
                self.folderListTableView.reloadData()
            }
            let cancel = UIAlertAction(title: "취소", style: .default)
            
            alert.addAction(cancel)
            alert.addAction(realdelete)
            
            alert.view.tintColor = UIColor(red: 255/255, green: 130/255, blue: 28/255, alpha: 1)
            self.present(alert, animated: true, completion: nil)
            
            completion(true) }
        
        //아이콘 이미지 변경
        delete.image = UIImage.init(systemName: "trash.fill")
        folder.image = UIImage.init(systemName: "folder.fill")
        share.image = UIImage.init(systemName: "person.crop.circle.badge.plus")
        
        // background Color 설정
        folder.backgroundColor = UIColor.systemPurple
        share.backgroundColor = UIColor.systemBlue
        
        return UISwipeActionsConfiguration(actions: [delete, folder, share])
            
        }
    }
    // 편집 버튼 클릭 시 왼쪽에 생기는 delete 버튼 없애기
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
        
    }
}
