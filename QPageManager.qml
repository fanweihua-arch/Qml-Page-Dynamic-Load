import QtQuick 2.5
import VBasicControls 1.0

Item {
    id: root
    width: VGlobalVariable.windowWidth
    height: VGlobalVariable.windowHeight

    // 应用程序注册表
    property var table: {"": {"layer": "", "source": ""}}

    // 启动一个应用程序
    function launch(name, params) {
        var info = table[name]
        if (info === undefined)
            return

        var item = layer(info["layer"])
        if (item === undefined)
            return

        item.source = info["source"]
        item.content.args = params

//        root.childAt(0, 0).refresh()
        refreshChild();

    }

//    刷新焦点所在位置
    function refreshChild() {
        var childList = root.children;

        for ( var count = ( childList.length - 1 ); count >= 0; count-- )
        {
            if ( childList[count].visible && childList[count].source !== "" )
            {
                if ( childList[count].refresh() )
                {
                    //print( "focus name: ", count, childList[count]["name"] )
                    return;
                }
                continue;
            }
        }
        //print( "default name: ", childList[0]["name"] )
        childList[0].refresh();
    }

    // 停止一个应用程序
    function stop(name) {
        var info = table[name]
        if (info === undefined)
            return

        var item = layer(info["layer"])
        if (item === undefined)
            return

        item.source = ""

//        root.childAt(0, 0).refresh()
        refreshChild()
    }

    // 返回Home界面
    function home() {
        for (var i = 0; i < children.length; i++)
            if ((children[i].name !== "homeRootLayer") && (children[i].name !== "menuManagerLayer"))
                children[i].source = ""
//        root.childAt(0, 0).refresh()
        refreshChild();
    }

    // 向顶层应用发送一个消息, 如果顶层应用不需要响应消息，则依次向下发
    function message(params) {
        var childList = root.children;

        for ( var count = ( childList.length - 1 ); count > 0; count-- )
        {
            if ( childList[count].visible && childList[count].source !== "" )
            {
                if ( childList[count].message(params) )
                {
                    return;
                }
                continue;
            }
        }
    }

    // 查询一个应用程序属于哪个图层
    function layer(name) {
        for (var i = 0; i < children.length; i++)
            if (children[i].name === name)
                return children[i]
    }

    // 清空一个图层
    function clear(layer) {
        layer.source = ""
//        root.childAt(0, 0).refresh()
        refreshChild();
    }
}
