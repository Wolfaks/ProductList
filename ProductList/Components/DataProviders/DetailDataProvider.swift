
import UIKit

class DetailDataProvider: NSObject {
    var categoryList = [Category]()    
}

extension DetailDataProvider: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categoryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! CategoryListTableCell
        cell.set(category: categoryList[indexPath.row])
        return cell
        
    }
    
}

extension DetailDataProvider: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 32.0
    }
    
}
