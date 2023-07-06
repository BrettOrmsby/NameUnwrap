import Foundation

enum LoadError: Error {
    case invalidUrl, loadFailure, parseFailure
}

enum Gender: String, Codable  {
    case male, female
}
struct GenderResult: Codable {
    var name: String
    var gender: Gender?
    var probability: Double
    var count: Int
}

func getGender(name: String) -> Result<GenderResult, LoadError> {
    let urlString = "https://api.genderize.io?name=" + name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    let result = fetchJSON(from: urlString, to: GenderResult.self)
    return result
}

struct AgeResult: Codable {
    var name: String
    var age: Int?
    var count: Int
}

func getAge(name: String) -> Result<AgeResult, LoadError> {
    let urlString = "https://api.agify.io?name=" + name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    print(urlString)
    let result = fetchJSON(from: urlString, to: AgeResult.self)
    print(result)
    return result
}

struct NationalityCountry: Codable, Identifiable {
    let id = UUID()
    
    var country_id: String
    var probability: Float
    
    private enum CodingKeys: String, CodingKey {
            case country_id
            case probability
        }
}
struct NationalityResult: Codable {
    var name: String
    var country: [NationalityCountry]
}

func getNationality(name: String) -> Result<NationalityResult, LoadError> {
    let urlString = "https://api.nationalize.io?name=" + name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    let result = fetchJSON(from: urlString, to: NationalityResult.self)
    return result
}

private func fetchJSON<T: Codable>(from urlString: String, to structure: T.Type) -> Result<T, LoadError> {
    guard let url = URL(string: urlString) else {
        return .failure(.invalidUrl)
    }
    
    var jsonString = ""
    let semaphore = DispatchSemaphore(value: 0)
    
    URLSession.shared.dataTask(with: url) { (data, response, error) in
        defer {
            semaphore.signal()
        }
        
        if let error = error {
            print("Error: \(error.localizedDescription)")
            return
        }
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            print("HTTP Error")
            return
        }
        
        guard let jsonData = data else {
            print("No data received")
            return
        }
        
        if let receivedString = String(data: jsonData, encoding: .utf8) {
            jsonString = receivedString
        } else {
            return
        }
    }.resume()
    
    semaphore.wait()
    
    if jsonString.isEmpty {
        return .failure(.loadFailure)
    }
    if let data = jsonString.data(using: .utf8), let result = try? JSONDecoder().decode(structure, from: data) {
        return .success(result)
    }
    return .failure(.parseFailure)
}
