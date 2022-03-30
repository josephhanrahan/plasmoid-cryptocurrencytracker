import QtQuick 2.0
import QtQuick.Layouts 1.12
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.plasma.core 2.0 as PlasmaCore
import "../js/crypto.js" as Tools


GridLayout {
  id: tickerRoot

  columns: 4
  rows: 1

  Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
  Layout.fillWidth: true

  property var json: undefined

  property string crypto: ''
  property string currency: ''
  property int updateFrequency: 10
  property bool showName: false
  property string nameShown: ''
  property bool showDecimal: true
  property bool useCustomLocale: false
  property string customLocaleName: ''

  Component.onCompleted: {
    if (json !== undefined) {
      crypto = json.crypto
      currency = json.currency
      updateFrequency = json.updateFrequency
      showDecimal = json.showDecimal
      showName = json.showName
      nameShown = json.nameShown
      useCustomLocale = json.useCustomLocale
      customLocaleName = json.customLocaleName
    }
  }

  onCryptoChanged: {
    getPrice(crypto, currency)
  }
  
  onCurrencyChanged: {
    getPrice(crypto, currency)
  }

  function getCurrentRateText() {
    if (showName == true) {
      return nameShown + " " + currentRate
    } 
    return currentRate
  }

  Timer {
    interval: updateFrequency * 1000 * 60
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: getPrice(crypto, currency)
  }

  Image {
    id: cryptoIcon
  }

  PlasmaComponents.Label {
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter

    Layout.alignment: Qt.AlignHCenter
    height: 20
    textFormat: Text.RichText
    fontSizeMode: Text.Fit
    minimumPixelSize: 8
    text: getCurrentRateText()
  }

  property var currentRate: '10'

  function getPrice(crypto, currency) {
    var xhr = new XMLHttpRequest()
    var url = 'https://api.coingecko.com/api/v3/simple/price?ids=crypto&vs_currencies=currency'
    var newCrypto = crypto.replace(/ /g, "-")
    newCrypto = newCrypto.replace(/\./g, "-")
    url = url.replace("crypto", newCrypto)
    url = url.replace("currency", currency)
    xhr.open('GET', url)
    xhr.send()
    xhr.onload = () => {
      var json = xhr.response
      var data = json.replace(/[^0-9.]/g, '')
      var dataFloat = parseInt(data)
      if (!showDecimal) {
        data = Math.round(data)
      }
      var localeName = useCustomLocale ? customLocaleName : ''
      var tmp = Number(data).toLocaleCurrencyString(Qt.locale(localeName), Tools.getCurrencySymbol(currency))
      if (!showDecimal) {
        tmp = tmp.replace(Qt.locale(localeName).decimalPoint + '00', '')
      }
      setPrice(tmp)
    }
  }

  function request(url, callback) {
    var xhr = new XMLHttpRequest()
    xhr.onreadystatechange = function() {
      if (xhr.readyState === 4) {
        callback(xhr.responseText)
      }
    }
    xhr.open('GET', url, true)
    xhr.send('')
  }

  function setPrice(rate) {
    currentRate = rate
  }
}
