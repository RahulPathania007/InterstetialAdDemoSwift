//
//  SelectLanguageViewController.swift
//  Localization Demo
//
//  Created by Sunfocus Solutions on 22/02/24.
//

import UIKit


enum Language: String{
    case def = ""
    case english = "English"
    case spanish = "Spanish"
    case german = "German"
    case hindi = "हिन्दी"
    case chinese = "中文"
    case japanese = "日本語"
}



class SelectLanguageViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Variables
    var selectedLanguage: String = "English"
    var selectedLang: Language = .english
    var selectMultiLang: [Language] = []
    var adManager = AdManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectedLang = LanguageManager.getSelectedLanguage()
        self.tableView.register(UINib(nibName: "languageTableViewCell", bundle: nil), forCellReuseIdentifier: "languageTableViewCell")
        self.nextButton.layer.cornerRadius = 5
        self.adManager.loadStartupAd()
    }
    
    //MARK: - IBAction
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        if selectedLang == .def {
            AlertManager.shared.show(GPAlert(title: "Oops", message: "Please select a Language"))
            return
        }
        LanguageManager.saveSelectedLanguage(selectedLang)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(identifier: "ResponseViewController") as? ResponseViewController else {
            return
        }
        self.navigationController?.pushViewController(vc, animated: false)
    }
}

extension SelectLanguageViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constant.languages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "languageTableViewCell", for: indexPath) as? languageTableViewCell else { return UITableViewCell() }
        
        //For multi select
//        if selectMultiLang.contains(where: {$0 == Constant.languages[indexPath.row] }){
//            cell.selectImage.image = UIImage(systemName: "checkmark.circle.fill")
//        }else{
//            cell.selectImage.image = UIImage(systemName: "")
//        }
        
        //For single select
        if selectedLang.rawValue == Constant.languages[indexPath.row].rawValue{
            cell.selectImage.image = UIImage(systemName: "checkmark.circle.fill")
        }else{
            cell.selectImage.image = UIImage(systemName: "")
        }
        
        cell.langNameLabel.text = Constant.languages[indexPath.row].rawValue
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //For multi select
//        if selectMultiLang.contains(where: {$0 == Constant.languages[indexPath.row] }){
//            selectMultiLang.removeAll(where: {$0 == Constant.languages[indexPath.row] } )
//        }else{
//            selectMultiLang.append(Constant.languages[indexPath.row])
//        }
        
        
        //For single select
        if selectedLang.rawValue == Constant.languages[indexPath.row].rawValue{
            selectedLang = .def
        }else{
            selectedLang = Constant.languages[indexPath.row]
        }
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55.0
    }
}
