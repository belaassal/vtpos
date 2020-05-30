<?php

/**
 * @author Brahim EL AASSAL , belaassal@gmail.com
 */

class VtPos_DateTimeAjax_Action extends Vtiger_SaveAjax_Action {
    public function process(Vtiger_Request $request) {
        
        $localUserDateTime = $request->get("time"); //date time in user computer not server time
        
        $date = new DateTime();

        $date->setTimestamp($localUserDateTime);
        $dt = $date->format('Y-m-d H:i:s') . "\n";
        
        $userDateTime = new DateTimeField($dt);
        $current = $userDateTime->getDisplayDateTimeValue();
        
        $result = array("current" => $current);
        
        $response = new Vtiger_Response();
        $response->setResult($result);
        $response->emit();
    }
}