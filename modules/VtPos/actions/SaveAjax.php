<?php

/* +***********************************************************************************
 * The contents of this file are subject to the vtiger CRM Public License Version 1.0
 * ("License"); You may not use this file except in compliance with the License
 * The Original Code is:  vtiger CRM Open Source
 * The Initial Developer of the Original Code is vtiger.
 * Portions created by vtiger are Copyright (C) vtiger.
 * All Rights Reserved.
 * *********************************************************************************** */

class VtPos_SaveAjax_Action extends Vtiger_SaveAjax_Action {

    public function process(Vtiger_Request $request) {
        $user = Users_Record_Model::getCurrentUserModel();
        $request->set("record", "");
        $pay_method = $request->get("pay_method");
        $clientId = $request->get("client");
        $credit = $request->get("prix_ttc");
        if($pay_method == "LBL_CREDIT"){
            $this->updateClientCredit($clientId, $credit);
        }

//        $moduleModel = Settings_Vtiger_CustomRecordNumberingModule_Model::getInstance("Sales");
//        $moduleData = $moduleModel->getModuleCustomNumberingData();
//        $moduleModel->updateRecordsWithSequence();

        $recordModel = $this->saveRecord($request);
        $saleId= $recordModel->getId();
        $items = $request->get("products");
        $this->saveItems($saleId, $items);
    }

    private function saveItems($saleId, $items) {
        global $adb;
        foreach ($items as $item) {
            $productid = $item["productid"];
            $quantity = $item["quantity"];
            $unit_price = $item["unit_price"];
            $total_price = $item["total_price"];
            
            $sql = 'INSERT INTO vtiger_sales_detail VALUES(?,?,?,?,?)';
            $adb->pquery($sql, array($saleId,$productid,$quantity,$unit_price,$total_price));
            
            $this->inventoryUpdate($productid, $quantity);
        }
    }

    private function inventoryUpdate($productid,$quantity) {
        $db = PearDatabase::getInstance();
        $result = $db->pquery("SELECT qtyinstock FROM vtiger_products WHERE productid=?", array($productid));
	$qty = $db->query_result($result,0,"qtyinstock");
        $stock = $qty - $quantity;
        $db->pquery("UPDATE vtiger_products SET qtyinstock=? WHERE productid=?", array($stock, $productid));
    }
    
    private function updateClientCredit($clientId,$credit){
        $ContactModel = Vtiger_Record_Model::getInstanceById($clientId, "Contacts");
        $old_credit = $ContactModel->get("credit");
        $new_credit = $old_credit +  $credit ;
        $ContactModel->set("credit", $new_credit);
        $ContactModel->set('mode', 'edit');
        $ContactModel->save();
        
    }

}
