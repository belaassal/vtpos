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
    {assign var=somefields value=["refs","createdtime","modifiedtime","assigned_user_id","client","pay_method","description"]}
    {foreach key=BLOCK_LABEL_KEY item=FIELD_MODEL_LIST from=$RECORD_STRUCTURE}
        {assign var=BLOCK value=$BLOCK_LIST[$BLOCK_LABEL_KEY]}
    {if $BLOCK eq null or $FIELD_MODEL_LIST|@count lte 0}{continue}{/if}
    {assign var=IS_HIDDEN value=$BLOCK->isHidden()}
    {assign var=WIDTHTYPE value=$USER_MODEL->get('rowheight')}
    <input type=hidden name="timeFormatOptions" data-value='{$DAY_STARTS}' />
    <table class="table table-bordered equalSplit detailview-table">
        <thead>
            <tr>
                <th class="blockHeader" colspan="4">
                    <img class="cursorPointer alignMiddle blockToggle {if !($IS_HIDDEN)} hide {/if} "  src="{vimage_path('arrowRight.png')}" data-mode="hide" data-id={$BLOCK_LIST[$BLOCK_LABEL_KEY]->get('id')}>
                    <img class="cursorPointer alignMiddle blockToggle {if ($IS_HIDDEN)} hide {/if}"  src="{vimage_path('arrowDown.png')}" data-mode="show" data-id={$BLOCK_LIST[$BLOCK_LABEL_KEY]->get('id')}>
                    &nbsp;&nbsp;{vtranslate({$BLOCK_LABEL_KEY},{$MODULE_NAME})}
                </th>
            </tr>
        </thead>
        <tbody {if $IS_HIDDEN} class="hide" {/if}>
            {assign var=COUNTER value=0}
            <tr>
                {foreach item=FIELD_MODEL key=FIELD_NAME from=$FIELD_MODEL_LIST}

                    {if !$FIELD_MODEL->isViewableInDetailView() or !in_array($FIELD_NAME,$somefields)}
                        {continue}
                    {/if}
                    {if $FIELD_MODEL->get('uitype') eq "83"}
                        {foreach item=tax key=count from=$TAXCLASS_DETAILS}
                            {if $tax.check_value eq 1}
                                {if $COUNTER eq 2}
                                </tr><tr>
                                    {assign var="COUNTER" value=1}
                                {else}
                                    {assign var="COUNTER" value=$COUNTER+1}
                                {/if}
                                <td class="fieldLabel {$WIDTHTYPE}">
                                    <label class='muted pull-right marginRight10px'>{vtranslate($tax.taxlabel, $MODULE)}(%)</label>
                                </td>
                                <td class="fieldValue {$WIDTHTYPE}">
                                    <span class="value">
                                        {$tax.percentage}
                                    </span>
                                </td>
                            {/if}
                        {/foreach}
                    {else if $FIELD_MODEL->get('uitype') eq "69" || $FIELD_MODEL->get('uitype') eq "105"}
                        {if $COUNTER neq 0}
                            {if $COUNTER eq 2}
                            </tr><tr>
                                {assign var=COUNTER value=0}
                            {/if}
                        {/if}
                        <td class="fieldLabel {$WIDTHTYPE}"><label class="muted pull-right marginRight10px">{vtranslate({$FIELD_MODEL->get('label')},{$MODULE_NAME})}</label></td>
                        <td class="fieldValue {$WIDTHTYPE}">
                            <div id="imageContainer" width="300" height="200">
                                {foreach key=ITER item=IMAGE_INFO from=$IMAGE_DETAILS}
                                    {if !empty($IMAGE_INFO.path) && !empty({$IMAGE_INFO.orgname})}
                                        <img src="{$IMAGE_INFO.path}_{$IMAGE_INFO.orgname}" width="300" height="200">
                                    {/if}
                                {/foreach}
                            </div>
                        </td>
                        {assign var=COUNTER value=$COUNTER+1}
                    {else}
                        {if $FIELD_MODEL->get('uitype') eq "20" or $FIELD_MODEL->get('uitype') eq "19"}
                            {if $COUNTER eq '1'}
                                <td class="{$WIDTHTYPE}"></td><td class="{$WIDTHTYPE}"></td></tr><tr>
                                    {assign var=COUNTER value=0}
                                {/if}
                            {/if}
                            {if $COUNTER eq 2}
                        </tr><tr>
                            {assign var=COUNTER value=1}
                        {else}
                            {assign var=COUNTER value=$COUNTER+1}
                        {/if}
                        <td class="fieldLabel {$WIDTHTYPE}" id="{$MODULE_NAME}_detailView_fieldLabel_{$FIELD_MODEL->getName()}" {if $FIELD_MODEL->getName() eq 'description' or $FIELD_MODEL->get('uitype') eq '69'} style='width:8%'{/if}>
                            <label class="muted pull-right marginRight10px">
                                {vtranslate({$FIELD_MODEL->get('label')},{$MODULE_NAME})}
                                {if ($FIELD_MODEL->get('uitype') eq '72') && ($FIELD_MODEL->getName() eq 'unit_price')}
                                    ({$BASE_CURRENCY_SYMBOL})
                                {/if}
                            </label>
                        </td>
                        <td class="fieldValue {$WIDTHTYPE}" id="{$MODULE_NAME}_detailView_fieldValue_{$FIELD_MODEL->getName()}" {if $FIELD_MODEL->get('uitype') eq '19' or $FIELD_MODEL->get('uitype') eq '20'} colspan="3" {assign var=COUNTER value=$COUNTER+1} {/if}>
                            <span class="value" data-field-type="{$FIELD_MODEL->getFieldDataType()}" {if $FIELD_MODEL->get('uitype') eq '19' or $FIELD_MODEL->get('uitype') eq '20' or $FIELD_MODEL->get('uitype') eq '21'} style="white-space:normal;" {/if}>
                                {include file=vtemplate_path($FIELD_MODEL->getUITypeModel()->getDetailViewTemplateName(),$MODULE_NAME) FIELD_MODEL=$FIELD_MODEL USER_MODEL=$USER_MODEL MODULE=$MODULE_NAME RECORD=$RECORD}
                            </span>
                            {if $IS_AJAX_ENABLED && $FIELD_MODEL->isEditable() eq 'true' && ($FIELD_MODEL->getFieldDataType()!=Vtiger_Field_Model::REFERENCE_TYPE) && $FIELD_MODEL->isAjaxEditable() eq 'true'}
                                <span class="hide edit">
                                    {include file=vtemplate_path($FIELD_MODEL->getUITypeModel()->getTemplateName(),$MODULE_NAME) FIELD_MODEL=$FIELD_MODEL USER_MODEL=$USER_MODEL MODULE=$MODULE_NAME}
                                    {if $FIELD_MODEL->getFieldDataType() eq 'multipicklist'}
                                        <input type="hidden" class="fieldname" value='{$FIELD_MODEL->get('name')}[]' data-prev-value='{$FIELD_MODEL->getDisplayValue($FIELD_MODEL->get('fieldvalue'))}' />
                                    {else}
                                        <input type="hidden" class="fieldname" value='{$FIELD_MODEL->get('name')}' data-prev-value='{Vtiger_Util_Helper::toSafeHTML($FIELD_MODEL->getDisplayValue($FIELD_MODEL->get('fieldvalue')))}' />
                                    {/if}
                                </span>
                            {/if}
                        </td>
                    {/if}

                    {if $FIELD_MODEL_LIST|@count eq 1 and $FIELD_MODEL->get('uitype') neq "19" and $FIELD_MODEL->get('uitype') neq "20" and $FIELD_MODEL->get('uitype') neq "30" and $FIELD_MODEL->get('name') neq "recurringtype" and $FIELD_MODEL->get('uitype') neq "69" and $FIELD_MODEL->get('uitype') neq "105"}
                        <td class="fieldLabel {$WIDTHTYPE}"></td><td class="{$WIDTHTYPE}"></td>
                        {/if}
                    {/foreach}
                    {* adding additional column for odd number of fields in a block *}
                    {if $FIELD_MODEL_LIST|@end eq true and $FIELD_MODEL_LIST|@count neq 1 and $COUNTER eq 1}
                    <td class="fieldLabel {$WIDTHTYPE}"></td><td class="{$WIDTHTYPE}"></td>
                    {/if}
            </tr>
        </tbody>
    </table>
    <br>
{/foreach}

