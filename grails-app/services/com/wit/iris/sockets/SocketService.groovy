package com.wit.iris.sockets

import com.wit.iris.charts.Chart
import grails.gorm.transactions.Transactional
import groovy.json.JsonOutput
import org.springframework.messaging.simp.SimpMessagingTemplate

@Transactional
class SocketService {

    SimpMessagingTemplate brokerMessagingTemplate

    /**
     * Sends dashboard chart data to specific dashboard chart types for specific schemas
     * @param esIndex - the name of the schema index which is used as a unique subscription socket endpoint
     * @param chartType - the type of dashboard.chart (Bubble, Pie etc...)
     * @param data - the data to be send to the dashboard.chart
     */
    void sendUpdateToClient(long schemaId, Chart chart, Map data){
        brokerMessagingTemplate.convertAndSend "/topic/$schemaId/$chart.chartType/$chart.subscriptionId".toString(), JsonOutput.toJson(data)
    }

    void sendDataToClient(long schemaId, Chart chart, Map data){
        brokerMessagingTemplate.convertAndSend "/topic/load/$schemaId/$chart.chartType/$chart.subscriptionId".toString(), JsonOutput.toJson(data)
    }
}
