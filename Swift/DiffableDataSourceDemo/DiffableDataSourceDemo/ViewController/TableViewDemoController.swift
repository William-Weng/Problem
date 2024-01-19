//
//  TableViewDemoController.swift
//  Example
//
//  Created by William.Weng on 2024/1/1.
//
/// [EwingYangs/awesome-open-gpt: Collection of Open Source Projects Related to GPT，GPT相关开源项目合集🚀、精选🔥🔥](https://github.com/EwingYangs/awesome-open-gpt)

import UIKit
import WWPrint

final class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var actorLabel: UILabel!
    
    var movie: TableViewDemoController.Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSetting()
    }
    
    /// 初始化
    func initSetting() {
        yearLabel.text = "\(movie?.year ?? 1911)"
        nameLabel.text = movie?.name
        actorLabel.text = movie?.actor
    }
}

final class TableViewDemoController: UIViewController {

    typealias MovieInfo = (section: Section, items: [Movie])
    
    enum Section: Int {
        case adventure
        case romance
    }
    
    struct Movie: Hashable {
        
        let uuid = UUID()   // 以UUID為hash值 (防止一樣的資料不能新增)
        
        var name: String
        var actor: String
        var year: Int
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(uuid)
        }
        
        static func ==(lhs: Movie, rhs: Movie) -> Bool {
            return lhs.uuid == rhs.uuid
        }
    }
    
    @IBOutlet weak var myTableView: UITableView!
    
    private var moviesInfo: [MovieInfo] = []
    private lazy var dataSource: UITableViewDiffableDataSource<Section, Movie> = dataSourceMaker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSetting()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let indexPath = myTableView.indexPathForSelectedRow,
              let viewController = segue.destination as? MovieDetailViewController
        else {
            return
        }
        
        viewController.movie = seachMovie(with: indexPath)
    }
}

// MARK: - UITableViewDelegate
extension TableViewDemoController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = seachMovie(with: indexPath)
        wwPrint(movie)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return UISwipeActionsConfiguration._build(actions: trailingSwipeActionsMaker(with: indexPath), performsFirstActionWithFullSwipe: true)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return UISwipeActionsConfiguration._build(actions: leadingSwipeActionsMaker(with: indexPath), performsFirstActionWithFullSwipe: false)
    }
}

// MARK: - UITableViewDataSource
//extension TableViewDemoController: UITableViewDataSource {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 10
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let cell = tableView.dequeueReusableCell(withIdentifier: "MyTableViewCell", for: indexPath)
//        let icon = UIImage(systemName: "heart.fill")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
//
//        cell._contentConfiguration(text: "\(indexPath.row)", secondaryText: "\(indexPath.section)", image: icon)
//
//        return cell
//    }
//}

// MARK: - UITableViewDiffableDataSource / NSDiffableDataSourceSnapshot
private extension TableViewDemoController {
    
    /// 初始化
    func initSetting() {
        
        let moviesInfo = movieInfoMaker()
        let snapshot = sourceSnapshotMaker(moviesInfo: moviesInfo)
        
        myTableView.delegate = self
        myTableView.dataSource = dataSource                                 // 取代 myTableView.dataSource = self
        dataSource.apply(snapshot, animatingDifferences: false)             // 取代 reloadData() / reloadRows(at:with:)
        navigationController?.navigationBar.tintColor = .black
    }
    
    /// [產生DiffableDataSource](https://medium.com/彼得潘的-swift-ios-app-開發問題解答集/利用-diffable-data-source-顯示表格內容-4e4aa0294bf6)
    /// => 取代 tableView(_:cellForRowAt:)
    /// - Returns: UITableViewDiffableDataSource<Section, Movie>
    func dataSourceMaker() -> UITableViewDiffableDataSource<Section, Movie> {
        
        let dataSource = UITableViewDiffableDataSource<Section, Movie>(tableView: myTableView) { tableView, indexPath, itemIdentifier in
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyTableViewCell", for: indexPath)
            let icon = UIImage(systemName: "heart.fill")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
            
            cell._contentConfiguration(text: itemIdentifier.name, secondaryText: itemIdentifier.actor, image: icon)
            
            return cell
        }
        
        return dataSource
    }
    
    /// 產生比對用的DataSource
    /// - Returns: NSDiffableDataSourceSnapshot<Section, Movie>
    func sourceSnapshotMaker(moviesInfo: [TableViewDemoController.MovieInfo]) -> NSDiffableDataSourceSnapshot<Section, Movie> {
        
        let sections = moviesInfo.map { $0.section }                                    // [.adventure, .romance]
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Movie>()                   // 取代 Model
        snapshot.appendSections(sections)                                               // 取代 numberOfSections(in:)
        moviesInfo.forEach { snapshot.appendItems($0.items, toSection: $0.section) }    // 取代 tableView(_:numberOfRowsInSection:)

        return snapshot
    }
}

// MARK: - 小工具
private extension TableViewDemoController {
    
