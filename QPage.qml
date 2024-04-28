import QtQuick 2.3

Item{
	id:root
	anchors.fill:parent
	property var args

	function pageTo(pageName,pageArg){
		load(pageName,pageArg)
	}
	//切换页面
	signal load(string pageName,var pageArg)
	//退出页面
	signal quit()
	//返回home页面
	signal home()
	//发送消息出去
	signal message(var args)

	//记录当前组件
	property Item currentItem
	//记录当前页面组件的焦点列表
	property var focusList:[]
	//记录当前页面是否需要接收外部消息
	property bool needGetMessage:true
	//判断当前页面是否存在焦点
	readonly property bool hasFocus:{
		//如果root节点不可视，或未使能，直接返回false
		if(!root.visible || !root.enabled){
			return false
		}
		var ret = false
		for(var i = 0; i < focusList.length;i++){
			if(focusList[i].visible && focusList[i].enabled){
				ret = true
			}
		}
		return ret
	}
	//处理焦点变化
	onHasFocusChanged:focusCurrentItem()
	//处理当前组件变化
	onCurrentItemChange:focusCurrentItem()
	//上键按下时，切换焦点到上一个Item
	Keys.onUpPressed:focusPrevItem()
	//下键按下时，切换焦点到下一个Item
	Keys.onDownPressed:focusNextItem()


	function focusCurrentItem(){
		//root节点不可视或不使能，直接返回
		if (!root.visible || !root.enabled)
            return false
		//当前项目就是可视项目，直接返回
        if (currentItem && currentItem.visible && currentItem.enabled) {
            currentItem.forceActiveFocus()
            return true
        }
        var i = focusList.indexOf(currentItem)
        var j = 0
        for (j = i + 1; j < focusList.length; j++) {
            if (focusList[j].visible && focusList[j].enabled) {
                currentItem = focusList[j]
                return true
            }
        }
        for (j = i - 1; j >= 0; j--) {
            if (focusList[j].visible && focusList[j].enabled) {
                currentItem = focusList[j]
                return true
            }
        }
        return false
	}
	function focusNextItem() {
        if (!root.visible || !root.enabled)
            return false

        var i = focusList.indexOf(currentItem)
        var j = 0

        for (j = i + 1; j < focusList.length; j++) {
            if (focusList[j].visible && focusList[j].enabled) {
                currentItem = focusList[j]
                return true
            }
        }
        for (j = 0; j < focusList.length; j++) {
            if (focusList[j].visible && focusList[j].enabled) {
                currentItem = focusList[j]
                return true
            }
        }
        return false
    }

    function focusPrevItem() {
        if (!root.visible || !root.enabled)
            return false

        var i = focusList.indexOf(currentItem)
        var j = 0

        for (j = i - 1; j >= 0; j--) {
            if (focusList[j].visible && focusList[j].enabled) {
                currentItem = focusList[j]
                return true
            }
        }
        for (j = focusList.length - 1; j >= 0; j--) {
            if (focusList[j].visible && focusList[j].enabled) {
                currentItem = focusList[j]
                return true
            }
        }
        return false
    }
}