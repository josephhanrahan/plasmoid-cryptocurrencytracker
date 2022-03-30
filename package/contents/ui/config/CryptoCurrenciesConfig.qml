import QtQuick 2.0
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12
import QtQuick.Dialogs 1.2

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.kquickcontrolsaddons 2.0 as KQuickAddons
import org.kde.kquickcontrols 2.0 as KQControls
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.kirigami 2.5 as Kirigami

import "../../js/cryptodata.js" as Data

ColumnLayout {

  property string crypto: undefined
  property string currency: undefined

  function init() {
    fromJson({
      'enabled': true,
      'crypto': 'Bitcoin',
      'currency': 'BTC',
      'showDecimal': true,
      'updateFrequency': 10,
      'showName': false,
      'nameShown': '',
      'useCustomLocale': true,
      'customLocaleName': 'en-US',
    })
  }

  function fromJson(json) {
    console.debug(json)

    cryptoEnabled.checked = json.enabled
    crypto = json.crypto
    cryptoComboBox.editText = crypto
    currency = json.currency
    currencyComboBox.editText = currency
    showDecimalCheckBox.checked = json.showDecimal
    updateFrequency.value = json.updateFrequency
    showNameCheckBox.checked = json.showName
    nameTextField.text = json.nameShown
    useCustomLocaleCheckBox.checked = json.useCustomLocale
    customLocaleNameTextField.text = json.customLocaleName

  }

  function toJson() {
    return {
      'enabled': cryptoEnabled.checked,
      'crypto': crypto,
      'currency': currency,
      'showDecimal': showDecimalCheckBox.checked,
      'updateFrequency': updateFrequency.value,
      'showName': showNameCheckBox.checked,
      'nameShown': nameTextField.text,
      'useCustomLocale': useCustomLocaleCheckBox.checked,
      'customLocaleName': customLocaleNameTextField.text,
    }
  }

  Kirigami.FormLayout {
    CheckBox {
      id: cryptoEnabled
      Kirigami.FormData.label: ("Enabled")
      checked: true
    }

    PlasmaComponents.ComboBox {
      id: cryptoComboBox
      editable: true
      Kirigami.FormData.label: ('Cryptocurrency')
      textRole: "text"
      onCurrentIndexChanged: crypto = model[currentIndex]['text']
      function fillWithCryptos(crypto) {
        var tmp = []
        var idx = 0
        var currentIdx = 0
        for (const key in Data.cryptos) {
          tmp.push({'value': key, 'text': Data.cryptos[key]['name']})
          if (key == crypto) {
            currentIdx = idx
          }
          idx++
        }
        model = tmp
        currentIndex = currentIdx
      }
      Component.onCompleted:fillWithCryptos(crypto)
    
    }

    
    PlasmaComponents.ComboBox {
      id: currencyComboBox
      textRole: "text"
      Kirigami.FormData.label: ('Currency')
      editable: true
      onCurrentIndexChanged: currency = model[currentIndex]['text']
      function fillWithCurrencies(currency) {
        var tmp = []
        var idx = 0
        var currentIdx = 0
        for (const key in Data.currencies) {
          tmp.push({'value': key, 'text': Data.currencies[key]['id']})
          if (key === crypto) currentIdx = idx
          idx++
        }
        model = tmp
        currentIndex = currentIdx
      }
      Component.onCompleted:fillWithCurrencies(currency)
    }

    CheckBox {
      id: showDecimalCheckBox
      Kirigami.FormData.label: ('Show Decimal')
      checked: false
    }
    

    PlasmaComponents.SpinBox {
      id: updateFrequency
      Kirigami.FormData.label: ('Price Update Frequency')
      from: 1
      to: 60
      stepSize: 1
      value: 10
    }

    RowLayout {
      Kirigami.FormData.label: ('Show Name Next To Price')
    
      CheckBox {
        id: showNameCheckBox
        checked: true
      }

      TextField {
        id: nameTextField
        enabled: showNameCheckBox.checked
      }
    }

    RowLayout {
      Kirigami.FormData.label: ('Use Custom Locale')
      CheckBox {
        id: useCustomLocaleCheckBox
        checked: true
      }

      TextField {
        id: customLocaleNameTextField
        text: "en-US"
        enabled: useCustomLocaleCheckBox.checked
      }
    }

  } // Kirigami.FormLayout

}
