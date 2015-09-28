# Bundler



Bundler is a swift repository for changing application language bundle on air.

## Usage

Bundler should be initiliazed at appdelegate launchwithoptions to change bundle for UI elements.

```Swift

Bundler.sharedLocalSystem = Bundler()

```


Bundler stores previous language selection at keychain. 


####How to use

```Swift Bundler.sharedLocalSystem?.setLanguageWithBlock(.EN, completion: { (settedLanguage) -> () in
self.lbl.text = "ELLO".localized 
})```



## Requirements

This library requires a deployment target of iOS 7.0 or greater.


## Author

Davut Kilinc, davutklnc@gmail.com

## License

LinkedinIOSHelper is available under the MIT license. See the LICENSE file for more info.
© 2015 Microsoft Koşullar Gizlilik ve tanımlama bilgileri Geliştiriciler Türkçe
