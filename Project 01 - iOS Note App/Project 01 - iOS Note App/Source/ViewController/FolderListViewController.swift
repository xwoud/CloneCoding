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
    
    
    
    
    override func viewDidLoad() {
        setView()
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}
extension FolderListViewController {
    func setView() {
        setFolderListData()
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
    
    
}

extension FolderListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
