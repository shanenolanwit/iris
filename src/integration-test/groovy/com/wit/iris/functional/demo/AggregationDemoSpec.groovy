package com.wit.iris.functional.demo

import com.wit.iris.elastic.ElasticEndpoint
import com.wit.iris.elastic.ElasticService
import com.wit.iris.functional.pages.schemas.SchemaPage
import com.wit.iris.schemas.SchemaField
import com.wit.iris.schemas.enums.FieldType
import grails.plugins.rest.client.RestResponse
import grails.testing.mixin.integration.Integration
import grails.transaction.*
import com.wit.iris.functional.webdrivers.DriverFactory
import com.codeborne.selenide.WebDriverRunner
import com.wit.iris.functional.pages.login.LoginPage
import spock.lang.Specification

import static com.codeborne.selenide.Selenide.open
import static com.codeborne.selenide.Selenide.$$


@Integration
@Rollback
class AggregationDemoSpec extends Specification {

    String AGENT_NAME = "node_agent"

    ElasticService elasticService
    ElasticEndpoint elasticEndpoint

    RestResponse resp

    def setup() {
        DriverFactory.setFirefoxDriver()
    }

    def cleanup() {
        WebDriverRunner.getWebDriver().close()
    }

    def setupData(){
        elasticEndpoint = new ElasticEndpoint(name: "aws", url: "https://search-iris-ibwkuxcv4b2unly3c7d2d77v2a.eu-west-1.es.amazonaws.com", active: true)
        elasticEndpoint.save(flush: true)

        assert ElasticEndpoint.count == 1
    }

    void cleanElasticsearch(){
        if(elasticService.indexExists(AGENT_NAME)){
            resp = elasticService.deleteIndex(AGENT_NAME)
            assert resp.statusCodeValue == 200
        }
    }

    void "test iris demo"() {
        when: "I setup the data"
        setupData()

        and: "I login and create a schema"

        open("http://localhost:9000/login/auth")

        SchemaPage schemaPage = new LoginPage().login().getNavbar().goToSchemaPage()

        int numOfSchemas = schemaPage.getNumberOfSchemas()
        schemaPage.createSchema(AGENT_NAME, getSchemaFields())

        then: "there should now be 3 schemas present"
        assert $$(SchemaPage.SCHEMA_ROWS).shouldHaveSize(numOfSchemas + 1)

        cleanElasticsearch()
    }

    private List<SchemaField> getSchemaFields(){
        return [new SchemaField(name: "uptime", fieldType: FieldType.DOUBLE.getValue()),
                new SchemaField(name: "cpuSpeedGHZ", fieldType: FieldType.FLOAT.getValue()),
                new SchemaField(name: "memTotal", fieldType: FieldType.LONG.getValue()),
                new SchemaField(name: "memFree", fieldType: FieldType.LONG.getValue()),
                new SchemaField(name: "memUsed", fieldType: FieldType.LONG.getValue()),
                new SchemaField(name: "cpuCurrentLoad", fieldType: FieldType.DOUBLE.getValue())]
    }
}
