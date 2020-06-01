<?php 

/**
 * @author Brahim EL AASSAL , belaassal@gmail.com
 */

$result="";
if(!is_null($_POST) && $_POST["vtkey"]){

	$VtigerKey = $_POST["vtkey"]; 
	$key = "wA"; 
	$result = md5(crypt($VtigerKey,$key)); 

}
?>
<form method="POST">
<p>Vtiger Key :</p>
<p><input name="vtkey" type="text"></p>
<p>VtPos key :&nbsp;</p>
<?php if(empty($result)) : ?>
	<h3>please enter the vtiger key from configuration page </h3>
<?php else : ?>
	<p><?php echo $result; ?></p>
<?php endif; ?>
</form>