{assign var=DECIMAL value=$USER_MODEL->get('currency_decimal_separator')}
{assign var=GROUP value=$USER_MODEL->get('currency_grouping_separator')}
{assign var=CURRENCY_SYMBOL value={$USER_MODEL->get('currency_symbol')}}
{assign var=NO_DECIMAL value={$USER_MODEL->get('no_of_currency_decimals')}}
<table class="table table-bordered equalSplit detailview-table">
    <thead>
        <tr><th>Item Details</th></tr>
    </thead>
</table>
<table class="table table-bordered detailview-table">
    <thead>
        <tr>
            <th width="4%">#</th>
            <th width="50%">Product</th>
            <th width="13%">Quantity</th>
            <th width="13%">Price ({$CURRENCY_SYMBOL})</th>
            <th width="20%">Total Price ({$CURRENCY_SYMBOL})</th>
        </tr>
    </thead>
    <tbody>
        {foreach item=PRODUCT key=count from=$PRODUCTS}
            <tr>
                <td>{$count+1}</td>
                <td>{$PRODUCT["productname"]}</td>
                <td><div class="pull-right">{$PRODUCT["quantity"]}</div></td>
                <td><div class="pull-right">{$PRODUCT["unit_price"]|number_format:$NO_DECIMAL:$DECIMAL:$GROUP}</div></td>
                <td><div class="pull-right">{$PRODUCT["total_price"]|number_format:$NO_DECIMAL:$DECIMAL:$GROUP}</div></td>
            </tr>
        {/foreach}
    </tbody>
