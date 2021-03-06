import QtQuick 2.6
import QtQuick.Window 2.2
import JsonFlux 1.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1

Window {
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")
    property var myarry: []

    JsonFluxModel{
        id: jsonModel
        source: "demo.json"
        name: "mymodel"
        fileSync: true
    }

    //    JsonFluxView{
    //        id: jsonQuery
    //        query: ["/widget/debug", "/widget/image"]
    //        //model: jsonModel
    //        modelName: "mymodel"
    //        property var myVar
    //        onMyVarChanged: {
    //            console.log("new myVar:", myVar);
    //        }

    //        onValuesChanged: {
    //           // console.log(values["@0"], values["@1"]);
    //            myVar = values["@0"];
    //        }
    //    }

    //    JsonFluxModifier{
    //        id: jsonModifier
    //        //model: jsonModel
    //        modelName: "mymodel"
    //    }

    //    Button{
    //        id: btn
    //        width: 100
    //        height: 50
    //        anchors.centerIn: parent
    //        text: "Click!"

    //        onClicked:{
    //            var obj = {};
    //            obj.a = "jimmy";
    //            obj.b = "lucy";
    //            jsonModifier.modify("/widget/debug", /*false*/["Aa", "Bb", "Cc", "Dd"]/*[false, true, false]*/);
    //            //jsonModifier.modify("/widget/debug", obj);
    //        }
    //    }

    Component.onCompleted: {
        var connector = JsonFlux.getOrCreateConnector("myConnector", jsonModel);
        connector.addConnections( [
                                     {"control": textField0, "type": JsonFluxConnector.TextField, "query": "/widget/jimmy"},
                                     {"control": textField1, "type": JsonFluxConnector.TextField, "query": "/widget/debug/0"},
                                     {"control": textField2, "type": JsonFluxConnector.TextField, "query": "/widget/debug/0"},
                                     {"control": spinBox1, "type": JsonFluxConnector.SpinBox, "query": "/widget/image/hOffset"},
                                     {"control": spinBox2, "type": JsonFluxConnector.SpinBox, "query": "/widget/image/hOffset"},
                                     {"control": switch1, "type": JsonFluxConnector.Switch, "query": "/widget/image/mipmap"},
                                     {"control": switch2, "type": JsonFluxConnector.Switch, "query": "/widget/image/mipmap"}
                                     //
                                 ]);
    }

    TextField{
        id: textField0
        width: 120
        height: 30
        anchors{centerIn: parent; horizontalCenterOffset: -100; verticalCenterOffset: -150}
    }

    TextField{
        id: textField1
        width: 120
        height: 30
        anchors{centerIn: parent; horizontalCenterOffset: -100; verticalCenterOffset: -100}
    }
    TextField{
        id: textField2
        width: 120
        height: 30
        anchors{centerIn: parent; horizontalCenterOffset: 100; verticalCenterOffset: -100}
    }

    SpinBox{
        id: spinBox1
        width: 120
        height: 20
        maximumValue: 10000
        anchors{centerIn: parent; horizontalCenterOffset: -100; verticalCenterOffset: -50}
    }

    SpinBox{
        id: spinBox2
        width: 120
        height: 20
        maximumValue: 10000
        anchors{centerIn: parent; horizontalCenterOffset: 100; verticalCenterOffset: -50}
    }

    Switch{
        id: switch1
        width: 120
        height: 20
        anchors{centerIn: parent; horizontalCenterOffset: -100; verticalCenterOffset: 0}
    }

    Switch{
        id: switch2
        width: 120
        height: 20
        anchors{centerIn: parent; horizontalCenterOffset: 100; verticalCenterOffset: 0}
    }

    ComboBox{
        id: comboBox1
        width: 120
        height: 20
        anchors{centerIn: parent; horizontalCenterOffset: -100; verticalCenterOffset: 50}
        model:["bold", "italic", "normal"]
        Component.onCompleted: {
            var conn = JsonFlux.getOrCreateConnector("myConnector", jsonModel);
            conn.addConnection({"control": comboBox1, "type": JsonFluxConnector.ComboBox, "query": "/widget/text/style"});
        }
    }

    ComboBox{
        id: comboBox2
        width: 120
        height: 20
        anchors{centerIn: parent; horizontalCenterOffset: 100; verticalCenterOffset: 50}
        model:["bold", "italic", "normal"]
        Component.onCompleted: {
            var conn = JsonFlux.getOrCreateConnector("myConnector", jsonModel);
            conn.addConnection({"control": comboBox2, "type": JsonFluxConnector.ComboBox, "query": "/widget/text/style"});
        }

    }

    ComboBox{
        id: comboBox3
        width: 120
        height: 20
        anchors{centerIn: parent; horizontalCenterOffset: -100; verticalCenterOffset: 80}
        model: JsonFlux.getOrCreateListModel("myList1", "/widget/image", [], jsonModel)
        textRole: "$key"
    }

    Button{
        width: 100
        height: 20
        text: "add"
        anchors{centerIn: parent; horizontalCenterOffset: 100; verticalCenterOffset: 80}
        onClicked: {
            var lm = comboBox3.model;
            lm.addElement({"$key": "testKey", "$value": [3, 2, 5]});
        }
    }

    ComboBox{
        id: comboBox4
        width: 120
        height: 20
        anchors{centerIn: parent; horizontalCenterOffset: -100; verticalCenterOffset: 110}
        model: JsonFlux.getOrCreateListModel("myList2", "/widget/testArray", ["xname"], jsonModel)
        textRole: "xname"
    }
    Button{
        width: 100
        height: 20
        text: "add"
        anchors{centerIn: parent; horizontalCenterOffset: 50; verticalCenterOffset: 110}
        onClicked: {
            var lm = comboBox4.model;
            lm.addElement({"xname": "fang", "age": 5});
        }
    }
    Button{
        width: 100
        height: 20
        text: "remove"
        anchors{centerIn: parent; horizontalCenterOffset: 150; verticalCenterOffset: 110}
        onClicked: {
            var lm = comboBox4.model;
            lm.removeElement(comboBox4.currentIndex);
            comboBox4.currentIndex = -1;
            comboBox4.currentIndex = 0;
        }
    }

//    ListView{
//        id: listView1
//        width: 120
//        height: 120
//        anchors{centerIn: parent; horizontalCenterOffset: 100; verticalCenterOffset: 150}
//        model: JsonFlux.getOrCreateListModel("myList", "/widget/testArray", ["xname", "age"], jsonModel)
//        delegate: RowLayout{
//            height: 20
//            Text{
//                text: xname
//            }
//            Text{
//                text: $.dep
//            }
//        }
//    }
}
