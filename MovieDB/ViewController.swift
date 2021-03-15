//
//  ViewController.swift
//  MovieDB
//
//  Created by Rahul Nair on 12/03/21.
//

import UIKit

class ViewController: UIViewController {
    
    let searchController = UISearchController(searchResultsController: nil)


    @IBOutlet weak var movieCollectionView: UICollectionView!
    private let itemsPerRow: CGFloat = 2

    private let sectionInsets = UIEdgeInsets(top: 10.0,left: 10.0,bottom: 10.0,right:10.0)

    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var cellSize :CGSize?
    
    var isLoading = false
    
    var loadingView: LoaderCollectionReusableView?

    var nowPlayingViewModel = NowPlayingViewModel()

    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }

    
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let settingMenuItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action:  #selector(menuAction))

        
        settingMenuItem.title = "Settings"
        self.navigationItem.setLeftBarButton(settingMenuItem, animated: false);

        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Movies Locally"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        
        movieCollectionView.register(UINib(nibName: "MoviewCVCell", bundle: nil), forCellWithReuseIdentifier: "moview_cell_id")
        let loadingReusableNib = UINib(nibName: "LoaderCollectionReusableView", bundle: nil)
        movieCollectionView.register(loadingReusableNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "loadingresuableviewid")

        
        movieCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")

        movieCollectionView.delegate = self
        movieCollectionView.dataSource = self
        
        
        
        var  paddingSpace : CGFloat = 10.0
        if UIDevice.current.orientation.isLandscape {
            print("isLandscape")
            paddingSpace = (view.frame.width * 0.15) * (itemsPerRow + 1)
        }else if UIDevice.current.orientation.isPortrait {
            print("isPortrait")
            paddingSpace = (view.frame.width * 0.025) * (itemsPerRow + 1)
         }
        
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth * 0.50
      
        cellSize = CGSize(width: widthPerItem, height: (widthPerItem + widthPerItem/2))

        
        
        nowPlayingViewModel.fetchNowPlaying { (response) in
            if response == true {
                DispatchQueue.main.async {
                    self.movieCollectionView.reloadData()
                }
                
            }
        }
    }
    
    @objc func menuAction(){
        print("menu button pressed")  //Do your action here
        let alert = UIAlertController(title: "SORT", message: "Please select sorting order", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Popularity", style: .default , handler:{ [self] (UIAlertAction)in
            let tempArray = self.nowPlayingViewModel.response?.movies
            nowPlayingViewModel.response?.movies = (tempArray?.sorted(by: {$0.voteAverage > $1.voteAverage}))!
            self.movieCollectionView.reloadData()
            
           }))
           
           alert.addAction(UIAlertAction(title: "Rating", style: .default , handler:{ (UIAlertAction)in
            // TODO

           }))

           self.present(alert, animated: true, completion: {
               print("completion block")
           })
    }
    
    
    
    func filterContentForSearchText(_ searchText: String) {
        self.nowPlayingViewModel.filteredMovies =  (self.nowPlayingViewModel.response?.movies.filter { (movie: Movie) -> Bool in
            return (movie.title?.lowercased().contains(searchText.lowercased()))!
        })!
        
        
        self.movieCollectionView.reloadData()
      
    }

}


// MARK: - Collection View Flow Layout Delegate

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == (self.nowPlayingViewModel.response?.movies.count)! - 10 && !self.isLoading {
                loadMoreData()
            }
        }

        func loadMoreData() {
            if !self.isLoading {
                self.isLoading = true
                DispatchQueue.global().async {
                    self.nowPlayingViewModel.fetchNowPlaying { (response) in
                        if response == true {
                            DispatchQueue.main.async {
                                self.movieCollectionView.reloadData()
                                self.isLoading = false
                            }
                        }
                    }
                }
            }
        }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
            if elementKind == UICollectionView.elementKindSectionFooter {
                self.loadingView?.activityIndicator.startAnimating()
            }
        }

        func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
            if elementKind == UICollectionView.elementKindSectionFooter {
                self.loadingView?.activityIndicator.stopAnimating()
            }
        }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
            if kind == UICollectionView.elementKindSectionFooter {
                let aFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "loadingresuableviewid", for: indexPath) as! LoaderCollectionReusableView
                loadingView = aFooterView
                loadingView?.backgroundColor = UIColor.clear
                return aFooterView
            }
            return UICollectionReusableView()
        }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
            if self.isLoading {
                return CGSize.zero
            } else {
                return CGSize(width: collectionView.bounds.size.width, height: 55)
            }
        }
  // 1
  func collectionView(
    _ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    // 2
   
    
    return cellSize!
  }
  
  // 3
  func collectionView(
    _ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,insetForSectionAt insetForSectionAtsection: Int) -> UIEdgeInsets {
    return sectionInsets
  }
  
  // 4
  func collectionView(
    _ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return sectionInsets.left
  }
}


extension ViewController : UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var obj : Movie?

        if isFiltering {
            obj = nowPlayingViewModel.filteredMovies[indexPath.row]
        } else {
            obj = nowPlayingViewModel.response?.movies[indexPath.row]
        }
        
        if obj != nil {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "detail_vc_id") as?
                MovieDetailViewController {
                vc.movie = obj
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
            
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if isFiltering {
            return nowPlayingViewModel.filteredMovies.count ?? 0
         }
        
        return nowPlayingViewModel.response?.movies.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        
        let cell : MoviewCVCell = collectionView.dequeueReusableCell(withReuseIdentifier: "moview_cell_id", for: indexPath) as! MoviewCVCell
        var obj : Movie?
        
        if isFiltering {
            obj = nowPlayingViewModel.filteredMovies[indexPath.row]
        } else {
            obj = nowPlayingViewModel.response?.movies[indexPath.row]
        }
        
        if obj != nil {
            cell.setupData(movieObj: obj!)
        }
        
            
        
            
        
        
        return cell
    }
}

extension ViewController: UISearchResultsUpdating{
    

  func updateSearchResults(for searchController: UISearchController) {
    let searchBar = searchController.searchBar
    filterContentForSearchText(searchBar.text!)
  }
}
