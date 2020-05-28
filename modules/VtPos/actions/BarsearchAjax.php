<?php

class VtPos_BarsearchAjax_Action extends Vtiger_Save_Action {

    public function process(Vtiger_Request $request) {
        $Module = $request->get('module');
        $code = $request->get('code');
        $result = $this->getProductFromBarCode($code);
        $response = new Vtiger_Response();
        $response->setResult($result);
        $response->emit();
    }
    
    private function getProductFromBarCode($code){
        $db = PearDatabase::getInstance();
        $row = array();
        $sql = "SELECT productid,barecode ,productname ,unit_price FROM vtiger_products 
                INNER JOIN vtiger_crmentity ON vtiger_crmentity.crmid = vtiger_products.productid "
                . "where vtiger_crmentity.deleted=0 ";
        $sql .= "and barecode='$code' limit 1";
        
        $params = array();
        
	$result = $db->pquery($sql, $params);
	$noOfRows = $db->num_rows($result);
        $currentUserModel = Users_Record_Model::getCurrentUserModel();
        $noDec = $currentUserModel->get('no_of_currency_decimals');
        $noDec = ($noDec>0) ? $noDec : 0;
        if ($noOfRows > 0) {
            $row = $db->query_result_rowdata($result);
            $uprice = round($row["unit_price"],$noDec) ;
            $row["unit_price"] = $uprice;
        }
        return $row;
	
    }

}
