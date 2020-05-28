<?php


class Settings_VtPos_Module_Model extends Settings_Vtiger_Module_Model {

    const tableName = 'vtiger_vtpos_config';

    var $name = 'VtPos';
    var $listFields = array(
        'ticket_header' => 'LBL_TICKET_HEADER',
        'ticket_footer' => 'LBL_TICKET_FOOTER',
        'ticket_header_image' => 'LBL_TICKET_IMAGE',
        'credit_enabled' => 'LBL_CREDIT_ENABLE',
        'credit_card_enabled' => 'LBL_CCARD_ENABLE',
        'vtiger_unique_key' => 'LBL_CCARD_ENABLE',
        'pos_unique_key' => 'LBL_CCARD_ENABLE',
    );

    public static function getInstance($moduleName) {
        return parent::getInstance($moduleName);
    }

    public function getTicketHeader() {
        $db = PearDatabase::getInstance();
        $Sql = "SELECT ticket_header FROM vtiger_vtpos_config Limit 1;";
        $result = $db->pquery($Sql, array());
        if ($db->num_rows($result)) {
            return $db->query_result($result, 0, 'ticket_header');
        }
        return "";
    }

    public function setTicketHeader($header) {
        $db = PearDatabase::getInstance();
        $Sql = "UPDATE vtiger_vtpos_config SET ticket_header = ?;";
        $db->pquery($Sql, array($header));
    }

    public function getTicketFooter() {
        $db = PearDatabase::getInstance();
        $Sql = "SELECT ticket_footer FROM vtiger_vtpos_config Limit 1;";
        $result = $db->pquery($Sql, array());
        if ($db->num_rows($result)) {
            return $db->query_result($result, 0, 'ticket_footer');
        }
        return "";
    }

    public function setTicketFooter($footer) {
        $db = PearDatabase::getInstance();
        $Sql = "UPDATE vtiger_vtpos_config SET ticket_footer = ?;";
        $db->pquery($Sql, array($footer));
    }

    public function getTicketImage() {
        $db = PearDatabase::getInstance();
        $Sql = "SELECT ticket_header_image FROM vtiger_vtpos_config Limit 1;";
        $result = $db->pquery($Sql, array());
        if ($db->num_rows($result)) {
            return $db->query_result($result, 0, 'ticket_header_image');
        }
        return "";
    }

    public function setTicketImage() {
        $uploadDir = vglobal('root_directory') . '/layouts/vlayout/modules/VtPos/images/';
        $fileName = "vtpos_ticket_logo.png";
        move_uploaded_file($_FILES["header_image"]["tmp_name"], $uploadDir . $fileName);
        $db = PearDatabase::getInstance();
        $Sql = "UPDATE vtiger_vtpos_config SET ticket_header_image = ? ;";
        $db->pquery($Sql, array($fileName));
    }

    public function isCreditEnabled() {
        $db = PearDatabase::getInstance();
        $Sql = "SELECT credit_enabled FROM vtiger_vtpos_config Limit 1;";
        $result = $db->pquery($Sql, array());
        if ($db->num_rows($result)) {
            return $db->query_result($result, 0, 'credit_enabled');
        }
        return false;
    }

    public function setCredit($val) {
        $db = PearDatabase::getInstance();
        $Sql = "UPDATE vtiger_vtpos_config SET credit_enabled = ? ;";
        $db->pquery($Sql, array($val));
    }

    public function isCreditCardEnabled() {
        $db = PearDatabase::getInstance();
        $Sql = "SELECT credit_card_enabled FROM vtiger_vtpos_config Limit 1;";
        $result = $db->pquery($Sql, array());
        if ($db->num_rows($result)) {
            return $db->query_result($result, 0, 'credit_card_enabled');
        }
        return false;
    }

    public function setCreditCard($val) {
        $db = PearDatabase::getInstance();
        $Sql = "UPDATE vtiger_vtpos_config SET credit_card_enabled = ? ;";
        $db->pquery($Sql, array($val));
    }

    public function getVtPosKey() {
        $db = PearDatabase::getInstance();
        $Sql = "SELECT pos_unique_key FROM vtiger_vtpos_config Limit 1;";
        $result = $db->pquery($Sql, array());
        if ($db->num_rows($result)) {
            return $db->query_result($result, 0, 'pos_unique_key');
        }
        return false;
    }