    /// 產生假資料
    /// - Returns: [MovieInfo]
    func movieInfoMaker() -> [MovieInfo] {
        
        let adventureMovies = [
            Movie(name: "蜘蛛人:返校日", actor: "湯姆", year: 2017),
            Movie(name: "蜘蛛人:驚奇再起", actor: "安德魯", year: 2012),
            Movie(name: "蜘蛛人", actor: "陶比", year: 2002)
        ]
        
        let romanceMovies = [
            Movie(name: "生命中的美好缺憾", actor: "雪琳", year: 2014),
            Movie(name: "真愛每一天", actor: "瑞秋", year: 2013),
            Movie(name: "手札情緣", actor: "雷恩", year: 2004)
        ]
        
        moviesInfo = [
            (section: .adventure, items: adventureMovies),
            (section: .romance, items: romanceMovies),
        ]

        return moviesInfo
    }
    
    /// 電影假資料
    /// - Returns: Movie
    func fakeMove() -> Movie {
        
        let value = Int.random(in: 1...100)
        let movie = Movie(name: "William 失落的薪水 - \(value)", actor: "你猜猜", year: 2345)
        
        return movie
    }
    
    /// 左側滑動按鈕功能
    /// - Parameter indexPath: IndexPath
    /// - Returns: [UIContextualAction]
    func leadingSwipeActionsMaker(with indexPath: IndexPath) -> [UIContextualAction] {
        
        let deleteAction = UIContextualAction._build(with: "刪除", color: #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)) {
            self.deleteMovie(with: indexPath)
        }
        
        let insertAction = UIContextualAction._build(with: "插入", color: #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)) {
            let movie = self.fakeMove()
            self.insertMovie(movie, after: indexPath)
        }
        
        return [deleteAction, insertAction]
    }
        
    /// 右側滑動按鈕功能
    /// - Parameter indexPath: IndexPath
    /// - Returns: [UIContextualAction]
    func trailingSwipeActionsMaker(with indexPath: IndexPath) -> [UIContextualAction] {
        
        let appendAction = UIContextualAction._build(with: "新增", color: #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)) {
            let movie = self.fakeMove()
            self.appendMovie(movie, with: indexPath)
        }
        
        let insertAction = UIContextualAction._build(with: "插入", color: #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)) {
            let movie = self.fakeMove()
            self.insertMovie(movie, before: indexPath)
        }
        
        let updateAction = UIContextualAction._build(with: "更新", color: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)) {
            
            guard let oldMovie = self.dataSource.itemIdentifier(for: indexPath) else { return }
            
            let movie = Movie(name: "\(Date())", actor: oldMovie.actor, year: oldMovie.year)
            self.updateMovie(movie: movie, with: indexPath)
        }
        
        return [appendAction, insertAction, updateAction]
    }
}

// MARK: - CRUD
private extension TableViewDemoController {
    
    /// [刪除資料](https://medium.com/@le821227/diffable-datasource-for-uitableview-uicollectionview-6c4436362ae6)
    /// - Parameters:
    ///   - indexPath: IndexPath
    ///   - animatingDifferences: Bool
    func deleteMovie(with indexPath: IndexPath, animatingDifferences: Bool = true) {
        
        guard var snapshot = Optional.some(dataSource.snapshot()),
              let deleteItem = dataSource.itemIdentifier(for: indexPath)
        else {
            return
        }
        
        snapshot.deleteItems([deleteItem])
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    /// 新增資料
    /// - Parameters:
    ///   - movie: Movie
    ///   - indexPath: IndexPath
    ///   - animatingDifferences: Bool
    func appendMovie(_ movie: Movie, with indexPath: IndexPath, animatingDifferences: Bool = true) {
        
        guard var snapshot = Optional.some(dataSource.snapshot()),
              let section = Section(rawValue: indexPath.section)
        else {
            return
        }
        
        snapshot.appendItems([movie], toSection: section)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    /// 插入資料 (之前)
    /// - Parameters:
    ///   - movie: Movie
    ///   - indexPath: IndexPath
    ///   - animatingDifferences: Bool
    func insertMovie(_ movie: Movie, before indexPath: IndexPath, animatingDifferences: Bool = true) {
        
        guard var snapshot = Optional.some(dataSource.snapshot()),
              let beforeItem = dataSource.itemIdentifier(for: indexPath)
        else {
            return
        }

        snapshot.insertItems([movie], beforeItem: beforeItem)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    /// 插入資料 (之後)
    /// - Parameters:
    ///   - indexPath: IndexPath
    ///   - movie: Movie
    ///   - animatingDifferences: Bool
    func insertMovie(_ movie: Movie, after indexPath: IndexPath, animatingDifferences: Bool = true) {
                
        guard var snapshot = Optional.some(dataSource.snapshot()),
              let afterItem = dataSource.itemIdentifier(for: indexPath)
        else {
            return
        }

        snapshot.insertItems([movie], afterItem: afterItem)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    /// 搜尋資料
    /// - Parameter indexPath: IndexPath
    /// - Returns: Movie?
    func seachMovie(with indexPath: IndexPath) -> Movie? {
        let item = dataSource.itemIdentifier(for: indexPath)
        return item
    }
    
    /// 更新資料
    /// - Parameters:
    ///   - movie: Movie
    ///   - indexPath: IndexPath
    func updateMovie(movie: Movie, with indexPath: IndexPath) {
        insertMovie(movie, after: indexPath)
        deleteMovie(with: indexPath)
    }
}
