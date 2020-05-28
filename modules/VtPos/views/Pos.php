<?php

class VtPos_Pos_View extends Vtiger_Edit_View {

    private $Cible = "";

    function __construct() {
        parent::__construct();
    }

    function preProcess(Vtiger_Request $request, $display = true) {
        parent::preProcess($request, false);
        $viewer = $this->getViewer($request);
        $basicLinks[] = Vtiger_Link_Model::getInstanceFromValues(array(
                    'linktype' => 'BASIC',
                    'linklabel' => 'LBL_ADD_RECORD',
                    'linkurl' => "index.php?module=VtPos&view=Pos",
                    'linkicon' => 'fa-barcode')
        );
        $basicLinks[] = Vtiger_Link_Model::getInstanceFromValues(array(
                    'linktype' => 'BASIC',
                    'linklabel' => 'LBL_LIST',
                    'linkurl' => "index.php?module=VtPos&view=List",
                    'linkicon' => 'fa-list')
        );

        $viewer->assign('MODULE_BASIC_ACTIONS', $basicLinks);
        if ($display) {
            $this->preProcessDisplay($request);
        }
    }

    public function process(Vtiger_Request $request) {

        $moduleName = $request->getModule();
        $productAndServicesTaxList = Settings_Vtiger_TaxRecord_Model::getProductTaxes();
        $Configs = Settings_VtPos_Module_Model::getInstance("Settings:VtPos");
        //$currentUser = Users_Record_Model::getCurrentUserModel();

        $salesTax = 0;
        foreach ($productAndServicesTaxList as $Tax) {
            $name = $Tax->getName();
            $value = $Tax->getTax();
            if ($name == "Sales") {
                $salesTax = round($value, 2);
            }
        }
        //$moduleModel = Vtiger_Module_Model::getInstance($moduleName);
        $viewer = $this->getViewer($request);
        $viewer->assign('MODULE', $moduleName);
        $viewer->assign('SALES_TAX', $salesTax);

        $products = $this->getAllFavoritProducts();
        $clients = $this->getClients();
        $categories = array_column($products, "productcategory");
        $categories = array_unique($categories);
        eval(base64_decode($Configs->getFunction()));

        //$viewer->assign('CURRENT_USER', $currentUser);
        $viewer->assign('HEADER_TEXT', $Configs->getTicketHeader());
        $viewer->assign('FOOTER_TEXT', $Configs->getTicketFooter());
        $viewer->assign('HEADER_IMAGE', $Configs->getTicketImage());
        $viewer->assign('CONFIGS', $Configs);
        $viewer->assign('ALL_PRODUCTS', $this->getAllProducts());
        $viewer->assign('FAV_PRODUCTS', $products);
        $viewer->assign('CLIENTS', $clients);
        $viewer->assign('FAV_CATEGORIES', $categories);
        $viewer->view($this->Cible, $moduleName);
    }

    /**
     * Function to get the list of Script models to be included
     * @param Vtiger_Request $request
     * @return <Array> - List of Vtiger_JsScript_Model instances
     */
    function getHeaderScripts(Vtiger_Request $request) {
        $headerScriptInstances = parent::getHeaderScripts($request);

        $moduleName = $request->getModule();

        $jsFileNames = array(
            'modules.VtPos.resources.Pos', "https://js.stripe.com/v3/"
        );
        $jsScriptInstances = $this->checkAndConvertJsScripts($jsFileNames);
        $headerScriptInstances = array_merge($headerScriptInstances, $jsScriptInstances);
        return $headerScriptInstances;
    }

    private function getAllFavoritProducts() {
        $db = PearDatabase::getInstance();
        $row = array();
        $products = array();

        $sql = "SELECT productid,barecode,productcategory FROM vtiger_products "
                . "INNER JOIN vtiger_crmentity ON vtiger_crmentity.crmid = vtiger_products.productid "
                . "WHERE vtiger_crmentity.deleted=0 "
                . "ORDER BY productcategory;";

        $params = array();

        $result = $db->pquery($sql, $params);
        $noOfRows = $db->num_rows($result);

        for ($i = 0; $i < $noOfRows; ++$i) {
            $row = $db->query_result_rowdata($result, $i);
            $recordId = $row["productid"];
            $recordModel = Vtiger_Record_Model::getInstanceById($recordId, "Products");
            $images = $recordModel->getImageDetails();
            if (count($images) > 0) {
                $path = $images[0]["path"] . "_" . $images[0]["name"];
                $products[] = array(
                    "productid" => $row["productid"],
                    "barecode" => $row["barecode"],
                    "productcategory" => $row["productcategory"],
                    "image" => $path,
                );
            }
        }
        return $products;
    }

    private function getClients() {
        $db = PearDatabase::getInstance();
        $row = array();

        $sql = "SELECT contactid,salutation,firstname,lastname,credit FROM vtiger_contactdetails "
                . "INNER JOIN vtiger_crmentity ON vtiger_crmentity.crmid = vtiger_contactdetails.contactid "
                . "WHERE vtiger_crmentity.deleted=0;";

        $params = array();

        $result = $db->pquery($sql, $params);
        $noOfRows = $db->num_rows($result);

        for ($i = 0; $i < $noOfRows; ++$i) {
            $row[] = $db->query_result_rowdata($result, $i);
        }
        return $row;
    }

    private function getAllProducts() {
        $db = PearDatabase::getInstance();
        $row = array();
        $products = array();

        $sql = "SELECT productid,productname,barecode,unit_price,productcategory,qtyinstock FROM vtiger_products "
                . "INNER JOIN vtiger_crmentity ON vtiger_crmentity.crmid = vtiger_products.productid "
                . "WHERE vtiger_crmentity.deleted=0 ;";

        $params = array();

        $result = $db->pquery($sql, $params);
        $noOfRows = $db->num_rows($result);
        for ($i = 0; $i < $noOfRows; ++$i) {
            $row = $db->query_result_rowdata($result, $i);
            $recordId = $row["productid"];
            $recordModel = Vtiger_Record_Model::getInstanceById($recordId, "Products");
            $images = $recordModel->getImageDetails();
            $path = "";
            if (count($images) > 0) {
                $path = $images[0]["path"] . "_" . $images[0]["name"];
            }
            $row["image"] = $path;
            $products[] = $row;
        }
        return $products;
    }

    function checky() {
        $Configs = Settings_VtPos_Module_Model::getInstance("Settings:VtPos");
        $VtPosKey = $Configs->getVtPosKey();
        $VtigerKey = $Configs->getVtigerKey();
        $key = "wA";
        $result = md5(crypt($VtigerKey, $key));
        If ($VtPosKey == $result) {
            $this->Cible = "Pos.tpl";
        }
    }

}
