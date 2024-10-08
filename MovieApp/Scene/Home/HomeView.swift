//
//  HomeView.swift
//  MovieApp
//
//  Created by mert polat on 3.02.2024.
//

import UIKit
import TinyConstraints

class HomeView: UIViewController {
    
    private let viewModel: HomeViewModel
    private let router: HomeRouter
    
    private let customHeaderElementKind = "customHeaderElementKind"

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = ColorManager.surfaceDark
        return collectionView
    }()
    
    init(viewModel: HomeViewModel, router: HomeRouter) {
        self.viewModel = viewModel
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        viewModel.fetchInitialData()
        configureNavigationBar()
        
        viewModel.updateHandler = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    
  private func configureUI(){
        view.backgroundColor = ColorManager.dark
        
        view.addSubview(collectionView)
        collectionView.edgesToSuperview()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(PopularMoviesCollectionViewCell.self, forCellWithReuseIdentifier: "StoryCollectionViewCell")
        collectionView.register(PortraitCollectionViewCell.self, forCellWithReuseIdentifier: "PortraitCollectionViewCell")
        collectionView.register(LandscapeCollectionViewCell.self, forCellWithReuseIdentifier: "LandscapeCollectionViewCell")
        collectionView.register(MediumCollectionViewCell.self, forCellWithReuseIdentifier: "MediumCollectionViewCell")
        collectionView.register(CollectionViewHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CollectionViewHeaderReusableView")
        collectionView.register(CustomHeaderReusableView.self, forSupplementaryViewOfKind: customHeaderElementKind, withReuseIdentifier: "CustomHeaderReusableView")
        
        collectionView.collectionViewLayout = createLayout()
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnvironment in
            guard let self = self else { return nil }
            let section = self.viewModel.model.sections[sectionIndex]
            switch section {
            case .stories:
                return self.createStoriesSection()
            case .popular:
                return self.createPopularSection()
            case .trending:
                return self.createComingSoonSection()
            case .topRated:
                return self.createUpcomingSection()
            case .nowPlaying:
                return self.createPopularTVShowsSection()
            }
        }
    }
    
    private func createStoriesSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .absolute(104), heightDimension: .absolute(40)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 0
        section.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 10)
        
        let supplementaryItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(259)), elementKind: customHeaderElementKind, alignment: .bottom)
        section.boundarySupplementaryItems = [supplementaryItem]
        section.supplementariesFollowContentInsets = false
        return section
    }
    
    private func createPopularTVShowsSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .absolute(110), heightDimension: .absolute(165)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 10
        section.contentInsets = .init(top: 0, leading: 15, bottom: 30, trailing: 20)
        section.boundarySupplementaryItems = [self.supplementaryHeaderItem()]
        section.supplementariesFollowContentInsets = false
        return section
    }
    
    private func createPopularSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .absolute(335), heightDimension: .absolute(189)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.interGroupSpacing = 10
        section.contentInsets = .init(top: 0, leading: -20, bottom: 30, trailing: 10)
        section.boundarySupplementaryItems = [self.supplementaryHeaderItem()]
        section.supplementariesFollowContentInsets = false
        return section
    }
    
    private func createComingSoonSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .absolute(110), heightDimension: .absolute(165)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 10
        section.contentInsets = .init(top: 0, leading: 15, bottom: 30, trailing: 20)
        section.boundarySupplementaryItems = [self.supplementaryHeaderItem()]
        section.supplementariesFollowContentInsets = false
        return section
    }
    
    private func createUpcomingSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .absolute(240), heightDimension: .absolute(136)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 10
        section.contentInsets = .init(top: 0, leading: 15, bottom: 30, trailing: 10)
        section.boundarySupplementaryItems = [self.supplementaryHeaderItem()]
        section.supplementariesFollowContentInsets = false
        return section
    }
    
    private func supplementaryHeaderItem() -> NSCollectionLayoutBoundarySupplementaryItem {
        .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
    }
    
    private func configureNavigationBar() {
        let logoImage = UIImage(named: "whiteLogo")
        let logoImageView = UIImageView(image: logoImage)
        logoImageView.contentMode = .scaleAspectFit
        
        navigationController?.navigationBar.barTintColor = ColorManager.dark
        navigationController?.navigationBar.isTranslucent = false
        
        let titleView = UIView()
        titleView.addSubview(logoImageView)
        
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = ColorManager.dark
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }
        
        logoImageView.edgesToSuperview(excluding: .trailing, insets: .left(20))
        logoImageView.width(121)
        logoImageView.height(35)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleView)
        
        let notificationButton = UIBarButtonItem(image: UIImage(systemName: "bell")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(notificationTapped))
        notificationButton.tintColor = .white
        
        let bookmarkButton = UIBarButtonItem(image: UIImage(systemName: "bookmark")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(bookmarkTapped))
        bookmarkButton.tintColor = .white
        
        self.navigationItem.rightBarButtonItems = [notificationButton, bookmarkButton]
    }
    
    @objc private func notificationTapped() {
    }
    
    @objc private func bookmarkTapped() {
    }
}

