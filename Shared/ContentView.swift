import UIKit
import SwiftUI
import RealmSwift
import GoogleMobileAds
import AppTrackingTransparency
import AdSupport
import MediaPlayer
import StoreKit


struct AdView: UIViewRepresentable {
    
    
    func makeUIView(context: Context) -> GADBannerView {
        let banner = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        banner.adUnitID = "ca-app-pub-1023155372875273/8634824522"
        
        // 以下は、バナー広告向けのテスト専用広告ユニットIDです。自身の広告ユニットIDと置き換えてください。
        //        banner.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        banner.rootViewController = UIApplication.shared.windows.first?.rootViewController
        banner.load(GADRequest())
        return banner
    }
    
    func updateUIView(_ uiView: GADBannerView, context: Context) {
    }
}


class UserProfile: ObservableObject {
    
    /// 振動機能のモード値
    @Published var vibrationmode: Bool {
        didSet {
            UserDefaults.standard.set(vibrationmode, forKey: "vbmode")
        }}
    @Published var level: Int {
        didSet {
            UserDefaults.standard.set(level, forKey: "level")
        }}
    /// 利き手のモード値
    @Published var mode: Bool {
        didSet {
            UserDefaults.standard.set(mode, forKey: "mode")
        }}
    /// 初期化処理
    init() {
        vibrationmode = UserDefaults.standard.object(forKey:  "vbmode") as? Bool ?? true
        level = UserDefaults.standard.object(forKey: "level") as? Int ?? 1
        mode = UserDefaults.standard.object(forKey: "mode") as? Bool ?? true
    }
}

struct ContentView: View {
    
    let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
    let generator = UINotificationFeedbackGenerator()
    
    @State private var lapmode = true
    @State private var jumpTo = "0"
    @State private var isActive = false
    @AppStorage("FirstLaunch") var firstLaunch = true
    @AppStorage("vbmode2") var vbmode2 = true
    @AppStorage("selection") var selection = 0
    @AppStorage("selection2") var selection2 = 0
    @AppStorage("kidou") var kidou = 0
    
    @State var screen: CGSize?
    @ObservedObject var profile = UserProfile()
    @ObservedObject var soundAlert = SoundAlert()
    @ObservedObject var stopWatchManeger = StopWatchManeger()
    @State var flag = true
    @State var nowTime : Double
    @State var sheetAlert : Bool = false
    @State var sheetAlertRire : Bool = false
    @State var lap234Purchase : String = "false"
    
    var dateFormat: DateFormatter {
        let dformat = DateFormatter()
        dformat.dateFormat = "yyyy/M/d"
        return dformat
    }
    
