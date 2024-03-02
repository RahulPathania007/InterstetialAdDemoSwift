//
//  Constant.swift
//  Localization Demo
//
//  Created by Sunfocus Solutions on 22/02/24.
//

import Foundation

class Constant: NSObject{
    static let languages: [Language] = [.english, .spanish, .german, .hindi, .chinese, .japanese]
    
    
    static let englishWelcomeNote = "Hello, You've selected english as your default app language"
    static let spanishWelcomeNote = "Hola, has seleccionado español como el idioma predeterminado de tu aplicación."
    static let germanWelcomeNote = "Hallo, Sie haben Deutsch als Ihre Standardsprache für die App ausgewählt."
    static let hindiWelcomeNote = "नमस्ते, आपने अपनी डिफ़ॉल्ट एप्लिकेशन भाषा के रूप में हिन्दी का चयन किया है।"
    static let chineseWelcomeNote = "你好，你选择了中文作为你的默认应用语言。"
    static let japaneseWelcomeNote = "こんにちは、あなたは日本語をデフォルトのアプリ言語として選択しました。"
}
