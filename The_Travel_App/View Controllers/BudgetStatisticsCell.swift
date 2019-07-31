//
//  BudgetStatisticsCell.swift
//  Haggle
//
//  Created by Anil Kumar on 23/04/19.
//  Copyright © 2019 AIT. All rights reserved.
//

import UIKit
import Charts

class BudgetStatisticsCell: UITableViewCell {
    
    lazy var tripChartView      = PieChartView()
    
    var dataEntries             = [PieChartDataEntry]()
    var numberOfDataEntries     = [PieChartDataEntry]()
    
    let statisticsView = UIViewFactory()
        .build()
    
    let tripStatusView = UIViewFactory()
        .build()
    
    let chartLegendView = UIViewFactory()
        .build()
    
    let chartLegendImage = UIImageFactory()
        .setImage(imageString: "Legend")
        .build()
    
    let totalAmountLabel = UILabelFactory(text: "Total Starting Budget")
        .textAlignment(with: .left)
        .textFonts(with: UIFont(name: "Montserrat-Medium", size: 10)!)
        .textColor(with: UIColor(red: 0.01, green: 0.59, blue: 0.85, alpha: 1))
        .build()
    
    let totalAmount = UILabelFactory(text: "2,000 EUR".uppercased())
        .textAlignment(with: .left)
        .textFonts(with: UIFont(name: "Montserrat-Bold", size: 22)!)
        .textColor(with: UIColor(red: 0.29, green: 0.29, blue: 0.29, alpha: 1))
        .build()
    
    let totalSpendLabel = UILabelFactory(text: "Total Spend")
        .textAlignment(with: .left)
        .textFonts(with: UIFont(name: "Montserrat-Medium", size: 10)!)
        .textColor(with: UIColor(red: 0.01, green: 0.59, blue: 0.85, alpha: 1))
        .build()
    
    let totalSpendAmount = UILabelFactory(text: "500 EUR".uppercased())
        .textAlignment(with: .left)
        .textFonts(with: UIFont(name: "Montserrat-Bold", size: 22)!)
        .textColor(with: UIColor(red: 0.29, green: 0.29, blue: 0.29, alpha: 1))
        .build()
    
    let daysLabel = UILabelFactory(text: "Days Remaining")
        .textAlignment(with: .left)
        .textFonts(with: UIFont(name: "Montserrat-Medium", size: 10)!)
        .textColor(with: UIColor(red: 0.01, green: 0.59, blue: 0.85, alpha: 1))
        .build()
    
    let daysRemaining = UILabelFactory(text: "4 DAYS".uppercased())
        .textAlignment(with: .left)
        .textFonts(with: UIFont(name: "Montserrat-Bold", size: 22)!)
        .textColor(with: UIColor(red: 0.29, green: 0.29, blue: 0.29, alpha: 1))
        .build()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
      
        tripChartView.chartDescription?.text = ""
        tripChartView.legend.enabled = false
        tripChartView.holeRadiusPercent = 0.35
        tripChartView.transparentCircleRadiusPercent = 0.0
        tripChartView.entryLabelFont = UIFont(name: "HelveticaNeue", size: 11.0)
        
        addSubview(statisticsView)
        statisticsView.addSubview(tripStatusView)
        statisticsView.addSubview(tripChartView)
        tripStatusView.addSubview(totalAmountLabel)
        tripStatusView.addSubview(totalAmount)
        tripStatusView.addSubview(totalSpendLabel)
        tripStatusView.addSubview(totalSpendAmount)
        tripStatusView.addSubview(daysLabel)
        tripStatusView.addSubview(daysRemaining)
        tripStatusView.addSubview(chartLegendView)
        chartLegendView.addSubview(chartLegendImage)
        
        tripStatusView.bringSubviewToFront(totalAmountLabel)
        tripStatusView.bringSubviewToFront(totalAmount)
        tripStatusView.bringSubviewToFront(totalSpendLabel)
        tripStatusView.bringSubviewToFront(totalSpendAmount)
        tripStatusView.bringSubviewToFront(daysLabel)
        tripStatusView.bringSubviewToFront(daysRemaining)
        tripStatusView.bringSubviewToFront(chartLegendView)
        chartLegendView.bringSubviewToFront(chartLegendImage)
        