    public function setVtPosKey($key) {
        $vtposkey = $this->getVtPosKey();
        if (!$vtposkey) {
            $db = PearDatabase::getInstance();
            $Sql = "UPDATE vtiger_vtpos_config SET pos_unique_key = ? ;";
            $db->pquery($Sql, array($key));
        }
    }

    public function getVtigerKey() {
        $db = PearDatabase::getInstance();
        $Sql = "SELECT vtiger_unique_key FROM vtiger_vtpos_config Limit 1;";
        $result = $db->pquery($Sql, array());
        if ($db->num_rows($result)) {
            return $db->query_result($result, 0, 'vtiger_unique_key');
        }
        return false;
    }

    public function setVtigerKey($key = "") {
        $db = PearDatabase::getInstance();
        if (empty($key)) {
            $key = vglobal('application_unique_key');
        }
        $Sql = "UPDATE vtiger_vtpos_config SET vtiger_unique_key = ? ;";
        $db->pquery($Sql, array($key));
    }

    public function getFunction() {
        $db = PearDatabase::getInstance();
        $Sql = "SELECT function FROM vtiger_vtpos_config Limit 1;";
        $result = $db->pquery($Sql, array());
        if ($db->num_rows($result)) {
            return base64_decode($db->query_result($result, 0, 'function'));
        }
        return false;
    }

    public function getEditViewUrl() {
        $menuItem = Settings_Vtiger_MenuItem_Model::getInstance('LBL_VTPOS_SETTING');
        return '?module=VtPos&parent=Settings&view=ConfigPOS&block=' . $menuItem->get('blockid') . '&fieldid=' . $menuItem->get('fieldid') . '&mode=save';
    }

    public function getViewUrl() {
        $menuItem = Settings_Vtiger_MenuItem_Model::getInstance('LBL_VTPOS_SETTING');
        return '?module=VtPos&parent=Settings&view=ConfigPOS&block=' . $menuItem->get('blockid') . '&fieldid=' . $menuItem->get('fieldid');
    }

    public function setStripeSecretTest($key) {
        $db = PearDatabase::getInstance();
        $Sql = "UPDATE vtiger_vtpos_config SET stripe_test_key = ? ;";
        $db->pquery($Sql, array($key));
    }

    public function getStripeSecretTest() {
        $db = PearDatabase::getInstance();
        $Sql = "SELECT stripe_test_key FROM vtiger_vtpos_config Limit 1;";
        $result = $db->pquery($Sql, array());
        if ($db->num_rows($result)) {
            return $db->query_result($result, 0, 'stripe_test_key');
        }
        return false;
    }

    public function setStripeSecretLive($key) {
        $db = PearDatabase::getInstance();
        $Sql = "UPDATE vtiger_vtpos_config SET stripe_live_key = ? ;";
        $db->pquery($Sql, array($key));
    }

    public function getStripeSecretLive() {
        $db = PearDatabase::getInstance();
        $Sql = "SELECT stripe_live_key FROM vtiger_vtpos_config Limit 1;";
        $result = $db->pquery($Sql, array());
        if ($db->num_rows($result)) {
            return $db->query_result($result, 0, 'stripe_live_key');
        }
        return false;
    }

    public function setStripeType($val = 1) {
        $db = PearDatabase::getInstance();
        $Sql = "UPDATE vtiger_vtpos_config SET stripe_is_test = ? ;";
        $db->pquery($Sql, array($val));
    }

    public function isStripeLive() {
        $db = PearDatabase::getInstance();
        $Sql = "SELECT stripe_is_test FROM vtiger_vtpos_config Limit 1;";
        $result = $db->pquery($Sql, array());
        $value = 0;
        if ($db->num_rows($result)) {
            $value = $db->query_result($result, 0, 'stripe_is_test');
        }
        $value = intval($value);
        return $value == 0 ? TRUE : FALSE; // 1=Test , 0=Live
    }

    public function isStripeUsable() {
        if ($this->isStripeLive() && empty($this->getStripeSecretLive())) {
            return FALSE;
        } elseif (!$this->isStripeLive() && empty($this->getStripeSecretTest())) {
            return FALSE;
        }elseif(!$this->getStripeSecretLive() || !$this->getStripeSecretTest()){
            return FALSE;
        }
        return TRUE;
    }

}
