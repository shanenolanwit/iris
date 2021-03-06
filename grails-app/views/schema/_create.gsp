<div id="create-schema-container">
    <div id="schema-modal" class="modal fade bd-example-modal-lg" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">

                <div class="modal-header">
                    <h5 class="modal-title">Create Schema</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>

                <div class="modal-body">

                    <div id="accordion" role="tablist" aria-multiselectable="true">

                        <!--SCHEMA CREATION START-->
                        <div class="card">

                            <div class="card-header" role="tab" id="schema-creation-header">
                                <h5 class="mb-0">
                                    <a data-toggle="collapse" data-parent="#accordion" href="#schema-creation" aria-expanded="false" aria-controls="schema-creation">
                                        Schema
                                    </a>
                                </h5>
                            </div>

                           <div id="schema-creation" class="collapse show" role="tabpanel" aria-labelledby="schema-creation-header">
                                <div class="card-block">
                                    <div class="form-group">
                                        <label class="col-2 col-form-label">Name</label>
                                        <div class="col-6">
                                            <input class="form-control" id="schema-name" type="text" value="" required>
                                        </div>
                                        <label class="col-2 col-form-label">Refresh Interval</label>
                                        <div class="col-6">
                                            <input class="form-control" id="schema-refresh" type="number" value="" required>
                                        </div>
                                    </div>
                                    <div id="schema-field-container"></div>
                                    <button type="button" id="add-schema-field-btn" class="btn" href="${createLink(controller: 'schemaField', action: 'form')}">Add field</button>
                                </div>
                           </div>

                        </div>
                        <!--SCHEMA CREATION END-->

                        <!--SCHEMA FIELD CREATION-->
                        <div class="card">

                            <div class="card-header" role="tab" id="schema-fields-header">
                                <h5 class="mb-0">
                                    <a id="schema-fields-title" data-toggle="collapse" data-parent="#accordion" href="#schema-fields" aria-expanded="false" aria-controls="schema-fields">
                                        Schema Fields (0)
                                    </a>
                                </h5>
                            </div>

                            <div id="schema-fields" class="collapse show" role="tabpanel" aria-labelledby="schema-fields-header">
                                <div class="card-block">
                                    <div id="schema-fields-container">
                                        <table id="schema-fields-table" class="table">
                                            <thead>
                                            <tr>
                                                <th>#</th>
                                                <th>Name</th>
                                                <th>Type</th>
                                            </tr>
                                            </thead>
                                            <tbody></tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>

                        </div>

                        <!--SCHEMA FIELD END-->

                        <!--SCHEMA RULE CREATION-->
                        <div class="card">

                            <div class="card-header" role="tab" id="schema-rule-header">
                                <h5 class="mb-0">
                                    <a id="schema-rule-title" data-toggle="collapse" data-parent="#accordion" href="#schema-rule" aria-expanded="false" aria-controls="schema-fields">
                                        Schema Rule
                                    </a>
                                </h5>
                            </div>

                            <div id="schema-rule" class="collapse show" role="tabpanel" aria-labelledby="schema-fields-header">
                                <div class="card-block">
                                    <div id="schema-rule-container">
                                        <div id="editor">/*This Groovy script will run every time new data enters associated with this schema. You have access to the raw json through a Map object called 'json'*/</div>
                                    </div>
                                </div>
                            </div>

                        </div>
                        <!--SCHEMA RULE END-->

                    </div>
                    <!--ACCORDION END-->
                </div>

                <div class="modal-footer">
                    <button type="button" id="save-schema-btn" class="btn ml-1" href="${createLink(controller: 'schema', action: 'save')}">Save</button>
                </div>

            </div>
        </div>
    </div>
</div>

<g:javascript>

    var editor = ace.edit("editor");
    editor.setTheme("ace/theme/monokai");
    editor.session.setMode("ace/mode/groovy");
    editor.session.setUseWrapMode(true);

    editor.setOptions({
        autoScrollEditorIntoView: true,
        maxLines: 100
    });
    editor.renderer.setScrollMargin(10, 10, 10, 10);

    editor.setAutoScrollEditorIntoView(true);

    $("#schema-modal").modal({
        show: true,
        backdrop: true
    });

    var Schema = function(name, refreshInterval,scriptVal){
        this.name = name;
        this.refreshInterval = refreshInterval;
        this.schemaFields = [];
        this.rule = {
            script: scriptVal
        };
    }

    var SchemaField = function(name, fieldType){
        this.name = name;
        this.fieldType = fieldType;
    }

    $("#add-schema-field-btn").on( "click", function(){
        var URL = $(this).attr("href");
        appendContainerHtml(URL, REST.method.post, REST.contentType.json, {}, "#schema-field-container");
    });

    $("#save-schema-btn").on("click", function(){
        var URL = $(this).attr("href");
        //create schema object from name and refresh interval
        var schemaObj = new Schema($("#schema-name").val(), $("#schema-refresh").val(), editor.getSession().getValue());
        $("#schema-fields-table > tbody > tr").each(function(){
            var schemaFieldObj = new SchemaField($(this).find("td.schema-field-name").html(), $(this).find("td.schema-field-type").html());
            //add this obj to schema array
            schemaObj.schemaFields.push(schemaFieldObj);
        });

        reloadAfterAjax(URL, REST.method.post, REST.contentType.json, schemaObj);
    });
</g:javascript>