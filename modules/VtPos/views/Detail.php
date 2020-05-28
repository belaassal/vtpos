<?php

class VtPos_Detail_View extends Vtiger_Detail_View {

    function __construct() {
        parent::__construct();
    }

    function process(Vtiger_Request $request) {
        $recordId = $request->get('record');
        $moduleName = $request->getModule();
        $viewer = $this->getViewer($request);
        $products = $this->getSaleProducts($recordId);
        $Model = Vtiger_Record_Model::getInstanceById($recordId, $moduleName);
        
        $currentUserModel = Users_Record_Model::getCurrentUserModel();
        $precision = $currentUserModel->get('no_of_currency_decimals');
        
        $prix_ht = $Model->get("prix_ht");
        $prix_ht = round($prix_ht, $precision);
        $prix_ttc = $Model->get('prix_ttc');
        $prix_ttc = round($prix_ttc, $precision);
        
        $viewer->assign('SUB_TOTAL', $prix_ht);
        $viewer->assign('DISCOUNT', $Model->get('remise_price'));
        $viewer->assign('TAX', $Model->get('tax'));
        $viewer->assign('TOTAL', $prix_ttc);
        $viewer->assign('TENDERED', $Model->get('money_get'));
        $viewer->assign('CHANGE', $Model->get('money_back'));
        $viewer->assign('PRODUCTS', $products);
        parent::process($request);
    }

    function getSaleProducts($SaleId) {
        $db = PearDatabase::getInstance();
        $currentUserModel = Users_Record_Model::getCurrentUserModel();
        $precision = $currentUserModel->get('no_of_currency_decimals');
        
        $sql = "SELECT * FROM vtiger_sales_detail "
                . "INNER JOIN vtiger_products ON vtiger_sales_detail.productid=vtiger_products.productid "
                . "INNER JOIN vtiger_crmentity ON vtiger_crmentity.crmid = vtiger_products.productid "
                . "WHERE vtiger_crmentity.deleted=0 "
                . "AND salesid=?; ";
        $result = $db->pquery($sql, array($SaleId));
        $noOfRows = $db->num_rows($result);
        $row = array();
        for ($i = 0; $i < $noOfRows; ++$i) {
            $detail = $db->query_result_rowdata($result, $i);
            $detail["quantity"] = round($detail["quantity"], $precision);
            $row[] = $detail;
        }
        return $row;
    }

}
