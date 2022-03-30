import QtQuick 2.0
import QtQuick.Controls 1.4 as QtControls
import QtQuick.Layouts 1.12
import QtQuick.Dialogs 1.2

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.kquickcontrolsaddons 2.0 as KQuickAddons
import org.kde.kirigami 2.5 as Kirigami
import org.kde.plasma.components 3.0 as PlasmaComponents
import ".."

Item {
  id: configCryptos
  Layout.fillWidth: true
  property alias cfg_cryptos: serializedCryptos.text

  Text {
    id: serializedCryptos
    visible: false
    onTextChanged: {
      cryptosModel.clear()
      JSON.parse(serializedCryptos.text).forEach(
        ex => cryptosModel.append(ex)
      )
    }
  }

  CryptoModel {
    id: cryptosModel
  }

  RowLayout {
    anchors.fill: parent
    Layout.alignment: Qt.AlignTop | Qt.AlignRight

    QtControls.TableView {
      id: cryptosTable
      model: cryptosModel
      Layout.fillWidth: true
      sortIndicatorVisible: true
      anchors.top: parent.top
      anchors.bottom: parent.bottom

      QtControls.TableViewColumn {
        role: "crypto"
        title: "Crypto"
      }

      QtControls.TableViewColumn {
        role: "currency"
        title: "Currency"
      }

      onDoubleClicked: editCryptos(cryptosTable.currentRow)
    }

    ColumnLayout {
      id: buttonmenu
      anchors.top: parent.top
      Kirigami.FormLayout {
        PlasmaComponents.Button {
            icon.name: "list-add"
            text: ("Add Crypto")
            onClicked: addCryptos()
        }

        PlasmaComponents.Button {
          icon.name: "cell_edit"
          text: ("Edit")
          onClicked: editCryptos(cryptosTable.currentRow)
        }
        
        PlasmaComponents.Button {
          icon.name: "remove"
          text: "Remove"
          onClicked: removeCryptos(cryptosTable.currentRow)
        }
      }
    } // ColumnLayout
  } // RowLayout

  Dialog {
    id: addCryptoDialog
    width: 350
    height: 200
    visible: false
    title: ("Add Crypto")
    standardButtons: StandardButton.Save | StandardButton.Cancel
    onAccepted: {
      var ex = crypto.toJson()
      if (selectedRow === -1) {
        cryptosModel.append(ex)
      } else {
        cryptosModel.set(selectedRow, ex)
      }
      saveCryptos();
    }
    CryptoCurrenciesConfig {
      id: crypto
    }
  }

  property int selectedRow: -1

  function saveCryptos() {
    var cryptos = []
    for (var i=0; i<cryptosModel.count; i++) {
      cryptos.push(cryptosModel.get(i))
    }
    serializedCryptos.text = JSON.stringify(cryptos)
  }

  function addCryptos() {
    crypto.init()
    selectedRow = -1
    addCryptoDialog.visible = true
  }

  function editCryptos(idx) {
    if (idx === -1) return
    if ((idx+1) > cryptosModel.count) return
    crypto.fromJson(cryptosModel.get(idx))
    selectedRow = idx
    addCryptoDialog.visible = true
  }

  function removeCryptos(idx) {
    if (idx === -1) return
    cryptosTable.model.remove(idx)
    saveCryptos()
  }

} // Item
