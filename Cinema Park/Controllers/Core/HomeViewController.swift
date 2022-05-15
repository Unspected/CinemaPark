//
//  HomeViewController.swift
//  Cinema Park
//
//  Created by Pavel Andreev on 4/16/22.
//

import UIKit

enum Sections: Int {
    
    case TrandingMovies = 0
    case TrandingTv = 1
    case Popular = 2
    case Upcoming = 3
    case TopRated = 4
}

class HomeViewController: UIViewController {
    
    private var randomTrandingMovie: Title?
    private var headerView: HeroHeaderUIView?
    
    let sectionTitles: [String] = ["Tranding Movies", "Tranding TV", "Popular", "Upcoming Movies", "Top Rated"]
    
    private let homeFeedTable: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addSubview(homeFeedTable)
        homeFeedTable.dataSource = self
        homeFeedTable.delegate = self
        configureNavBar()
        headerView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 500))
        homeFeedTable.tableHeaderView = headerView
        configureHeroHeaderView()
        
    }
    
    private func configureNavBar() {
        var image = UIImage(named: "netflixLogo")
        image = image?.withRenderingMode(.alwaysOriginal)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        navigationItem.rightBarButtonItems = [
                UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
                UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
                ]
        navigationController?.navigationBar.tintColor = .white
    }
    
    private func configureHeroHeaderView() {
        
        APICaller.share.getTrendingMovies { [weak self] result in
            switch result {
            case .success(let titles):
                let selectedTitles = titles.randomElement()
                self?.randomTrandingMovie = selectedTitles
                self?.headerView?.configure(with: TitleViewModel(titleName: selectedTitles?.original_title ?? "", posterUrl: selectedTitles?.poster_path ?? ""))
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }
    

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else { return UITableViewCell() }
        
        cell.delegate = self
        
        switch indexPath.section {
            
        case Sections.TrandingMovies.rawValue:
             APICaller.share.getTrendingMovies(complition: { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error)
                }
            })
        case Sections.TrandingTv.rawValue:
            APICaller.share.getTrendingTV(complition: { result in
               switch result {
               case .success(let titles):
                   cell.configure(with: titles)
               case .failure(let error):
                   print(error)
               }
           })
        case Sections.Popular.rawValue:
            APICaller.share.getPopular(complition: { result in
               switch result {
               case .success(let titles):
                   cell.configure(with: titles)
               case .failure(let error):
                   print(error)
               }
           })
        case Sections.Upcoming.rawValue:
            APICaller.share.getUpComingMovies(complition: { result in
               switch result {
               case .success(let titles):
                   cell.configure(with: titles)
               case .failure(let error):
                   print(error)
               }
           })
        case Sections.TopRated.rawValue:
            APICaller.share.getTopRated(complition: { result in
               switch result {
               case .success(let titles):
                   cell.configure(with: titles)
               case .failure(let error):
                   print(error)
               }
           })
        default:
            return UITableViewCell()
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return}
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100,
                                         height: header.bounds.height)
        header.textLabel?.textColor = .white
        header.textLabel?.text = header.textLabel?.text?.capitalizeFirstLetter()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        40
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOfsets = view.safeAreaInsets.top
        let offsets = scrollView.contentOffset.y + defaultOfsets
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offsets))
    }
    
}


extension HomeViewController: CollectionViewTableViewCellDelegate {
    func collectionViewTableViewCellDidTap(_ cell: CollectionViewTableViewCell, viewModel: TitlePreviewModel) {
        DispatchQueue.main.async { [weak self] in
            let vc = TitlePreviewViewController()
            vc.configure(model: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}
