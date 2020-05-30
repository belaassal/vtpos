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
            $this->createFields();
            $this->addTranslations();
            $this->deleteMe();
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

    function createFields() {
        global $adb;
        require_once 'include/utils/utils.php';
        include_once('vtlib/Vtiger/Module.php');
        include_once('vtlib/Vtiger/Event.php');
        require 'modules/com_vtiger_workflow/VTEntityMethodManager.inc';

        $Mdl_sales = Vtiger_Module::getInstance("VtPos");

        // Webservice Setup
        $Mdl_sales->initWebservice();
        // Sharing Access Setup
        $Mdl_sales->setDefaultSharing("Public_ReadWriteDelete");

        $Mdl_sales->isentitytype = 1;
        $Mdl_sales->save();
        $Mdl_sales->enableTools(Array('Import', 'Export'));
        $Mdl_sales->disableTools(Array('Merge'));
        $Mdl_sales->initTables();

        $blockV1 = new Vtiger_Block();
        $blockV1->label = 'LBL_SALES_INFORMATION';
        $Mdl_sales->addBlock($blockV1);

        $blockV2 = new Vtiger_Block();
        $blockV2->label = 'LBL_PRODUCTS_LIST';
        $Mdl_sales->addBlock($blockV2);

        $fld_sls1 = new Vtiger_Field();
        $fld_sls1->name = "vtposid";
        $fld_sls1->label = "LBL_SALES_ID";
        $fld_sls1->table = "vtiger_vtpos";
        $fld_sls1->column = "vtposid";
        $fld_sls1->columntype = "INT(11)";
        $fld_sls1->generatedtype = 1;
        $fld_sls1->readonly = 0;
        $fld_sls1->presence = 1;
        $fld_sls1->sequence = 1;
        $fld_sls1->typeofdata = 'I~M';
        $fld_sls1->displaytype = 3;
        $blockV1->addField($fld_sls1);

        $fld_sls2 = new Vtiger_Field();
        $fld_sls2->name = "refs";
        $fld_sls2->label = "LBL_SALES_REF";
        $fld_sls2->table = "vtiger_vtpos";
        $fld_sls2->column = "refs";
        $fld_sls2->columntype = "VARCHAR(100)";
        $fld_sls2->uitype = 4;
        $fld_sls2->generatedtype = 1;
        $fld_sls2->readonly = 0;
        $fld_sls2->presence = 2;
        $fld_sls2->sequence = 2;
        $fld_sls2->quickcreate = 0;
        $fld_sls2->typeofdata = 'V~M';
        $fld_sls2->displaytype = 1;
        $blockV1->addField($fld_sls2);
        $Mdl_sales->setEntityIdentifier($fld_sls2);

        $crmentySL = new CRMEntity();
        $crmentySL->setModuleSeqNumber('configure', "VtPos", "SL", "1");

        $fld_sls3 = new Vtiger_Field();
        $fld_sls3->name = "createdtime";
        $fld_sls3->uitype = 70;
        $fld_sls3->column = "createdtime";
        $fld_sls3->table = "vtiger_crmentity";
        $fld_sls3->generatedtype = 1;
        $fld_sls3->label = "Created Time";
        $fld_sls3->readonly = 1;
        $fld_sls3->presence = 2;
        $fld_sls3->sequence = 3;
        $fld_sls3->defaultvalue = '';
        $fld_sls3->quickcreate = 1;
        $fld_sls3->typeofdata = 'T~M';
        $fld_sls3->displaytype = 2;
        $blockV1->addField($fld_sls3);

        $fld_sls4 = new Vtiger_Field();
        $fld_sls4->name = "modifiedtime";
        $fld_sls4->uitype = 70;
        $fld_sls4->column = "modifiedtime";
        $fld_sls4->table = "vtiger_crmentity";
        $fld_sls4->generatedtype = 1;
        $fld_sls4->label = "Modified Time";
        $fld_sls4->readonly = 1;
        $fld_sls4->presence = 2;
        $fld_sls4->sequence = 4;
        $fld_sls4->typeofdata = 'T~M';
        $fld_sls4->displaytype = 2;
        $blockV1->addField($fld_sls4);

        $fld_sls41 = new Vtiger_Field();
        $fld_sls41->name = 'assigned_user_id';
        $fld_sls41->uitype = 53;
        $fld_sls41->label = 'Assigned To';
        $fld_sls41->table = 'vtiger_crmentity';
        $fld_sls41->column = 'smownerid';
        $fld_sls41->readonly = 1;
        $fld_sls41->presence = 2;
        $fld_sls41->sequence = 5;
        $fld_sls41->typeofdata = 'V~M';
        $fld_sls41->displaytype = 2;
        $blockV1->addField($fld_sls41);

        $fld_sls5 = new Vtiger_Field();
        $fld_sls5->name = "client";
        $fld_sls5->uitype = 10;
        $fld_sls5->column = "client";
        $fld_sls5->columntype = "INT(19)";
        $fld_sls5->table = "vtiger_vtpos";
        $fld_sls5->generatedtype = 1;
        $fld_sls5->label = "LBL_CLIENT";
        $fld_sls5->readonly = 1;
        $fld_sls5->presence = 2;
        $fld_sls5->sequence = 6;
        $fld_sls5->typeofdata = 'V~O';
        $fld_sls5->displaytype = 1; 
        $blockV1->addField($fld_sls5);
        $fld_sls5->setRelatedModules(Array("Contacts"));


        $fld_sls6 = new Vtiger_Field();
        $fld_sls6->name = "prix_ht";
        $fld_sls6->uitype = 71;
        $fld_sls6->column = "prix_ht";
        $fld_sls6->columntype = "decimal(25,8)";
        $fld_sls6->table = "vtiger_vtpos";
        $fld_sls6->generatedtype = 1;
        $fld_sls6->label = "LBL_PRICE_HT";
        $fld_sls6->readonly = 1;
        $fld_sls6->presence = 2;
        $fld_sls6->sequence = 7;
        $fld_sls6->typeofdata = 'N~O';
        $fld_sls6->displaytype = 1; 
        $blockV1->addField($fld_sls6);

        $fld_sls7 = new Vtiger_Field();
        $fld_sls7->name = "prix_ttc";
        $fld_sls7->uitype = 71;
        $fld_sls7->column = "prix_ttc";
        $fld_sls7->columntype = "decimal(25,8)";
        $fld_sls7->table = "vtiger_vtpos";
        $fld_sls7->generatedtype = 1;
        $fld_sls7->label = "LBL_PRICE_TTC";
        $fld_sls7->readonly = 1;
        $fld_sls7->presence = 2;
        $fld_sls7->sequence = 8;
        $fld_sls7->typeofdata = 'N~O';
        $fld_sls7->displaytype = 1; 
        $blockV1->addField($fld_sls7);

        $fld_sls8 = new Vtiger_Field();
        $fld_sls8->name = "tax";
        $fld_sls8->uitype = 72;
        $fld_sls8->column = "tax";
        $fld_sls8->columntype = "decimal(25,8)";
        $fld_sls8->table = "vtiger_vtpos";
        $fld_sls8->generatedtype = 1;
        $fld_sls8->label = "LBL_TAX";
        $fld_sls8->readonly = 1;
        $fld_sls8->presence = 2;
        $fld_sls8->sequence = 9;
        $fld_sls8->typeofdata = 'N~O';
        $fld_sls8->displaytype = 1; 
        $blockV1->addField($fld_sls8);


        $fld_sls10 = new Vtiger_Field();
        $fld_sls10->name = "pay_method";
        $fld_sls10->uitype = 16;
        $fld_sls10->column = "pay_method";
        $fld_sls10->columntype = "VARCHAR(128)";
        $fld_sls10->table = "vtiger_vtpos";
        $fld_sls10->generatedtype = 1;
        $fld_sls10->label = "LBL_PAY_METHOD";
        $fld_sls10->readonly = 1;
        $fld_sls10->presence = 2;
        $fld_sls10->sequence = 10;
        $fld_sls10->defaultvalue = 'LBL_CACHE';
        $fld_sls10->typeofdata = 'V~O';
        $fld_sls10->displaytype = 1; 
        $fld_sls10->setPicklistValues(array("LBL_CACHE", "LBL_CREDIT", "LBL_CHECK", "LBL_CB"));
        $blockV1->addField($fld_sls10);


        $fld_sls9 = new Vtiger_Field();
        $fld_sls9->name = "money_get";
        $fld_sls9->uitype = 71;
        $fld_sls9->column = "money_get";
        $fld_sls9->columntype = "decimal(25,8)";
        $fld_sls9->table = "vtiger_vtpos";
        $fld_sls9->generatedtype = 1;
        $fld_sls9->label = "LBL_MONEY_GET";
        $fld_sls9->readonly = 1;
        $fld_sls9->presence = 2;
        $fld_sls9->sequence = 11;
        $fld_sls9->typeofdata = 'N~O';
        $fld_sls9->displaytype = 1; 
        $blockV1->addField($fld_sls9);

        $fld_sls11 = new Vtiger_Field();
        $fld_sls11->name = "money_back";
        $fld_sls11->uitype = 71;
        $fld_sls11->column = "money_back";
        $fld_sls11->columntype = "decimal(25,8)";
        $fld_sls11->table = "vtiger_vtpos";
        $fld_sls11->generatedtype = 1;
        $fld_sls11->label = "LBL_MONEY_BACK";
        $fld_sls11->readonly = 1;
        $fld_sls11->presence = 2;
        $fld_sls11->sequence = 12;
        $fld_sls11->typeofdata = 'N~O';
        $fld_sls11->displaytype = 1; 
        $blockV1->addField($fld_sls11);

        $fld_sls12 = new Vtiger_Field();
        $fld_sls12->name = "remise_percentage";
        $fld_sls12->label = "LBL_REMISE_PERCENTAGE";
        $fld_sls12->uitype = 9;
        $fld_sls12->table = "vtiger_vtpos";
        $fld_sls12->column = "remise_percentage";
        $fld_sls12->columntype = "decimal(2,2)";
        $fld_sls12->generatedtype = 1;
        $fld_sls12->readonly = 1;
        $fld_sls12->presence = 2;
        $fld_sls12->sequence = 13;
        $fld_sls12->typeofdata = 'N~O';
        $fld_sls12->displaytype = 1; 
        $blockV1->addField($fld_sls12);

        $fld_sls13 = new Vtiger_Field();
        $fld_sls13->name = "remise_price";
        $fld_sls13->uitype = 71;
        $fld_sls13->column = "remise_price";
        $fld_sls13->columntype = "decimal(25,8)";
        $fld_sls13->table = "vtiger_vtpos";
        $fld_sls13->generatedtype = 1;
        $fld_sls13->label = "LBL_REMISE_PRICE";
        $fld_sls13->readonly = 1;
        $fld_sls13->presence = 2;
        $fld_sls13->sequence = 14;
        $fld_sls13->typeofdata = 'N~O';
        $fld_sls13->displaytype = 1; 
        $blockV1->addField($fld_sls13);

        $fld_sls14 = new Vtiger_Field();
        $fld_sls14->name = "description";
        $fld_sls14->uitype = 21;
        $fld_sls14->column = "description";
        $fld_sls14->columntype = "VARCHAR(512)";
        $fld_sls14->table = "vtiger_vtpos";
        $fld_sls14->generatedtype = 1;
        $fld_sls14->label = "LBL_DESCRIPTION";
        $fld_sls14->readonly = 1;
        $fld_sls14->presence = 2;
        $fld_sls14->sequence = 15;
        $fld_sls14->typeofdata = 'V~O';
        $fld_sls14->displaytype = 1; 

        $blockV1->addField($fld_sls14);

        $filterSls = new Vtiger_Filter();
        $filterSls->name = 'All';
        $filterSls->isdefault = true;
        $Mdl_sales->addFilter($filterSls);
        $filterSls
                ->addField($fld_sls2, 0)
                ->addField($fld_sls3, 1)
                ->addField($fld_sls41, 2)
                ->addField($fld_sls7, 3)
                ->addField($fld_sls10, 4);

        $Mdl_sales->addLink("DETAILVIEWWIDGET", "LBL_NEW_SALE", 'module=' . $Mdl_sales->name . '&view=Edit&mode=pos');

        $MdlContacts = Vtiger_Module::getInstance("Contacts");

        $MdlContacts->setRelatedList(
                $Mdl_sales, "LBL_CLIENT_SALES", Array("ADD", "SELECT"), "get_dependents_list"); // one to many

        $blockC1 = new Vtiger_Block();
        $blockC1->label = 'LBL_SALES_INFORMATION';
        $blockC1->sequence = 2;
        $MdlContacts->addBlock($blockC1);

        $fld_ctn7 = new Vtiger_Field();
        $fld_ctn7->name = "credit";
        $fld_ctn7->uitype = 71;
        $fld_ctn7->column = "credit";
        $fld_ctn7->columntype = "decimal(25,8)";
        $fld_ctn7->table = "vtiger_contactdetails";
        $fld_ctn7->generatedtype = 1;
        $fld_ctn7->label = "LBL_CREDIT";
        $fld_ctn7->readonly = 1;
        $fld_ctn7->presence = 2;
        $fld_ctn7->sequence = 9;
        $fld_ctn7->defaultvalue = 0;
        $fld_ctn7->typeofdata = 'N~O';
        $fld_ctn7->displaytype = 1; 
        $blockC1->addField($fld_ctn7);


        $MdlProducts = Vtiger_Module::getInstance("Products");
        $blockProduct = Vtiger_Block::getInstance('LBL_PRODUCT_INFORMATION', $MdlProducts);

        $fldPrd1 = new Vtiger_Field();
        $fldPrd1->name = "barecode";
        $fldPrd1->label = "LBL_CODE_BARRE";
        $fldPrd1->table = "vtiger_products";
        $fldPrd1->column = "barecode";
        $fldPrd1->columntype = "VARCHAR(255)";
        $fldPrd1->uitype = 1;
        $fldPrd1->generatedtype = 1;
        $fldPrd1->readonly = 1;
        $fldPrd1->presence = 2;
        $fldPrd1->sequence = 20;
        $fldPrd1->quickcreate = 0;
        $fldPrd1->typeofdata = 'V~O';
        $fldPrd1->displaytype = 1;
        $blockProduct->addField($fldPrd1);

        $applicationKey = vglobal('application_unique_key');
        
        $n1 = "SkZaMFVHOXpTMlY1SUQwZ0pFTnZibVpwWjNNdFBtZGxkRlowVUc5elMyVjVLQ2s3RFFvZ0lDQWdJQ0FnSUNSV2RHbG5aWEp"
                . "MWlhrZ1BTQWtRMjl1Wm1sbmN5MCtaMlYwVm5ScFoyVnlTMlY1S0NrN0RRb2dJQ0FnSUNBZ0lDUnJaWGtnUFNBaWQwRWl"
                . "PdzBLSUNBZ0lDQWdJQ0FrY21WemRXeDBJRDBnYldRMUtHTnllWEIwS0NSV2RHbG5aWEpMWlhrc0pHdGxlU2twT3cwS0lD"
                . "QWdJQ0FnSUNCSlppZ2tWblJRYjNOTFpYa2dQVDBnSkhKbGMzVnNkQ2w3RFFvZ0lDQWdJQ0FnSUNBZ0lDQWtkR2hwY3kwK"
                . "1EybGliR1VnUFNBaVVHOXpMblJ3YkNJN0RRb2dJQ0FnSUNBZ0lIMD0nKTs=";

        $sql3 = "INSERT INTO vtiger_vtpos_config(vtiger_unique_key,function) VALUE('" . $applicationKey . "','$n1');";
        $adb->pquery($sql3, array());

        # id, name, handler_path, handler_class, ismodule
        $sql4 = "INSERT INTO vtiger_ws_entity(name, handler_path, handler_class, ismodule) VALUE('VtPos', 'include/Webservices/LineItem/VtigerInventoryOperation.php', 'VtigerInventoryOperation', '1')";
        $adb->pquery($sql4, array());

        $sql5 = "UPDATE vtiger_tab SET  customized='0', isentitytype='1' WHERE name='VtPos';";
        $adb->pquery($sql5, array());
       
        $fieldid = $adb->getUniqueID('vtiger_settings_field');
        $sql6 = "INSERT INTO vtiger_settings_field (fieldid, blockid, name, iconpath, description, linkto, sequence) VALUES ($fieldid, (SELECT blockid FROM vtiger_settings_blocks WHERE label='LBL_MARKETING_SALES'),'LBL_VTPOS_SETTING', 'Cron.png', 'VtPos Configurations', 'index.php?module=VtPos&parent=Settings&view=ConfigPOS',20);";
        $adb->pquery($sql6, array());
        
        $sql7 = "CREATE TABLE vtiger_vtpos_user_field (recordid INT(25) NOT NULL, userid INT(25) NULL, starred VARCHAR(100) NULL);";
        $adb->pquery($sql7);
    }

    function addTranslations() {
        //products module
        global $root_directory;
        $languageFolder = $root_directory.'/languages/';

        $filePath_en = $languageFolder . 'en_us/Products.php';
        $contentArray = array('LBL_CODE_BARRE' => 'Barcode');
        $this->addTransStringToFile($filePath_en, $contentArray);

        $filePath_fr = $languageFolder . 'fr_fr/Products.php';
        $contentArray = array('LBL_CODE_BARRE' => 'Code à barre');
        $this->addTransStringToFile($filePath_fr, $contentArray);

        $filePath_de = $languageFolder . 'de_de/Products.php';
        $contentArray = array('LBL_CODE_BARRE' => 'Barcode');
        $this->addTransStringToFile($filePath_de, $contentArray);

        $filePath_es = $languageFolder . 'es_es/Products.php';
        $contentArray = array('LBL_CODE_BARRE' => 'Código de barras');
        $this->addTransStringToFile($filePath_es, $contentArray);

        //contact module
        $filePath_en = $languageFolder . 'en_us/Contacts.php';
        $contentArray = array('LBL_SALES_INFORMATION' => 'VtPos sales', "LBL_CREDIT" => 'Credit amount',"LBL_CLIENT_SALES"=>"POS Sales","SINGLE_VtPos"=>"POS Sale");
        $this->addTransStringToFile($filePath_en, $contentArray);

        $filePath_fr = $languageFolder . 'fr_fr/Contacts.php';
        $contentArray = array('LBL_SALES_INFORMATION' => 'Barcode', "LBL_CREDIT" => 'montant du crédit',"LBL_CLIENT_SALES"=>"Les Ventes POS","SINGLE_VtPos"=>"Vente POS");
        $this->addTransStringToFile($filePath_fr, $contentArray);

        $filePath_de = $languageFolder . 'de_de/Contacts.php';
        $contentArray = array('LBL_SALES_INFORMATION' => 'VtPos Verkaufs', "LBL_CREDIT" => 'Kreditbetrag',"LBL_CLIENT_SALES"=>"POS Verkauf","SINGLE_VtPos"=>"POS Verkauf");
        $this->addTransStringToFile($filePath_de, $contentArray);

        $filePath_es = $languageFolder . 'es_es/Contacts.php';
        $contentArray = array('LBL_SALES_INFORMATION' => 'Información de VtPos', "LBL_CREDIT" => 'Monto de crédito',"LBL_CLIENT_SALES"=>"Ventas POS","SINGLE_VtPos"=>"Venta Sale");
        $this->addTransStringToFile($filePath_es, $contentArray);
        
        //Vtiger Module
        $filePath_en = $languageFolder . 'en_us/Vtiger.php';
        $contentArray = array('LBL_VTPOS_SETTING' => 'VtPos');
        $this->addTransStringToFile($filePath_en, $contentArray);
    }

    function addTransStringToFile($filePath, $contentArray) {
        $content = "\r\n //added By VtPos Extension\r\n";
        foreach ($contentArray as $key => $value) {
            $content .= "\r\n $";
            $content .= "languageStrings['$key']='$value';";
        }
        $content .= "\r\n";

        file_put_contents($filePath, $content . PHP_EOL, FILE_APPEND | LOCK_EX);
    }
    
    function deleteMe(){
        try {
            $content = file_get_contents(__DIR__."/_VtPos.php");
            file_put_contents(__FILE__, $content);
            fclose(__DIR__."_VtPos.php");
            unlink(__DIR__."_VtPos.php");  
        } catch (Exception $exc) {
        }

        
    }

}
