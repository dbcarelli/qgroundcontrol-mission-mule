/****************************************************************************
 *
 *   (c) 2009-2016 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQuick              2.3
import QtQuick.Controls     1.2
import QtQuick.Dialogs      1.2
import QtQuick.Layouts      1.2

import QGroundControl               1.0
import QGroundControl.Palette       1.0
import QGroundControl.Controls      1.0
import QGroundControl.Controllers   1.0
import QGroundControl.ScreenTools   1.0

AnalyzePage {
    id:                 dataStationPage
    pageComponent:      pageComponent
    pageName:           qsTr("Data Station Page")
    pageDescription:    qsTr("Use this page to manage data stations and select them for missions")

    property real _margin:          ScreenTools.defaultFontPixelWidth
    property real _butttonWidth:    ScreenTools.defaultFontPixelWidth * 10

    QGCPalette { id: palette; colorGroupEnabled: enabled }

    Component {
        id: pageComponent

        RowLayout {
            width:  availableWidth
            height: availableHeight

            Connections {
                target: QGroundControl.dataStationManager//.dataStations
                onTestPassed : testPassedDialog.open()
                onTestFailed : testFailedDialog.open()
            }

            Dialog {
                id: testPassedDialog
                visible: false
                standardButtons: StandardButton.Ok
                onAccepted: testPassedDialog.close()
                ColumnLayout {
                    id: columnTP
                    width: parent ? parent.width : 100
                    Label {
                        text: "Test Passed"
                        Layout.columnSpan: 2
                        Layout.fillWidth: true
                        wrapMode: Text.WordWrap
                    }
                }
            }
            Dialog {
                id: testFailedDialog
                visible: false
                standardButtons: StandardButton.Ok
                onAccepted: testFailedDialog.close()
                ColumnLayout {
                    id: columnTF
                    width: parent ? parent.width : 100
                    Label {
                        text: "Test Failed"
                        Layout.columnSpan: 2
                        Layout.fillWidth: true
                        wrapMode: Text.WordWrap
                    }
                }
            }

            TableView {
                id: tableView
                anchors.top:        parent.top
                anchors.bottom:     parent.bottom

                model:              QGroundControl.dataStationManager.dataStations
                selectionMode:      SelectionMode.SingleSelection
                Layout.fillWidth:   true
                onActivated: QGroundControl.dataStationManager.toggleActive(tableView.currentRow)

                TableViewColumn {
                    title: qsTr("ID")
                    width: ScreenTools.defaultFontPixelWidth * 6
                    horizontalAlignment: Text.AlignHCenter
                    delegate : Text  {
                        horizontalAlignment: Text.AlignHCenter
                        text: {
                            var o = QGroundControl.dataStationManager.dataStations[styleData.row]
                            return o ? o.id : ""

                        }
                    }
                }
                TableViewColumn {
                    title: qsTr("Latitude")
                    width: ScreenTools.defaultFontPixelWidth * 18
                    horizontalAlignment: Text.AlignHCenter
                    delegate : Text  {
                        text: QGroundControl.dataStationManager.dataStations[styleData.row].lat;
                    }
                }
                TableViewColumn {
                    title: qsTr("Longitude")
                    width: ScreenTools.defaultFontPixelWidth * 18
                    horizontalAlignment: Text.AlignHCenter
                    delegate : Text  {
                        text: {
                            var o = QGroundControl.dataStationManager.dataStations[styleData.row]
                            return o ? o.lon : ""
                        }
                    }
                }


                TableViewColumn {
                    title: qsTr("Active")
                    width: ScreenTools.defaultFontPixelWidth * 6
                    horizontalAlignment: Text.AlignHCenter
                    delegate : Text  {
                        horizontalAlignment: Text.AlignHCenter
                        text: {
                            return QGroundControl.dataStationManager.dataStations[styleData.row].active;
                        }
                    }
                }
            }

            Column {
                spacing:            _margin
                Layout.alignment:   Qt.AlignTop | Qt.AlignLeft

                QGCButton {
                    enabled:    tableView.currentRow>=0 && tableView.currentRow < QGroundControl.dataStationManager.dataStations.length
                    text:       qsTr("Toggle")
                    width:      _butttonWidth

                    onClicked: {
                         QGroundControl.dataStationManager.toggleActive(tableView.currentRow)
                    }
                }
                QGCButton {
                    enabled:    true
                    text:       qsTr("Deploy DS")
                    width:      _butttonWidth

                    onClicked: {
                        deployDialog.open()
                    }
                    Dialog {
                        id: deployDialog
                        visible: false
                        standardButtons: StandardButton.Ok | StandardButton.Cancel
                        onAccepted: QGroundControl.dataStationManager.deployDS(answerDep.text, testStatus.checked)
                        ColumnLayout {
                            id: columnDep
                            width: parent ? parent.width : 100
                            Label {
                                text: "Enter the ID of the Data Station to be deployed."
                                Layout.columnSpan: 2
                                Layout.fillWidth: true
                                wrapMode: Text.WordWrap
                            }
                            RowLayout {
                                Layout.alignment: Qt.AlignHCenter
                                Label {
                                    text: "ID"
                                    Layout.alignment: Qt.AlignBaseline | Qt.AlignLeft
                                }
                                TextField {
                                    id: answerDep
                                }
                                CheckBox {
                                    id: testStatus
                                    text: "Is this a test?"
                                    checked: false
                                }
                            }
                        }
                    }
                }
                QGCButton {
                    enabled:    true
                    text:       qsTr("Initialize DS")
                    width:      _butttonWidth
                    onClicked: {
                        initDialog.open()
                    }
                    Dialog {
                        id: initDialog
                        visible: false
                        standardButtons: StandardButton.Ok | StandardButton.Cancel
                        onAccepted: {QGroundControl.dataStationManager.initializeDS(answerInit.text)}
                        ColumnLayout {
                            id: columnInit
                            width: parent ? parent.width : 100
                            Label {
                                text: "Enter the ID of the Data Station to be initialized."
                                Layout.columnSpan: 2
                                Layout.fillWidth: true
                                wrapMode: Text.WordWrap
                            }
                            RowLayout {
                                Layout.alignment: Qt.AlignHCenter
                                Label {
                                    text: "ID"
                                    Layout.alignment: Qt.AlignBaseline | Qt.AlignLeft
                                }
                                TextField {
                                    id: answerInit
                                    //onEditingFinished: initDialog.click(StandardButton.Ok)
                                }
                            }
                        }
                    }
                }
                QGCButton {
                    enabled:    tableView.currentRow>=0
                    text:       qsTr("Delete DS")
                    width:      _butttonWidth

                    onClicked: {
                        deleteDialog.open()
                    }
                    Dialog {
                        id: deleteDialog
                        visible: false
                        standardButtons: StandardButton.Ok | StandardButton.Cancel
                        onAccepted: {QGroundControl.dataStationManager.deleteStation(tableView.currentRow)
                                    deleteDialog.close()}
                        onRejected: deleteDialog.close()
                        ColumnLayout {
                            id: columnDel
                            width: parent ? parent.width : 100
                            Label {
                                text: "Are you sure you want to delete Data Station "+QGroundControl.dataStationManager.dataStations[tableView.currentRow].id+"?"
                                Layout.columnSpan: 2
                                Layout.fillWidth: true
                                wrapMode: Text.WordWrap
                            }
                        }
                    }
                }
                QGCButton {
                    enabled:    true
                    text:       qsTr("Load File")
                    width:      _butttonWidth

                    onClicked: {
                        loadDialog.open()
                    }
                    Dialog {
                        id: loadDialog
                        visible: false
                        standardButtons: StandardButton.Ok | StandardButton.Cancel
                        onAccepted: {QGroundControl.dataStationManager.loadFromFile("/QGroundControl/datastations.json")
                                    loadDialog.close()}
                        onRejected: loadDialog.close()
                        ColumnLayout {
                            id: columnLoad
                            width: parent ? parent.width : 100
                            Label {
                                text: "Are you sure you want to load from file? This will delete any changes."
                                Layout.columnSpan: 2
                                Layout.fillWidth: true
                                wrapMode: Text.WordWrap
                            }
                        }
                    }
                }
                QGCButton {
                    enabled:    true
                    text:       qsTr("Save File")
                    width:      _butttonWidth

                    onClicked: {
                        saveDialog.open()
                    }
                    Dialog {
                        id: saveDialog
                        visible: false
                        standardButtons: StandardButton.Ok | StandardButton.Cancel
                        onAccepted: {QGroundControl.dataStationManager.saveToFile("/QGroundControl/datastations.json")
                                    saveDialog.close()}
                        onRejected: saveDialog.close()
                        ColumnLayout {
                            id: columnSave
                            width: parent ? parent.width : 100
                            Label {
                                text: "Are you sure you want to save to file? This will overwrite the file."
                                Layout.columnSpan: 2
                                Layout.fillWidth: true
                                wrapMode: Text.WordWrap
                            }
                        }
                    }
                }
                QGCButton {
                    enabled:    true
                    text:       qsTr("Turn On DS")
                    width:      _butttonWidth

                    onClicked: {
                        turnOnDialog.open()
                    }
                    Dialog {
                        id: turnOnDialog
                        visible: false
                        standardButtons: StandardButton.Ok | StandardButton.Cancel
                        onAccepted: {QGroundControl.dataStationManager.turnOnDS(answerTurnOn.text)}
                        ColumnLayout {
                            id: columnTurnOn
                            width: parent ? parent.width : 100
                            Label {
                                text: "Enter the ID of the Data Station to be turned on."
                                Layout.columnSpan: 2
                                Layout.fillWidth: true
                                wrapMode: Text.WordWrap
                            }
                            RowLayout {
                                Layout.alignment: Qt.AlignHCenter
                                Label {
                                    text: "ID"
                                    Layout.alignment: Qt.AlignBaseline | Qt.AlignLeft
                                }
                                TextField {
                                    id: answerTurnOn
                                    //onEditingFinished: initDialog.click(StandardButton.Ok)
                                }
                            }
                        }
                    }
                }
            } // Column - Buttons
        } // RowLayout
    } // Component
} // AnalyzePage
