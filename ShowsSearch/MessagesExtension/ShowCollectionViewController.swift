//
//  ShowCollectionViewController.swift
//  ShowSearch
//
//  Created by Markim Shaw on 9/17/16.
//  Copyright © 2016 Markim Shaw. All rights reserved.
//

import UIKit

private let reuseIdentifier = "PosterCell"



class ShowCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout{
    
    static let storyboardID = "ShowController"
    
    var model:ViewModel!
    weak var delegate:ShowControllerDelegate?
    var cache:NSCache<AnyObject, AnyObject>!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        //create cache for storing images that can be passed into other viewcontrollers
        self.cache = NSCache()
        
        self.model = ViewModel(delegate: self)
        //self.model.delegate = self
        
        let api = ShowAPI(url: "http://api.tvmaze.com/shows", params: [:], delegate: self.model)
        api.request()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var view:UICollectionReusableView? = nil
        
        if kind == UICollectionElementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ShowHeaderCell", for: indexPath) as! ShowCollectionReusableView
            view = header
        }
        
        return view!
    }
 
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let show = self.model.data![indexPath.row]
        let image = self.cache.object(forKey: "\(self.model[indexPath.row].value.name)" as AnyObject) as? UIImage
        self.delegate?.sendTVInformation(show: show, posterImage: image)
    }



    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        guard let count = self.model.data?.count else { return 0 }
        return count
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        

    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PosterCell", for: indexPath) as! PosterCollectionViewCell
        cell.tag = indexPath.row
        cell._posterImageView.image = nil
        
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        //indicator.center = cell.center
        indicator.hidesWhenStopped = true
        
        indicator.frame = CGRect(x: cell.frame.width / 2 - (37/2), y: cell.frame.height / 2 - (37/2), width: 37, height: 37)
        indicator.startAnimating()
        cell.addSubview(indicator)
        
        //See if there are any images loaded into the cache. If not, create the images then load them into the cache
        if self.cache.object(forKey: "\(self.model[indexPath.row].value.name)" as AnyObject) != nil {
            cell._posterImageView.image = self.cache.object(forKey: "\(self.model[indexPath.row].value.name)" as AnyObject) as? UIImage
            indicator.stopAnimating()
            indicator.removeFromSuperview()
        } else {
            DispatchQueue.global().async{
                do {
                    let data = try Data(contentsOf: URL(string: (self.model[indexPath.row].value.poster_url))!)
                    let image = UIImage(data: data)
                    let index = indexPath.row
                    self.cache.setObject(image!, forKey: "\(self.model[index].value.name)" as AnyObject)
                    DispatchQueue.main.sync {
                        if cell.tag == indexPath.row {
                            cell._posterImageView.image = image
                            indicator.stopAnimating()
                            //cell.indicator.removeFromSuperview()
                            //indicator = nil
                        }
                    }
                } catch {
                    fatalError()
                }
            }
        }
    
        // Configure the cell
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        //bounds.width - (number of items * cell spacing) - (right + left insets)
        return CGSize(width: (UIScreen.main.bounds.width - 6 - 10) / 4.0, height: UIScreen.main.bounds.height / 5.0)
        
    }
 
}

extension ShowCollectionViewController : ViewModelDelegate {
    func reloadData(){
        self.collectionView?.reloadData()
    }
}
