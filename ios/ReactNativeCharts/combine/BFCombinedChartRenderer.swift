//
//  BFCombinedChartRenderer.swift
//  RNCharts
//
//  Created by Taylor Johnson on 6/17/20.
//

import Foundation
import Charts

// Support Highlighting Candle and Line charts where the horizontal highlight
// line follows the Highlight's y value
class BFCombinedChartRenderer: CombinedChartRenderer {
	
	@objc public override init(chart: CombinedChartView, animator: Animator, viewPortHandler: ViewPortHandler)
     {
        super.init(chart: chart, animator: animator, viewPortHandler: viewPortHandler)

         self.chart = chart

         createRenderers()
     }

     /// Creates the renderers needed for this combined-renderer in the required order. Also takes the DrawOrder into consideration.
     internal func createRenderers()
     {
         subRenderers = [DataRenderer]()

         guard let chart = chart else { return }

         for order in drawOrder
         {
             switch (order)
             {
             case .bar:
                 if chart.barData !== nil
                 {
                     subRenderers.append(BarChartRenderer(dataProvider: chart, animator: animator, viewPortHandler: viewPortHandler))
                 }
                 break

             case .line:
                 if chart.lineData !== nil
                 {
                     subRenderers.append(BFLineChartRenderer(dataProvider: chart, animator: animator, viewPortHandler: viewPortHandler))
                 }
                 break

             case .candle:
                 if chart.candleData !== nil
                 {
                     subRenderers.append(BFCandleStickChartRenderer(dataProvider: chart, animator: animator, viewPortHandler: viewPortHandler))
                 }
                 break

             case .scatter:
                 if chart.scatterData !== nil
                 {
                     subRenderers.append(ScatterChartRenderer(dataProvider: chart, animator: animator, viewPortHandler: viewPortHandler))
                 }
                 break

             case .bubble:
                 if chart.bubbleData !== nil
                 {
                     subRenderers.append(BubbleChartRenderer(dataProvider: chart, animator: animator, viewPortHandler: viewPortHandler))
                 }
                 break
             }
         }

     }

	open override func drawHighlighted(context: CGContext, indices: [Highlight])
	{
			for renderer in subRenderers
			{
					var data: ChartData?

					if renderer is BarChartRenderer
					{
							data = (renderer as! BarChartRenderer).dataProvider?.barData
					}
					else if renderer is LineChartRenderer
					{
							data = (renderer as! BFLineChartRenderer).dataProvider?.lineData
					}
					else if renderer is CandleStickChartRenderer
					{
							data = (renderer as! BFCandleStickChartRenderer).dataProvider?.candleData
					}
					else if renderer is ScatterChartRenderer
					{
							data = (renderer as! ScatterChartRenderer).dataProvider?.scatterData
					}
					else if renderer is BubbleChartRenderer
					{
							data = (renderer as! BubbleChartRenderer).dataProvider?.bubbleData
					}

					let dataIndex: Int? = {
							guard let data = data else { return nil }
							return (chart?.data as? CombinedChartData)?
									.allData
									.firstIndex(of: data)
					}()

					let dataIndices = indices.filter{ $0.dataIndex == dataIndex || $0.dataIndex == -1 }

					renderer.drawHighlighted(context: context, indices: dataIndices)
			}
	}
}
