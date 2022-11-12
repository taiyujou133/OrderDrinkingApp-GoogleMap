//
//  MainViewController.swift
//  OrderDrinkingApp
//
//  Created by Tai on 2022/11/3.
//

import UIKit

class MainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    //儲存螢幕寬度
    let width = UIScreen.main.bounds.width
    //先在素材庫存了七張圖片，這是儲存圖片的陣列
    let imageArray: [UIImage] =
        {
            var arr = [UIImage]()
            for i in 1...7
            {
                let image = UIImage(named: String(i))
                arr.append(image!)
            }
            arr.append(UIImage(named: "1")!)
            return arr
        }()
        
    //儲存當下顯示的圖片的索引
    var imageIndex = 0
        
    //宣告一個CollectionView
    var collectionView: UICollectionView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet var drinkingContainerViews: [UIView]!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //切換冷熱飲
        drinkingContainerViewsChange()
        setupCollectionView()
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(changeBanner), userInfo: nil, repeats: true)
    }
    
    @IBAction func segmentedControlAction(_ sender: UISegmentedControl) {
        
        drinkingContainerViewsChange()
        
    }
    
    func drinkingContainerViewsChange() {
        drinkingContainerViews.forEach {
            $0.isHidden = true
        }
        drinkingContainerViews[segmentedControl.selectedSegmentIndex].isHidden = false
    }
    
    func setupCollectionView()
        {
            let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            
            // section與section之間的距離(如果只有一個section，可以想像成frame) 沒影響
            layout.sectionInset = UIEdgeInsets.zero
            
            // cell的寬、高
            layout.itemSize = CGSize(width: width,
                                     height: 200)
            
            // cell與cell的間距
            layout.minimumLineSpacing = CGFloat(integerLiteral: Int(0))
            
            // cell與邊界的間距 沒影響
            //        layout.minimumInteritemSpacing = CGFloat(integerLiteral: 10)
            
            // 滑動方向預設為垂直。注意若設為垂直，則cell的加入方式為由左至右，滿了才會換行；若是水平則由上往下，滿了才會換列
            layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
            
            // 設定collectionView的大小
            let rect = CGRect(x: 0, y: 90, width: width, height: width * (9 / 17))
            self.collectionView = UICollectionView(frame: rect, collectionViewLayout: layout)
            self.collectionView.dataSource = self
            self.collectionView.delegate = self
            self.collectionView.register(MyCollectionViewCell.self, forCellWithReuseIdentifier: "MyCollectionViewCell")
            self.collectionView.isPagingEnabled = true
            self.collectionView.backgroundColor = .clear
            self.view.addSubview(collectionView)
        }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            imageArray.count
        }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCollectionViewCell", for: indexPath) as! MyCollectionViewCell
        cell.imageView.image = imageArray[indexPath.item]
        return cell
    }
    
    @objc func changeBanner()
    {
        imageIndex += 1
        let indexPath: IndexPath = IndexPath(item: imageIndex - 1, section: 0)
        if imageIndex < (imageArray.count - 1) {
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        } else if imageIndex == imageArray.count {
            imageIndex = 0
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
            changeBanner()
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
