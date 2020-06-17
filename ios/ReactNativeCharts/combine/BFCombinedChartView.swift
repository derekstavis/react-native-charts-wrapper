//
//  BFCombinedChartView.swift
//  RNCharts
//
//  Created by Taylor Johnson on 6/17/20.
//

import Foundation
import Charts

open class BFCombinedChartView: CombinedChartView {

	public override init(frame: CGRect)
	{
        super.init(frame: frame)
        initialize()

        renderer = BFCombinedChartRenderer(chart: self, animator: self.chartAnimator, viewPortHandler: self.viewPortHandler)
	}

	public required init?(coder aDecoder: NSCoder)
	{
        super.init(coder: aDecoder)
        initialize()

        renderer = BFCombinedChartRenderer(chart: self, animator: self.chartAnimator, viewPortHandler: self.viewPortHandler)
	}
	
	open override var data: ChartData?
	{
        get
        {
            return super.data
        }
        set
        {
            super.data = newValue

            self.highlighter = CombinedHighlighter(chart: self, barDataProvider: self)

            (renderer as? BFCombinedChartRenderer)?.createRenderers()
            renderer?.initBuffers()
        }
	}
}
