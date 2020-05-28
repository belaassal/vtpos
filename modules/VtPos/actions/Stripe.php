<?php

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

class VtPos_Stripe_Action extends Vtiger_SaveAjax_Action {

    public function process(Vtiger_Request $request) {
        $response = new Vtiger_Response();

        //$track = "%25B4242424242424242%5ETESTLAST%2FTESTFIRST%5E1805201425400714000000%3F%3B4242424242424242%3D180520142547140130%3F";
        $url = "https://api.stripe.com/v1/charges";

        $track = $request->get("track");
        $RealAmount = $request->get("amount");
        $currentUser = Users_Record_Model::getCurrentUserModel();
        $currency = strtoupper($currentUser->get('currency_code'));
        $amount = $this->convertToStripeAmount($RealAmount, $currency);
        $apiKey = $this->getStripeSecretKey();

        $description = "description=Swiped card using VtPOS";

        $fields = "card[swipe_data]=$track&amount=$amount&currency=$currency&description=$description";

        try {
            $ch = curl_init();
            curl_setopt($ch, CURLOPT_URL, $url);
            curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
            curl_setopt($ch, CURLOPT_POST, 1);
            curl_setopt($ch, CURLOPT_POSTFIELDS, $fields);
            curl_setopt($ch, CURLOPT_USERPWD, $apiKey);
            $result = curl_exec($ch);

            if (curl_errno($ch)) {
                $response->setError("0", json_decode(curl_errno($ch)));
            }
            curl_close($ch);
        } catch (Exception $exc) {
            $response->setError($exc->getCode(), $exc->getMessage());
        }

        $result = array("Response" => json_decode($result));
        $response->setResult($result);
        $response->emit();
    }

    private function convertToStripeAmount($RealAmount, $UserCurrency) {

        $zeroDecimalCurrencies = [ 'BIF', 'DJF', 'JPY', 'KRW', 'PYG', 'VND', 'XAF', 'XPF', 'CLP', 'GNF', 'KMF', 'MGA', 'RWF', 'VUV', 'XOF'];
        if (in_array($UserCurrency, $zeroDecimalCurrencies)) {
            return $RealAmount;
        }
        return intval(floatval($RealAmount) * 100);
    }

    private function getStripeSecretKey() {
        $Configs = Settings_VtPos_Module_Model::getInstance("Settings:VtPos");
        if ($Configs->isStripeLive()) {
            return $Configs->getStripeSecretLive();
        } else {
            return $Configs->getStripeSecretTest();
        }
    }

}
