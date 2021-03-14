//
//  MoviewCVCell.swift
//  MovieDB
//
//  Created by Rahul Nair on 13/03/21.
//

import UIKit

class MoviewCVCell: UICollectionViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupData(movieObj: Movie) {
        self.titleLable.text = movieObj.title
        APIClient.sharedInstance.getData(from: movieObj.posterUrl()!) { (data, response, erro) in
            DispatchQueue.main.async {
                self.imageView.image = UIImage(data: data!)
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //hide or reset anything you want hereafter, for example
        titleLable.text = ""
        imageView.image = nil
    }
}
