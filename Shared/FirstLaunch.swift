import SwiftUI

struct FirstLaunch: View {
    
    @Binding var isAActive: Bool
    @Binding var firstLaunch2: Bool
    @State var screen2: CGSize?
    
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color("akaruiYellow") , Color("ColorSkyBlue")]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack {
                Spacer().frame(height: 30)
                Text("ダウンロードありがとうございます。").bold().font(.title3)
                VStack(alignment: .leading){
                    Spacer().frame(height: 10)
                    
                    Text(" 【 アプリの使い方 】")
                    VStack(alignment: .leading){
                        Text("１.「すたーと」ボタンで計測開始")
                        Text("２.「すとっぷ」ボタンで計測停止")
                        Text("３.「りせっと」ボタンで０秒に")
                        Text("  　戻ります。")
                    }.frame(width: (screen2?.width ?? 100) * 0.95 , height: 120)
                    .border(Color.black, width: 2)
                    
                    Spacer().frame(height: 20)
                    Text(" 【 測定時間について 】")
                    VStack(alignment: .leading){
                        Text("本アプリは簡単操作かつ数字が大きく")
                        Text("見やすいことを重視しているため")
                        Text("59分59秒までしか表示されません。")
                    }.frame(width: (screen2?.width ?? 100) * 0.95 , height: 90)
                    .border(Color.black, width: 2)
                }.font(.title2)
                    .frame(width: (screen2?.width ?? 100) * 0.95)
                VStack(alignment: .leading){
                    Spacer().frame(height: 8)
                    HStack{
                        Text("※")
                        Image(systemName: "gear")
                    Text("ボタンから設定メニューに　　")}
                    Text("　入れます。")
                    Spacer().frame(height: 8)
                    Text("※ 60秒毎にサウンドが鳴ります。　")
                    Text("  (マナーモード解除時)")
                }.font(.title2)
                    .frame(width: (screen2?.width ?? 100) * 0.95)
                Spacer().frame(height: 40)

                Button(action: {
                    isAActive = false
                    firstLaunch2 = false
                })
                {
                    TextView4(label : "確認しました。")
                }
                .buttonStyle(MyButtonStyle2())
                Spacer()
            }
        }.onAppear {
            screen2 = UIScreen.main.bounds.size
        }
    }
}