        // setUpChartData()
        setUpConstraintsToLayoutViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpConstraintsToLayoutViews(){
        statisticsView.layoutAnchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: 0.0, enableInsets: true)
        
        tripStatusView.layoutAnchor(top: statisticsView.topAnchor, left: statisticsView.leftAnchor, bottom: statisticsView.bottomAnchor, right: nil, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: frame.size.width/2, height: 0.0, enableInsets: true)
        
        tripChartView.layoutAnchor(top: statisticsView.topAnchor, left: nil, bottom: statisticsView.bottomAnchor, right: statisticsView.rightAnchor, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 10.0, paddingRight: 0.0, width: frame.size.width/2, height: 0.0, enableInsets: true)
        
        chartLegendView.layoutAnchor(top: tripChartView.bottomAnchor, left: tripChartView.leftAnchor, bottom: statisticsView.bottomAnchor, right: tripChartView.rightAnchor, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: 0.0, enableInsets: true)
        
        chartLegendImage.layoutAnchor(top: chartLegendView.topAnchor, left: nil, bottom: chartLegendView.bottomAnchor, right: nil, centerX: chartLegendView.centerXAnchor, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 110, height: 0.0, enableInsets: true)
        
        totalAmountLabel.layoutAnchor(top: tripStatusView.topAnchor, left: tripStatusView.leftAnchor, bottom: nil, right: tripStatusView.rightAnchor, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: 14.0, enableInsets: true)
        
        totalAmount.layoutAnchor(top: totalAmountLabel.bottomAnchor, left: totalAmountLabel.leftAnchor, bottom: nil, right: totalAmountLabel.rightAnchor, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: 28.0, enableInsets: true)
        
        totalSpendLabel.layoutAnchor(top: totalAmount.bottomAnchor, left: totalAmountLabel.leftAnchor, bottom: nil, right: totalAmountLabel.rightAnchor, centerX: nil, centerY: nil, paddingTop: 9.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: 14.0, enableInsets: true)
        
        totalSpendAmount.layoutAnchor(top: totalSpendLabel.bottomAnchor, left: totalAmountLabel.leftAnchor, bottom: nil, right: totalAmountLabel.rightAnchor, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: 28.0, enableInsets: true)
        
        daysLabel.layoutAnchor(top: totalSpendAmount.bottomAnchor, left: totalAmountLabel.leftAnchor, bottom: nil, right: totalAmountLabel.rightAnchor, centerX: nil, centerY: nil, paddingTop: 9.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: 14.0, enableInsets: true)
        
        daysRemaining.layoutAnchor(top: daysLabel.bottomAnchor, left: totalAmountLabel.leftAnchor, bottom: nil, right: totalAmountLabel.rightAnchor, centerX: nil, centerY: nil, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: 28.0, enableInsets: true)
    }
    
    func setUpChartData(spendValue:Double,reminingValue:Double){
        
        let spendEntry              = PieChartDataEntry(value: spendValue)
        let remainingEntry          = PieChartDataEntry(value: reminingValue)
        numberOfDataEntries         = [spendEntry, remainingEntry]
        
        let chartDataSet    = PieChartDataSet(entries: numberOfDataEntries, label: nil)
        let chartData       = PieChartData(dataSet: chartDataSet)
        let colors          = [UIColor(red: 0.17, green: 0.51, blue: 0.75, alpha: 1),UIColor(red: 1.00, green: 0.42, blue: 0.18, alpha: 1)]
        chartDataSet.colors = colors
        let formatter       = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 0
        formatter.multiplier = 1.0
        formatter.percentSymbol = "%"
        chartData.setValueFormatter(DefaultValueFormatter(formatter:formatter))
        tripChartView.data  = chartData
    }
}