</table>
<table class="table table-bordered">
    <tbody>
        <tr>
            <td width="80%">
                <div class="pull-right">
                    <b>SubTotal</b>
                </div>
            </td>
            <td width="20%">
                <div class="pull-right">
                    <b>{$SUB_TOTAL|number_format:$NO_DECIMAL:$DECIMAL:$GROUP}</b>
                </div>
            </td>
        </tr>
        <tr>
            <td width="80%">
                <div class="pull-right">
                    <b>Discount</b>
                </div>
            </td>
            <td width="20%">
                <div class="pull-right">
                    <b>{$DISCOUNT|number_format:$NO_DECIMAL:$DECIMAL:$GROUP}</b>
                </div>
            </td>
        </tr>
        <tr>
            <td width="80%">
                <div class="pull-right">
                    <b>Tax Total</b>
                </div>
            </td>
            <td width="20%">
                <div class="pull-right">
                    <b>{$TAX|number_format:$NO_DECIMAL:$DECIMAL:$GROUP}</b>
                </div>
            </td>
        </tr>
        <tr>
            <td width="80%">
                <div class="pull-right">
                    <b>Total</b>
                </div>
            </td>
            <td width="20%">
                <div class="pull-right">
                    <b>{$TOTAL}</b>
                </div>
            </td>
        </tr>
        <tr>
            <td width="80%">
                <div class="pull-right">
                    <b>Amount Tendered</b>
                </div>
            </td>
            <td width="20%">
                <div class="pull-right">
                    <b>{$TENDERED|number_format:$NO_DECIMAL:$DECIMAL:$GROUP}</b>
                </div>
            </td>
        </tr>
        <tr>
            <td width="80%">
                <div class="pull-right">
                    <b>Change</b>
                </div>
            </td>
            <td width="20%">
                <div class="pull-right">
                    <b>{$CHANGE|number_format:$NO_DECIMAL:$DECIMAL:$GROUP}</b>
                </div>
            </td>
        </tr>
        <tr>
            <td colspan="2">
                <button class="btn btn-success pull-right" id='btn_print_ticket'><strong>{vtranslate('LBL_PRINT_TICKET', $MODULE)}</strong></button>
            </td>
        </tr>
    </tbody>
</table>
<div class="hide" id="printable" style="max-width: 200px;font-size: 10px">
    <b>
        <span style="text-align: center;display: block">
            <img src="data:image/png;base64,{$HEADER_IMAGE}" width="80px"> 
            <br>
            {$HEADER_TEXT}
        </span>
        <div style="text-align: center;display: block">26-07-2017 12:36 PM</div>
    </b>
    <hr>
    <table style="font-size:12px">
        <tbody>
            <tr>
                <td>Qnty</td>
                <td>Unit Price</td>
                <td>Total Price</td>
            </tr>
            {foreach item=PRODUCT key=count from=$PRODUCTS}
            <tr>
                <td colspan="3"><u><b>{$PRODUCT["productname"]}</b></u></td>
            </tr>
            <tr>
                <td>{$PRODUCT["quantity"]}</td>
                <td>{$PRODUCT["unit_price"]|number_format:$NO_DECIMAL:$DECIMAL:$GROUP}</td>
                <td>{$PRODUCT["total_price"]|number_format:$NO_DECIMAL:$DECIMAL:$GROUP}</td>
            </tr>
            {/foreach}
        </tbody>
    </table>
    <hr>
    <table width="100%" style="font-size:12px">
        <tbody>
            <tr><td>subTotal</td><td><span class="pull-right">{$SUB_TOTAL|number_format:$NO_DECIMAL:$DECIMAL:$GROUP}</span></td></tr>
            <tr><td>Discount</td><td><span class="pull-right">{$DISCOUNT|number_format:$NO_DECIMAL:$DECIMAL:$GROUP}</span></td></tr>
            <tr><td>Tax</td><td><span class="pull-right">{$TAX|number_format:$NO_DECIMAL:$DECIMAL:$GROUP}</span></td></tr>
            <tr><td>Total</td><td><span class="pull-right">{$TOTAL}</span></td></tr>
            <tr><td>Paid</td><td><span class="pull-right">{$TENDERED|number_format:$NO_DECIMAL:$DECIMAL:$GROUP}</span></td></tr>
            <tr><td>Change</td><td><span class="pull-right">{$CHANGE|number_format:$NO_DECIMAL:$DECIMAL:$GROUP}</span></td></tr>
        </tbody>
    </table>
    <hr>
    <b><span style="text-align: center;display: block">{$FOOTER_TEXT}</span></b>
</div>
{/strip}