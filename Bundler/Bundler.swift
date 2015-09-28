//
//  Bundler.swift
//  Bundler
//
//  Created by davut on 11/09/15.
//  Copyright (c) 2015 davut. All rights reserved.
//


import UIKit

// Add Observer for notification to get language changes
let LanguageChangedFromBundleNotification = "LanguageChangedFromBundleNotification"
// NSUserdefaults key to get language from previous session
let SavedAppLanguageKey = "SavedAppLanguageKey"

// Language type keys. Defaults from project settings page. 
//If you want to add more dont forget to add same value to setLanguage(language : String,completion: (settedLanguage :LanguageType) ->()) method too
enum LanguageType :String{
    case BASE = "base"
    case EN = "en"
    case TR = "tr"
    case DE = "de"
    case ZH = "zh"
    case JA = "ja"
    case ES = "es"
    case IT = "it"
    case NL = "nl"
    case KO = "ko"
    case PT = "pt"
    case DA = "da"
    case FI = "fi"
    case NB = "nb"
    case SV = "sv"
    case RU = "ru"
    case PL = "pl"
    case AR = "ar"
    case TH = "th"
    case CS = "cs"
    case HU = "hu"
    case CA = "ca"
    case HR = "hr"
    case EL = "el"
    case HE = "he"
    case RO = "ro"
    case SK = "sk"
    case UK = "uk"
    case ID = "id"
    case VI = "vi"
    case MS = "ms"
    
    static let allValues = [BASE,EN,TR,DE,ZH,JA,ES,IT,NL,KO,PT,DA,FI,NB,SV,RU,PL,AR,TH,CS,HU,CA,HR,EL,HE,RO,SK,UK,ID,VI,MS]
}


class Bundler: NSObject {
    
    static var sharedLocalSystem : Bundler?
    
    // When bundle changes appLanguageChanged() function called to send notification
    // By default mainBundle is setted
    private var bundle : NSBundle = NSBundle.mainBundle(){didSet{appLanguageChanged()}}
    
    //dynamic variable to get and set app language
    private var savedAppLanguage : String
        {
        get{
            if let appLang = AKGSimpleKeychain.loadWithService(SavedAppLanguageKey)
            {
                return appLang as! String
            }
            return "base" // it should never be called
        }
        set{
            AKGSimpleKeychain.saveWithService(SavedAppLanguageKey, data: newValue)
        }
    }
    
    override init() {
        super.init()
        
        if savedAppLanguage.isEmpty == false
        {
            setLanguage(savedAppLanguage, completion: { (settedLanguage) -> () in
                
            })
        }
    }
    
    /**
    Changes bundle and calls block when new language is set.
    
    :param: language     Language type to set
    :returns: completion   Completion closure
    */
    func setLanguageWithBlock(language: LanguageType , completion: (settedLanguage :LanguageType) ->())
    {
        
        let pathForBundle = NSBundle.mainBundle().pathForResource(language.rawValue, ofType: "lproj")
        if pathForBundle == nil
        {
            self.resetLocalization()
        }
        else
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
                if let newBundle = NSBundle(path: pathForBundle!)
                {
                    self.bundle = newBundle
                    self.savedAppLanguage = language.rawValue
                }
                else
                {
                    assert(true, "failed to assign new bundle: " + language.rawValue)
                }
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completion(settedLanguage: language)
                })
            }
        }
    }
    /**
    Changes bundle and sets new language.
    :param: language     Language type to set
    */
    func setLanguage(language: LanguageType)
    {
        setLanguageWithBlock(language) { (settedLanguage) -> () in
        }
    }
    
    func localizedStringForKey(key : String , value : String) ->String
    {
        return bundle.localizedStringForKey(key, value: value, table: nil)
    }
    /**
    Get the current language.
    
    :returns: String current language
    */
    func getCurrentLanguage() ->String
    {
        if let languages = NSUserDefaults.standardUserDefaults().objectForKey("AppleLanguages") as? Array<String>
        {
            if languages.count > 0
            {
                return languages.first!
            }
        }
        return "error lang"
    }

    // Set current language.
    // Since we can't save enums to userdafults we have to check with case
    private func setLanguage(language : String,completion: (settedLanguage :LanguageType) ->())
    {
        var newLanguageKey : LanguageType?
        
        for langType in LanguageType.allValues
        {
            if langType.rawValue == language
            {
                newLanguageKey = langType
            }
        }

        if let key = newLanguageKey
        {
            setLanguageWithBlock(key, completion: { (settedLanguage) -> () in
                completion(settedLanguage: settedLanguage)
            })
        }

    }
    
    private func resetLocalization()
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            self.bundle = NSBundle.mainBundle()
        }
    }
    private func appLanguageChanged()
    {
        NSNotificationCenter.defaultCenter().postNotificationName(LanguageChangedFromBundleNotification, object: nil)
    }
   
}

