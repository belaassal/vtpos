<?php

/**
 * @author Brahim EL AASSAL , belaassal@gmail.com
 */

include_once 'modules/Vtiger/CRMEntity.php';

class VtPos extends Vtiger_CRMEntity {

    var $table_name = 'vtiger_vtpos';
    var $table_index = 'vtposid';

    /**
     * Mandatory table for supporting custom fields.
     */
    var $customFieldTable = Array('vtiger_vtposcf', 'vtposid');

    /**
     * Mandatory for Saving, Include tables related to this module.
     */
    var $tab_name = Array('vtiger_crmentity', 'vtiger_vtpos', 'vtiger_vtposcf');

    /**
     * Mandatory for Saving, Include tablename and tablekey columnname here.
     */
    var $tab_name_index = Array(
        'vtiger_crmentity' => 'crmid',
        'vtiger_vtpos' => 'vtposid',
        'vtiger_vtposcf' => 'vtposid');

    /**
     * Mandatory for Listing (Related listview)
     */
    var $list_fields = Array(
        /* Format: Field Label => Array(tablename, columnname) */
        // tablename should not have prefix 'vtiger_'
        'Refs' => Array('vtpos', 'refs'),
        'Time' => Array('crmentity', 'createdtime'),
        'Assigned' => Array('crmentity', 'assigned_user_id'),
        'Client' => Array('vtpos', 'client'),
        'Prix_TTC' => Array('vtpos', 'prix_ttc')
    );
    var $list_fields_name = Array(
        /* Format: Field Label => fieldname */
        'Refs' => 'refs',
        'Time' => 'createdtime',
        'Assigned' => 'assigned_user_id',
        'Client' => 'client',
        'Prix_TTC' => 'prix_ttc'
    );
    // Make the field link to detail view
    var $list_link_field = 'refs';
    // For Popup listview and UI type support
    var $search_fields = Array(
        /* Format: Field Label => Array(tablename, columnname) */
        // tablename should not have prefix 'vtiger_'
        'Refs' => Array('vtpos', 'refs'),
        'Time' => Array('crmentity', 'createdtime'),
        'Assigned' => Array('crmentity', 'assigned_user_id'),
        'Client' => Array('vtpos', 'client'),
        'Prix_TTC' => Array('vtpos', 'prix_ttc')
    );
    var $search_fields_name = Array(
        /* Format: Field Label => fieldname */
        'Refs' => 'refs',
        'Time' => 'createdtime',
        'Assigned' => 'assigned_user_id',
        'Client' => 'client',
        'Prix_TTC' => 'prix_ttc'
    );
    // Column value to use on detail view record text display
    var $def_detailview_recname = 'refs';
    // Used when enabling/disabling the mandatory fields for the module.
    // Refers to vtiger_field.fieldname values.
    var $mandatory_fields = Array('refs', 'assigned_user_id');
    var $default_order_by = 'vtposid';
    var $default_sort_order = 'ASC';

    /**
     * Invoked when special actions are performed on the module.
     * @param String Module name
     * @param String Event Type
     */
    function vtlib_handler($moduleName, $eventType) {
        global $adb;
        if ($eventType == 'module.postinstall') {
            
        } else if ($eventType == 'module.disabled') {
            // TODO Handle actions before this module is being uninstalled.
        } else if ($eventType == 'module.preuninstall') {
            // TODO Handle actions when this module is about to be deleted.
        } else if ($eventType == 'module.preupdate') {
            // TODO Handle actions before this module is updated.
        } else if ($eventType == 'module.postupdate') {
            // TODO Handle actions after this module is updated.
        }
    }

}
