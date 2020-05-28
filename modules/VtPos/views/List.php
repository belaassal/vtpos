<?php

class VtPos_List_View extends Vtiger_List_View {

    function preProcess(Vtiger_Request $request, $display = true) {
        parent::preProcess($request, false);
        $viewer = $this->getViewer($request);
        $vars = $viewer->getTemplateVars('MODULE_BASIC_ACTIONS');
        foreach ($vars as $var) {
            if ($var->linklabel == "LBL_ADD_RECORD") {
                $var->linkurl = $this->getCreateRecordUrl();
                $var->linkicon = 'fa-barcode';
            }
        }
        if ($display) {
            $this->preProcessDisplay($request);
        }

    }

    private function getCreateRecordUrl() {
        return 'index.php?module=VtPos&view=Pos';
    }

}