extension HomeView: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.model.sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.model.sections[section].items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let selectedItem = viewModel.model.sections[indexPath.section].items[indexPath.row]
            switch selectedItem.title {
            case "Featured":
                viewModel.updateCategory(.featured)
            case "Series":
                viewModel.updateCategory(.series)
            case "Films":
                viewModel.updateCategory(.films)
            case "Originals":
                viewModel.updateCategory(.originals)
            default:
                break
            }
        } else {
            let selectedItem = viewModel.model.sections[indexPath.section].items[indexPath.row]
            
            let titlePreviewViewModel = TitlePreviewViewModel(movieService: MovieService(), youtubeService: YoutubeService(), tvShowService: TVShowService())
            
            if let movie = selectedItem.movie {
                titlePreviewViewModel.fetchMovieDetails(for: movie.id)
            } else if let tvShow = selectedItem.tvShow {
                titlePreviewViewModel.fetchTVShowDetails(for: tvShow.id)
            }
            
            let titlePreviewViewController = TitlePreviewViewController(viewModel: titlePreviewViewModel)
            navigationController?.pushViewController(titlePreviewViewController, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch viewModel.model.sections[indexPath.section] {
        case .stories(let items):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoryCollectionViewCell", for: indexPath) as! PopularMoviesCollectionViewCell
            cell.setup(items[indexPath.row])
            return cell
        case .popular(let items):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PortraitCollectionViewCell", for: indexPath) as! PortraitCollectionViewCell
            cell.setup(items[indexPath.row])
            return cell
        case .trending(let items):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LandscapeCollectionViewCell", for: indexPath) as! LandscapeCollectionViewCell
            cell.setup(items[indexPath.row])
            return cell
        case .topRated(let items):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MediumCollectionViewCell", for: indexPath) as! MediumCollectionViewCell
            cell.setup(items[indexPath.row])
            return cell
        case .nowPlaying(let items):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LandscapeCollectionViewCell", for: indexPath) as! LandscapeCollectionViewCell
            cell.setup(items[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == customHeaderElementKind {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CustomHeaderReusableView", for: indexPath) as! CustomHeaderReusableView
            header.setup(with: viewModel.headerImageURL)
            header.onTap = { [weak self] in
                self?.showHeaderMovieDetails()
            }
            return header
        } else if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CollectionViewHeaderReusableView", for: indexPath) as! CollectionViewHeaderReusableView
            header.setup(viewModel.model.sections[indexPath.section].title)
            return header
        }
        return UICollectionReusableView()
    }
    
    private func showHeaderMovieDetails() {
        guard let headerMovie = viewModel.headerItem else { return }

        let titlePreviewViewModel = TitlePreviewViewModel(movieService: MovieService(), youtubeService: YoutubeService(), tvShowService: TVShowService())
        
        if let movie = headerMovie.movie {
            titlePreviewViewModel.fetchMovieDetails(for: movie.id)
        } else if let tvShow = headerMovie.tvShow {
            titlePreviewViewModel.fetchTVShowDetails(for: tvShow.id)
        }
        
        let titlePreviewViewController = TitlePreviewViewController(viewModel: titlePreviewViewModel)
        navigationController?.pushViewController(titlePreviewViewController, animated: true)
    }
}
