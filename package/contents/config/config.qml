import QtQuick 2.0
import org.kde.plasma.configuration 2.0

ConfigModel {
  ConfigCategory {
    name: ("Crypto")
    icon: "taxes-finances"
    source: "config/CryptoCurrencies.qml"
  }
  ConfigCategory {
    name: ("About")
    icon: "color-management"
    source: "configGeneral.qml"
  }
}
