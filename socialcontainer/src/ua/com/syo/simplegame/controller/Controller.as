import ua.com.syo.simplegame.model.net.social.VKData;
import ua.com.syo.simplegame.view.UIManager;

public function init():void {
	if (!parameters["api_url"]) {
		parameters["api_url"] = "http://api.vkontakte.ru/api.php";
		parameters["api_id"] = "1846753";
		parameters["viewer_id"] = "74967375";
		parameters["user_id"] = "74967375";
	}
	VKData.init(parameters);
	Security.allowDomain("*");
	Model.instance.init();
	UIManager.instance.init();
	startButton.setFocus();
	
}

