//
//  BFCandleStickChartRenderer.swift
//  RNCharts
//
//  Created by Taylor Johnson on 6/17/20.
//

import Foundation
import Charts

open class BFCandleStickChartRenderer: CandleStickChartRenderer {
	
	/// Checks if the provided entry object is in bounds for drawing considering the current animation phase.
	internal func isInBoundsX(entry e: ChartDataEntry, dataSet: IBarLineScatterCandleBubbleChartDataSet) -> Bool
	{
        let entryIndex = dataSet.entryIndex(entry: e)
        return Double(entryIndex) < Double(dataSet.entryCount) * animator.phaseX
	}
	
	open override func drawHighlighted(context: CGContext, indices: [Highlight])
	{
        guard
                let dataProvider = dataProvider,
                let candleData = dataProvider.candleData
                else { return }

        context.saveGState()

        for high in indices
        {
            guard
                let set = candleData.getDataSetByIndex(high.dataSetIndex) as? ICandleChartDataSet,
                set.isHighlightEnabled
                else { continue }

            guard let e = set.entryForXValue(high.x, closestToY: high.y) as? CandleChartDataEntry else { continue }

            if !isInBoundsX(entry: e, dataSet: set)
            {
                continue
            }

            let trans = dataProvider.getTransformer(forAxis: set.axisDependency)

            context.setStrokeColor(set.highlightColor.cgColor)
            context.setLineWidth(set.highlightLineWidth)

            if set.highlightLineDashLengths != nil
            {
                context.setLineDash(phase: set.highlightLineDashPhase, lengths: set.highlightLineDashLengths!)
            }
            else
            {
                context.setLineDash(phase: 0.0, lengths: [])
            }

            let pt = trans.pixelForValues(x: e.x, y: high.y)

            high.setDraw(pt: pt)

            // draw the lines
            drawHighlightLines(context: context, point: pt, set: set)
        }

        context.restoreGState()
	}
}