    var body: some View {
        
        ScrollViewReader { scrollProxy in       // ①ScrollViewProxyインスタンスを取得
            ZStack {
                
                LinearGradient(gradient: Gradient(colors: [Color("akaruiYellow") , Color("ColorSkyBlue")]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                VStack(spacing:2) {
                    
                    if lap234Purchase == "false" {
                        AdView()
                            .frame(height: 50)
                    }
                    
                    Spacer().frame(height: 10)
                    HStack{
                        Spacer().frame(width: 10)
                        Button(action: {
                            self.sheetAlert.toggle()
                        }) {
                            Image(systemName: "gear")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 28, height: 28)
                                .foregroundColor(.black)
                                .padding(5)
                        }.sheet(isPresented: $sheetAlert) {
                            SecondView(lap234Purchase: Binding(projectedValue: $lap234Purchase))
                        }
                        Spacer()
                    }
                    
                    if lap234Purchase == "true" {
                        Spacer().frame(height: 50)
                    }
                    
                    Spacer().frame(height: (screen?.height ?? 100) * 0.03)
                    
                    if selection == 0 {
                        HStack{
                            if stopWatchManeger.minutes > 9 {
                                HStack{
                                    Text(String(format: "%02d", stopWatchManeger.minutes))
                                        .font(Font.custom("HiraginoSans-W3", size: (screen?.width ?? 100) * 0.24))
                                        .font(.system(size: 0, weight: .bold, design: .monospaced))
                                    VStack{
                                        Spacer()
                                        Text("ふん").font(.system(size: (screen?.width ?? 100) * 0.05, weight: .bold, design: .default))
                                    }
                                    Text(String(format: "%02d", stopWatchManeger.second))
                                        .font(Font.custom("HiraginoSans-W3", size: (screen?.width ?? 100) * 0.24))
                                        .font(.system(size: 0, weight: .bold, design: .monospaced))
                                    VStack{
                                        Spacer()
                                        Text("びょう").font(.system(size: (screen?.width ?? 100) * 0.05, weight: .bold, design: .default))
                                    }
                                }.frame(height: 150)
                            } else if stopWatchManeger.minutes > 0 {
                                HStack{
                                    Text(String(format: "%01d", stopWatchManeger.minutes))
                                        .font(Font.custom("HiraginoSans-W3", size: (screen?.width ?? 100) * 0.3))
                                        .font(.system(size: 0, weight: .bold, design: .monospaced))
                                    VStack{
                                        Spacer()
                                        Text("ふん").font(.system(size: (screen?.width ?? 100) * 0.06, weight: .bold, design: .default))
                                    }
                                    Text(String(format: "%02d", stopWatchManeger.second))
                                        .font(Font.custom("HiraginoSans-W3", size: (screen?.width ?? 100) * 0.3))
                                        .font(.system(size: 0, weight: .bold, design: .monospaced))
                                    VStack{
                                        Spacer()
                                        Text("びょう").font(.system(size: (screen?.width ?? 100) * 0.06, weight: .bold, design: .default))
                                    }
                                }.frame(height: 150)
                            } else if stopWatchManeger.second > 9 {
                                HStack{
                                    Text(String(format: "%02d", stopWatchManeger.second))
                                        .font(Font.custom("HiraginoSans-W3", size: (screen?.width ?? 100) * 0.45))
                                        .font(.system(size: 0, weight: .bold, design: .monospaced))
                                    VStack{
                                        Spacer()
                                        Text("びょう").font(.system(size: (screen?.width ?? 100) * 0.1, weight: .bold, design: .default))
                                    }
                                }.frame(height: 150)
                            } else {
                                HStack{
                                    Text(String(format: "%01d", stopWatchManeger.second))
                                        .font(Font.custom("HiraginoSans-W3", size: (screen?.width ?? 100) * 0.5))
                                        .font(.system(size: 0, weight: .bold, design: .monospaced))
                                    VStack{
                                        Spacer()
                                        Text("びょう").font(.system(size: (screen?.width ?? 100) * 0.1, weight: .bold, design: .default))
                                    }
                                }.frame(height: 150)
                            }
                        }
                        .frame(width: (screen?.width ?? 100) * 0.95, height: 200)
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30) //cornerRadiusに角の丸み
                                .stroke(Color.white, lineWidth: 5)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 30))
                    } else if selection == 1 {
                        HStack{
                            if stopWatchManeger.minutes > 9 {
                                HStack{
                                    Text(String(format: "%02d", stopWatchManeger.minutes))
                                        .font(Font.custom("HiraginoSans-W3", size: (screen?.width ?? 100) * 0.28))
                                        .font(.system(size: 0, weight: .bold, design: .monospaced))
                                    VStack{
                                        Spacer()
                                        Text("分").font(.system(size: (screen?.width ?? 100) * 0.05, weight: .bold, design: .default))
                                    }
                                    Text(String(format: "%02d", stopWatchManeger.second))
                                        .font(Font.custom("HiraginoSans-W3", size: (screen?.width ?? 100) * 0.28))
                                        .font(.system(size: 0, weight: .bold, design: .monospaced))
                                    VStack{
                                        Spacer()
                                        Text("秒").font(.system(size: (screen?.width ?? 100) * 0.05, weight: .bold, design: .default))
                                    }
                                }.frame(height: 150)
                            } else if stopWatchManeger.minutes > 0 {
                                HStack{
                                    Text(String(format: "%01d", stopWatchManeger.minutes))
                                        .font(Font.custom("HiraginoSans-W3", size: (screen?.width ?? 100) * 0.33))
                                        .font(.system(size: 0, weight: .bold, design: .monospaced))
                                    VStack{
                                        Spacer()
                                        Text("分").font(.system(size: (screen?.width ?? 100) * 0.06, weight: .bold, design: .default))
                                    }
                                    Text(String(format: "%02d", stopWatchManeger.second))
                                        .font(Font.custom("HiraginoSans-W3", size: (screen?.width ?? 100) * 0.33))
                                        .font(.system(size: 0, weight: .bold, design: .monospaced))
                                    VStack{
                                        Spacer()
                                        Text("秒").font(.system(size: (screen?.width ?? 100) * 0.06, weight: .bold, design: .default))
                                    }
                                }.frame(height: 150)
                            } else if stopWatchManeger.second > 9 {
                                HStack{
                                    Text(String(format: "%02d", stopWatchManeger.second))
                                        .font(Font.custom("HiraginoSans-W3", size: (screen?.width ?? 100) * 0.5))
                                        .font(.system(size: 0, weight: .bold, design: .monospaced))
                                    VStack{
                                        Spacer()
                                        Text("秒").font(.system(size: (screen?.width ?? 100) * 0.1, weight: .bold, design: .default))
                                    }
                                }.frame(height: 150)
                            } else {
                                HStack{
                                    Text(String(format: "%01d", stopWatchManeger.second))
                                        .font(Font.custom("HiraginoSans-W3", size: (screen?.width ?? 100) * 0.6))
                                        .font(.system(size: 0, weight: .bold, design: .monospaced))
                                    VStack{
                                        Spacer()
                                        Text("秒").font(.system(size: (screen?.width ?? 100) * 0.1, weight: .bold, design: .default))
                                    }
                                }.frame(height: 150)
                            }
                        }
                        .frame(width: (screen?.width ?? 100) * 0.95, height: 200)
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30) //cornerRadiusに角の丸み
                                .stroke(Color.white, lineWidth: 5)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 30))
                        
                    } else {
                        HStack{
                            if stopWatchManeger.minutes > 9 {
                                HStack{
                                    Text(String(format: "%02d", stopWatchManeger.minutes))
                                        .font(Font.custom("HiraginoSans-W3", size: (screen?.width ?? 100) * 0.27))
                                        .font(.system(size: 0, weight: .bold, design: .monospaced))
                                    VStack{
                                        Spacer()
                                        Text("Min").font(.system(size: (screen?.width ?? 100) * 0.043, weight: .bold, design: .default))
                                    }
                                    Text(String(format: "%02d", stopWatchManeger.second))
                                        .font(Font.custom("HiraginoSans-W3", size: (screen?.width ?? 100) * 0.27))
                                        .font(.system(size: 0, weight: .bold, design: .monospaced))
                                    VStack{
                                        Spacer()
                                        Text("Sec").font(.system(size: (screen?.width ?? 100) * 0.043, weight: .bold, design: .default))
                                    }
                                }.frame(height: 150)
                            } else if stopWatchManeger.minutes > 0 {
                                HStack{
                                    Text(String(format: "%01d", stopWatchManeger.minutes))
                                        .font(Font.custom("HiraginoSans-W3", size: (screen?.width ?? 100) * 0.33))
                                        .font(.system(size: 0, weight: .bold, design: .monospaced))
                                    VStack{
                                        Spacer()
                                        Text("Min").font(.system(size: (screen?.width ?? 100) * 0.05, weight: .bold, design: .default))
                                    }
                                    Text(String(format: "%02d", stopWatchManeger.second))
                                        .font(Font.custom("HiraginoSans-W3", size: (screen?.width ?? 100) * 0.33))
                                        .font(.system(size: 0, weight: .bold, design: .monospaced))
                                    VStack{
                                        Spacer()
                                        Text("Sec").font(.system(size: (screen?.width ?? 100) * 0.05, weight: .bold, design: .default))
                                    }
                                }.frame(height: 150)
                            } else if stopWatchManeger.second > 9 {
                                HStack{
                                    Text(String(format: "%02d", stopWatchManeger.second))
                                        .font(Font.custom("HiraginoSans-W3", size: (screen?.width ?? 100) * 0.5))
                                        .font(.system(size: 0, weight: .bold, design: .monospaced))
                                    VStack{
                                        Spacer()
                                        Text("Sec").font(.system(size: (screen?.width ?? 100) * 0.1, weight: .bold, design: .default))
                                    }
                                }.frame(height: 150)
                            } else {
                                HStack{
                                    Text(String(format: "%01d", stopWatchManeger.second))
                                        .font(Font.custom("HiraginoSans-W3", size: (screen?.width ?? 100) * 0.6))
                                        .font(.system(size: 0, weight: .bold, design: .monospaced))
                                    VStack{
                                        Spacer()
                                        Text("Sec").font(.system(size: (screen?.width ?? 100) * 0.1, weight: .bold, design: .default))
                                    }
                                }.frame(height: 150)
                            }
                        }
                        .frame(width: (screen?.width ?? 100) * 0.95, height: 200)
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30) //cornerRadiusに角の丸み
                                .stroke(Color.white, lineWidth: 5)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 30))
                    }
                    
                    //◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆ボタン◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆
                    
                    Spacer()
                    
                    if selection2 == 0 {
                        
                        if stopWatchManeger.mode == .stop{
                            VStack{
                                Button(action: {
                                    self.stopWatchManeger.start()
                                    self.soundAlert.start()
                                    if vbmode2 == true{
                                        impactHeavy.impactOccurred() //■■■■■■■■■■■■■■tapticengine feedback■■■■■■■■■■■■■■
                                    }
                                }){
                                    TextView(label : "すたーと")
                                }
                                Spacer().frame(height: 10)
                            }
                        }
                        if stopWatchManeger.mode == .start{
                            VStack{
                                Button(action: {
                                    self.stopWatchManeger.pause()
                                    self.soundAlert.pause()
                                    if vbmode2 == true{
                                        impactHeavy.impactOccurred() //■■■■■■■■■■■■■■tapticengine feedback■■■■■■■■■■■■■■
                                    }
                                }){
                                    TextViewPin(label : "すとっぷ")
                                }
                                Spacer().frame(height: 10)
                            }
                        }
                        
                        if stopWatchManeger.mode == .pause{
                            VStack{
                                Button(action: {
                                    if vbmode2 == true{
                                        impactHeavy.impactOccurred() //■■■■■■■■■■■■■■tapticengine feedback■■■■■■■■■■■■■■
                                    }
                                    
                                    //-書き込み---------------------------書き込み---------------------------書き込み--------------------------
                                    soundAlert.oldMin = 0
                                    stopWatchManeger.minutes = 00
                                    stopWatchManeger.second = 00
                                    stopWatchManeger.milliSecond = 00
                                    stopWatchManeger.hour = 00
                                    self.stopWatchManeger.stop()
                                    self.soundAlert.stop()
                                    
                                }){
                                    TextViewGre(label : "りせっと")
                                }
                                Spacer().frame(height: 10)
                            }
                        }
                    } else  if selection2 == 1 {
                        
                        if stopWatchManeger.mode == .stop{
                            VStack{
                                Button(action: {
                                    self.stopWatchManeger.start()
                                    self.soundAlert.start()
                                    if vbmode2 == true{
                                        impactHeavy.impactOccurred() //■■■■■■■■■■■■■■tapticengine feedback■■■■■■■■■■■■■■
                                    }
                                }){
                                    TextView(label : "スタート")
                                }
                                Spacer().frame(height: 10)
                            }
                        }
                        if stopWatchManeger.mode == .start{
                            VStack{
                                Button(action: {
                                    self.stopWatchManeger.pause()
                                    self.soundAlert.pause()
                                    if vbmode2 == true{
                                        impactHeavy.impactOccurred() //■■■■■■■■■■■■■■tapticengine feedback■■■■■■■■■■■■■■
                                    }
                                }){
                                    TextViewPin(label : "ストップ")
                                }
                                Spacer().frame(height: 10)
                            }
                        }
                        
                        if stopWatchManeger.mode == .pause{
                            VStack{
                                Button(action: {
                                    if vbmode2 == true{
                                        impactHeavy.impactOccurred() //■■■■■■■■■■■■■■tapticengine feedback■■■■■■■■■■■■■■
                                    }
                                    
                                    //-書き込み---------------------------書き込み---------------------------書き込み--------------------------
                                    soundAlert.oldMin = 0
                                    stopWatchManeger.minutes = 00
                                    stopWatchManeger.second = 00
                                    stopWatchManeger.milliSecond = 00
                                    stopWatchManeger.hour = 00
                                    self.stopWatchManeger.stop()
                                    self.soundAlert.stop()
                                    
                                }){
                                    TextViewGre(label : "リセット")
                                }
                                Spacer().frame(height: 10)
                            }
                        }
                    } else {
                        
                        if stopWatchManeger.mode == .stop{
                            VStack{
                                Button(action: {
                                    self.stopWatchManeger.start()
                                    self.soundAlert.start()
                                    if vbmode2 == true{
                                        impactHeavy.impactOccurred() //■■■■■■■■■■■■■■tapticengine feedback■■■■■■■■■■■■■■
                                    }
                                }){
                                    TextView(label : "START")
                                }
                                Spacer().frame(height: 10)
                            }
                        }
                        if stopWatchManeger.mode == .start{
                            VStack{
                                Button(action: {
                                    self.stopWatchManeger.pause()
                                    self.soundAlert.pause()
                                    if vbmode2 == true{
                                        impactHeavy.impactOccurred() //■■■■■■■■■■■■■■tapticengine feedback■■■■■■■■■■■■■■
                                    }
                                }){
                                    TextViewPin(label : "STOP")
                                }
                                Spacer().frame(height: 10)
                            }
                        }
                        
                        if stopWatchManeger.mode == .pause{
                            VStack{
                                Button(action: {
                                    if vbmode2 == true{
                                        impactHeavy.impactOccurred() //■■■■■■■■■■■■■■tapticengine feedback■■■■■■■■■■■■■■
                                    }
                                    
                                    //-書き込み---------------------------書き込み---------------------------書き込み--------------------------
                                    soundAlert.oldMin = 0
                                    stopWatchManeger.minutes = 00
                                    stopWatchManeger.second = 00
                                    stopWatchManeger.milliSecond = 00
                                    stopWatchManeger.hour = 00
                                    self.stopWatchManeger.stop()
                                    self.soundAlert.stop()
                                    
                                }){
                                    TextViewGre(label : "RESET")
                                }
                                Spacer().frame(height: 10)
                            }
                        }
                    }
                    Spacer()
                }
            }
            .fullScreenCover(isPresented: self.$isActive){
                FirstLaunch(isAActive: $isActive, firstLaunch2: $firstLaunch)
                    .onDisappear{
                        ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                            GADMobileAds.sharedInstance().start(completionHandler: nil)
                        })
                    }
            }}
        .onAppear {
            
            print("onAppear")
            
            if firstLaunch {
                isActive = true
            }
            screen = UIScreen.main.bounds.size
            let userDefaults = UserDefaults.standard
            if let value2 = userDefaults.string(forKey: "lap234") {
                print("lap234:\(value2)")
                lap234Purchase = value2
            }
            //--------○回起動毎にレビューを促す--------
            kidou += 1
            if kidou <= 60 {
                if kidou % 30 == 0 {
                    if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                        SKStoreReviewController.requestReview(in: scene)
                    }
                }
            }
            //--------○回起動毎にレビューを促す--------
        }
        .onDisappear {
            
        }
        .onChange(of: profile.mode) { mode in
            UserDefaults.standard.set(profile.mode , forKey: "mode")
        }
        .navigationBarTitle("", displayMode: .inline)
    }
}

