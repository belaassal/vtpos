{*<!--
/*********************************************************************************
** The contents of this file are subject to the vtiger CRM Public License Version 1.0
* ("License"); You may not use this file except in compliance with the License
* The Original Code is:  vtiger CRM Open Source
* The Initial Developer of the Original Code is vtiger.
* Portions created by vtiger are Copyright (C) vtiger.
* All Rights Reserved.
*
********************************************************************************/
-->*}
{strip}
    {assign var=DECIMAL value=$USER_MODEL->get('currency_decimal_separator')}
    {assign var=GROUP value=$USER_MODEL->get('currency_grouping_separator')}
    {assign var=CURRENCY_SYMBOL value={$USER_MODEL->get('currency_symbol')}}
    {assign var=NO_DECIMAL value={$USER_MODEL->get('no_of_currency_decimals')}}
    <div class="recordDetails clearfix">
        <div id="modnavigator" class="module-nav editViewModNavigator">
            <div class="hidden-xs hidden-sm mod-switcher-container">
                {include file="partials/Menubar.tpl"|vtemplate_path:$MODULE}
            </div>
        </div>
        <div class="detailViewContainer viewContent">
            <br>
            <div class="" style="padding-left: 35px" id="pos_container">
                <div class="col-md-4 col-lg-4">
                    <div class="alert alert-block alert-warning" style="position: relative">
                        <div class="tabbable" id="optionsTab">
                            <ul class="nav nav-tabs nav-justified">
                                <li class="active"><a href="#1" data-toggle="tab">{vtranslate('LBL_SCAN', $MODULE)}</a></li>
                                <li><a href="#2" data-toggle="tab">{vtranslate('LBL_SEARCH', $MODULE)}</a></li>
                            </ul>
                            <div class="tab-content">
                                <div class="tab-pane active " id="1">
                                    <br/>
                                    <div class="form-inline">
                                        <div class="form-group has-success">
                                            <div class="input-group">
                                                <span class="input-group-addon"><span class=" glyphicon glyphicon-barcode"></span></span>
                                                <input class="form-control" type="text" id="code_scanner_input" placeholder="{vtranslate('LBL_BARCODE', $MODULE)}">
                                            </div>
                                        </div>
                                        <button id="btn_bar_search" class="marginLeft10px btn btn-success" type="button">{vtranslate('LBL_SEARCH', $MODULE)}</button>
                                    </div>

                                    <hr/>

                                    <div class="">
                                        <label >{vtranslate('LBL_CATEGORIES_LIST', $MODULE)} : </label>
                                    </div>
                                    <div id='Fav_Products' style="width: 100%;border:1px solid #C2C2C2;overflow-x: hidden">

                                        <div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">
                                            {foreach item=CATEGORY from=$FAV_CATEGORIES key=KEY name=cat}
                                                <div class="panel panel-default">
                                                    <div class="panel-heading" role="tab" id="heading{$KEY}">
                                                        <h4 class="panel-title">
                                                            <a {if $KEY neq 0} class="collapsed" {/if} role="button" data-toggle="collapse" data-parent="#accordion" href="#collapse{$KEY}" aria-expanded="{if $KEY eq 0}true{else}false{/if}" aria-controls="collapse{$KEY}">
                                                                {if empty($CATEGORY)} {vtranslate('LBL_UNCATEGORIZED', $MODULE)} {else} {$CATEGORY} {/if}
                                                            </a>
                                                        </h4>
                                                    </div>
                                                    <div id="collapse{$KEY}" class="panel-collapse collapse {if $KEY eq 0} in {/if}" role="tabpanel" aria-labelledby="heading{$KEY}">
                                                        <div class="panel-body padding0px">
                                                            {foreach item=PRODUCT from=$FAV_PRODUCTS}
                                                                {if $CATEGORY eq $PRODUCT['productcategory']}
                                                                    <span class="{$PRODUCT['productcategory']|replace:' ':''}">
                                                                        <img class="imgProducts" src="{$PRODUCT['image']}" data-prodid="{$PRODUCT['productid']}" data-code="{$PRODUCT['barecode']}"  style="margin: 8px 0px 8px 4px;border:1px solid #696969;cursor: pointer" width="60px" height="60px" >
                                                                    </span>
                                                                {/if}
                                                            {/foreach}
                                                        </div>
                                                    </div>
                                                </div>
                                            {/foreach}
                                        </div>
                                    </div>
                                </div>
                                <div class="tab-pane" id="2">
                                    <div class="" >
                                        <br/>

                                        <select id="item_browser"  data-placeholder="{vtranslate('LBL_PRODUCT_NAME', $MODULE)}" style="width: 100%">
                                            <option value="">&nbsp;</option>
                                            {foreach item=ITEM from=$ALL_PRODUCTS}
                                                <option value="{$ITEM["barecode"]}" data-image="{$ITEM["image"]}" data-id="{$ITEM["productid"]}" data-stock="{$ITEM["qtyinstock"]|number_format:$NO_DECIMAL:$DECIMAL:$GROUP}" data-category="{$ITEM["productcategory"]}"  data-price="{$ITEM["unit_price"]|number_format:$NO_DECIMAL:$DECIMAL:$GROUP}">{$ITEM["productname"]}</option>
                                            {/foreach}
                                        </select>
                                    </div>
                                    <hr>
                                    <div class="" >
                                        <div id="detail_product" style="display: none;">
                                            <input id="empty_img"type="hidden" value="data:image/svg+xml;utf8;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iaXNvLTg4NTktMSI/Pgo8IS0tIEdlbmVyYXRvcjogQWRvYmUgSWxsdXN0cmF0b3IgMTguMS4xLCBTVkcgRXhwb3J0IFBsdWctSW4gLiBTVkcgVmVyc2lvbjogNi4wMCBCdWlsZCAwKSAgLS0+CjxzdmcgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB4bWxuczp4bGluaz0iaHR0cDovL3d3dy53My5vcmcvMTk5OS94bGluayIgdmVyc2lvbj0iMS4xIiBpZD0iQ2FwYV8xIiB4PSIwcHgiIHk9IjBweCIgdmlld0JveD0iMCAwIDEwMCAxMDAiIHN0eWxlPSJlbmFibGUtYmFja2dyb3VuZDpuZXcgMCAwIDEwMCAxMDA7IiB4bWw6c3BhY2U9InByZXNlcnZlIiB3aWR0aD0iNjRweCIgaGVpZ2h0PSI2NHB4Ij4KPGc+Cgk8Zz4KCQk8cGF0aCBkPSJNNTAsNDBjLTguMjg1LDAtMTUsNi43MTgtMTUsMTVjMCw4LjI4NSw2LjcxNSwxNSwxNSwxNWM4LjI4MywwLDE1LTYuNzE1LDE1LTE1ICAgIEM2NSw0Ni43MTgsNTguMjgzLDQwLDUwLDQweiBNOTAsMjVINzhjLTEuNjUsMC0zLjQyOC0xLjI4LTMuOTQ5LTIuODQ2bC0zLjEwMi05LjMwOUM3MC40MjYsMTEuMjgsNjguNjUsMTAsNjcsMTBIMzMgICAgYy0xLjY1LDAtMy40MjgsMS4yOC0zLjk0OSwyLjg0NmwtMy4xMDIsOS4zMDlDMjUuNDI2LDIzLjcyLDIzLjY1LDI1LDIyLDI1SDEwQzQuNSwyNSwwLDI5LjUsMCwzNXY0NWMwLDUuNSw0LjUsMTAsMTAsMTBoODAgICAgYzUuNSwwLDEwLTQuNSwxMC0xMFYzNUMxMDAsMjkuNSw5NS41LDI1LDkwLDI1eiBNNTAsODBjLTEzLjgwNywwLTI1LTExLjE5My0yNS0yNWMwLTEzLjgwNiwxMS4xOTMtMjUsMjUtMjUgICAgYzEzLjgwNSwwLDI1LDExLjE5NCwyNSwyNUM3NSw2OC44MDcsNjMuODA1LDgwLDUwLDgweiBNODYuNSw0MS45OTNjLTEuOTMyLDAtMy41LTEuNTY2LTMuNS0zLjVjMC0xLjkzMiwxLjU2OC0zLjUsMy41LTMuNSAgICBjMS45MzQsMCwzLjUsMS41NjgsMy41LDMuNUM5MCw0MC40MjcsODguNDMzLDQxLjk5Myw4Ni41LDQxLjk5M3oiIGZpbGw9IiNkNGQ0ZDQiLz4KCTwvZz4KPC9nPgo8Zz4KPC9nPgo8Zz4KPC9nPgo8Zz4KPC9nPgo8Zz4KPC9nPgo8Zz4KPC9nPgo8Zz4KPC9nPgo8Zz4KPC9nPgo8Zz4KPC9nPgo8Zz4KPC9nPgo8Zz4KPC9nPgo8Zz4KPC9nPgo8Zz4KPC9nPgo8Zz4KPC9nPgo8Zz4KPC9nPgo8Zz4KPC9nPgo8L3N2Zz4K" />
                                            <table>
                                                <tr>
                                                    <td width="22%" rowspan="4"><img style="border:1px solid #696969;" src="" width="80px" alt=""></td>
                                                    <td ><b>Name</b> : <span class="name"></span> </td>
                                                </tr>
                                                <tr>
                                                    <td><b>Price : </b> <span class="price">0</span></td>
                                                </tr>
                                                <tr>
                                                    <td><b>Category : </b> <span class="categ">0</span></td>
                                                </tr>
                                                <tr>
                                                    <td><b>stock : </b> <span class="stock">0</span></td>
                                                </tr>
                                            </table>

                                            <br/>
                                            <label class="label-success"></label>
                                            <button class="btn btn-primary pull-right" id="add_item" type="button">{vtranslate('LBL_ADD', $MODULE)}</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <hr/>
                        <table style="bottom: 0;">
                            <tr>
                                <td colspan="3"></td>
                            </tr>
                            <tr>
                                <td width="15%">
                                    <img width="56px" src="layouts/v7/modules/VtPos/images/logo.png">
                                </td>
                                <td width="60%">
                                    <span style="font-size: 16px" class="">Vtiger Point Of Sale</span>
                                </td>
                                <td><span style="font-size: 16px" class="label label-danger" id="timer_display"></span></td>
                            </tr>
                        </table>
                    </div>
                </div><!--/span-->
                <div class="col-md-5 col-lg-5 paddingLeft0">


                    <div class="alert alert-info">
                        <h5>Products List : </h5>
                        <table id="products_table" class="table cursorPointer">
                            <thead>
                                <tr>
                                    <th width="3%" style="padding: 2px">#</th>
                                    <th width="5%" style="padding: 2px">Select</th>
                                    <th width="40%" style="padding: 2px">Name</th>
                                    <th width="12%" style="padding: 2px">Quantity</th>
                                    <th width="16%" style="padding: 2px">Unit Price</th>
                                    <th width="16%" style="padding: 2px">Total Price</th>
                                </tr>
                            </thead>
                            <tbody>

                            </tbody>
                        </table>
                        <div>
                            <button class="btn btn-sm btn-danger" id="btn_delete_product" style="float: right" type="button">Delete</button>&nbsp;&nbsp;&nbsp;&nbsp;
                            <button class="btn btn-sm btn-success" type="button" id="btn_edit_qnty">Qnty</button>&nbsp;&nbsp;&nbsp;&nbsp;
                            <button class="btn btn-sm btn-primary" type="button" id="btn_increase_qnty">&nbsp;&nbsp; + &nbsp;&nbsp;</button>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            <button class="btn btn-sm btn-primary" type="button" id="btn_decrease_qnty">&nbsp;&nbsp; - &nbsp;&nbsp;</button>&nbsp;&nbsp;&nbsp;&nbsp;
                        </div>
                    </div>



                </div><!--/span-->
                <div class="col-md-3 col-lg-3 paddingLeft0">

                    <div class="alert alert-success">
                        <table class="table table-striped marginBottom10px">
                            <tr>
                                <td width="50%">Total items</td>
                                <td width="50%"><span id="items">0</span></td>
                            </tr>
                            <tr>
                                <td><h4>SubTotal</h4></td>
                                <td><h4 id="sub_total">0</h4></td>
                            </tr>
                            <tr>
                                <td>Discount</td>
                                <td><span id="discount" data-discount="0">0</span> 
                                    <button id="btn_discount" class="btn btn-sm btn-success pull-right" type="button">
                                        <span class="glyphicon glyphicon-edit"></span>
                                    </button>
                                </td>
                            </tr>
                            <tr>
                                <td>Tax Total ({$SALES_TAX} %)</td>
                                <td><span id="total_tax">0</span></td>
                            </tr>
                            <tr>
                                <td colspan="2" style="font-size: 20px;font-weight: bolder;text-align: center;padding: 1px;">Total</td>
                            </tr><tr>
                                <td  colspan="2" style="font-size: 30px;font-weight: bolder;text-align: center;padding: 3px;border: 1px solid #696969;"><span id="total_price">0</span></td>
                            </tr>
                            <tr class="forcashuse">
                                <td width="50%">Amount Tendered</td>
                                <td width="50%">
                                    <span id="tendered" data-amount="0">0</span>
                                    <button id="btn_tendered" class="btn btn-sm btn-success pull-right" type="button">
                                        <span class="glyphicon glyphicon-edit"></span>
                                    </button>
                                </td>
                            </tr>
                            <tr class="forcashuse">
                                <td style="font-size: 18px;font-weight: bolder;padding: 1px;">Change</td>
                                <td  style="font-size: 18px;font-weight: bolder;padding: 1px;"><span id="change">0</span></td>
                            </tr>
                        </table> 
                    </div>
                    {if $CONFIGS->isCreditEnabled() || $CONFIGS->isCreditCardEnabled()}          
                        <div class="alert alert-info" id="check_cb_div">
                            <div class="">
                                <h4>Payment Methods</h4>
                            </div>
                            <hr>
                            <div class="">

                                <div id="stripe_info" class="hide" style="font-size: 14px;font-weight: bold">
                                    {vtranslate('LBL_CARD_NUM', $MODULE)} : <span id="stripe_card_num">...</span><br/>
                                    {vtranslate('LBL_CARD_HOLDER', $MODULE)} : <span id="stripe_card_holder">...</span><br/>
                                    {vtranslate('LBL_CARD_EXPIR', $MODULE)} : <span id="stripe_Expir_date">...</span><br/>
                                </div>
                                <div id="cstm_credit_info" class="" style="display: none">
                                    <h5>{vtranslate('LBL_PAY_BY_CUSTOMER_CREDIT', $MODULE)} </h5>
                                    <b>{vtranslate('LBL_CUSTOMER_CREDIT', $MODULE)}</b> : <span id="cstm_credit_name">...</span><br/>
                                    <b>{vtranslate('LBL_CUSTOMER_ACTUAL_CREDIT', $MODULE)}</b> : <span id="cstm_credit_actual">...</span><br/>
                                    <b>{vtranslate('LBL_CUSTOMER_FINAL_CREDIT', $MODULE)}</b> : <span id="cstm_credit_final">...</span><br/>
                                </div>
                                <div class="btn-group btn-group-justified">
                                    <div class="btn-group" role="group">
                                        {if $CONFIGS->isCreditEnabled()}
                                            <button class="btn btn-primary"  disabled="disabled" id="btn_crdt" type="button"><span class=" glyphicon glyphicon-user"></span> Customer credit</button>
                                        {/if}
                                    </div>
                                    <div class="btn-group" role="group">
                                        {if $CONFIGS->isCreditCardEnabled()}
                                            <button class="btn btn-danger"  disabled="disabled" id="btn_cc" type="button"><span class=" glyphicon glyphicon-credit-card"></span> Credit Card</button>
                                        {/if}
                                    </div>
                                </div>
                            </div>
                            <br/><br/>
                        </div>
                    {/if}


                    <div class="alert alert-danger">
                        <div class="">
                            <h4>Sale</h4>
                        </div>
                        <hr>
                        <div class="btn-group btn-group-justified">
                            <div class="btn-group" role="group">
                                <button id="btn_done" class="btn btn-primary" disabled="disabled" type="button">
                                    {vtranslate('LBL_DONE', $MODULE)}
                                </button>
                            </div>
                            <div class="btn-group" role="group">
                                <button id="btn_cancel" class="btn btn-warning" disabled="disabled" type="button">
                                    {vtranslate('LBL_CANCEL', $MODULE)}
                                </button>
                            </div>
                            <div class="btn-group" role="group">
                                <button class="btn btn-info" id="btnTicketPrint" disabled="disabled" type="button">
                                    {vtranslate('LBL_PRINT_TICKET', $MODULE)}
                                </button>
                            </div>
                        </div>

                        <br/><br/>
                    </div>

                </div><!--/span-->
            </div><!--/row-->

        </div>
        <div id="QntyPad" class="modal fade" >
            <div class="modal-dialog modal-sm">
                <div class="modal-content">
                    <div class="modal-header">
                        <button class="close"  class="close" data-dismiss="modal" title="{vtranslate('LBL_CLOSE', $MODULE)}"><span aria-hidden="true">&times;</span></button>
                        <h3 class="modal-title">{vtranslate('LBL_CHOOSE_QNTY', $MODULE)}</h3>
                    </div>
                    <div class="modal-body textAlignCenter">
                        <div class="input-group input-group-lg">
                            <div class="input-group-addon btnclear"><span id="quantity_clear" class="glyphicon glyphicon-remove" title="Clear"></span></div>
                            <input type="text" id="quantity_input" class="form-control input-xxlarge" style="font-size: 18px"  placeholder="{vtranslate('LBL_QUANTITY', $MODULE)}">
                            <div class="input-group-addon btnback"><span class="glyphicon glyphicon-arrow-left" id="quantity_back" title="Backspace"></span></div>
                        </div>

                        <hr/>
                        <button class="btn btn-large btn-success btn7" type="button"><h4>&nbsp;7&nbsp;</h4></button>&nbsp;&nbsp;&nbsp;&nbsp;
                        <button class="btn btn-large btn-success btn8" type="button"><h4>&nbsp;8&nbsp;</h4></button>&nbsp;&nbsp;&nbsp;&nbsp;
                        <button class="btn btn-large btn-success btn9" type="button"><h4>&nbsp;9&nbsp;</h4></button>&nbsp;&nbsp;&nbsp;&nbsp;
                        <br><br>
                        <button class="btn btn-large btn-success btn4" type="button"><h4>&nbsp;4&nbsp;</h4></button>&nbsp;&nbsp;&nbsp;&nbsp;
                        <button class="btn btn-large btn-success btn5" type="button"><h4>&nbsp;5&nbsp;</h4></button>&nbsp;&nbsp;&nbsp;&nbsp;
                        <button class="btn btn-large btn-success btn6" type="button"><h4>&nbsp;6&nbsp;</h4></button>&nbsp;&nbsp;&nbsp;&nbsp;
                        <br><br>
                        <button class="btn btn-large btn-success btn1" type="button"><h4>&nbsp;1&nbsp;</h4></button>&nbsp;&nbsp;&nbsp;&nbsp;
                        <button class="btn btn-large btn-success btn2" type="button"><h4>&nbsp;2&nbsp;</h4></button>&nbsp;&nbsp;&nbsp;&nbsp;
                        <button class="btn btn-large btn-success btn3" type="button"><h4>&nbsp;3&nbsp;</h4></button>&nbsp;&nbsp;&nbsp;&nbsp;
                        <br><br>
                        <button class="btn btn-large btn-success btnsep" type="button"><h4>&nbsp;{$USER_MODEL->get('currency_decimal_separator')}&nbsp;&nbsp;</h4></button>&nbsp;&nbsp;&nbsp;&nbsp;
                        <button class="btn btn-large btn-success btn0" type="button"><h4>&nbsp;0&nbsp;</h4></button>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        <button class="btn btn-large btn-info btnok" type="button"><h4>OK</h4></button>&nbsp;&nbsp;&nbsp;

                    </div>
                    <div class="modal-footer">
                        <div class=" pull-right cancelLinkContainer">
                            <button class="btn btn-primary" type="reset" data-dismiss="modal"><strong>{vtranslate('LBL_CLOSE', $MODULE)}</strong></button>
                        </div>
                    </div>    
                </div>
            </div>

        </div>   


        <div id="DiscountPad" class="modal fade">
            <div class="modal-dialog modal-sm">
                <div class="modal-content">
                    <div class="modal-header">
                        <button class="close" data-dismiss="modal" title="{vtranslate('LBL_CLOSE', $MODULE)}"><span aria-hidden="true">&times;</span></button>
                        <h3 class="modal-title">{vtranslate('LBL_ENTER_DISCOUNT', $MODULE)}</h3>
                    </div>
                    <div class="modal-body textAlignCenter">

                        <div class="input-group input-group-lg">
                            <div class="input-group-addon btnclear">
                                <span id="discount_clear"  class="glyphicon glyphicon-remove" title="Clear"></span>
                            </div>
                            <input type="text" id="discount_input" class="form-control input-xxlarge"  style="font-size: 18px" placeholder="{vtranslate('LBL_DISCOUNT', $MODULE)}">
                            <div class="input-group-addon btnback">
                                <span id="discount_back"  class="glyphicon glyphicon-arrow-left" title="Backspace"></span>
                            </div>

                        </div>
                        <hr/>
                        <button class="btn btn-large btn-success btn7" type="button"><h4>&nbsp;7&nbsp;</h4></button>&nbsp;&nbsp;&nbsp;&nbsp;
                        <button class="btn btn-large btn-success btn8" type="button"><h4>&nbsp;8&nbsp;</h4></button>&nbsp;&nbsp;&nbsp;&nbsp;
                        <button class="btn btn-large btn-success btn9" type="button"><h4>&nbsp;9&nbsp;</h4></button>&nbsp;&nbsp;&nbsp;&nbsp;
                        <br><br>
                        <button class="btn btn-large btn-success btn4" type="button"><h4>&nbsp;4&nbsp;</h4></button>&nbsp;&nbsp;&nbsp;&nbsp;
                        <button class="btn btn-large btn-success btn5" type="button"><h4>&nbsp;5&nbsp;</h4></button>&nbsp;&nbsp;&nbsp;&nbsp;
                        <button class="btn btn-large btn-success btn6" type="button"><h4>&nbsp;6&nbsp;</h4></button>&nbsp;&nbsp;&nbsp;&nbsp;
                        <br><br>
                        <button class="btn btn-large btn-success btn1" type="button"><h4>&nbsp;1&nbsp;</h4></button>&nbsp;&nbsp;&nbsp;&nbsp;
                        <button class="btn btn-large btn-success btn2" type="button"><h4>&nbsp;2&nbsp;</h4></button>&nbsp;&nbsp;&nbsp;&nbsp;
                        <button class="btn btn-large btn-success btn3" type="button"><h4>&nbsp;3&nbsp;</h4></button>&nbsp;&nbsp;&nbsp;&nbsp;
                        <br><br>
                        <button class="btn btn-large btn-success btnsep" type="button"><h4>&nbsp;{$USER_MODEL->get('currency_decimal_separator')}&nbsp;&nbsp;</h4></button>&nbsp;&nbsp;&nbsp;&nbsp;
                        <button class="btn btn-large btn-success btn0" type="button"><h4>&nbsp;0&nbsp;</h4></button>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        <button class="btn btn-large btn-info btnok" type="button"><h4>OK</h4></button>&nbsp;&nbsp;&nbsp;

                    </div>
                    <div class="modal-footer">
                        <div class=" pull-right cancelLinkContainer">
                            <button class="btn btn-primary" type="reset" data-dismiss="modal"><strong>{vtranslate('LBL_CLOSE', $MODULE)}</strong></button>
                        </div>
                    </div>
                </div>
            </div>
        </div>


        <div id="changePad" class="modal fade">
            <div class="modal-dialog modal-sm">
                <div class="modal-content">
                    <div class="modal-header">
                        <button class="close" data-dismiss="modal" title="{vtranslate('LBL_CLOSE', $MODULE)}">x</button>
                        <h3>{vtranslate('LBL_ENTER_AMOUNT', $MODULE)}</h3>
                    </div>
                    <div class="modal-body textAlignCenter">
                        <div class="input-group input-group-lg">
                            <div class="input-group-addon btnclear">
                                <span id="change_clear"  class="glyphicon glyphicon-remove" title="Clear"></span>
                            </div>
                            <input type="text" id="change_input" class="form-control input-xxlarge"  style="font-size: 18px" placeholder="{vtranslate('LBL_CHANGE', $MODULE)}">
                            <div class="input-group-addon btnback">
                                <span id="change_back"  class="glyphicon glyphicon-arrow-left" title="Backspace"></span>
                            </div>
                        </div>
                        <hr/>
                        <button class="btn btn-large btn-success btn7" type="button"><h4>&nbsp;7&nbsp;</h4></button>&nbsp;&nbsp;&nbsp;&nbsp;
                        <button class="btn btn-large btn-success btn8" type="button"><h4>&nbsp;8&nbsp;</h4></button>&nbsp;&nbsp;&nbsp;&nbsp;
                        <button class="btn btn-large btn-success btn9" type="button"><h4>&nbsp;9&nbsp;</h4></button>&nbsp;&nbsp;&nbsp;&nbsp;
                        <br><br>
                        <button class="btn btn-large btn-success btn4" type="button"><h4>&nbsp;4&nbsp;</h4></button>&nbsp;&nbsp;&nbsp;&nbsp;
                        <button class="btn btn-large btn-success btn5" type="button"><h4>&nbsp;5&nbsp;</h4></button>&nbsp;&nbsp;&nbsp;&nbsp;
                        <button class="btn btn-large btn-success btn6" type="button"><h4>&nbsp;6&nbsp;</h4></button>&nbsp;&nbsp;&nbsp;&nbsp;
                        <br><br>
                        <button class="btn btn-large btn-success btn1" type="button"><h4>&nbsp;1&nbsp;</h4></button>&nbsp;&nbsp;&nbsp;&nbsp;
                        <button class="btn btn-large btn-success btn2" type="button"><h4>&nbsp;2&nbsp;</h4></button>&nbsp;&nbsp;&nbsp;&nbsp;
                        <button class="btn btn-large btn-success btn3" type="button"><h4>&nbsp;3&nbsp;</h4></button>&nbsp;&nbsp;&nbsp;&nbsp;
                        <br><br>
                        <button class="btn btn-large btn-success btnsep" type="button"><h4>&nbsp;{$USER_MODEL->get('currency_decimal_separator')}&nbsp;&nbsp;</h4></button>&nbsp;&nbsp;&nbsp;&nbsp;
                        <button class="btn btn-large btn-success btn0" type="button"><h4>&nbsp;0&nbsp;</h4></button>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        <button class="btn btn-large btn-info btnok" type="button"><h4>OK</h4></button>&nbsp;&nbsp;&nbsp;

                    </div>
                    <div class="modal-footer">
                        <div class=" pull-right cancelLinkContainer">
                            <button class="btn btn-primary" type="reset" data-dismiss="modal"><strong>{vtranslate('LBL_CLOSE', $MODULE)}</strong></button>
                        </div>
                    </div>
                </div>
            </div>
        </div>



        <div class="modal fade" tabindex="-1" role="dialog" id="customer_credit">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                        <h4 class="modal-title">Modal title</h4>
                    </div>
                    <div class="modal-body">
                        <div class="form-group">
                            <select id='clients_list' data-placeholder="{vtranslate('LBL_SELECT_CLIENT', $MODULE)}" class="form-control">
                                <option value="">&nbsp;</option>
                                {foreach item=CLIENT from=$CLIENTS}
                                    <option data-salutation="{$CLIENT["salutation"]}" data-credit="{$CLIENT["credit"]|number_format:$NO_DECIMAL:$DECIMAL:$GROUP}" value="{$CLIENT["contactid"]}">{$CLIENT["firstname"]} {$CLIENT["lastname"]}</option>
                                {/foreach}
                            </select>
                            <br/><br/>
                            <div class="" style="display: none">
                                <h4><span class="label label-info"><i class="icon-user"></i> {vtranslate('LBL_CLIENT', $MODULE)} : </span><span class="label label-info" id="client_info"></span></h4>
                                <h4><span class="label label-info" ><i class="icon-warning-sign"></i>{vtranslate('LBL_CLIENT_CREDIT', $MODULE)} : </span><span class="label label-info" id="client_credit"></span></h4>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
                        <button type="button" id="btn_credit" class="btn btn-primary">{vtranslate('LBL_BTN_CREDIT_CLIENT', $MODULE)}</button>
                    </div>
                </div><!-- /.modal-content -->
            </div><!-- /.modal-dialog -->
        </div><!-- /.modal -->     

        <div class="modal fade" tabindex="-1" role="dialog" id="credit_card">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    {if !$CONFIGS->isStripeUsable()}
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                            <h4 class="modal-title">Error</h4>
                        </div>
                        <div class="modal-body">
                            <span>{vtranslate('LBL_STRIPE_NOT_CONFIGURED', $MODULE)}</span>
                        </div>
                    {else}
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                            <h4 class="modal-title">Swipe Credit Card</h4>
                        </div>
                        <div class="modal-body">
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-lg-3 col-md-3 col-sm-3">
                                        <img src="data:image/svg+xml;utf8;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iaXNvLTg4NTktMSI/Pgo8IS0tIEdlbmVyYXRvcjogQWRvYmUgSWxsdXN0cmF0b3IgMTYuMC4wLCBTVkcgRXhwb3J0IFBsdWctSW4gLiBTVkcgVmVyc2lvbjogNi4wMCBCdWlsZCAwKSAgLS0+CjwhRE9DVFlQRSBzdmcgUFVCTElDICItLy9XM0MvL0RURCBTVkcgMS4xLy9FTiIgImh0dHA6Ly93d3cudzMub3JnL0dyYXBoaWNzL1NWRy8xLjEvRFREL3N2ZzExLmR0ZCI+CjxzdmcgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB4bWxuczp4bGluaz0iaHR0cDovL3d3dy53My5vcmcvMTk5OS94bGluayIgdmVyc2lvbj0iMS4xIiBpZD0iQ2FwYV8xIiB4PSIwcHgiIHk9IjBweCIgd2lkdGg9IjY0cHgiIGhlaWdodD0iNjRweCIgdmlld0JveD0iMCAwIDYyLjk1NCA2Mi45NTQiIHN0eWxlPSJlbmFibGUtYmFja2dyb3VuZDpuZXcgMCAwIDYyLjk1NCA2Mi45NTQ7IiB4bWw6c3BhY2U9InByZXNlcnZlIj4KPGc+Cgk8Zz4KCQk8cGF0aCBkPSJNNjAuODgsMzYuNDJsLTE0LjQ0MiwwLjAxNGMwLjEyMi0xLjM1MiwwLjA0Ny0zLjAxNCwwLjAyLTUuNjM4Yy0wLjA1NS00Ljk4NS0xLjYxNS02LjQ0OS01LjE4Ni0xMS40MDMgICAgYy0yLjM3OS0zLjMtMi4xNDMtNS41MzQtNC4zOTktNi42NDFjLTEuMjA5LTAuNTU2LTIuMzk1LTAuNzQ0LTMuMjYyLTAuOGMtMC4xOTUtMC4wMTMtMC4zNzQtMC4wMi0wLjUzMy0wLjAyMiAgICBjLTAuMzgtMC4wMDMtMC42MjksMC4wMTQtMC43MjIsMC4wMjRjLTAuMTc4LDAtMC4zNzcsMC4wMDMtMC41NjgsMC4wMDZ2LTAuMDAybC0wLjgzMSwwLjAwOGwtMC45ODMsMC4wMWwtMC41MywwLjAwNWwtMC4wMDItMC4wMSAgICBjLTAuMTU5LDAtMC4zMTMsMC0wLjQ2NywwYy03LjI1MiwwLTguNjA1LTAuMzQxLTE0LjIzMi0wLjY1MkM4LjYyNSwxMC45ODEsNC4zMTEsOS4xNzgsNC4zMTEsOS4xNzhTLTEuOTIxLDIxLjY3LDAuNjAyLDIyLjMxICAgIGMyLjUyNCwwLjY0LDUuMjAyLDIuNjc0LDUuMjAyLDIuNjc0YzYuMjM5LDUuNTk4LDE4Ljc0LDguMTc4LDE2LjU0Nyw4LjE4Yy0yLjE5MywwLjAwMi0yLjk3LDAuMjk1LTMuMzY5LDIuNDg0ICAgIGMtMC4zOTksMi4xODgsNC45NTQsMi4zODQsNC45NTQsMi4zODRzLTAuNDMyLDAuNzU2LTAuMDQsMi43M2MwLjExNywwLjU4NiwwLjg1LDAuNzkzLDEuODIzLDAuNzkzICAgIGMyLjMwNCwwLDUuOTUzLTEuMTU0LDUuOTUzLTEuMTU0cy0xLjY1NCwyLjQ5MiwwLjk3MSwzLjQxNWMwLjM2OSwwLjEzLDAuNjk3LDAuMTg2LDAuOTkzLDAuMTg2YzEuNDIxLDAsMi4wNzEtMS4yNjYsMi41NDItMS43NjQgICAgYzAuMTE0LTAuMTIyLDAuMjIyLTAuMjEyLDAuMzIyLTAuMjEyYzAuMDE2LDAsMC4wMywwLjAwMiwwLjA0NCwwLjAwNWMwLjExNSwwLjAyNSwwLjI2MSwwLjA3MiwwLjQxNCwwLjEyNSAgICBjMC4yNDksMC4wODYsMC41MjUsMC4xOTUsMC43ODEsMC4zMDRjMC40NDEsMC4xODUsMC44MTIsMC4zNTcsMC44MTIsMC4zNTdjMS4yMTIsMC41NjYsMi4xMzksMC43ODUsMi44NDQsMC43ODUgICAgYzIuNDE0LDAsMi4yNjItMi41NiwyLjI2Mi0yLjU2czAuMjY5LTEuMjU0LTAuNzEyLTMuMDQ0Yy0wLjEzNy0wLjI1LTAuMzAxLTAuNTEyLTAuNDkyLTAuNzgxICAgIGMtMC4xNzktMC4yNTQtMC4zNzgtMC41MTQtMC42MTMtMC43OGMtMC43OS0wLjkwNC0xLjkwNi0xLjg3OC0zLjQ5NC0yLjg1N2MtNi4xMzEtMy43ODMtNi43MzUtNS42NTgtNi43MzUtNS42NTggICAgYzAuMTI3LTEuNzEyLDEuMjE2LTIuMTQ5LDIuMjk4LTIuMTQ5YzAuMzUsMCwwLjY5NywwLjA0NywxLjAxMiwwLjEwOWMwLjIwMywwLjEwMSwwLjQxMiwwLjIyLDAuNjI0LDAuMzQ2ICAgIGMwLjE5NiwwLjExNywwLjM5NCwwLjI0LDAuNTk0LDAuMzcyYzEuODEyLDEuMjAzLDMuNjQ1LDIuOTIsMy44MDIsMy4wNjlsMC4wNzYsMC40MjFjMC4yNTUsMC43MzEsMC4zNTYsMS40NDEsMC4zNzMsMi4wNDcgICAgbDAuMzMzLDEuODM1YzEuMDczLDAuODQ3LDEuODYyLDEuNjgsMi40NDIsMi40NjRjMC4xOTYsMC4yNjcsMC4zNzMsMC41MjcsMC41MjQsMC43OGMwLjE2LDAuMjY4LDAuMzA0LDAuNTMsMC40MTksMC43ODEgICAgbDIuMDU3LTAuMDAybDE0LjcxMi0wLjAxNGMwLjI3MywwLDAuNDk3LDAuMjMzLDAuNDk3LDAuNTJsMC4wMDgsNi45NzJsLTIzLjYzOCwwLjAyMmwtMC4wMDItMS45MDEgICAgYy0wLjI1My0wLjExLTAuNTI3LTAuMjI3LTAuNzgxLTAuMzI2Yy0wLjA3NS0wLjAyOC0wLjE1Mi0wLjA2MS0wLjIyMS0wLjA4NmMtMC4wMTIsMC4wMTctMC4wMjQsMC4wMzItMC4wMzUsMC4wNDcgICAgYy0wLjEzOCwwLjE3OC0wLjMxMywwLjM5Ny0wLjUyNCwwLjYyMWwwLjAwOCw3Ljg0N2MwLjAwMSwxLjE0NywwLjkyNiwyLjA4MSwyLjA2MSwyLjA4MWgwLjAwMWwyMi42NDUtMC4wMjEgICAgYzEuMTM1LTAuMDAyLDIuMDYtMC45MzYsMi4wNTktMi4wODVMNjIuOTQsMzguNUM2Mi45MzksMzcuMzU0LDYyLjAxNywzNi40Miw2MC44OCwzNi40MnogTTYxLjM5LDQ5LjczNmwwLjAwMiwxLjkzNiAgICBjMCwwLjI4Ni0wLjIyMywwLjUyMS0wLjQ5NywwLjUyMUwzOC4yNSw1Mi4yMTRjLTAuMjc0LDAtMC40OTgtMC4yMzMtMC40OTgtMC41MjFsLTAuMDAyLTEuOTM1TDYxLjM5LDQ5LjczNnoiIGZpbGw9IiMwMDZERjAiLz4KCTwvZz4KPC9nPgo8Zz4KPC9nPgo8Zz4KPC9nPgo8Zz4KPC9nPgo8Zz4KPC9nPgo8Zz4KPC9nPgo8Zz4KPC9nPgo8Zz4KPC9nPgo8Zz4KPC9nPgo8Zz4KPC9nPgo8Zz4KPC9nPgo8Zz4KPC9nPgo8Zz4KPC9nPgo8Zz4KPC9nPgo8Zz4KPC9nPgo8Zz4KPC9nPgo8L3N2Zz4K" />
                                    </div>
                                    <div class="alert alert-danger col-lg-8 col-md-8 col-sm-8">
                                        <span>{vtranslate('LBL_SWIPE_CARD', $MODULE)}</span>
                                        <input type="text" name="cc_stripe" id="stripe_tracks" style="color: rgba(0,0,0,0);width: 0;height: 0;border: none;background-color: rgba(0,0,0,0)" />
                                    </div>
                                    <div class="col-lg-1 col-md-1 col-sm-1">

                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
                            <button type="button" id="btn_credit" style="display: none" class="btn btn-primary">{vtranslate('Validate', $MODULE)}</button>
                        </div>
                    {/if}
                </div><!-- /.modal-content -->
            </div><!-- /.modal-dialog -->
        </div><!-- /.modal --> 


        <input id="module" type="hidden" value="{$MODULE}">
        <input id="SALES_TAX" type="hidden" value="{$SALES_TAX}">
        <input id="SEPARATOR" type="hidden" value="{$USER_MODEL->get('currency_decimal_separator')}">

        <input type="hidden" id="date_time_format" value="" />
        {php} 
 $path = "layouts/vlayout/modules/VtPos/images/".$template->get_template_vars('HEADER_IMAGE');
 $data = base64_encode(file_get_contents($path));
 $template->assign("data",$data);
        {/php}
        <div id="header" class="hide"><span style="text-align: center;display: block"><img src="data:image/png;base64,{$data}" width="80px" /> <br>{$HEADER_TEXT|nl2br}</span></div>
        <div id="footer" class="hide"><span style="text-align: center;display: block">{$FOOTER_TEXT|nl2br}</span></div>
        <div class="hide" id="printable" style="max-width: 200px;font-size: 10px">

        </div>
    </div>

{/strip}