import UIKit
import Network

class ViewController: UIViewController {
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet weak var theme: UISegmentedControl!
    @IBOutlet var myPage: UIPageControl!
    
    @IBOutlet var bannerCollections: UICollectionView!
    @IBOutlet var carouselCollectionA: UICollectionView!
    @IBOutlet var carouselCollectionB: UICollectionView!
    
    @IBOutlet var card: UIView!
    @IBOutlet var cardTitle: UILabel!
    @IBOutlet var cardImage: UIImageView!

    private var currentPage : Int = 0
    private var bannerImages = [String]()
    private var carouselOneImages = [String]()
    private var carouselTwoImages = [String]()
    
    var dataViewModel = DataViewModel()
    private let monitor = NWPathMonitor()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        dataViewModel.getData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.refreshControl = UIRefreshControl()
        scrollView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
        
        card.layer.cornerRadius = 5.0
        card.layer.shadowColor = UIColor.gray.cgColor
        card.layer.shadowOffset = CGSize(width: 100.0, height: 10.0)
        card.layer.shadowRadius = 10.0
        card.layer.shadowOpacity = 0.7
        
        let bannerLayout = UICollectionViewFlowLayout()
        bannerLayout.scrollDirection = .horizontal
        bannerLayout.minimumLineSpacing = 0
        bannerLayout.minimumInteritemSpacing = 0
        bannerCollections.collectionViewLayout = bannerLayout
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        carouselCollectionB.collectionViewLayout = layout
        
        dataViewModel.delegate = self
        bannerCollections.delegate = self
        carouselCollectionA.delegate = self
        
        bannerCollections.dataSource = self
        carouselCollectionA.dataSource = self
        
        myPage.currentPage = 0
        theme.selectedSegmentIndex = ThemeViewModel.shared.theme.rawValue
        
        monitor.pathUpdateHandler = { path in
                if path.status == .satisfied {
                    print("Internet connection is available.")
                } else {
                    print("No internet connection.")
                }
            }
            
            let queue = DispatchQueue(label: "NetworkMonitor")
            monitor.start(queue: queue)
    }
    
    @IBAction func changeTheme(_ sender: UISegmentedControl) {
        ThemeViewModel.shared.theme = ThemeModel(rawValue: sender.selectedSegmentIndex) ?? .Light
        self.view.window?.overrideUserInterfaceStyle = ThemeViewModel.shared.theme.getUserInterfaceStyle()
    }
    
    @objc func handleRefreshControl() {
       DispatchQueue.main.async {
          self.scrollView.refreshControl?.endRefreshing()
       }
    }
     
    deinit {
           monitor.cancel()
       }
}
//MARK: - TestData

extension ViewController : TestDataManagerDelegate {
    func allDatas(data: TestModel) {
        DispatchQueue.main.async { [self] in
            
            data.details[0].items?.forEach({ item in
                self.bannerImages.append(item.coverUrl)
                myPage.numberOfPages = bannerImages.count
                self.bannerCollections.reloadData()
            })
            
            data.details[1].items?.forEach({ item in
                self.carouselOneImages.append(item.coverUrl)
                self.carouselCollectionA.reloadData()
            })
            
            data.details[3].items?.forEach({ item in
                self.carouselTwoImages.append(item.coverUrl)
                self.carouselCollectionB.reloadData()
            })
            
            self.cardTitle.text = data.details[2].title
            self.cardImage.downloaded(from: data.details[2].coverUrl!)
        }
    }
}
//MARK: - UICollectionView

extension ViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
            case self.bannerCollections :
                let count = bannerImages.count
                return count
                
            case self.carouselCollectionA :
                let count = carouselOneImages.count
                return count
            
            case self.carouselCollectionB :
                let count = carouselTwoImages.count
                return count
            
            default :
                return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
            case self.bannerCollections :
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! BannerCollectionCell
                cell.bannerImages.downloaded(from: URL(string: bannerImages[indexPath.row])!)
                cell.reloadInputViews()
                return cell
            
            case self.carouselCollectionA :
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "carouselACell", for: indexPath) as! CarouselCollectionACell
                cell.carouselImageCollections.downloaded(from: URL(string: carouselOneImages[indexPath.row])!)
                cell.reloadInputViews()
                return cell
            
            case self.carouselCollectionB :
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "carouselBCell", for: indexPath) as! CarouselCollectionBCell
                cell.carouselBImages.downloaded(from: URL(string: carouselTwoImages[indexPath.row])!)
                cell.reloadInputViews()
                return cell
            
            default:
                return UICollectionViewCell()
        }
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == bannerCollections {
            myPage.currentPage = indexPath.row
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case bannerCollections :
            let width = collectionView.frame.width
            return CGSize(width: width, height: 350)
            
        case carouselCollectionA :
            let width = ((collectionView.frame.width - 15) / 2)
            return CGSize(width: width, height: floor(200.0))
            
        case carouselCollectionB :
            return CGSize(width: 200, height: 200)
        default :
            return CGSize(width: 0, height: 0)
        }

    }
    
}

//MARK: - UIImageView

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
                              
            if let data = data, let image = UIImage(data: data) {
                   DispatchQueue.main.async {
                       self.image = image
                   }
               } else {
                   if let defaultImageUrl = URL(string: "https://files.wpfixit.com/wp-content/uploads/2019/03/HTTP-error-when-uploading-images-in-WordPress.jpg") {
                       let defaultTask = URLSession.shared.dataTask(with: defaultImageUrl) { (defaultData, _, _) in
                           if let defaultData = defaultData, let defaultImage = UIImage(data: defaultData) {
                               DispatchQueue.main.async {
                                   self.image = defaultImage
                               }
                           } else {
                               print("Failed to load the default image.")
                           }
                       }
                       defaultTask.resume()
                   }
               }
        }.resume()
    }

    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}


