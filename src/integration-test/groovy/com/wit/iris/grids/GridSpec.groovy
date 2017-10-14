package com.wit.iris.grids

import com.wit.iris.charts.Chart
import com.wit.iris.charts.enums.ChartType
import com.wit.iris.elastic.Aggregation
import com.wit.iris.schemas.Schema
import grails.testing.mixin.integration.Integration
import grails.transaction.*
import spock.lang.Specification

@Integration
@Rollback
class GridSpec extends Specification {

    Grid grid
    GridCell gridCell
    Chart chart
    Schema schema
    Aggregation aggregation

    def setupData(){
        schema = new Schema(name: "Performance Monitor", esIndex: "performance_monitor", refreshInterval: 1000)
        schema.save(flush: true)
        aggregation = new Aggregation(schema: schema)
        chart = new Chart(name: "SQL Chart", chartType: ChartType.BAR.getValue(), aggregation: aggregation)
        grid = new Grid(gridCellPositions: "[{some: json}]")
        gridCell = new GridCell(gridPosition: 0, chart: chart)
        grid.addToGridCells(gridCell)
        grid.save(flush: true, failOnError: true)

        assert Grid.count() == 1
        assert GridCell.count() == 1
        assert Chart.count() == 1
        assert Schema.count() == 1
        assert Aggregation.count() == 1
    }

    def setup() {

    }

    def cleanup() {
    }

    void "test cascade delete Grid"(){
        setup:
        setupData()

        when: "I delete the grid"
        grid.delete(flush: true)

        then: "Grid cells also get deleted"
        assert Grid.count() == 0
        assert GridCell.count() == 0
    }

    void "test cascade removeFrom Grid"(){
        setup:
        setupData()

        when: "I delete a gridcell from a grid"
        grid.removeFromGridCells(grid.gridCells[0])

        and: "I save the grid"
        grid.save(flush: true)

        then: "Grid cells also get deleted"
        assert Grid.count() == 1
        assert GridCell.count() == 0
    }
}
