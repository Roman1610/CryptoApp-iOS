import Foundation
import SwiftUI
import Combine
import SwiftUICharts


struct CoinDetailSwiftUIView: View {
    private var coordinator: MainCoordinatorProtocol? = nil
    private var coin: CoinMarket
    @ObservedObject var coinViewModel: CoinDetailViewModel
    
    private let chartStyle = ChartStyle(
        backgroundColor: Color.getAppThemeColor(AppThemeColor.coinDetailBgColor),
        accentColor: .red,
        gradientColor: GradientColor(start: .green, end: .blue),
        textColor: Color.getAppThemeColor(AppThemeColor.coinDetailTextColor),
        legendTextColor: Color.getAppThemeColor(AppThemeColor.coinDetailTextColor),
        dropShadowColor: .gray
    )
    
    init(
        coin coinMarket: CoinMarket,
        viewModel: CoinDetailViewModel,
        coordinator: MainCoordinatorProtocol?
    ) {
        debugPrint("CoinDetailView init")
        coin = coinMarket
        coinViewModel = viewModel
        self.coordinator = coordinator
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "chevron.backward")
                    .frame(minWidth: 40, maxWidth: 40, minHeight: 0, maxHeight: .infinity, alignment: .leading)
                    .scaledToFit()
                Text(coin.name)
                    .font(.system(size: 28, weight: .medium))
            }
            .foregroundColor(Color.getAppThemeColor(AppThemeColor.coinDetailTextColor))
            .frame(maxWidth: .infinity, minHeight: 0, maxHeight: 60, alignment: .leading)
            
            Text("\(coin.currentPrice)")
                .padding(.top, 20)
                .font(.system(size: 23, weight: .medium))
                .foregroundColor(Color.getAppThemeColor(AppThemeColor.coinDetailTextColor))
            
            VStack {
                ZStack {
                    LineView(data: coinViewModel.prices, style: chartStyle)
                        .frame(maxWidth: .infinity, minHeight: 0, maxHeight: 300, alignment: .top)
                    if (coinViewModel.isLoading) {
                        if #available(iOS 14.0, *) {
                            ProgressView()
                                .scaleEffect(2)
                        }
                    }
                }
                .padding(.bottom, 20)
                
                ListPeriodView(currentPeriod: $coinViewModel.period)
                Spacer()
            }
        }
        .preferredColorScheme(.dark)
        .padding(.horizontal, 25)
        .background(Color.getAppThemeColor(AppThemeColor.coinDetailBgColor))
        .onAppear {
            coinViewModel.loadChart()
        }
    }
}

struct ListPeriodView: View {
    @Binding var currentPeriod: TimePeriod
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(TimePeriod.allCases, id: \.self) { period in
                PeriodView(
                    name: period.getName(),
                    isActive: currentPeriod == period
                ) {
                    currentPeriod = period
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity)
        }
    }
}

struct PeriodView: View {
    let name: String
    let isActive: Bool
    let didClicked: () -> Void
    
    var body: some View {
        if isActive {
            buildButton(
                bgColor: Color.getAppThemeColor(AppThemeColor.coinDetailPeriodBgColor)
            )
            .foregroundColor(
                Color.getAppThemeColor(AppThemeColor.coinDetailPeriodActiveTextColor)
            )
        } else {
            buildButton(bgColor: nil)
                .foregroundColor(
                    Color.getAppThemeColor(AppThemeColor.coinDetailPeriodInactiveTextColor)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color.green, lineWidth: 2)
                )
        }
    }
    
    private func buildButton(bgColor: Color?) -> some View {
        return Button(name, action: !isActive ? didClicked : {})
            .font(.system(size: 12, weight: .medium))
            .lineLimit(1)
            .padding(.vertical, 5)
            .padding(.horizontal, 15)
            .background(bgColor)
            .cornerRadius(30)
    }
}

struct CoinDetailSwiftUIView_Previews: PreviewProvider {
    
    static var previews: some View {
        let coin = CoinMarket(
            id: "bitcoin",
            symbol: "Bitcoin",
            name: "Bitcoin",
            image: "",
            currentPrice: 123
        )
        
        let viewModel = CoinDetailViewModel(
            fetcher: DataFetcher(),
            coinId: coin.id,
            coinName: coin.name
        )
        
        CoinDetailSwiftUIView(coin: coin, viewModel: viewModel, coordinator: nil)
    }
}
