import QtQuick 2.0
import QtQuick.Layouts 1.12
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.plasma.core 2.0 as PlasmaCore

GridLayout {

  property var cryptos: JSON.parse(plasmoid.configuration.cryptos).filter(ex => ex['enabled'])
  property int cryptoCount: 0

  onCryptosChanged: {
    cryptoCount = 0
    cryptoCount = cryptos.length
  }

  Repeater {
    model: cryptoCount
    Crypto {
      json: cryptos[index]
    }
  }
}
