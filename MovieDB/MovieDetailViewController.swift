//
//  MovieDetailViewController.swift
//  MovieDB
//
//  Created by Rahul Nair on 14/03/21.
//

import UIKit

class MovieDetailViewController: UIViewController {

    //MARK:- IBOutlet
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewTextView: UITextView!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    
    //MARK:- Variables
    var movie: Movie?

    //MARK:- View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        setupView()
    }

    init(movie: Movie) {
        super.init(nibName: String(describing: MovieDetailViewController.self), bundle: nil)
        self.movie = movie
    }
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    
    
   
   

    //MARK:- Helpers
    func setupView() {
        guard let movie = movie else { return }
        titleLabel.text = movie.title
        overviewTextView.text = movie.overview
        ratingLabel.text = "\(movie.rating)"
        let placeholderImage = UIImage(named: "placeholder")
        APIClient.sharedInstance.getData(from: movie.posterUrl()!) { (data, response, erro) in
            DispatchQueue.main.async { [self] in
                if data != nil {
                    self.posterImage.image = UIImage(data: data!)
                }else{
                    posterImage.image = placeholderImage
                }
                
            }
            
        }
     
    
    
    }

    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

