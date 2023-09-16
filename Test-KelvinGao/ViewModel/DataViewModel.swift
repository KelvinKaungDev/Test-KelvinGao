import Foundation

protocol TestDataManagerDelegate {
    func allDatas(data : TestModel)
}

struct DataViewModel {
    
    var delegate : TestDataManagerDelegate?

    func getData() {
        if let url = URL(string: "https://wv-interview.web.app/resource/data.json") {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, _, error in
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    if let fetchedData =  self.fetchData(safeData) {
                        delegate?.allDatas(data: fetchedData)
                    }
                }
            }
            
            task.resume()
        }
    }

    func fetchData(_ data: Data) -> TestModel? {
        let decoder = JSONDecoder()
        do {
            let result = try decoder.decode(TestData.self, from: data)
            let data = TestModel(details: result.responseObject.contentShelfs)
            
            return data
        } catch {
            print(error)
            return nil
        }
    }
    
}
