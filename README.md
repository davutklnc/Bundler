# Bundler

Bundler is a swift repository for changing application language bundle on air.

Bundler should be initiliazed at appdelegate launchwithoptions to change bundle for UI elements.

Bundler.sharedLocalSystem = Bundler()


Bundler stores previous language selection at keychain. 


#How to use

Bundler.sharedLocalSystem?.setLanguageWithBlock(.EN, completion: { (settedLanguage) -> () in
self.lbl.text = "ELLO".localized
})
