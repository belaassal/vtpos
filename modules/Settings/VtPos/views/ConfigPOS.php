<?php


class Settings_VtPos_ConfigPOS_View extends Settings_Vtiger_Index_View {

    public function process(Vtiger_Request $request) {

        $mode = $request->get("mode");
        $qualifiedName = $request->getModule(false);
        $moduleModel = Settings_VtPos_Module_Model::getInstance("Settings:VtPos");
        if (!empty($mode)) {
            $this->saveInfos($request);
            header("Location: ".$moduleModel->getViewUrl());
        } else {




            $viewer = $this->getViewer($request);

            $viewer->assign('MODEL', $moduleModel);
            $viewer->assign('QUALIFIED_MODULE', $qualifiedName);
            $viewer->assign('CURRENT_USER_MODEL', Users_Record_Model::getCurrentUserModel());
            $viewer->view('ConfigPos.tpl', $qualifiedName);
        }
    }

    private function saveInfos(Vtiger_Request $request) {
        $moduleModel = Settings_VtPos_Module_Model::getInstance("Settings:VtPos");
        $header_image = $request->get("header_image");
        $ticket_header = $request->get("ticket_header");
        $ticket_footer = $request->get("ticket_footer");
        $vtpos_license = $request->get("vtpos_license_key");
        $enable_credit = ($request->get("enable_credit") == "on") ? 1 : 0;
        $enable_credit_card = ($request->get("enable_credit_card") == "on") ? 1 : 0;
        $StripeType = $request->get("is_test_stripe") ;
        $StripeSecretLive = $request->get("stripe_live") ;
        $StripeSecretTest = $request->get("stripe_test") ;
        
        
        $moduleModel->setTicketImage();
        $moduleModel->setTicketHeader($ticket_header);
        $moduleModel->setTicketFooter($ticket_footer);
        $moduleModel->setCredit($enable_credit);
        $moduleModel->setCreditCard($enable_credit_card);
        $moduleModel->setVtPosKey($vtpos_license);
        $moduleModel->setStripeType($StripeType);
        $moduleModel->setStripeSecretLive($StripeSecretLive);
        $moduleModel->setStripeSecretTest($StripeSecretTest);
    }

}
