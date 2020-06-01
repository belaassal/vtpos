
{strip}
    <div class="container-fluid">

        <div class="widget_header row-fluid">
            <div class=""><h3>{vtranslate('LBL_VTPOS_CONFIG', $QUALIFIED_MODULE)}</h3></div>
        </div>
        <hr>
        <div class="contents">
            <form  enctype="multipart/form-data" action="{$MODEL->getEditViewUrl()}" method="post">
                <table class="table table-bordered table-condensed themeTableColor">
                    <thead>
                        <tr class="blockHeader">
                            <th colspan="2" >
                                <span class="alignMiddle">{vtranslate('LBL_VTPOS_CONFIG', $QUALIFIED_MODULE)}</span>
                            </th>
                        </tr>
                    </thead>
                    <tbody>

                        <tr>
                            <td width="30%"><label  class="muted pull-right">{vtranslate('LBL_TICKET_IMAGE', $QUALIFIED_MODULE)}</label></td>
                            <td>
                                <input type="file" name="header_image"/>
                                <img src="layouts/vlayout/modules/VtPos/images/{$MODEL->getTicketImage()}" width="96px"/>
                            </td>
                        </tr>
                        <tr>
                            <td><label  class="muted pull-right">{vtranslate('LBL_TICKET_HEADER', $QUALIFIED_MODULE)}</label></td>
                            <td><textarea name="ticket_header" rows="2" maxlength="250">{$MODEL->getTicketHeader()}</textarea></td>
                        </tr>
                        <tr>
                            <td><label  class="muted pull-right">{vtranslate('LBL_TICKET_FOOTER', $QUALIFIED_MODULE)}</label></td>
                            <td><textarea name="ticket_footer" rows="2" maxlength="250">{$MODEL->getTicketFooter()}</textarea></td>
                        </tr>
                        <tr>
                            <td><label  class="muted pull-right">{vtranslate('LBL_CLIENT_CREDIT_ENABLE', $QUALIFIED_MODULE)}</label></td>
                            <td><input type="checkbox" {if $MODEL->isCreditEnabled()} checked="checked" {/if} name="enable_credit"/></td>
                        </tr>
                        <tr>
                            <td><label  class="muted pull-right">{vtranslate('LBL_CLIENT_CREDIT_CARD_ENABLE', $QUALIFIED_MODULE)}</label></td>
                            <td><input type="checkbox" {if $MODEL->isCreditCardEnabled()} checked="checked" {/if} name="enable_credit_card"/></td>
                        </tr>
                        <tr>
                            <td><label  class="muted pull-right">{vtranslate('LBL_VTPOS_KEY', $QUALIFIED_MODULE)}</label></td>
                            <td>
                                {if empty($MODEL->getVtPosKey())}
                                    <input type="text" value="{$MODEL->getVtPosKey()}" name="vtpos_license_key"/>
                                {else}
                                    <input type="text" disabled="disabled" size="30" value="{$MODEL->getVtPosKey()}" name="vtpos_license_key"/>
                                {/if}
                            </td>
                        </tr>
                        <tr>
                            <td><label  class="muted pull-right">{vtranslate('LBL_VTIGER_KEY', $QUALIFIED_MODULE)}</label></td>
                            <td>{$MODEL->getVtigerKey()}</td>
                        </tr>
                    </tbody>
                </table> 
                <br>

                <table class="table table-bordered table-condensed themeTableColor">
                    <thead>
                        <tr class="blockHeader">
                            <th colspan="2" >
                                <span class="alignMiddle">{vtranslate('Stripe')}</span>
                            </th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td width="30%"><label  class="muted pull-right">{vtranslate('Use Stripe')}</label></td>
                            <td>
                                <label class="radio-inline">
                                    <input type="radio" name="is_test_stripe" value="1" {if !$MODEL->isStripeLive()}checked="checked"{/if}> Test
                                </label>
                                <label class="radio-inline">
                                    <input type="radio" name="is_test_stripe" value="0" {if $MODEL->isStripeLive()}checked="checked"{/if}> Live
                                </label>
                            </td>
                        </tr>
                        <tr>
                            <td><label  class="muted pull-right">{vtranslate('Stripe Test Secret Key')}</label></td>
                            <td>
                                <input type="text" size="30" value="{$MODEL->getStripeSecretTest()}" name="stripe_test"/>
                            </td>
                        </tr>
                        <tr>
                            <td><label  class="muted pull-right">{vtranslate('Stripe Live Secret Key')}</label></td>
                            <td><input type="text"  size="30" value="{$MODEL->getStripeSecretLive()}" name="stripe_live"/></td>
                        </tr>
                    </tbody>
                </table>
                <br>
                <div class="pull-right">
                    <button class="btn btn-success span2" type="submit"><strong>{vtranslate('LBL_SAVE', $QUALIFIED_MODULE)}</strong></button>
                </div>
            </form>
        </div>
    </div>
{/strip}