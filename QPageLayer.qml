import QtQuick 2.5

Item {
    id: root
    anchors.fill: parent
    visible: loader.status === Loader.Ready

    property string name
    property string source
    property alias content: loader.item

    function message(params) {
        if (loader.item)
        {
            if ( loader.item.needAcceptMessage )
            {
                loader.item.message(params)
                return true;
            }
            return false;
        }
        return false;
    }

    function refresh() {
        if (loader.item)
        {
            if ( loader.item.focusList.length > 0 )
            {
                loader.item.focusCurrentItem()
                return true;
            }
            return false;
        }
        return false;
    }

    Loader {
        id: loader
        anchors.fill: parent
        source: root.source
    }

    Connections {
        target: loader.item
        onLoad: root.parent.launch(name, params)
        onQuit: root.parent.clear(root)
        onHome: root.parent.home()
    }
}