//MARK: String extension to get localised string from bundle
// if you want to change its place consider to change privacy of bundle in manager
extension String
{
    /**
    Get string from LocalizationManager.sharedLocalSystem.bundle.
    
    :returns: String with current bundle
    */
    var localized: String {
        let bundle = Bundler.sharedLocalSystem!.bundle
        return NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
    }
    /**
    Get string from LocalizationManager.sharedLocalSystem.bundle with comment
    
    :returns: String with current bundle
    */
    func localizedWithComment(comment:String) -> String {
        let bundle = Bundler.sharedLocalSystem!.bundle
        return NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: comment)
    }
}



let kSecClassValue = kSecClass as NSString
let kSecAttrAccountValue = kSecAttrAccount as NSString
let kSecValueDataValue = kSecValueData as NSString
let kSecClassGenericPasswordValue = kSecClassGenericPassword as NSString
let kSecAttrServiceValue = kSecAttrService as NSString
let kSecMatchLimitValue = kSecMatchLimit as NSString
let kSecReturnDataValue = kSecReturnData as NSString
let kSecMatchLimitOneValue = kSecMatchLimitOne as NSString

class AKGSimpleKeychain {
    
    class func getKeychainQuery(service:String!) -> NSMutableDictionary! {
        return [
            String(kSecClass)         : String(kSecClassGenericPassword),
            String(kSecAttrAccount)   : service,
            String(kSecValueData)     : service ] as NSMutableDictionary!
    }
    
    class func saveWithService(service:String!, data:String!) {
        
        let dataFromString: NSData = data.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
        // Instantiate a new default keychain query
        let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service, dataFromString], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecValueDataValue])
        
        // Delete any existing items
        SecItemDelete(keychainQuery as CFDictionaryRef)
        
        if data == "" { return }
        
        // Add the new keychain item
        let _ : OSStatus = SecItemAdd(keychainQuery as CFDictionaryRef, nil)
    }
    
    class func loadWithService(serviceKey:String?) -> AnyObject? {
        
        if let service = serviceKey
        {
            let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service, kCFBooleanTrue, kSecMatchLimitOneValue], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecReturnDataValue, kSecMatchLimitValue])
            
            // Search for the keychain items
            var result: AnyObject?
            let status = withUnsafeMutablePointer(&result) { SecItemCopyMatching(keychainQuery as CFDictionaryRef, UnsafeMutablePointer($0)) }
            
            var contentsOfKeychain: NSString?
            if status == errSecSuccess {
                if let data = result as! NSData? {
                    if let _ = NSString(data: data, encoding: NSUTF8StringEncoding) {
                        // Convert the data retrieved from the keychain into a string
                        contentsOfKeychain = NSString(data: data, encoding: NSUTF8StringEncoding)
                    }
                }
            } else {
                return nil
            }
            
            return contentsOfKeychain

        }
        return nil
    }
    
    class func deleteObjectWithService(service:String!) {
        
        let keychainQuery = self.getKeychainQuery(service)
        SecItemDelete(keychainQuery as CFDictionaryRef)
    }
}

